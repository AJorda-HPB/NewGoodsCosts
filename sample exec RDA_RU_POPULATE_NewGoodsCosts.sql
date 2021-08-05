
use ReportsView

drop table if exists #bfr
select *
into #bfr
from ReportsView..RDA_RU_NewGoodsCosts
where BusinessMonth = '2021-07-01'
    and DistSoldVal + DistOnlineSoldVal <> 0
order by 1,2


declare @UpdateMonth date = '2021-07-01'

exec ReportsView.dbo.RDA_RU_Populate_NewGoodsCosts @FirstDayOfMonth = @UpdateMonth


select @UpdateMonth[@UpdateMonth],getdate()[EndTime]


drop table if exists #aft
select *
into #aft
from ReportsView..RDA_RU_NewGoodsCosts
where BusinessMonth = '2021-07-01'
    and DistSoldVal + DistOnlineSoldVal <> 0
order by 1,2

-- stuff in #bfr that's DIFFERENT or missing from #afr
select * from #bfr 
except 
select * from #aft

-- stuff in #afr that's DIFFERENT or missing from #bfr
select * from #aft 
except 
select * from #bfr


select * 
from #aft
order by 1,2





select 
    datefromparts(year(om.OrderDate),month(om.OrderDate),1)[BusinessMonth]
    -- ,fa.HPBLocationNo[LocationNo]
    ,isnull(od.LocationNo,fa.HPBLocationNo)[LocationNo]
	,3[SldTy]
	,case when pm.ProductType = 'SCAN' then 'scan' when right(rtrim(pm.ProductType),1) <> 'F' then 'dist' else 'frln' end[PrCat]
	,sum(om.Quantity)[Qty]
	,sum(pm.Cost)[Cost]
	,sum(om.ExtendedAmount)[Val]
	,sum(om.ShippingAmount)[Fee]
--   select om.*
from isis..Order_Omni om 
	inner join isis..App_Facilities fa on om.FacilityID = fa.FacilityID
	inner join ReportsData..ProductMaster pm on right(om.SKU,20) = pm.ItemCode
    inner join ReportsView..ProdGoals_ItemMaster it on pm.ItemCode = it.ItemCode
	left join ofs..Order_Header oh on om.ISIS_OrderID = oh.ISISOrderID and oh.OrderSystem = 'HMP' and om.MarketOrderID = oh.MarketOrderID
	-- --Grabs fulfilment location where available, otherwise uses originating location
	left join ofs..Order_Detail od on oh.OrderID = od.OrderID and od.Status in (1,4) and od.ProblemStatusID is null 
where om.OrderStatus not in ('canceled')
	and om.ItemStatus = 'shipped'
    and om.ShippingMethod <> '222'
	and om.OrderDate < '2021-08-01'
	and om.OrderDate >= '2021-07-01'
	and left(om.SKU,1) = 'D'
	and om.Quantity > 0 
    and fa.HPBLocationNo = '00275'
group by 
    datefromparts(year(om.OrderDate),month(om.OrderDate),1)
    -- ,fa.HPBLocationNo
    ,isnull(od.LocationNo,fa.HPBLocationNo)
	,case when pm.ProductType = 'SCAN' then 'scan' when right(rtrim(pm.ProductType),1) <> 'F' then 'dist' else 'frln' end