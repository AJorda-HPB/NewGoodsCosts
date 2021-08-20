
USE [Report_Analytics]
GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:          Alicia Jorda
-- Create date:     08/6/2021
-- Description:		Maps all product types to categories for determining new goods costs,
--                  For new: dist, frln, or scan; everything else: gc, spcl, or used.
-- Run Schedule:	Once at start of each month, after all 
-- 					sales & transfers for the previous month are in.
-- =============================================
CREATE PROCEDURE [dbo].[RDA_Populate_NewGoodsCosts_PTypeCategory]

-- Add the parameters for the stored procedure here

AS 
BEGIN 

SET NOCOUNT ON;


truncate table [dbo].[RDA_NewGoodsCosts_PTypeCategory]

insert into [dbo].[RDA_NewGoodsCosts_PTypeCategory]
select pt.ProductType 
    ,case when pt.ProductType in ('BDGF','CALF','HBF','LPF','NBAF','NBJF','PBF','TOYF','TRF','VGF') then 'frln' 
          when pt.ProductType in ('PGC','EGC')    then 'gc'
          when pt.ProductType in ('SCAN')         then lower(pt.ProductType) 
          when pt.PTypeClass  in ('SPCL','USED')  then lower(pt.PTypeClass) 
          when pt.PTypeClass  in ('NEW')          then 'dist' 
          else 'zzz' end
    ,pt.PTypeClass
from ReportsData.dbo.ProductTypes pt; 


END


