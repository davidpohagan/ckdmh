-- Step 1: Establish baseline time horizons and compounding risk drivers
WITH Target_Years AS (
    SELECT 2026 AS project_year, 1.000 AS pop_index, 0.1000 AS prev_rate, 1.000 AS inflation_index UNION ALL
    SELECT 2028,                 1.010,            0.1050,            1.071 UNION ALL
    SELECT 2030,                 1.020,            0.1100,            1.148 UNION ALL
    SELECT 2032,                 1.030,            0.1150,            1.229 UNION ALL
    SELECT 2034,                 1.040,            0.1200,            1.317 UNION ALL
    SELECT 2036,                 1.050,            0.1250,            1.411
),

-- Step 2: Layer patients and simulate structural risk shift due to ageing
Simulated_Patient_Acuity AS (
    SELECT 
        y.project_year,
        p.patient_id,
        p.ckd_stage,
        -- Structural shift: Ageing increases dementia and RRT transition rates over time
        CASE 
            WHEN y.project_year >= 2034 AND p.ckd_stage = 'Stage 3' THEN 1.15 -- 15% progression acceleration
            ELSE 1.00 
        END AS age_progression_modifier
    FROM patient_registry p
    CROSS JOIN Target_Years y
    WHERE p.is_active_ckd = 1
)

-- Step 3: Global System Forecasting Table
SELECT 
    project_year AS [Forecast Year],
    COUNT(patient_id) AS [Simulated Registry Count],
    ROUND(SUM(12000.00 * age_progression_modifier) / 1000000.0, 2) AS [Simulated High-Acuity Spend (£M)]
FROM Simulated_Patient_Acuity
GROUP BY project_year
ORDER BY project_year;
