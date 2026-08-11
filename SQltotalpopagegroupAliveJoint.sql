 drop table Client_BTP_RW.DOH101_populations 

--- 1st group is background whole population from main patient index ---
--- grouped by sex and age group ---
SELECT
    case
   when [Age] <18 then 'Under 18' 
   when [Age] between 18 and 24 then '18-24'
   when [Age] between 25 and 34then '25-34'
   when [Age] between 35 and 49 then '35-49'
   when [Age] between 50 and 59 then '50-59'
    when [Age] between 60 and 69 then '60-69'
   when [Age] between 70 and 79 then '70-79'
  else  'over 80' 
  end  As age_group,
   count(*) as total_count,
  [Sex], 'Whole' as population
 
 into  Client_BTP_RW.DOH101_populations 

  FROM [Client_BTP_RW].[DOH002_MPI] 
  
 where [deceased] = 'N'

  group by 
  case
   when Age <18 then 'Under 18' 
   when Age between 18 and 24 then '18-24'
   when Age between 25 and 34then '25-34'
   when Age between 35 and 49 then '35-49'
   when Age between 50 and 59 then '50-59'
    when Age between 60 and 69 then '60-69'
   when Age between 70 and 79 then '70-79'
  else  'over 80' 
  end  ,
  
  Sex
  order by 1
 --- 2nd group is ckd coded population from ckd cohort ---
--- grouped by sex and age group ---  
 insert into  Client_BTP_RW.DOH101_populations 
 
  SELECT
    case
   when Age <18 then 'Under 18' 
   when Age between 18 and 24 then '18-24'
   when Age between 25 and 34then '25-34'
   when Age between 35 and 49 then '35-49'
   when Age between 50 and 59 then '50-59'
    when Age between 60 and 69 then '60-69'
   when Age between 70 and 79 then '70-79'
  else  'over 80' 
  end  As age_group,
   count(*) as total_count,
   [Sex],'CKD' as population
   
  FROM [Client_BTP_RW].[DOH_103_CKD_cohort_1]

  group by 
  case
   when Age <18 then 'Under 18' 
   when Age between 18 and 24 then '18-24'
   when Age between 25 and 34then '25-34'
   when Age between 35 and 49 then '35-49'
   when Age between 50 and 59 then '50-59'
    when Age between 60 and 69 then '60-69'
   when Age between 70 and 79 then '70-79'
  else  'over 80' 
  end  ,
  
  Sex
  order by 1 

  --- 3rd group is background egfr population from egfr <60 PCA table selection ---
--- grouped by age group ---

 insert into  Client_BTP_RW.DOH101_populations 
  SELECT
    case
   when MPI.[Age] <18 then 'Under 18' 
   when MPI.[Age] between 18 and 24 then '18-24'
   when MPI.[Age] between 25 and 34then '25-34'
   when MPI.[Age] between 35 and 49 then '35-49'
   when MPI.[Age] between 50 and 59 then '50-59'
    when MPI.[Age] between 60 and 69 then '60-69'
   when MPI.[Age] between 70 and 79 then '70-79'
  else  'over 80' 
  end  As age_group,
   count(*) as total_count,
   MPI.[Sex],'eGFR' as population
   
  FROM [Client_BTP_RW].[DOH101_PCA] as pca


  

  left join
  [Client_BTP_RW].[DOH002_MPI] as MPI
  on MPI.[Pseudo_NHS_Number] = pca.[Pseudo_NHS_Number]

  


  where pca.[ConceptID] in  (
    '1011481000000105', -- Estimated glomerular filtration rate using creatinine Chronic Kidney Disease Epidemiology Collaboration equation per 1.73 square metres
    '1011491000000107', -- Estimated glomerular filtration rate using cystatin C Chronic Kidney Disease Epidemiology Collaboration equation per 1.73 square metres
    '1020291000000106', -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation
    '1107411000000104', -- Estimated glomerular filtration rate by laboratory calculation
    '241374009',        -- Chromium 51 ethylenediamine tetra-acetate clearance - glomerular filtration rate
    '262300005',        -- With glomerular filtration rate
    '326991000000101',  -- Radionuclide non-imaging glomerular filtration rate estimation study
    '71000237105',      -- Substance concentration ratio of calculated tubular maximum reabsorption of phosphate per litre of glomerular filtration rate to creatinine in urine
    '737105002',        -- Glomerular filtration rate calculation technique
    '80274001',         -- Glomerular filtration rate
    '857971000000104',  -- Estimated glomerular filtration rate using Chronic Kidney Disease Epidemiology Collaboration formula
    '963601000000106',  -- Estimated glomerular filtration rate using cystatin C Chronic Kidney Disease Epidemiology Collaboration equation
    '963621000000102',  -- Estimated glomerular filtration rate using creatinine Chronic Kidney Disease Epidemiology Collaboration equation
    '996231000000108'   -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation adjusted for African American origin
) 
and cast (pca.[Value] as numeric) <60
and MPI.[Deceased] = 'N'

  group by 
  case
   when Age <18 then 'Under 18' 
   when Age between 18 and 24 then '18-24'
   when Age between 25 and 34then '25-34'
   when Age between 35 and 49 then '35-49'
   when Age between 50 and 59 then '50-59'
    when Age between 60 and 69 then '60-69'
   when Age between 70 and 79 then '70-79'
  else  'over 80' 
  end  ,
  
  MPI.[Sex]
  order by 1 
