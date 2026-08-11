SELECT count(distinct mpi.[Pseudo_NHS_Number]) as Count_1
     
      ,DATEDIFF(year, try_cast([Dob]+'-01' as date),[First60Date]) as AgeatDate
   

--into [Client_BTP_RW].[DOH101_fullinforanked]

  FROM [Client_BTP_RW].[DOH003_MPI] as mpi

  left join [Client_BTP_RW].[DOH101_rankedegfrckd_wholecohort] as rckd
  on rckd.[Pseudo_NHS_Number] =    mpi.[Pseudo_NHS_Number]

  where X_CCG_OF_REGISTRATION = '01V'
  
  group by DATEDIFF(year, try_cast([Dob]+'-01' as date),[First60Date])

  order by 
     DATEDIFF(year, try_cast([Dob]+'-01' as date),[First60Date]) 
     ,Count_1