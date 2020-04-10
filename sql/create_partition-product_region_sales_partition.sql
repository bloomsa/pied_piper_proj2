-- set global variables
SET VAR:database_name=pied_piper_sales;

--create table product_region_sales_partition on pied_piper_sales Data
--Create an Impala Parquet sales and region materialized table that is partitioned by region, year, and month.
-- Variables:
    -- OrderID, SalesPerson ID, Customer ID, Product ID, Product Name, Product Price,
    -- Quantity, Total Sales Amount, Order Date, Region, Sales Year, Sales Month

CREATE TABLE IF NOT EXISTS ${var:database_name}.product_region_sales_partition
PARTITIONED BY (region, sales_year , sales_month) 
COMMENT 'Impala Parquet product and sales materialized table that is partitioned by sales_year and sales_month'
AS
Select 
s.orderid as order_id
,s.salespersonid as salesperson_id
,s.customerid as customer_id
,p.productid as product_id
,p.name as product_name
,p.price as product_price
,s.quantity as quantity
,CAST((p.price * s.quantity) as FLOAT) as total_sales_amount
,s.`date` as order_date
,e.region as region
,year(s.`date`) as sales_year 
,month(s.`date`) as sales_month 
From ${var:database_name}.sales s
join ${var:database_name}.products p
on (s.productid = p.productid)
join ${var:database_name}.employees e
on (s.salespersonid = e.employeeid)
; --Create the table from the query statement here



invalidate metadata;
compute stats ${var:database_name}.product_region_sales_partition;