

USE [ReportsView]
GO

DROP TABLE IF EXISTS [dbo].[RDA_NewGoodsCosts_PTypeCategory]
GO

USE [ReportsView]
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
go


insert into [dbo].[RDA_NewGoodsCosts_PTypeCategory]
select pt.ProductType 
    ,case when pt.PTypeClass = 'USED' then 'used'
          when pt.ProductType in ('PGC','EGC') then 'gc'
          when pt.ProductType in ('SCAN','XTRA') then lower(pt.ProductType) 
          when right(rtrim(pt.ProductType),1) <> 'F' then 'dist' 
          when right(rtrim(pt.ProductType),1) = 'F' then 'frln' 
          else 'zzz' end
    ,pt.PTypeClass
from ReportsData..ProductTypes pt 





select * 
from ReportsView..RDA_NewGoodsCosts_PTypeCategory pc 
order by PTypeClass
    ,PTypeCategory


select pc.*
    ,sih.ItemCode
    ,pm.Title
    ,loc.LocationNo
    ,sum(sih.Quantity)[SldQty]
    ,sum(sih.ExtendedAmt)[SldVal]
from HPB_SALES..SHH2021 shh 
	inner join HPB_SALES..SIH2021 sih 
		on sih.LocationID = shh.LocationID
		and sih.BusinessDate = shh.BusinessDate
		and sih.SalesXactionId = shh.SalesXactionID
	inner join ReportsData..Locations loc on sih.LocationID = loc.LocationID
	inner join ReportsData..ProductMaster pm on sih.ItemCode = pm.Itemcode 
	inner join ReportsView..RDA_NewGoodsCosts_PTypeCategory pc on pm.ProductType = pc.ProductType 
where pc.PTypeClass = 'SPCL' 
group by pc.ProductType
    ,pc.PTypeCategory
    ,pc.PTypeClass
    ,sih.ItemCode
    ,pm.Title
    ,loc.LocationNo