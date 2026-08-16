-- !preview conn=DBI::dbConnect(RSQLite::SQLite())
--sTEP 1 DEFINE BASELINE COSTS
with ckd_stage_costs as ( select 'stage 1-2'as ckd_stage, 2500.00 as base_cost
                          union all
                          select 'stage 3', 3000.00
                          union all 
                          select'stage 4-5' , 12000.00
                          union ALL
                          SELECT 'RRT', 40000.00 ),

--sTEP 2 CONSOLIDATE HEALTH FLAGS INCUDING mh CATEGORIES

comorbidities as( SELECT PATIENT_ID, 
                          ckd_stage, 
                          BP_flag, --boolean 1, yes 0 no
                          DM_flag,
                          Dep_flag,
                          Dem_flag,
                          Anx_flag,
                          Aut_flag
                          ADHD_flag,
                          schiz_flag,
                          bipolar_flag
                from mpi_doh
                where is_ckd), 
  --Step 3 
                    
                          ) 


cost_strata as ()
calculated_costs as()
SELECT stratum_name
