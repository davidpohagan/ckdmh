/* DOH; (assistance from Gemini on approach)This script identifies people with egfr <60 using any egfr code comparison should be for only individual codes!!
identifies date of first < 60 egfr labelling preceeding ones and subsequent 23/07/26; 3:53 to execute with all 4 tables
now rationalised using tables of opencode lists-- where ok ? not for when!
*/


drop table if exists [Client_BTP_RW].[DOH101_rankedegfrckd_wholecohort];

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


where [ConceptID] in (select gfr.[ConceptID]
       from [Client_BTP_RW].[DOH101_openegfrCodes] gfr
        union all 
        select ckd.[ConceptID]
        from [Client_BTP_RW].[DOH101_CKDCodes] ckd
        union all
         select ckd.[ConceptID]
         from [Client_BTP_RW].[DOH101_CKDCodes] ckd
        union all
         select acr.[ConceptID] 
         from [Client_BTP_RW].[DOH101_openacrCodes] acr
        union all
         select adc.[ConceptID] 
         from [Client_BTP_RW].[DOH101_openaddictCodes] adc
        union all
         select aut.[ConceptID] 
         from [Client_BTP_RW].[DOH101_openautCodes] aut
        union all
         select dem.[ConceptID] 
         from [Client_BTP_RW].[DOH101_opendemCodes] dem
        union all
         select dep.[ConceptID] 
         from [Client_BTP_RW].[DOH101_opendepCodes] dep
        union all
         select outc.[ConceptID] 
         from [Client_BTP_RW].[DOH101_openoutcomesCodes] outc
        union all
         select outr.[ConceptID] 
         from [Client_BTP_RW].[DOH101_openoutcomesrrtCodes] outr
        union all
        select smi.[ConceptID] 
         from [Client_BTP_RW].[DOH101_opensmiCodes] smi
        union all
        select val.[ConceptID] 
         from [Client_BTP_RW].[DOH101_openvaluesCodes] val
         ))
         , RankedData AS (
    SELECT 
        [Pseudo_NHS_Number],
        [Value],
        [Date],
        [ConceptID],
       cast ([Value] as numeric) as [number],
        ROW_NUMBER() OVER (PARTITION BY [Pseudo_NHS_Number] ORDER BY [Date]) as RN,

        MAX(Case when ConceptID IN ( select ckd.[ConceptID]
        from [Client_BTP_RW].[DOH101_CKDCodes] ckd
    -- currently code list too broad for this
) THEN '1' ELSE '0' END) over (partition by [Pseudo_NHS_Number]) AS hasCKD

  -- to calculate when ckd 3 <60
       ,MIN(CASE WHEN [ConceptID] in (  select gfr.[ConceptID]
       from [Client_BTP_RW].[DOH101_openegfrCodes] gfr)
       and TRY_CAST([Value] as decimal(10,2)) < 60.00 THEN [Date] END)
             OVER(PARTITION BY [Pseudo_NHS_Number]) as [First60Date]
 -- to calculate change to ckd 4 date    <30   
      ,MIN(CASE WHEN [ConceptID] in (  select gfr.[ConceptID]
       from [Client_BTP_RW].[DOH101_openegfrCodes] gfr)
       and TRY_CAST([Value] as decimal(10,2)) < 30.00 THEN [Date] END)
        OVER(PARTITION BY [Pseudo_NHS_Number]) as [First30Date]
  -- to calculate change to proteinuria    >3 mmg/mmol  
      ,MIN(CASE WHEN [ConceptID] in (  select acr.[ConceptID]
       from [Client_BTP_RW].[DOH101_openacrCodes] acr)
       and TRY_CAST([Value] as decimal(10,2)) < 3.00 THEN [Date] END)
        OVER(PARTITION BY [Pseudo_NHS_Number]) as [First3ACRDate]
-- db table PCA is events from 2017-2020 PCAw is a small test table PCAa,b,c are other time periods
  --  FROM [Client_BTP_RW].[DOH101_PCA]
-- from [Client_BTP].[GP_events] -- complete and up to date source but not available
From filteredconcepts
    -- This clause includes all egfr codes can be filtered to exclude non numeric/ can be filtered to individual codes

    where [ConceptID] in ( 
   select gfr.[ConceptID]
       from [Client_BTP_RW].[DOH101_openegfrCodes] gfr
) and Value is not NULL


    --order by [Pseudo_NHS_Number]
)

SELECT 
    [Pseudo_NHS_Number],
  [Value],
  [Date],
  [First60Date],
  [First30Date],
  [First3ACRDate],
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
            AND DATEDIFF(day, [First60Date], [Date]) >90
            AND try_cast ([Value] as decimal(10,2)) <60
            THEN '1'
            ELSE '0' END as Isover90dunder60,
-- check column for last 
      DATEDIFF(day, [First60Date],[Date]) as daysSinceFirst
      ,DATEDIFF(day, [First30Date],[Date]) as daysSinceFirst30

into [Client_BTP_RW].[DOH101_rankedegfrckd_wholecohort]

FROM RankedData

-- this line should ensure only those who have a value < 60 are included
where First60Date is not NULL

-- including the following line is useful for excluding values and individuals which don't reach the threshold egfr value
-- but excludes recovery values and preceeding values
--and try_cast ([Value] as decimal(10,2)) < 60

group by [Pseudo_NHS_Number],[ConceptID] ,[Date], [First60Date],[First30Date],[First3ACRDate],[Value], [hasCKD]
order by [Pseudo_NHS_Number], [Date], [Value];