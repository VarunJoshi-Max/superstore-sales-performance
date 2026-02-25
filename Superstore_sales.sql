/*
Project: Data Analytics & Business Intelligence – Task 2
Author: Varun
Purpose: Create database for sales performance analysis
*/

CREATE DATABASE sales_analysis;



/*
Table: orders
Purpose: Store transactional sales data at line-item level
*/

CREATE TABLE orders (
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    order_priority VARCHAR(20),
    ship_mode VARCHAR(50),
    customer_name VARCHAR(100),
    customer_segment VARCHAR(50),
    region VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(50),
    product_category VARCHAR(50),
    product_sub_category VARCHAR(100),
    product_name VARCHAR(255),
    product_container VARCHAR(50),
    order_quantity INT,
    unit_price DECIMAL(10,2),
    sales DECIMAL(12,2),
    discount DECIMAL(5,2),
    shipping_cost DECIMAL(10,2),
    profit DECIMAL(12,2),
    product_base_margin DECIMAL(5,2)
);


/*
Table: returns
Purpose: Identify returned orders
*/

CREATE TABLE returns (
    order_id VARCHAR(50),
    status VARCHAR(20)
);




COPY orders
FROM 'C:\Maincrafts Professional Internship\Task 2\archive (1)\orders.csv'
DELIMITER ','
CSV HEADER;




COPY returns
FROM 'C:\Maincrafts Professional Internship\Task 2\archive (1)\returns.csv'
DELIMITER ','
CSV HEADER;



/*
Business Question:
Which region generates the highest revenue?
*/

SELECT
    region,
    SUM(sales) AS total_sales
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

Output:

"region"	"total_sales"
"Central"	4699167.35
"West"	        3649747.86
"East"	        3416466.56
"South"	        3150219.34




/*
Business Question:
Which product category is most profitable?
*/

SELECT
    product_category,
    SUM(profit) AS total_profit
FROM orders
GROUP BY product_category
ORDER BY total_profit DESC;

OUTPUT:

"product_category"	"total_profit"
"Technology"	         886313.52
"Office Supplies"	 518021.43
"Furniture"		 117433.03




/*
Business Question:
Is there a seasonal sales pattern?
*/

SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(sales) AS monthly_sales
FROM orders
GROUP BY year, month
ORDER BY year, month;


/*
Business Question:
Identify returned transactions.
Join Type: LEFT JOIN (retain all orders)
*/

SELECT
    o.order_id,
    o.sales,
    r.status
FROM orders o
LEFT JOIN returns r
    ON o.order_id = r.order_id;



/*
Business Question:
What percentage of orders were returned?
*/

SELECT
    COUNT(DISTINCT r.order_id) AS returned_orders,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT r.order_id) * 100.0 /
        COUNT(DISTINCT o.order_id),
        2
    ) AS return_rate_percentage
FROM orders o
LEFT JOIN returns r
    ON o.order_id = r.order_id;


OUTPUT:


"returned_orders"	"total_orders"	   "return_rate_percentage"
     572	             5496	          10.41



/*
Business Question:
What is the financial impact of returns?
*/

SELECT
    SUM(o.sales) AS revenue_from_returned_orders
FROM orders o
INNER JOIN returns r
    ON o.order_id = r.order_id;



OUTPUT:

"revenue_from_returned_orders"
1654853.75




/*
Business Question:
What is overall profit margin?
*/

SELECT
    SUM(profit) AS total_profit,
    SUM(sales) AS total_sales,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percentage
FROM orders;



OUTPUT:

"total_profit"	"total_sales"	"profit_margin_percentage"
1521767.98	14915601.11	10.20




/*
Business Question:
What is the average revenue per order?
*/

SELECT
    SUM(sales) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(sales) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM orders;


OUTPUT:

"total_sales"	"total_orders"	"average_order_value"
14915601.11	   5496	             2713.90




/*
Business Question:
Who are the top revenue-generating customers?
*/

SELECT
    customer_name,
    SUM(sales) AS total_revenue
FROM orders
GROUP BY customer_name
ORDER BY total_revenue DESC
LIMIT 5;



OUTPUT:

"customer_name"	    "total_revenue"
"Emily Phan"		117124.43
"Deborah Brumfield"	97433.14
"Roy Skaria"		92542.16
"Sylvia Foulston"	88875.76
"Grant Carroll"		88417.00

