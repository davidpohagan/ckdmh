-- Step 1: Define baseline costs for each CKD stage (Unadjusted)
WITH CKD_Stage_Costs AS (    SELECT 'Stage 1-2' AS ckd_stage, 2500.00 AS base_cost 
                    UNION ALL    SELECT 'Stage 3',   3000.00  
                    UNION ALL    SELECT 'Stage 4-5', 12000.00 
                    UNION ALL    SELECT 'RRT',       40000.00),


-- Step 2: Consolidate patient health flags and map mental health sub-categories

Patient_Comorbidities AS (    SELECT         patient_id,        
                                            ckd_stage,        
                                            has_hypertension_bp,  -- Boolean flag (1 = Yes, 0 = No)       
                                            has_diabetes_dm,      -- Boolean flag       
                                    -- Specific Mental Health flags   
                                            has_depression,        
                                            has_smi,              -- Severe Mental Illness        
                                            has_dementia    
                                            FROM patient_registry   
                                            WHERE is_active_ckd = 1 
                -- Filters to your active CKD cohort (~250k - 300k out of 3M)
                ),
  -- Step 3: Apply layered, compounding multipliers based on clinical risk profiles


Patient_Cost_Strata AS (    SELECT         p.patient_id,       
                                          p.ckd_stage,        
                                          c.base_cost,       
            -- Determine the maximum Mental Health multiplier applicable to the patient        
                                          CASE  WHEN p.has_dementia = 1   THEN 3.5         
                                          WHEN p.has_smi = 1        THEN 2.7            
                                          WHEN p.has_depression = 1 THEN 1.6             ELSE 1.0        
                                          END
                                          AS mh_multiplier,       
          -- Determine physical comorbidity multiplier combining DM and BP    
                                        CASE   WHEN p.has_diabetes_dm = 1 
                                        AND p.has_hypertension_bp = 1 THEN 2.2 -- "Triple Threat" foundation             
                                        WHEN p.has_diabetes_dm = 1     THEN 1.9   
                                        WHEN p.has_hypertension_bp = 1  THEN 1.2       ELSE 1.0   
                                        END
                                        AS physical_multiplier,       
                  -- Label the cohort dynamically for the final summary output    
                                      CONCAT(     p.ckd_stage,             ' | ',           
                                      CASE WHEN p.has_diabetes_dm = 1 THEN 'DM ' ELSE ''
                                      END,           
                                      CASE WHEN p.has_hypertension_bp = 1 THEN 'BP ' ELSE '' END,   
                                      CASE      WHEN p.has_dementia = 1   THEN '+ Dementia'   
                                      WHEN p.has_smi = 1        THEN '+ SMI'      
                                      WHEN p.has_depression = 1 THEN '+ Depression'         
                                      ELSE 'No MH'            END        ) AS clinical_stratum_name   
                                      
                                      FROM Patient_Comorbidities p  
                                      JOIN CKD_Stage_Costs c 
                                      ON p.ckd_stage = c.ckd_stage),
    -- Step 4: Calculate the adjusted cost per individual patient


Patient_Calculated_Costs AS (    SELECT         
                                        patient_id,        
                                        ckd_stage,        
                                        clinical_stratum_name,        
                                        base_cost,
                                        -- Compounding the physical and mental health risks together        
                                        (base_cost * physical_multiplier * mh_multiplier) AS adjusted_annual_cost    
                                        FROM Patient_Cost_Strata)
    
    
    -- Step 5: Generate the Final Stratified System Cost Table

                  SELECT     clinical_stratum_name AS [Clinical Cohort Stratification],    
                  COUNT(patient_id) AS [Patient Count],    
                  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY adjusted_annual_cost)       
                  OVER (PARTITION BY clinical_stratum_name) AS [Median Cost Per Patient (£)], 
                  ROUND(AVG(adjusted_annual_cost), 2) AS [Average Cost Per Patient (£)], 
                  ROUND(SUM(adjusted_annual_cost), 2) AS [Total System Annual Spend (£)]
                  
                  FROM Patient_Calculated_Costs
                  GROUP  BY     ckd_stage,     clinical_stratum_name 
                  
                  ORDER BY     CASE ckd_stage      
                            WHEN 'Stage 1-2' THEN 1      
                            WHEN 'Stage 3'   THEN 2       
                            WHEN 'Stage 4-5' THEN 3       
                            WHEN 'Stage 4/5' THEN 3       
                            WHEN 'RRT'       THEN 4       
                            ELSE 5    END,  
                            [Total System Annual Spend (£)] DESC;
