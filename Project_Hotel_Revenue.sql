

--Group tables witch contains basic information to one big table
with hotels as (
select* 
from dbo.['2018$']
union
select*
from dbo.['2019$']
union
select*
from dbo.['2020$'])


--Shows revenue of hotels in individual years by hotel types
-- adr is American Depositary Receipt ("expresses income")
--Show every meal price on
select *
from hotels
left join dbo.market_segment$
on hotels.market_segment=market_segment$.market_segment
left join dbo.meal_cost$
on meal_cost$.meal= hotels.meal

