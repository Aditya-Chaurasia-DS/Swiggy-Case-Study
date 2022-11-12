Show databases;
#1. Find customers who have never ordered 
 select name from users where user_id not in (select user_id from orders);
 
 #2. Average Price/dish 
 select f_id,avg(price) from menu group by f_id
 #from above code only r.id is in output but we need to have dish name as well
 select f.f_name,avg(price) as 'AVG Price'
 from menu m
 join food f
 on m.f_id=f.f_id
 group by m.f_id
 
 #3. Find the top restaurant in terms of the number of orders for a given month 
 select r.r_name,count(*) As 'month'
 from orders o
 JOIN restaurants r
 on o.r_id = r.r_id
 where monthname(date) like 'June'
 group by o.r_id
 order by COUNT(*) desc limit 1
 
 #4. Restaurants with monthly sales greater than x for 
 select r.r_name, sum(amount) as 'revenue'
 from orders o
 join restaurants r
 on o.r_id=r.r_id
 where monthname(date) like'June'
 group by r.r_id
 having revenue>500;
 
 #5. Show all orders with order details for a particular customer in a particular date range 
 select o.order_id, r.r_name,f.f_name
 from orders o
 join restaurants r
 on r.r_id=o.r_id
 join order_details od
 on o.order_id=od.order_id
 join food f 
 on f.f_id=od.f_id
 where user_id = (select user_id from users where name='ankit')
 and (date > '2022-06-10' and date <'2022-07-10');
 
 #6. Find restaurants with max repeated customers 
 select r.r_name,count(*) As 'loyal_customer'
 from (
		select r_id,user_id,count(*) As 'visits'
		from orders
		group by r_id,user_id
		having visits>1
		) t
join restaurants r
on r.r_id=t.r_id
group by  t.r_id
order by loyal_customer desc limit 1;

#7. Month over month revenue growth of swiggy 
select month, ((revenue - prev)/prev)*100 from (
	with sales As
	(
	select monthname(date) as 'month',sum(amount) as 'Revenue'
	from orders
	group by month
	order by month(date)
	)
select month,revenue,LAG(revenue,1) over (order by revenue) as prev from sales 
) t

#8. Customer - favourite food Homework Find the most loyal customers for all restaurant Month over month revenue growth of a restaurant Most Paired Products.
with temp as (
	Select o.user_id, od.f_id, count(*) as 'frequency'
	from orders o
	join order_details od
	on o.order_id = od.order_id
	group by o.user_id, od.f_id
)

select u.name, f.f_name, t1.frequency
from temp t1 
join users u
on u.user_id=t1.user_id
join food f
on f.f_id=t1.f_id
where t1.frequency = (
select max(frequency) 
from temp t2 
where t2.user_id=t1.user_id);


 
 
 
 
 
 
 
 
 
 
 
 