use [Maven Project]

--Objective 1 -  Explore menu_items Table
--Q1 - View the Menu_Items table
select * from menu_items

--Q2 - Find the number of items on the menu
select count(*) from menu_items

--Q3 What are the least and most expensive items on menu
select * from menu_items ---for least expensive
order by price

select * from menu_items -- for most expensive
order by price desc

--Q4 How many italian dishes are on the menu?

select count(*) from menu_items
where category = 'Italian'

--Q5 what are the least and most expensive Italian dishes on the menu?
select * from menu_items ---for least expensive
where category = 'Italian'
order by price

select * from menu_items -- for most expensive
where category = 'Italian'
order by price desc

--Q6 How many dishes are in each category
select category, count(menu_item_id) as num_dishes
from menu_items
group by category

--Q7 What is the average dish price within each 

select category, round(avg(price),2) as avg_price
from menu_items
group by category

--Objective 2 - Explore the Orders Table 

---Q1 view the order_details table --Always look back at full table before making decision on how to answer questions

select * from order_details
---Primary key is the order_details_id

---Q2 What is the date range of the table?
select min(order_date) as min_date, max(order_date) as max_date from order_details

--Q3 How many orders were made within this date range
select count(distinct order_id) as num_orders from order_details --distinct indicates a unique record.

--Q4 How many items were ordered within this date range?
select count(item_id) as total_num_items from order_details --The items are already different so can count without using distinct.

--Q5 Which orders had the most number of items?

select order_id, count(item_id) as num_items from order_details
group by order_id
order by num_items desc --14 dishes ordered for each item

--Q6 How many orders had more than 12 items? --This uses subquery
select count(*) from
(select order_id, count(item_id) as num_items from order_details
group by order_id
having count(item_id) > 12) as num_orders

-----Objective 3: Analyse Customer Behaviour-------

--Q1 Combine the menu_items and order_details tables into a single table.
select * from menu_items
select * from order_details

ALTER TABLE menu_items
ALTER COLUMN menu_item_id varchar(max) NULL

select * --Left Join keeps all rows in left table but removes those not matching in right table. left table is transaction table and right table is the look up table.
from menu_items as m
left join order_details as o
on
m.menu_item_id = o.item_id
--Q2 What were the least and most ordered items? what categories were they in?

select m.item_name, m.category, count(o.order_details_id) as num_purchases
from menu_items as m
left join order_details as o
on
m.menu_item_id = o.item_id
group by m.item_name, m.category
order by count(o.order_details_id) --use desc for finding most ordered item and nothing after order by to find least ordered item.

--Chicken Tacos was least ordered and hamburger was most ordered item

--Hamburgers popular so should be kept on menu while chicken tacos are not so something needs to be done about that.

--Some American and Asian Items are doing well but Mexican items not doing so well.

--Q3 What were the top 5 orders that spent the most money?

select TOP(5) order_id, sum(price) as total_spent ---top() function enables you to select the top 5 rows 
from menu_items as m
left join order_details as o
on
m.menu_item_id = o.item_id
group by order_id
order by sum(price) desc

--order ids 440, 2075, 1957, 330, 2675 in order highest to smallest

--Q4 View the details of the highest spent order. What insights can you gather from the table? (Begin look at order id 440 as whole then break down what can find out from each column)

select category, COUNT(item_id) as num_items ---top() function enables you to select the top 5 rows 
from menu_items as m
left join order_details as o
on
m.menu_item_id = o.item_id
where order_id = '440'
GROUP BY category

--Found that highest category that was ordered by order id 440 was Italian food. They seem to like Italian food, so should still keep on menu despite not being most popular overall.

--Q5 View the details of the top 5 highest spend orders. What insights can you gather from the table?

select order_id, category, COUNT(item_id) as num_items ---top() function enables you to select the top 5 rows 
from menu_items as m
left join order_details as o
on
m.menu_item_id = o.item_id
where order_id in (440, 2075, 1957, 330, 2675)
GROUP BY order_id,category

--It seems that overall that Italian food is most loved from top 5 highest spend orders. Insight is that keep expensive italian foods on the menu based on this data.