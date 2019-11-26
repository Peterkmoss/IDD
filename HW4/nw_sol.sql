-------------
-- Clients --
-------------

--? Q1, number of customers
select count(id)
from customers;

--? Q2, number of distinct company names
select count(distinct company)
from customers;

--? Q3, duplicate company name with id's
select c1.company, c1.id, c2.id
from customers c1
	join customers c2 on c1.company = c2.company
where c1.id < c2.id 
and c1.company = (select company 
				  from customers 
				  group by company 
				  having count(*) > 1);

------------
-- Orders --
------------

--? Q1, total price of orders
select sum(unit_price * quantity * (1 - discount))
from order_details;

--? Q2, total price of orders per month basis
select to_char(o.order_date, 'month') as month, sum(od.unit_price * od.quantity * (1 - od.discount))
from order_details od
	join orders o on o.id = od.order_id
group by to_char(o.order_date, 'MM'), to_char(o.order_date, 'month')
order by to_char(o.order_date, 'MM'), to_char(o.order_date, 'month');

--? Q3, view of price being calculated for each order
drop view if exists order_prices;
create view order_prices as
select id as detail_id, order_id, product_id, unit_price * quantity * (1 - discount) as price
from order_details;

--? Q4, most expensive order detail with value
select order_id, detail_id, price
from order_prices
group by order_id, detail_id, price
having price = (select max(price) from order_prices);

--! HVAD ER FORSKELLEN PÅ DE TO? ^ v

--? Q5, which order is the most expensive
select order_id, price
from order_prices
group by order_id, price
having price = (select max(price) from order_prices);

-------------------
-- Product sales --
-------------------

--? Q1, total sales of each product, highest sellers first, include products that have not been sold
select id, sum(price)
from order_prices
	full outer join products on product_id = id
group by id
order by -sum(price);

--? Q2, Q1 but only with products that is in a category containing 'Pasta' in the description
select id, sum(price)
from order_prices
	full outer join products on product_id = id
group by id
having category like '%Pasta%'
order by -sum(price);

--? Q3, top ten frequently ordered products
