SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================
-- Author:		Alicia Jorda
-- Create date: 8/6/2021
-- Description:	Costs from new goods sales & transfers
-- Help Desk Ticket: #16597
-- =======================================================

CREATE   PROCEDURE [dbo].[RDA_COGS_NewGoodsCosts]
	-- Add the parameters for the stored procedure here

    -- Fed from PARAMS_DynFilter_Locations ?
	@LocationType VARCHAR(20),
	@Location VARCHAR(30),
	
    -- Fed from RDA_PARAMS_CreateDateRangeSelect ?
    @StartDate DATE,
	@EndDate DATE
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    --Create table in which to store locations which fall within dynamic selection criteria.
    DROP TABLE IF EXISTS #ReportLocations
    CREATE TABLE #ReportLocations (
        LocationNo CHAR(5),
        LocationName VARCHAR(30)
        )

    --Retrieve locations into table based on selection criteria.
    --Reference to stored procedure Reports..PARAMS_DynFilter_Locations is necessary for full context.
    IF @LocationType = 'All Locations'
        INSERT INTO #ReportLocations
        SELECT
            LocationNo,
            LocationNo + ' ' + loc.Name [LocationName]
        FROM ReportsData..Locations loc
        WHERE 
            loc.RetailStore = 'Y' AND
            loc.Status = 'A'

    IF @LocationType = 'Store'
        INSERT INTO #ReportLocations
        SELECT
            LocationNo,
            LocationNo + ' ' + loc.Name [LocationName]
        FROM ReportsData..Locations loc
        WHERE loc.LocationNo = @Location AND
            loc.RetailStore = 'Y' AND
            loc.Status = 'A' 

    IF @LocationType = 'District'
        INSERT INTO #ReportLocations
        SELECT
            LocationNo,
            LocationNo + ' ' + loc.Name [LocationName]
        FROM ReportsData..Locations loc
        WHERE
            RTRIM(loc.DistrictCode) = @Location AND
            loc.RetailStore = 'Y' AND
            loc.Status = 'A' 
            
    IF @LocationType = 'Region'
        INSERT INTO #ReportLocations
        SELECT DISTINCT
            loc.LocationNo,
            loc.LocationNo + ' ' + loc.Name [LocationName]
        FROM ReportsData..Locations loc
        INNER JOIN ReportsData..ReportLocations rl
            ON RTRIM(loc.DistrictCode) = rl.District
            AND rl.Region = @Location
        WHERE
            loc.RetailStore = 'Y' AND
            loc.Status = 'A'


	SELECT ngc.BusinessMonth
		,ngc.LocationNo

		-- In-Store Sales...
		,ngc.DistSoldCost
		,ngc.FrlnSoldCost
		,ngc.ScanSoldCost

		,ngc.DistSoldVal[DistSoldAmt]
		,ngc.FrlnSoldVal[FrlnSoldAmt]
		,ngc.ScanSoldVal[ScanSoldAmt]

		,ngc.ScanSoldQty

		-- Online Sales...
		,ngc.DistOnlineSoldCost
		,ngc.FrlnOnlineSoldCost

		,ngc.DistOnlineSoldVal[DistOnlineSoldAmt]
		,ngc.FrlnOnlineSoldVal[FrlnOnlineSoldAmt]

		-- Bookworm Sales...
		,ngc.DistBookwormSoldCost
		,ngc.FrlnBookwormSoldCost

		,ngc.DistBookwormSoldVal[DistBookwormSoldAmt]
		,ngc.FrlnBookwormSoldVal[FrlnBookwormSoldAmt]

		-- Total Xfers In/Out
		,ngc.DistTotXfrInCost[DistTotalTransfersInCost]
		,ngc.DistTotXfrOutCost[DistTotalTransfersOutCost]
		,ngc.FrlnTotXfrInCost[FrlnTotalTransfersInCost]
		,ngc.FrlnTotXfrOutCost[FrlnTotalTransfersOutCost]

		,ngc.DistTotXfrInQty[DistTotalTransfersInQty]
		,ngc.DistTotXfrOutQty[DistTotalTransfersOutQty]
		,ngc.FrlnTotXfrInQty[FrlnTotalTransfersInQty]
		,ngc.FrlnTotXfrOutQty[FrlnTotalTransfersOutQty]

        -- Total RFI Transfers
		,ngc.TotDistRfiCost[DistTotalRfiCost]
		,ngc.TotFrlnRfiCost[FrlnTotalRfiCost]

		,ngc.TotDistRfiQty[DistTotalRfiQty]
		,ngc.TotFrlnRfiQty[FrlnTotalRfiQty]

        -- Tsh/Dmg/Dnt Transfers
		,ngc.DistTshCost[DistTrashCost]
		,ngc.DistDmgCost[DistDamageCost]
		,ngc.DistDntCost[DistDonateCost]
		,ngc.FrlnTshCost[FrlnTrashCost]
		,ngc.FrlnDmgCost[FrlnDamageCost]
		,ngc.FrlnDntCost[FrlnDonateCost]

		,ngc.DistTshQty[DistTrashQty]
		,ngc.DistDmgQty[DistDamageQty]
		,ngc.DistDntQty[DistDonateQty]
		,ngc.FrlnTshQty[FrlnTrashQty]
		,ngc.FrlnDmgQty[FrlnDamageQty]
		,ngc.FrlnDntQty[FrlnDonateQty]

	FROM ReportsData.dbo.RDA_RU_NewGoodsCosts ngc 
		INNER JOIN #ReportLocations rl on ngc.LocationNo = rl.LocationNo    
    WHERE   ngc.BusinessMonth >= @StartDate
        and ngc.BusinessMonth <= @EndDate
	ORDER BY 1,2;

    DROP TABLE IF EXISTS #ReportLocations

END
GO
