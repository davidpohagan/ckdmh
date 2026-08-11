drop table [Client_BTP_RW].[DOH101_fullinforanked]
SELECT mpi.[Pseudo_NHS_Number]
      ,[X_CCG_OF_REGISTRATION]
      ,[X_CCG_OF_RESIDENCE]
      ,[Dob]
      ,[Sex]
      ,[EthnicGroupAlgorithm]
      ,[EthnicMainGroup]
      ,[InterpreterRequired]
      ,[Deceased]
      ,[LSOA_Code]
      ,[IMD_Score]
      ,[imd_numeric]
      ,[quintile_section]
       ,[Value]
      ,[Date]
      ,[First60Date]
      ,DATEDIFF(year, try_cast([Dob]+'-01' as date),[Date]) as AgeatDate
      ,[ConceptID]
      ,[value_num]
      ,[hasCKD]
      ,[Label]
      ,[Isover30dunder60]
      ,[daysSinceFirst]
      ,[DM_flag]
      ,[Dem_flag]
      ,[Dep_flag]
      ,[Shiz_flag]
      ,[BP_flag]
      ,[Adhd_flag]
      ,[Anx_flag]
      ,[Aut_flag]
      ,[bipolar_flag]

into [Client_BTP_RW].[DOH101_fullinforanked]

  FROM [Client_BTP_RW].[DOH003_MPI] as mpi

  left join [Client_BTP_RW].[DOH101_rankedegfrckd_wholecohort] as rckd
  on rckd.[Pseudo_NHS_Number] =    mpi.[Pseudo_NHS_Number]

  left join [Client_BTP_RW].[DOH101_DM] as dm
  on rckd.[Pseudo_NHS_Number] = dm.[Pseudo_NHS_Number]

    left join [Client_BTP_RW].[DOH101_Dem] as dem
  on rckd.[Pseudo_NHS_Number] = dem.[Pseudo_NHS_Number]

   left join [Client_BTP_RW].[DOH101_Dep] as dep
  on rckd.[Pseudo_NHS_Number] = dep.[Pseudo_NHS_Number]


    left join [Client_BTP_RW].[DOH101_Schiz] as sz
  on rckd.[Pseudo_NHS_Number] = sz.[Pseudo_NHS_Number]
    left join [Client_BTP_RW].[DOH101_hypertension] as bp
  on rckd.[Pseudo_NHS_Number] = bp.[Pseudo_NHS_Number]

    left join [Client_BTP_RW].[DOH101_adhd] as ad
  on rckd.[Pseudo_NHS_Number] = ad.[Pseudo_NHS_Number] 

    left join [Client_BTP_RW].[DOH101_anx] as ax
  on rckd.[Pseudo_NHS_Number] = ax.[Pseudo_NHS_Number]

    left join [Client_BTP_RW].[DOH101_aut] as au
  on rckd.[Pseudo_NHS_Number] = au.[Pseudo_NHS_Number]

    left join [Client_BTP_RW].[DOH101_bipol] as bi
  on rckd.[Pseudo_NHS_Number] = bi.[Pseudo_NHS_Number]


  

  order by [Pseudo_NHS_Number], [Date]