-- Step 1: Input your planned operational parameters
WITH Program_Parameters AS (
    SELECT 
        12000000.00 AS annual_program_cost,
        50000.00    AS annual_rrt_cost,
        3000.00     AS base_stage3_cost
),

-- Step 2: Extract current baseline registry volumes for high-deprivation areas
High_Risk_Registry AS (
    SELECT 
        COUNT(CASE WHEN ckd_stage = 'RRT' THEN 1 END) AS current_rrt_count,
        COUNT(CASE WHEN ckd_stage = 'Stage 4-5' THEN 1 END) AS current_stage45_count,
        COUNT(patient_id) AS total_deprived_ckd_population
    FROM patient_registry
    WHERE is_active_ckd = 1 AND imd_decile <= 3
)

-- Step 3: Generate operational key performance indicators (KPIs) for break-even
SELECT 
    p.annual_program_cost AS [Annual Budget Target (£)],
    
    -- Minimum number of patients who must be saved from transitioning to dialysis to pay for the program
    CEILING(p.annual_program_cost / p.annual_rrt_cost) AS [Required Annual RRT Preventions (Count)],
   
    -- Percentage of the high-deprivation advanced cohort that represents
    ROUND((p.annual_program_cost / p.annual_rrt_cost) / NULLIF(r.current_stage45_count, 0) * 100.0, 2) AS [Required Conversion Reduction (%)],
   
    -- Safe operational buffer target (aiming for a 1.5x ROI margin)
    CEILING((p.annual_program_cost * 1.5) / p.annual_rrt_cost) AS [Safe Clinical KPI Target (1.5x ROI)]
FROM High_Risk_Registry r
CROSS JOIN Program_Parameters p;
