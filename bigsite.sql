DROP TABLE IF EXISTS FinalBattenedBigSites;

SELECT 
    *,
    -- Divides the 200k location into 20 equal batches of 10k patients each
    -- Partitioning ensures every single batch has identical risk-factor prevalence
    NTILE(20) OVER (
        PARTITION BY baseline_mental_health, imd_quintile, baseline_dm, baseline_bp 
        ORDER BY NEWID()
    ) AS processing_batch_id
INTO FinalBattenedBigSites
FROM FinalStratifiedSites
WHERE assigned_study_site = 'Location_1_200k';
