USE [ReportsView]
GO

DROP TABLE IF EXISTS [dbo].[RDA_RU_NewGoodsCosts]
GO

USE [ReportsView]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RDA_RU_NewGoodsCosts](
	 [BusinessMonth]        [date]          not null
	,[LocationNo]           [char](5)       not null
	,[DistSoldCost]         [decimal](19,4) null
	,[DistSoldVal]          [decimal](19,4) null
	,[FrlnSoldCost]         [decimal](19,4) null
	,[FrlnSoldVal]          [decimal](19,4) null
	,[ScanSoldQty]          [bigint]        null
	,[ScanSoldCost]         [decimal](19,4) null
	,[ScanSoldVal]          [decimal](19,4) null
	,[DistTshQty]           [bigint]        null
	,[DistTshCost]          [decimal](19,4) null
	,[DistDmgQty]           [bigint]        null
	,[DistDmgCost]          [decimal](19,4) null
	,[DistDntQty]           [bigint]        null
	,[DistDntCost]          [decimal](19,4) null
	,[TotDistRfiQty]        [bigint]        null
	,[TotDistRfiCost]       [decimal](19,4) null
	,[DistOnlineSoldCost]   [decimal](19,4) null
	,[DistOnlineSoldVal]    [decimal](19,4) null
	,[FrlnOnlineSoldCost]   [decimal](19,4) null
	,[FrlnOnlineSoldVal]    [decimal](19,4) null
	,[DistBookwormSoldCost] [decimal](19,4) null
	,[DistBookwormSoldVal]  [decimal](19,4) null
	,[FrlnBookwormSoldCost] [decimal](19,4) null
	,[FrlnBookwormSoldVal]  [decimal](19,4) null
	,[FrlnTshQty]           [bigint]        null
	,[FrlnTshCost]          [decimal](19,4) null
	,[FrlnDmgQty]           [bigint]        null
	,[FrlnDmgCost]          [decimal](19,4) null
	,[FrlnDntQty]           [bigint]        null
	,[FrlnDntCost]          [decimal](19,4) null
	,[TotFrlnRfiQty]        [bigint]        null
	,[TotFrlnRfiCost]       [decimal](19,4) null
	,[DistLocXfrOutQty]     [bigint]        null
	,[DistLocXfrOutCost]    [decimal](19,4) null
	,[DistLocXfrInQty]      [bigint]        null
	,[DistLocXfrInCost]     [decimal](19,4) null
	,[FrlnLocXfrOutQty]     [bigint]        null
	,[FrlnLocXfrOutCost]    [decimal](19,4) null
	,[FrlnLocXfrInQty]      [bigint]        null
	,[FrlnLocXfrInCost]     [decimal](19,4) null
	,CONSTRAINT [PK_RDA_RU_NewGoodsCosts] 
		PRIMARY KEY CLUSTERED(
			 [BusinessMonth] asc
			,[LocationNo] asc 
		) with( PAD_INDEX = off 
			   ,STATISTICS_NORECOMPUTE = off 
			   ,IGNORE_DUP_KEY = off 
			   ,ALLOW_ROW_LOCKS = on 
			   ,ALLOW_PAGE_LOCKS = on 
			   ,fillfactor = 97
			) on [PRIMARY]
) on [PRIMARY]
go
