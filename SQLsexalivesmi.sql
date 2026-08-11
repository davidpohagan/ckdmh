SELECT count(distinct [Pseudo_NHS_Number]) as population
,[Sex]
,[Deceased]
into [Client_SystemP_RW].[DOH101_smisex_alive]
  FROM [Client_SystemP_RW].[DOH10_SMIegfrPl]
  group by [Sex], [Deceased]