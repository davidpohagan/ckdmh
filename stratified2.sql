DROP TABLE IF EXISTS #StratifiedCohort;

SELECT 
    *,
    -- Creates a unique integer group ID for every unique combination of risk factors
    DENSE_RANK() OVER (
        ORDER BY baseline_mental_health, imd_quintile, baseline_dm, baseline_bp
    ) AS stratification_cell_id,
    
    -- Assign a random row index to every unique patient within their specific cell
    ROW_NUMBER() OVER (
        PARTITION BY baseline_mental_health, imd_quintile, baseline_dm, baseline_bp 
        ORDER BY NEWID() -- Randomizes the patient ordering
    ) AS patient_cell_rank
INTO #StratifiedCohort
FROM #RenalBaseCohort;
