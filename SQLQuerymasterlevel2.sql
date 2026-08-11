/* DOH; (assistance from Gemini on approach)This script identifies people with egfr <60 using any egfr code comparison should be for only individual codes!!
identifies date of first < 60 egfr labelling preceeding ones and subsequent 23/07/26; 3:53 to execute with all 4 tables
*/

WITH
-- step one to filter for ckd and egfr -- filtered from pca tables as gp events unstable
filteredconcepts as (
select *
from [Client_BTP_RW].[DOH101_PCA]
union all
select * from [Client_BTP_RW].[DOH101_PCAa] 
union all
select * from [Client_BTP_RW].[DOH101_PCAb]
union all
select * from [Client_BTP_RW].[DOH101_PCAc]


where [ConceptID] in (
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
    '996231000000108' ,  -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation adjusted for African American origin

    '1011481000000105', -- Estimated glomerular filtration rate using creatinine Chronic Kidney Disease Epidemiology Collaboration equation per 1.73 square metres
    '1011491000000107', -- Estimated glomerular filtration rate using cystatin C Chronic Kidney Disease Epidemiology Collaboration equation per 1.73 square metres
    '1020291000000106', -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation
    '104931000119100',  -- Chronic kidney disease due to hypertension
    '10757401000119104',-- Pre-existing hypertensive heart and chronic kidney disease in mother complicating childbirth
    '10757481000119107',-- Pre-existing hypertensive heart and chronic kidney disease in mother complicating pregnancy
    '1107411000000104', -- Estimated glomerular filtration rate by laboratory calculation
    '111411000119103', -- End stage renal disease due to hypertension
    '117681000119102', -- Chronic kidney disease stage 1 due to hypertension
    '1187460003',       -- Unilateral multicystic renal dysplasia
    '118781000119108', -- Pre-existing hypertensive chronic kidney disease in mother complicating pregnancy
    '1208934006',       -- Sagliker syndrome
    '1217070004',       -- Renal osteodystrophy due to hyperparathyroidism
    '12341000',         -- Isotope study for glomerular filtration rate
    '127991000119101', -- Hypertension concurrent and due to end stage renal disease on dialysis due to type 2 diabetes mellitus
    '128001000119105', -- Hypertension concurrent and due to end stage renal disease on dialysis due to type 1 diabetes mellitus
    '129151000119102', -- Chronic kidney disease stage 4 due to hypertension
    '129161000119100', -- Chronic kidney disease stage 5 due to hypertension
    '129171000119106', -- Chronic kidney disease stage 3 due to hypertension
    '129181000119109', -- Chronic kidney disease stage 2 due to hypertension
    '1295482007',       -- Osteoporosis due to chronic kidney disease
    '1332436006',       -- Hypertension in chronic kidney disease stage 3B due to type 1 diabetes mellitus
    '1332441003',       -- Hypertension in chronic kidney disease stage 3A due to type 1 diabetes mellitus
    '1332442005',       -- Hypertension in chronic kidney disease stage 3 due to type 1 diabetes mellitus
    '1332464001',       -- Hypertension in chronic kidney disease stage 2 due to type 1 diabetes mellitus
    '1332465000',       -- Hypertension in chronic kidney disease stage 3B due to type 2 diabetes mellitus
    '1332466004',       -- Hypertension in chronic kidney disease stage 3A due to type 2 diabetes mellitus
    '1332467008',       -- Hypertension in chronic kidney disease stage 5 due to type 1 diabetes mellitus
    '1332468003',       -- Hypertension in chronic kidney disease stage 4 due to type 1 diabetes mellitus
    '1332469006',       -- Chronic kidney disease stage 3B due to type 2 diabetes mellitus
    '1332470007',       -- Chronic kidney disease stage 3A due to type 2 diabetes mellitus
    '1332471006',       -- Chronic kidney disease stage 3B due to type 1 diabetes mellitus
    '1332472004',       -- Chronic kidney disease stage 3A due to type 1 diabetes mellitus
    '1367961003',       -- Chronic lithium nephrotoxicity
    '1373674009',       -- Chronic cardiorenal syndrome
    '1373675005',       -- Chronic renocardiac syndrome
    '13889008',         -- Chronic disorder of kidney caused by semustine
    '140101000119109', -- Hypertension in chronic kidney disease stage 5 due to type 2 diabetes mellitus
    '14011000237108',   -- Glomerular filtration rate by iohexol plasma clearance (corrected)
    '140111000119107', -- Hypertension in chronic kidney disease stage 4 due to type 2 diabetes mellitus
    '140121000119100', -- Hypertension in chronic kidney disease stage 3 due to type 2 diabetes mellitus
    '140131000119102', -- Hypertension in chronic kidney disease stage 2 due to type 2 diabetes mellitus
    '153851000119106', -- Malignant hypertensive chronic kidney disease stage 5
    '153891000119101', -- End stage renal disease on dialysis due to hypertension
    '16461000237109',   -- Glomerular filtration rate by iohexol plasma clearance
    '166181000000100',  -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation
    '167183007',        -- Creatinine clearance-glomerular filtration outside reference range
    '16726004',         -- Renal osteodystrophy
    '168361000000105',  -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation
    '172941000000101',  -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation
    '177471000000100',  -- Glomerular filtration rate
    '1801000119106',    -- Anemia, pre-end stage renal disease on erythropoietin protocol
    '187401000000102',  -- Glomerular filtration rate
    '190841000000102',  -- Glomerular filtration rate
    '222521000000103',  -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation adjusted for African American origin
    '231131000000104',  -- Glomerular filtration rate testing
    '236425005',        -- Chronic renal impairment
    '236433006',        -- Acute-on-chronic renal failure
    '236434000',        -- End stage renal failure without renal replacement therapy
    '236435004',        -- End stage renal failure on dialysis
    '236436003',        -- End stage renal failure with renal transplant
    '236452000',        -- Chronic tubulointerstitial nephritis caused by drug
    '236519008',        -- Chronic disease of kidney caused by drug
    '236521003',        -- Disorder of kidney caused by penicillamine
    '236522005',        -- Chronic cyclosporin A nephrotoxicity
    '236552002',        -- Adynamic bone disease
    '241373003',        -- Technetium-99m-diethylenetriamine pentaacetic acid clearance - glomerular filtration rate
    '241374009',        -- Chromium 51 ethylenediamine tetra-acetate clearance - glomerular filtration rate
    '250021000000105',  -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation adjusted for African American origin 
    '252651000000108',  -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation adjusted for African American origin 
    '262300005',        -- With glomerular filtration rate
    '271921000000101',  -- Glomerular filtration rate testing 
    '284961000119106',  -- Chronic kidney disease due to benign hypertension
    '284971000119100',  -- Chronic kidney disease stage 1 due to benign hypertension
    '284981000119102',  -- Chronic kidney disease stage 2 due to benign hypertension
    '284991000119104',  -- Chronic kidney disease stage 3 due to benign hypertension
    '285001000119105',  -- Chronic kidney disease stage 4 due to benign hypertension
    '285011000119108',  -- Chronic kidney disease stage 5 due to benign hypertension
    '285831000119108',  -- Malignant hypertensive chronic kidney disease
    '285841000119104',  -- Malignant hypertensive end stage renal disease
    '285851000119102',  -- Malignant hypertensive chronic kidney disease stage 1
    '285861000119100',  -- Malignant hypertensive chronic kidney disease stage 2
    '285871000119106',  -- Malignant hypertensive chronic kidney disease stage 3
    '285881000119109',  -- Malignant hypertensive chronic kidney disease stage 4
    '286371000119107',  -- Malignant hypertensive end stage renal disease on dialysis
    '324121000000109',  -- Chronic kidney disease stage 1 with proteinuria
    '324151000000104',  -- Chronic kidney disease stage 1 without proteinuria
    '324181000000105',  -- Chronic kidney disease stage 2 with proteinuria
    '324211000000106',  -- Chronic kidney disease stage 2 without proteinuria
    '324251000000105',  -- Chronic kidney disease stage 3 with proteinuria
    '324281000000104',  -- Chronic kidney disease stage 3 without proteinuria
    '324311000000101',  -- Chronic kidney disease stage 3A with proteinuria
    '324341000000100',  -- Chronic kidney disease stage 3A without proteinuria
    '324371000000106',  -- Chronic kidney disease stage 3B with proteinuria
    '324411000000105',  -- Chronic kidney disease stage 3B without proteinuria
    '324441000000106',  -- Chronic kidney disease stage 4 with proteinuria
    '324471000000100',  -- Chronic kidney disease stage 4 without proteinuria
    '324501000000107',  -- Chronic kidney disease stage 5 with proteinuria
    '324541000000105',  -- Chronic kidney disease stage 5 without proteinuria
    '368421000119108',  -- Chronic kidney disease stage 1 due to drug induced diabetes mellitus
    '368431000119106',  -- Chronic kidney disease stage 2 due to drug induced diabetes mellitus
    '368441000119102',  -- Chronic kidney disease stage 3 due to drug induced diabetes mellitus
    '368451000119100',  -- Chronic kidney disease stage 4 due to drug induced diabetes mellitus
    '368461000119103',  -- Chronic kidney disease stage 5 due to drug induced diabetes mellitus
    '368471000119109',  -- End stage renal disease on dialysis due to drug induced diabetes mellitus
    '425369003',        -- Chronic progressive renal failure
    '431855005',        -- Chronic kidney disease stage 1
    '431856006'         -- Chronic kidney disease stage 2 (Inferred completion from text cutoff)
)
),


RankedData AS (
    SELECT 
        [Pseudo_NHS_Number],
        [Value],
        [Date],
        [ConceptID],
       cast ([Value] as numeric) as [number],
        ROW_NUMBER() OVER (PARTITION BY [Pseudo_NHS_Number] ORDER BY [Date]) as RN,

        MAX(Case when ConceptID IN (
    '1011481000000105', -- Estimated glomerular filtration rate using creatinine Chronic Kidney Disease Epidemiology Collaboration equation per 1.73 square metres
    '1011491000000107', -- Estimated glomerular filtration rate using cystatin C Chronic Kidney Disease Epidemiology Collaboration equation per 1.73 square metres
    '1020291000000106', -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation
    '104931000119100',  -- Chronic kidney disease due to hypertension
    '10757401000119104',-- Pre-existing hypertensive heart and chronic kidney disease in mother complicating childbirth
    '10757481000119107',-- Pre-existing hypertensive heart and chronic kidney disease in mother complicating pregnancy
    '1107411000000104', -- Estimated glomerular filtration rate by laboratory calculation
    '111411000119103', -- End stage renal disease due to hypertension
    '117681000119102', -- Chronic kidney disease stage 1 due to hypertension
    '1187460003',       -- Unilateral multicystic renal dysplasia
    '118781000119108', -- Pre-existing hypertensive chronic kidney disease in mother complicating pregnancy
    '1208934006',       -- Sagliker syndrome
    '1217070004',       -- Renal osteodystrophy due to hyperparathyroidism
    '12341000',         -- Isotope study for glomerular filtration rate
    '127991000119101', -- Hypertension concurrent and due to end stage renal disease on dialysis due to type 2 diabetes mellitus
    '128001000119105', -- Hypertension concurrent and due to end stage renal disease on dialysis due to type 1 diabetes mellitus
    '129151000119102', -- Chronic kidney disease stage 4 due to hypertension
    '129161000119100', -- Chronic kidney disease stage 5 due to hypertension
    '129171000119106', -- Chronic kidney disease stage 3 due to hypertension
    '129181000119109', -- Chronic kidney disease stage 2 due to hypertension
    '1295482007',       -- Osteoporosis due to chronic kidney disease
    '1332436006',       -- Hypertension in chronic kidney disease stage 3B due to type 1 diabetes mellitus
    '1332441003',       -- Hypertension in chronic kidney disease stage 3A due to type 1 diabetes mellitus
    '1332442005',       -- Hypertension in chronic kidney disease stage 3 due to type 1 diabetes mellitus
    '1332464001',       -- Hypertension in chronic kidney disease stage 2 due to type 1 diabetes mellitus
    '1332465000',       -- Hypertension in chronic kidney disease stage 3B due to type 2 diabetes mellitus
    '1332466004',       -- Hypertension in chronic kidney disease stage 3A due to type 2 diabetes mellitus
    '1332467008',       -- Hypertension in chronic kidney disease stage 5 due to type 1 diabetes mellitus
    '1332468003',       -- Hypertension in chronic kidney disease stage 4 due to type 1 diabetes mellitus
    '1332469006',       -- Chronic kidney disease stage 3B due to type 2 diabetes mellitus
    '1332470007',       -- Chronic kidney disease stage 3A due to type 2 diabetes mellitus
    '1332471006',       -- Chronic kidney disease stage 3B due to type 1 diabetes mellitus
    '1332472004',       -- Chronic kidney disease stage 3A due to type 1 diabetes mellitus
    '1367961003',       -- Chronic lithium nephrotoxicity
    '1373674009',       -- Chronic cardiorenal syndrome
    '1373675005',       -- Chronic renocardiac syndrome
    '13889008',         -- Chronic disorder of kidney caused by semustine
    '140101000119109', -- Hypertension in chronic kidney disease stage 5 due to type 2 diabetes mellitus
    '14011000237108',   -- Glomerular filtration rate by iohexol plasma clearance (corrected)
    '140111000119107', -- Hypertension in chronic kidney disease stage 4 due to type 2 diabetes mellitus
    '140121000119100', -- Hypertension in chronic kidney disease stage 3 due to type 2 diabetes mellitus
    '140131000119102', -- Hypertension in chronic kidney disease stage 2 due to type 2 diabetes mellitus
    '153851000119106', -- Malignant hypertensive chronic kidney disease stage 5
    '153891000119101', -- End stage renal disease on dialysis due to hypertension
    '16461000237109',   -- Glomerular filtration rate by iohexol plasma clearance
    '166181000000100',  -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation
    '167183007',        -- Creatinine clearance-glomerular filtration outside reference range
    '16726004',         -- Renal osteodystrophy
    '168361000000105',  -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation
    '172941000000101',  -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation
    '177471000000100',  -- Glomerular filtration rate
    '1801000119106',    -- Anemia, pre-end stage renal disease on erythropoietin protocol
    '187401000000102',  -- Glomerular filtration rate
    '190841000000102',  -- Glomerular filtration rate
    '222521000000103',  -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation adjusted for African American origin
    '231131000000104',  -- Glomerular filtration rate testing
    '236425005',        -- Chronic renal impairment
    '236433006',        -- Acute-on-chronic renal failure
    '236434000',        -- End stage renal failure without renal replacement therapy
    '236435004',        -- End stage renal failure on dialysis
    '236436003',        -- End stage renal failure with renal transplant
    '236452000',        -- Chronic tubulointerstitial nephritis caused by drug
    '236519008',        -- Chronic disease of kidney caused by drug
    '236521003',        -- Disorder of kidney caused by penicillamine
    '236522005',        -- Chronic cyclosporin A nephrotoxicity
    '236552002',        -- Adynamic bone disease
    '241373003',        -- Technetium-99m-diethylenetriamine pentaacetic acid clearance - glomerular filtration rate
    '241374009',        -- Chromium 51 ethylenediamine tetra-acetate clearance - glomerular filtration rate
    '250021000000105',  -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation adjusted for African American origin 
    '252651000000108',  -- Glomerular filtration rate calculated by abbreviated Modification of Diet in Renal Disease Study Group calculation adjusted for African American origin 
    '262300005',        -- With glomerular filtration rate
    '271921000000101',  -- Glomerular filtration rate testing 
    '284961000119106',  -- Chronic kidney disease due to benign hypertension
    '284971000119100',  -- Chronic kidney disease stage 1 due to benign hypertension
    '284981000119102',  -- Chronic kidney disease stage 2 due to benign hypertension
    '284991000119104',  -- Chronic kidney disease stage 3 due to benign hypertension
    '285001000119105',  -- Chronic kidney disease stage 4 due to benign hypertension
    '285011000119108',  -- Chronic kidney disease stage 5 due to benign hypertension
    '285831000119108',  -- Malignant hypertensive chronic kidney disease
    '285841000119104',  -- Malignant hypertensive end stage renal disease
    '285851000119102',  -- Malignant hypertensive chronic kidney disease stage 1
    '285861000119100',  -- Malignant hypertensive chronic kidney disease stage 2
    '285871000119106',  -- Malignant hypertensive chronic kidney disease stage 3
    '285881000119109',  -- Malignant hypertensive chronic kidney disease stage 4
    '286371000119107',  -- Malignant hypertensive end stage renal disease on dialysis
    '324121000000109',  -- Chronic kidney disease stage 1 with proteinuria
    '324151000000104',  -- Chronic kidney disease stage 1 without proteinuria
    '324181000000105',  -- Chronic kidney disease stage 2 with proteinuria
    '324211000000106',  -- Chronic kidney disease stage 2 without proteinuria
    '324251000000105',  -- Chronic kidney disease stage 3 with proteinuria
    '324281000000104',  -- Chronic kidney disease stage 3 without proteinuria
    '324311000000101',  -- Chronic kidney disease stage 3A with proteinuria
    '324341000000100',  -- Chronic kidney disease stage 3A without proteinuria
    '324371000000106',  -- Chronic kidney disease stage 3B with proteinuria
    '324411000000105',  -- Chronic kidney disease stage 3B without proteinuria
    '324441000000106',  -- Chronic kidney disease stage 4 with proteinuria
    '324471000000100',  -- Chronic kidney disease stage 4 without proteinuria
    '324501000000107',  -- Chronic kidney disease stage 5 with proteinuria
    '324541000000105',  -- Chronic kidney disease stage 5 without proteinuria
    '368421000119108',  -- Chronic kidney disease stage 1 due to drug induced diabetes mellitus
    '368431000119106',  -- Chronic kidney disease stage 2 due to drug induced diabetes mellitus
    '368441000119102',  -- Chronic kidney disease stage 3 due to drug induced diabetes mellitus
    '368451000119100',  -- Chronic kidney disease stage 4 due to drug induced diabetes mellitus
    '368461000119103',  -- Chronic kidney disease stage 5 due to drug induced diabetes mellitus
    '368471000119109',  -- End stage renal disease on dialysis due to drug induced diabetes mellitus
    '425369003',        -- Chronic progressive renal failure
    '431855005',        -- Chronic kidney disease stage 1
    '431856006'         -- Chronic kidney disease stage 2 (Inferred completion from text cutoff)
) THEN '1' ELSE '0' END) over (partition by [Pseudo_NHS_Number]) AS hasCKD


       ,MIN(CASE WHEN [ConceptID] in ( 
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
       
       and TRY_CAST([Value] as decimal(10,2)) < 60.00 THEN [Date] END)
        
       OVER(PARTITION BY [Pseudo_NHS_Number]) as [First60Date]

-- db table PCA is events from 2017-2020 PCAw is a small test table PCAa,b,c are other time periods
  --  FROM [Client_BTP_RW].[DOH101_PCA]
-- from [Client_BTP].[GP_events] -- complete and up to date source but not available
From filteredconcepts
    -- This clause includes all egfr codes can be filtered to exclude non numeric/ can be filtered to individual codes

    where [ConceptID] in ( 
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
) and Value is not NULL


    --order by [Pseudo_NHS_Number]
)

SELECT 
    [Pseudo_NHS_Number],
  [Value],
  [Date],
  [First60Date],
  [ConceptID],
  try_cast ([Value] as decimal(10,2)) as value_num,
  [hasCKD],


    CASE 
       WHEN [Date] < [First60Date] THEN 'Before Threshold'
        WHEN [Date] = [First60Date] THEN '1st Value <60'
       ELSE CAST(ROW_NUMBER() OVER(
            PARTITION BY [Pseudo_NHS_Number] 
            ORDER BY CASE WHEN [Date] > [First60Date] THEN [Date] END) - 1 AS VARCHAR(10))
   END as Label,

   -- Column identifying 30 day and <60 condition
   
   case 
            when [Date] > [First60Date]
            AND DATEDIFF(day, [First60Date], [Date]) >30
            AND try_cast ([Value] as decimal(10,2)) <60
            THEN '1'
            ELSE '0' END as Isover30dunder60,
-- check column for last 
DATEDIFF(day, [First60Date],[Date]) as daysSinceFirst


into [Client_BTP_RW].[DOH101_rankedegfrckd_wholecohort]

FROM RankedData

-- this line should ensure only those who have a value < 60 are included
where First60Date is not NULL

-- including the following line is useful for excluding values and individuals which don't reach the threshold egfr value
-- but excludes recovery values and preceeding values
--and try_cast ([Value] as decimal(10,2)) < 60

group by [Pseudo_NHS_Number],[ConceptID] ,[Date], [First60Date],[Value], [hasCKD]
order by [Pseudo_NHS_Number], [Date], [Value];