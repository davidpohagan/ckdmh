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
  [Sex]
    
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
   






