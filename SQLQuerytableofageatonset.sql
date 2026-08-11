SELECT DATEDIFF(year, try_cast([Dob]+'-01' as date),[First60Date]) as AgeatDate

,count(distinct [Pseudo_NHS_Number]) as Count_1
     
      
  FROM [Client_BTP_RW].[DOH101_fullinforanked]

  where Deceased = 'Y'
   --and Sex = 'M'
  -- and DM_flag = 1 
  -- and [X_CCG_OF_REGISTRATION] = '27D'

   group by DATEDIFF(year, try_cast([Dob]+'-01' as date),[First60Date])

  order by DATEDIFF(year, try_cast([Dob]+'-01' as date),[First60Date])