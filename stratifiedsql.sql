-- 1. Create a clean, indexed base view or table combining records
DROP TABLE IF EXISTS #RenalBaseCohort;

SELECT 
    p.patient_id,
    p.cohort,
    -- Ensure variables are standardized categorical strings
    ISNULL(p.baseline_mental_health, 'None/Minimal') AS baseline_mental_health,
    ISNULL(p.baseline_bp, 'Normal') AS baseline_bp,
    ISNULL(p.baseline_dm, 'No') AS baseline_dm,
    ISNULL(p.imd_quintile, '5') AS imd_quintile,
    
    -- Longitudinal tracking variables
    l.observation_time,
    l.eGFR,
    
    -- Survival/Competing Risk variables
    p.survival_time,
    p.event_status -- 0=Censored, 1=ESKD, 2=Pre-ESKD Death
INTO #RenalBaseCohort
FROM PatientsBaselineTable p
JOIN eGFRLabRecords l ON p.patient_id = l.patient_id
WHERE l.eGFR BETWEEN 5 AND 200 -- Remove extreme data errors
  AND p.survival_time > 0;

-- Index the temporary table to maximize performance for the next steps
CREATE CLUSTERED INDEX IX_Patient_Time ON #RenalBaseCohort(patient_id, observation_time);
