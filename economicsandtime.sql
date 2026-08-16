-- Step 1: Define baseline costs and IMD-specific health risk accelerators
WITH IMD_Risk_Profiles AS (
    SELECT 1 AS imd_decile, 1.35 AS ckd_prevalence_multiplier, 1.40 AS mh_overlap_multiplier UNION ALL
    SELECT 2,             1.25,                           1.30                           UNION ALL
    SELECT 5,             1.00,                           1.00                           UNION ALL -- National Average Baseline
    SELECT 10,            0.80,                           0.75                             -- Affluent Baseline
),

-- Step 2: Apply the counter-scenario logic to the active registry
Calculated_Intervention AS (
    SELECT 
        p.patient_id,
        p.ckd_stage,
        p.imd_decile,
        base_cost,
        -- Baseline calculation accounting for deprivation-driven risk
        (base_cost * r.ckd_prevalence_multiplier * r.mh_overlap_multiplier) AS baseline_modeled_cost,
        
        -- Counter-Scenario calculation: Apply a 15% optimization credit to high-deprivation bands
        CASE 
            WHEN p.imd_decile <= 3 THEN (base_cost * r.ckd_prevalence_multiplier * r.mh_overlap_multiplier) * 0.85
            ELSE (base_cost * r.ckd_prevalence_multiplier * r.mh_overlap_multiplier)
        END AS counter_scenario_cost
    FROM patient_registry p
    JOIN IMD_Risk_Profiles r ON p.imd_decile = r.imd_decile
    CROSS JOIN (SELECT 12000.00 AS base_cost) -- Example standardized baseline cost placeholder
    WHERE p.is_active_ckd = 1
)

-- Step 3: Comparative Output Summary for Business Case
SELECT 
    CASE 
        WHEN imd_decile <= 3 THEN 'High Deprivation (IMD 1-3)'
        WHEN imd_decile BETWEEN 4 AND 7 THEN 'Medium Deprivation (IMD 4-7)'
        ELSE 'Low Deprivation (IMD 8-10)'
    END AS [Socioeconomic Stratification],
    COUNT(patient_id) AS [Patient Cohort Volume],
    ROUND(SUM(baseline_modeled_cost) / 1000000.0, 2) AS [Current Baseline Spend (£M)],
    ROUND(SUM(counter_scenario_cost) / 1000000.0, 2) AS [Intervention Counter-Scenario Spend (£M)],
    ROUND(SUM(baseline_modeled_cost - counter_scenario_cost) / 1000000.0, 2) AS [Potential Realized Value (£M)]
FROM Calculated_Intervention
GROUP BY 
    CASE 
        WHEN imd_decile <= 3 THEN 'High Deprivation (IMD 1-3)'
        WHEN imd_decile BETWEEN 4 AND 7 THEN 'Medium Deprivation (IMD 4-7)'
        ELSE 'Low Deprivation (IMD 8-10)'
    END
ORDER BY [Potential Realized Value (£M)] DESC;
