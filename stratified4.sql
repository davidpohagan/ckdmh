SELECT 
    assigned_study_site,
    baseline_mental_health,
    imd_quintile,
    COUNT(DISTINCT patient_id) AS Total_Patients,
    -- Check proportion representation
    ROUND(COUNT(DISTINCT patient_id) * 100.0 / SUM(COUNT(DISTINCT patient_id)) OVER(PARTITION BY assigned_study_site), 2) AS Percentage_Of_Site
FROM FinalStratifiedSites
WHERE assigned_study_site <> 'Unallocated_Pool'
GROUP BY assigned_study_site, baseline_mental_health, imd_quintile
ORDER BY baseline_mental_health, imd_quintile, assigned_study_site;
