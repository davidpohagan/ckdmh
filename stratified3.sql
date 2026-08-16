DROP TABLE IF EXISTS FinalStratifiedSites;

WITH RankedPatients AS (
    -- Group data to the patient level first so a patient's longitudinal 
    -- records are never split across two different locations
    SELECT DISTINCT 
        patient_id, 
        stratification_cell_id,
        ROW_NUMBER() OVER(PARTITION BY stratification_cell_id ORDER BY NEWID()) as patient_rand_idx
    FROM #StratifiedCohort
)
SELECT 
    c.*,
    -- Allocate patients to sites based on strict size thresholds
    CASE 
        WHEN rp.patient_rand_idx <= 200000 THEN 'Location_1_200k'
        WHEN rp.patient_rand_idx <= 380000 THEN 'Location_2_180k'
        WHEN rp.patient_rand_idx <= 530000 THEN 'Location_3_150k'
        WHEN rp.patient_rand_idx <= 650000 THEN 'Location_4_120k'
        WHEN rp.patient_rand_idx <= 750000 THEN 'Location_5_100k'
        WHEN rp.patient_rand_idx <= 830000 THEN 'Location_6_80k'
        WHEN rp.patient_rand_idx <= 890000 THEN 'Location_7_60k'
        WHEN rp.patient_rand_idx <= 940000 THEN 'Location_8_50k'
        WHEN rp.patient_rand_idx <= 980000 THEN 'Location_9_40k'
        ELSE 'Unallocated_Pool' -- Excess data remains in the 2.5m pool if unneeded
    END AS assigned_study_site
INTO FinalStratifiedSites
FROM #StratifiedCohort c
JOIN RankedPatients rp ON c.patient_id = rp.patient_id;
