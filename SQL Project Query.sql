-- Taking a look at the dataset
SELECT
	*
FROM
	sales_data

-- Figuring out and sorting the sales numbers of each product line by qtr and year

SELECT
    SUM(sales) as revenue,
    product_line,
	qtr_id,
	year_id
FROM
    sales_data
GROUP BY
    product_line,
	year_id,
	qtr_id
ORDER BY
	year_id,
    qtr_id;

-- Calculating the total sales for every year independently
SELECT
	SUM(Sales),
	year_id
FROM
	sales_data
GROUP BY
	year_id
ORDER BY
	year_id
	
-- Calculate the total sales of all years combined 
SELECT
	SUM(Sales)
FROM
	sales_data;

-- Calculating the average sales for all the years
SELECT
	ROUND(AVG(Sales),2),
	year_id
FROM
	sales_data
GROUP BY
	year_id
ORDER BY
	year_id


	
-- Calculating the overall average sales 
SELECT
	avg(Sales)	
FROM
	sales_data;


-- Calculating the max sales for each of the years
SELECT
	MAX(Sales),
	year_id
FROM
	sales_data
GROUP BY 
	year_id
ORDER BY
	year_id
	
-- Calculating the overall max sales

SELECT
	MAX(Sales)
	
FROM
	sales_data;

	
-- Calculate  the min sales for each of the years
SELECT
	min(Sales),
	year_id
FROM
	sales_data
GROUP BY 
	year_id
ORDER BY 
	year_id
	
-- calculating the overall min sales 
SELECT
	min(Sales)
	
FROM
	sales_data;

-- Calculate the total revenue and total amount ordered for each product code and product line,
-- and order the results by the total amount ordered in descending order
SELECT
	product_code,
	product_line,
	SUM(quantity_ordered) as total_amount_ordered,
	SUM(sales) as total_revenue
FROM
	sales_data
GROUP BY
	product_code,
	product_line
ORDER BY
	SUM(quantity_ordered) DESC;

-- Figuring out our top customers and how many times each customer has ordered from the company
SELECT
	customer_name,
	COUNT(customer_name) AS times_ordered,
	SUM(sales) AS total_revenue
FROM
	sales_data
GROUP BY 
	customer_name
ORDER BY 
	times_ordered DESC;
	
-- figuring out the customer-product relationship 
SELECT
	customer_name,
	product_code,
	product_line,
	COUNT(customer_name) AS number_of_company_orders,
	SUM(quantity_ordered) as amount_of_products_ordered,
	SUM(sales) AS total_revenue
FROM
	sales_data
GROUP BY 
	customer_name,
	product_code,
	product_line
HAVING
	COUNT(customer_name) >= 2
ORDER BY 
	number_of_company_orders DESC,
	amount_of_products_ordered DESC,
	total_revenue DESC;

-- Figuring out the Customer - Product Relationship
WITH NumberedOrders AS (
    SELECT
        customer_name,
        product_code,
        product_line,
        COUNT(*) AS number_of_company_orders,
        SUM(quantity_ordered) as amount_of_products_ordered,
        SUM(sales) AS total_revenue,
        ROW_NUMBER() OVER(PARTITION BY customer_name ORDER BY COUNT(*) DESC) AS row_num
    FROM
        sales_data
    GROUP BY
        customer_name,
        product_code,
        product_line
)

SELECT
    customer_name,
    product_code,
    product_line,
    number_of_company_orders,
    amount_of_products_ordered,
    total_revenue,
	row_num
FROM
    NumberedOrders
WHERE
    row_num <= 2
ORDER BY
    number_of_company_orders DESC,
	total_revenue DESC,
	amount_of_products_ordered DESC,
	customer_name DESC;


-- Categorize orders by size based on sales
SELECT
	order_number,
	sales,
	CASE  
		WHEN sales < 1000 THEN 'small'
		WHEN sales < 6000 THEN 'medium'
		ELSE 'large'
	END AS order_size
FROM
	sales_data
ORDER BY
	sales DESC;

-- Creating a View with a case statement 
DROP VIEW IF EXISTS sale_order_size

CREATE VIEW sale_order_size AS (
SELECT
	order_number,
	sales,
	CASE  
		WHEN sales < 1000 THEN 'small'
		WHEN sales < 6000 THEN 'medium'
		ELSE 'large'
	END AS order_size
FROM
	sales_data
ORDER BY
	sales DESC
)
SELECT 
	*
FROM 
	sale_order_size;

-- Find the total sales for each month of the year 2003
SELECT 
    EXTRACT(MONTH FROM TO_DATE(ORDER_DATE, 'MM/DD/YYYY HH24:MI')) AS MONTH, 
    SUM(SALES) AS TOTAL_SALES 
FROM 
    sales_data 
WHERE 
    EXTRACT(YEAR FROM TO_DATE(ORDER_DATE, 'MM/DD/YYYY HH24:MI')) = 2003
GROUP BY 
    MONTH 
ORDER BY 
    MONTH;

-- Creating a temp table 
DROP TABLE IF EXISTS product_revenue
Create TEMP Table product_revenue AS(
SELECT
	product_code,
	product_line,
	SUM(quantity_ordered) as total_amount_ordered,
	SUM(sales) as total_revenue
FROM
	sales_data
GROUP BY
	product_code,
	product_line
);
SELECT
	*
FROM
	product_revenue
	
-- This query retrieves all sales data for each product line, 
-- along with the maximum sales within each product line and a ranking based on sales values in descending order. 
-- The outer query then filters the results to only include records 
-- with a rank of less than 4, effectively getting the top 3 sales records for each product line.
SELECT
	*
FROM(
		SELECT
		product_line,
		sales,
		MAX(Sales) OVER(PARTITION BY product_line) AS max_sales,
		RANK() OVER(PARTITION BY product_line ORDER BY sales DESC) AS row_number
	FROM
		sales_data) AS S
WHERE
	S.row_number < 4;

		

