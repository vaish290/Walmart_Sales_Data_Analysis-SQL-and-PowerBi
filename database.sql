select * from walmart

select distinct(payment_method),count(*),sum(quantity)
from walmart
group by payment_method

select * 
from (select branch,category,avg(rating),rank() over(partition by branch order by avg(rating) desc) as rank
from walmart
group by branch,category)
where rank=1

select * 
from (select branch,
to_char(to_date(date,'dd/mm/yy'),'day' ) as days, count(*),
rank() over(partition by branch order by count(*) desc) as rank
from walmart
group by branch ,days
order by branch,count(*) desc)
where rank=1

select payment_method,count(*),sum(quantity)
from walmart
group by payment_method

select city,category,avg(rating) as average_rating,min(rating)as min_rating,max(rating) as max_rating
from walmart
group by city,category

select category,sum(total) as total_revenue,sum(unit_price*quantity*profit_margin) as total_profit
from walmart
group by category
order by total_profit desc

select * from (select branch,count(payment_method),payment_method,
rank() over(partition by branch order by count(payment_method) desc)
from walmart 
group by branch,payment_method
order by branch,count(payment_method) desc)
where rank=1


select count(*),branch,
CASE 
   WHEN extract(hour from(time::time))< 12  THEN 'Morning'
   WHEN extract(hour from(time::time)) between 12 and 17 THEN 'Afternoon'
   else 'Evening'
end shifts
from walmart
group by shifts,branch


with revenue_2022 as(
select branch,sum(total) as revenue
from walmart
where extract(year from(to_date(date,'dd/mm/yy'))) = 2022
group by branch
),

revenue_2023 as(
select branch,sum(total) as revenue
from walmart
where extract(year from(to_date(date,'dd/mm/yy'))) = 2023
group by branch
)

select ls.branch , ls.revenue as ls_revenue,cs.revenue as cs_revenue,round((ls.revenue-cs.revenue)::numeric/ls.revenue::numeric *100,2) as ratio
from revenue_2022 as ls
join revenue_2023 as cs
on ls.branch = cs.branch
where ls.revenue > cs.revenue
order by ratio desc
limit 5
