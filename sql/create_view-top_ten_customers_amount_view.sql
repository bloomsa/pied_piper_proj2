-- set global variables
SET VAR:database_name=pied_piper_sales;


-- drop the view top_ten_customers_amount_view (if we need to revise)
-- DROP VIEW ${var:database_name}.top_ten_customers_amount_view;

--create view top_ten_customers_amount_view on pied_piper_sales Data

-- View: top_ten_customers_amount_view 
-- Customer id, customer last name, customer first name, total lifetime purchased amount
-- This view should only return the top ten customers sorted 
-- by total dollar amount in sales from highest to lowest. 

CREATE VIEW IF NOT EXISTS ${var:database_name}.top_ten_customers_amount_view as
Select 
c.customerid as customerid
,c.lastname as lastname
,c.firstname as firstname
,a.total_lifetime_purchases
From ${var:database_name}.customers c 
join
(
    Select 
    s.customerid
    ,sum(p.price) as total_lifetime_purchases
    From ${var:database_name}.sales s
    join ${var:database_name}.products p
    on (s.productid = p.productid)
    group by s.customerid
    order by sum(p.price) desc
    limit 10
) a
on (c.customerid = a.customerid);