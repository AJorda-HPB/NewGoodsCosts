

USE [Report_Analytics]
GO

DROP TABLE IF EXISTS [dbo].[RDA_NewGoodsCosts_PTypeCategory]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RDA_NewGoodsCosts_PTypeCategory](
	 [ProductType]          [char](4)       not null
	,[PTypeCategory]        [char](6)       not null
    ,[PTypeClass]           [char](6)       not null
	,CONSTRAINT [PK_RDA_NewGoodsCosts_PTypeCategory] 
		PRIMARY KEY CLUSTERED([ProductType] asc)
            with(PAD_INDEX = off 
                ,STATISTICS_NORECOMPUTE = off 
                ,IGNORE_DUP_KEY = off 
                ,ALLOW_ROW_LOCKS = on 
                ,ALLOW_PAGE_LOCKS = on 
                ,fillfactor = 97
			) on [PRIMARY]
) on [PRIMARY]
GO

