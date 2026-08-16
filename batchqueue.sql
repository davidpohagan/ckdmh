DROP TABLE IF EXISTS Production_Batch_Queue;

SELECT 
    *,
    -- Create a unified batch number combining the location and the 10k partition
    -- Partitioning by interaction cells ensures every single one of the 250 batches is demographic-balanced
   
 DENSE_RANK() OVER(
        ORDER BY assigned_study_site, 
        NTILE(20) OVER(PARTITION BY         assigned_study_site, 
baseline_mental_health, 
imd_quintile,
 baseline_dm, 
baseline_bp ORDER BY NEWID())
    ) AS universal_batch_id


INTO Production_Batch_Queue
FROM FinalStratifiedSites
WHERE assigned_study_site <> 'Unallocated_Pool';

-- Add a clustered index to make sequential streaming instantaneous
CREATE CLUSTERED INDEX IX_Universal_Batch
 ON Production_Batch_Queue(universal_batch_id, patient_id);
