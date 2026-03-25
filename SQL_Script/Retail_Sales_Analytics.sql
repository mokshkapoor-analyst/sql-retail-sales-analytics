CREATE DATABASE Retail_Sales_Analytics

USE Retail_Sales_Analytics

/*===============================================================================
Database Exploration [EDA]
===============================================================================*/

SELECT * FROM dim_customers
SELECT * FROM dim_products
SELECT * FROM fact_sales

--Explore All Objects in the Database
SELECT * 
FROM INFORMATION_SCHEMA.TABLES

-- Explore All Columns in the Database
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('dim_customers','dim_products','fact_sales')

-- Explore how many rows are there in each table?
SELECT 'dim_customers' AS TBL_NAME,COUNT(*) NUM_ROWS
FROM dim_customers
UNION ALL
SELECT 'dim_products' AS TBL_NAME,COUNT(*) NUM_ROWS
FROM dim_products
UNION ALL
SELECT 'fact_sales' AS TBL_NAME,COUNT(*) NUM_ROWS
FROM fact_sales

-- Retrieve a list of all tables in the database
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

-- Checking data type of each column
SELECT
TABLE_NAME,
COLUMN_NAME,
DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS;


--Checking NULLS
SELECT
    'dim_customers' AS TBL_NAME,
    SUM(CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END) AS customer_key,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id,
    SUM(CASE WHEN customer_number IS NULL THEN 1 ELSE 0 END) AS customer_number,
    SUM(CASE WHEN first_name IS NULL THEN 1 ELSE 0 END) AS first_name,
    SUM(CASE WHEN last_name IS NULL THEN 1 ELSE 0 END) AS last_name,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country,
    SUM(CASE WHEN marital_status IS NULL THEN 1 ELSE 0 END) AS marital_status,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender,
    SUM(CASE WHEN birthdate IS NULL THEN 1 ELSE 0 END) AS birthdate,
    SUM(CASE WHEN create_date IS NULL THEN 1 ELSE 0 END) AS create_date
FROM dim_customers


---PRODUCTS_TBL
SELECT 
     'dim_products' AS TBL_NAME,
    SUM(CASE WHEN product_key IS NULL THEN 1 ELSE 0 END) AS product_key,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id,
    SUM(CASE WHEN product_number IS NULL THEN 1 ELSE 0 END) AS product_number,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS product_name,
    SUM(CASE WHEN category_id IS NULL THEN 1 ELSE 0 END) AS category_id,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS category,
    SUM(CASE WHEN subcategory IS NULL THEN 1 ELSE 0 END) AS subcategory,
    SUM(CASE WHEN maintenance IS NULL THEN 1 ELSE 0 END) AS maintenance,
    SUM(CASE WHEN cost IS NULL THEN 1 ELSE 0 END) AS cost,
    SUM(CASE WHEN product_line IS NULL THEN 1 ELSE 0 END) AS product_line,
    SUM(CASE WHEN start_date IS NULL THEN 1 ELSE 0 END) AS start_date
FROM dim_products

---FACT_TBL
SELECT 
     'fact_sales' AS TBL_NAME,
    SUM(CASE WHEN order_number IS NULL THEN 1 ELSE 0 END) AS order_number,
    SUM(CASE WHEN product_key IS NULL THEN 1 ELSE 0 END) AS product_key,
    SUM(CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END) AS customer_key,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS order_date,
    SUM(CASE WHEN shipping_date IS NULL THEN 1 ELSE 0 END) AS shipping_date,
    SUM(CASE WHEN due_date IS NULL THEN 1 ELSE 0 END) AS due_date,
    SUM(CASE WHEN sales_amount IS NULL THEN 1 ELSE 0 END) AS sales_amount,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price
FROM fact_sales

----CHECKING BLANKS
SELECT
    'dim_customers' AS TBL_NAME,
    SUM(CASE WHEN customer_key ='' THEN 1 ELSE 0 END) AS customer_key,
    SUM(CASE WHEN customer_id ='' THEN 1 ELSE 0 END) AS customer_id,
    SUM(CASE WHEN customer_number ='' THEN 1 ELSE 0 END) AS customer_number,
    SUM(CASE WHEN first_name ='' THEN 1 ELSE 0 END) AS first_name,
    SUM(CASE WHEN last_name ='' THEN 1 ELSE 0 END) AS last_name,
    SUM(CASE WHEN country ='' THEN 1 ELSE 0 END) AS country,
    SUM(CASE WHEN marital_status ='' THEN 1 ELSE 0 END) AS marital_status,
    SUM(CASE WHEN gender ='' THEN 1 ELSE 0 END) AS gender,
    SUM(CASE WHEN birthdate ='' THEN 1 ELSE 0 END) AS birthdate,
    SUM(CASE WHEN create_date ='' THEN 1 ELSE 0 END) AS create_date
FROM dim_customers

--------------------DIMENSION EXPLORATION


-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT 
    country 
FROM dim_customers
ORDER BY country;

--Retrieve a list of unique Category from PRODUCT TBL
SELECT DISTINCT category
FROM dim_products

---Retrieve a list of unique SUB-Category from PRODUCT TBL
SELECT DISTINCT subcategory
FROM dim_products

-----Retrieve a list of unique product_name from PRODUCT TBL
SELECT DISTINCT product_name
FROM dim_products

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM dim_products
ORDER BY category, subcategory, product_name;

------------------------------DATE EXPLORATION
-- Determine the first and last order date and the total duration in months
SELECT MIN(order_date) AS MIN_ORD_DATE, MAX(order_date) AS MAX_ORD_DATE,
DATEDIFF(MONTH,MIN(order_date), MAX(order_date)) AS ORDER_RANGE_YRS
FROM fact_sales

-- Find the youngest and oldest customer based on birthdate
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM dim_customers;

/*===============================================================================
Measures Exploration (Key Metrics)
===============================================================================*/

-- Find the Total Sales
SELECT SUM(sales_amount) AS TOTAL_SALES
FROM fact_sales

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity 
FROM fact_sales

-- Find the average selling price
SELECT AVG(price) AS Selling_Price
FROM fact_sales

-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders
FROM fact_sales

-- Find the total number of products
SELECT COUNT(DISTINCT product_id) AS total_products
FROM dim_products

-- Find the total number of customers
SELECT COUNT(customer_id) AS total_customers
FROM dim_customers

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM fact_sales

---- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM fact_sales

/*===============================================================================
Magnitude Analysis
===============================================================================*/

-- Find total customers by countries
SELECT  country,COUNT(customer_id) AS total_customers 
FROM dim_customers
GROUP BY country
ORDER BY total_customers DESC;
 
-- Find total customers by gender
SELECT  gender,COUNT(customer_id) AS total_customers 
FROM dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Find total products by category
SELECT category,COUNT(product_id) AS total_products 
FROM dim_products
GROUP BY category
ORDER BY  total_products DESC

-- What is the average costs in each category?
SELECT category,AVG(cost) AS  avgerage_cost
FROM dim_products
WHERE category IS NOT NULL
GROUP BY category
ORDER BY avgerage_cost DESC

-- What is the total revenue generated for each category?
SELECT P.category,SUM(F.sales_amount) AS total_revenue
FROM fact_sales AS F
LEFT JOIN dim_products AS P
ON P.product_key= F.product_key 
GROUP BY P.category
ORDER BY total_revenue DESC

--Which gender made higher sales?
SELECT gender,SUM(sales_amount) AS total_sales
FROM fact_sales AS F
LEFT JOIN dim_customers AS C
ON F.customer_key =C.customer_key
GROUP BY gender
ORDER BY total_sales DESC


-- What is the total revenue generated by each customer?
SELECT customer_id,CONCAT(C.first_name,' ',C.last_name) AS customer_name ,SUM(F.sales_amount) AS total_revenue
FROM fact_sales AS F
LEFT JOIN dim_customers AS C
ON F.customer_key = C.customer_key
GROUP BY customer_id,CONCAT(C.first_name,' ',C.last_name)
ORDER BY total_revenue DESC

---- What is the distribution of sold items across countries?
SELECT C.country , SUM(F.quantity) AS total_qty
FROM fact_sales AS F
LEFT JOIN dim_customers AS C
ON F.customer_key = C.customer_key
GROUP BY C.country 
ORDER BY total_qty DESC

/*
===============================================================================
Ranking Analysis
===============================================================================*/

--What are the top 5 revenue genrated products?
SELECT TOP 5 P.product_name,SUM(F.sales_amount) AS total_revenue 
FROM fact_sales AS F
LEFT JOIN dim_products AS P
ON F.product_key = P.product_key
GROUP BY P.product_name
ORDER BY total_revenue DESC

--- using ranking function
SELECT * 
FROM
    (SELECT P.product_name,SUM(F.sales_amount) AS total_revenue,DENSE_RANK() OVER(ORDER BY SUM(F.sales_amount)  DESC)  AS Rnk
    FROM fact_sales AS F
    LEFT JOIN dim_products AS P
    ON F.product_key = P.product_key
    GROUP BY P.product_name
    ) AS t
WHERE Rnk<=5

-- What are the 5 worst-performing products in terms of sales?
SELECT * 
FROM
    (SELECT P.product_name,SUM(F.sales_amount) AS total_revenue,
    DENSE_RANK() OVER(ORDER BY SUM(F.sales_amount)  ASC)  AS Rnk
    FROM fact_sales AS F
    LEFT JOIN dim_products AS P
    ON F.product_key = P.product_key
    GROUP BY P.product_name
    ) AS t
WHERE Rnk<=5

-- Find the top 10 customers who have generated the highest revenue
SELECT *
FROM( 
SELECT C.customer_id,CONCAT(C.first_name,' ',C.last_name) AS customer_name
,SUM(F.sales_amount) AS total_revenue,
ROW_NUMBER() OVER(ORDER BY SUM(F.sales_amount) DESC) AS row_num
FROM fact_sales AS F
LEFT JOIN dim_customers AS C
ON F.customer_key =C.customer_key
GROUP BY C.customer_id,CONCAT(C.first_name,' ',C.last_name)
) AS T
WHERE row_num<=10

 -- The 3 customers with the fewest orders placed
SELECT TOP 3 C.customer_key, CONCAT(C.first_name, ' ',c.last_name) AS customer_name
,COUNT(DISTINCT order_number) AS total_orders
FROM fact_sales AS S
LEFT JOIN dim_customers AS C
ON C.customer_key =S.customer_key
GROUP BY C.customer_key,C.first_name,C.last_name
ORDER BY total_orders

------------------------------------------ADVANCE DATA ANALYTICS
/*
===============================================================================
Change Over Time Analysis
===============================================================================
*/

-- Analyse sales performance over time
SELECT FORMAT(order_date,'yyyy-MM') AS Order_date,SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_qty
FROM fact_sales AS S
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date,'yyyy-MM')
ORDER BY Order_date ASC

--Analyse monthly trends of total sales
SELECT 
    FORMAT(order_date,'yyyy-MM') AS Year_Month,
    SUM(sales_amount) AS total_sales
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date,'yyyy-MM')
ORDER BY Year_Month;

--Analyse Yearly trends of total sales
SELECT YEAR(order_date) AS Years,SUM(sales_amount) AS total_sales
FROM fact_sales AS S
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY Years ASC

/*
===============================================================================
Cumulative Analysis
===============================================================================*/

-- Calculate the total sales per month 
-- and the running total of sales over time 

SELECT 
    year_month,
    total_sales,
    SUM(total_sales) OVER (ORDER BY year_month  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM (
    SELECT 
        FORMAT(order_date,'yyyy-MM') AS year_month,
        SUM(sales_amount) AS total_sales
    FROM fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY FORMAT(order_date,'yyyy-MM')
) t
ORDER BY year_month;

-- Calculate the AVG sales per month 
-- and the moving avg sales over time     
SELECT *,
ROUND(
    AVG(avg_sales) OVER (
        ORDER BY year_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2
) AS running_avg
FROM (
    SELECT 
        FORMAT(order_date,'yyyy-MM') AS year_month,
        AVG(sales_amount) AS avg_sales
    FROM fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY FORMAT(order_date,'yyyy-MM')
) t
ORDER BY year_month;

-- Calculate the total sales per year
-- and the running total sales over time 
SELECT YEAR(order_date) AS Years,SUM(sales_amount) AS total_sales,
SUM(SUM(sales_amount)) OVER(ORDER BY YEAR(order_date)) AS running_total
FROM fact_sales AS S
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date) 


/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH yearly_sales AS (
    SELECT YEAR(S.order_date) AS Year,P.product_name,SUM(sales_amount) AS current_sales
    FROM fact_sales AS S
    LEFT JOIN dim_products AS P
    ON S.product_key = P.product_key
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(S.order_date),P.product_name
)
SELECT 
YEAR,
product_name,
current_sales,
AVG(current_sales) OVER(PARTITION BY product_name ORDER BY YEAR ) avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name ) as diff_avg,
CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name )> 0 THEN 'Above Avg'
     WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name )< 0 THEN 'Below Avg'
     ELSE 'Avg'
END AS avg_change,
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY YEAR) AS prev_yr_value,
current_sales- LAG(current_sales) OVER(PARTITION BY product_name ORDER BY YEAR) AS YOY,
CASE WHEN current_sales -LAG(current_sales) OVER(PARTITION BY product_name ORDER BY YEAR)> 0 THEN 'Increase'
     WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY YEAR)< 0 THEN 'Decrease'
     ELSE 'No Change'
END AS yoy_change
FROM yearly_sales
ORDER BY product_name, YEAR

/*
===============================================================================
Part-to-Whole Analysis
===============================================================================*/

-- Which categories contribute the most to overall sales?
SELECT *,
CONCAT(
        FORMAT(
        ROUND(
        CAST(total_sales AS float)*100/SUM(total_sales) OVER() ,2)
        ,'N2'),'%') AS contribution 
FROM (
SELECT P.category , SUM(S.sales_amount) AS total_sales
FROM fact_sales S
INNER JOIN dim_products AS P
ON S.product_key = P.product_key
GROUP BY P.category 
) AS t


/*
===============================================================================
Data Segmentation Analysis
===============================================================================*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/
WITH product_segments AS (
SELECT product_key,product_name,cost,
CASE WHEN cost<100 THEN 'Below 100'
     WHEN cost BETWEEN 100 AND 500 THEN '100-500'
     WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
     ELSE  'Above 1000'
END cost_range
FROM dim_products )

SELECT cost_range,COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC

--Segment customers based on their age
WITH segment AS
(
        SELECT *, 
        CASE WHEN Age BETWEEN 18 AND 24 THEN 'Young Adults'
             WHEN Age BETWEEN 25 AND 34 THEN 'Early Adults'
             WHEN Age BETWEEN 35 AND 44 THEN 'Mid Adults'
             WHEN Age BETWEEN 45 AND 54 THEN 'Mature Adults'
             WHEN Age BETWEEN 55 AND 64 THEN 'Pre-Seniors'
             ELSE 'Seniors'
        END AS Age_category
        FROM (
                SELECT C.customer_id,C.birthdate,DATEDIFF(YEAR,birthdate,MAX(S.order_date)) AS Age , sum(s.sales_amount) as totsl_sales
                FROM dim_customers C
                INNER JOIN fact_sales S
                ON C.customer_key = S.customer_key
                GROUP BY C.customer_id,C.birthdate
        ) AS t
)
SELECT Age_category,COUNT(customer_id) AS total_customers,SUM(totsl_sales) as sales 
FROM segment
GROUP BY Age_category
ORDER BY sales DESC

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH customer_spending AS (
  SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM fact_sales f
    LEFT JOIN dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT 
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT 
        customer_key,
        CASE 
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;


/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
IF OBJECT_ID('customer_report' ,'V') IS NOT NULL
    DROP VIEW customer_report
GO 

CREATE VIEW customer_report AS
WITH base_query AS (
SELECT 
S.order_number,
S.product_key,
S.order_date,
S.sales_amount,
S.quantity,
C.customer_key,
C.customer_number,
CONCAT(C.first_name, ' ', C.last_name) AS customer_name,
DATEDIFF(year, C.birthdate, GETDATE()) age
FROM fact_sales AS S
LEFT JOIN dim_customers C
ON S.customer_key = C.customer_key
WHERE S.order_date IS NOT NULL)

,customer_aggregation AS(
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY
customer_key,
customer_number,
customer_name,
age
)
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE 
	     WHEN age < 20 THEN 'Under 20'
	     WHEN age between 20 and 29 THEN '20-29'
	     WHEN age between 30 and 39 THEN '30-39'
	     WHEN age between 40 and 49 THEN '40-49'
	     ELSE '50 and above'
    END AS age_group,
    CASE 
        WHEN lifespan >= 12 AND total_sales<= 5000 THEN 'Regular'
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        ELSE 'New'
    END AS customer_segment,
    last_order_date,
    DATEDIFF(month, last_order_date, GETDATE()) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,
-- Compuate average order value (AVO)
    CASE WHEN total_sales = 0 THEN 0
    	 ELSE total_sales / total_orders
    END AS avg_order_value,
-- Compuate average monthly spend
    CASE WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_spend    
FROM customer_aggregation

SELECT * 
FROM customer_report

/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

IF OBJECT_ID('report_products', 'V') IS NOT NULL
    DROP VIEW report_products;
GO

CREATE VIEW report_products AS
WITH base_query AS (
SELECT 
f.order_number,
f.order_date,
f.customer_key,
f.sales_amount,
f.quantity,
p.product_key,
P.product_name,
P.category,
P.subcategory,
P.cost
FROM fact_sales AS F
LEFT JOIN dim_products AS P
ON F.product_key = P.product_key
WHERE F.order_date IS NOT NULL
),
product_aggregations AS (
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
    MAX(order_date) AS last_sale_date,
    COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query
GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
)
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- Average Order Revenue (AOR)
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,

	-- Average Monthly Revenue
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue

FROM product_aggregations 



SELECT * 
FROM customer_report

SELECT * 
FROM report_products









