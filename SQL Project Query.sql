-- Looking at the dataset
SELECT
	*
FROM
	sales_data

-- Calculating the total revenue by product line for Q1 of 2003
SELECT
	SUM(sales) as revenue,
	product_line
FROM
	sales_data
WHERE
	qtr_id = 1 AND
	year_id = 2003 
GROUP BY
	product_line;

-- Calculating the total revenue by product line for Q2 of 2003
SELECT
	SUM(sales) as revenue,
	product_line
FROM
	sales_data
WHERE
	qtr_id = 2 AND
	year_id = 2003 
GROUP BY
	product_line;

-- Calculating the total revenue by product line for Q3 of 2003
SELECT
	SUM(sales) as revenue,
	product_line
FROM
	sales_data
WHERE
	qtr_id = 3 AND
	year_id = 2003 
GROUP BY
	product_line;

-- Calculating the total revenue by product line for Q4 of 2003
SELECT
	SUM(sales) as revenue,
	product_line
FROM
	sales_data
WHERE
	qtr_id = 4 AND
	year_id = 2003 
GROUP BY
	product_line;

-- Calculating the total revenue by product line for Q1 of 2004
SELECT
	SUM(sales) as revenue,
	product_line
FROM
	sales_data
WHERE
	qtr_id = 1 AND
	year_id = 2004 
GROUP BY
	product_line;

-- Calculating the total revenue by product line for Q2 of 2004
SELECT
	SUM(sales) as revenue,
	product_line
FROM
	sales_data
WHERE
	qtr_id = 2 AND
	year_id = 2004 
GROUP BY
	product_line;

-- Calculating the total revenue by product line for Q3 of 2004
SELECT
	SUM(sales) as revenue,
	product_line
FROM
	sales_data
WHERE
	qtr_id = 3 AND
	year_id = 2004 
GROUP BY
	product_line;

-- Calculating the total revenue by product line for Q4 of 2004 
SELECT
	SUM(sales) as revenue,
	product_line
FROM
	sales_data
WHERE
	qtr_id = 4 AND
	year_id = 2004 
GROUP BY
	product_line;
-- Calculating the total revenue by product line for Q1of 2005
SELECT
	SUM(sales) as revenue,
	product_line
FROM
	sales_data
WHERE
	qtr_id = 1 AND
	year_id = 2005 
GROUP BY
	product_line;

-- Calculating the total revenue by product line for Q2 of 2005 
SELECT
	SUM(sales) as revenue,
	product_line
FROM
	sales_data
WHERE
	qtr_id = 2 AND
	year_id = 2005 
GROUP BY
	product_line;

-- Calculating the total sales for the year 2003
SELECT
	SUM(Sales)
FROM
	sales_data
WHERE
	year_id = 2003;

-- Calculating the total sales for the year 2004
SELECT
	SUM(Sales)
	
FROM
	sales_data
WHERE
	year_id = 2004;

-- Calculating the total sales for the year 2005
SELECT
	SUM(Sales)
	
FROM
	sales_data
WHERE
	year_id = 2005;
	
-- Calculate the total sales of all years combined 
SELECT
	SUM(Sales)
FROM
	sales_data;

-- Calculating the average sales for the year 2003
SELECT
	AVG(Sales)
	
FROM
	sales_data
WHERE
	year_id = 2003;

-- Calculating the average sales for the year 2004

SELECT
	AVG(Sales)
	
FROM
	sales_data
WHERE
	year_id = 2004;
	
-- Calculating the average sales for the year 2005 
SELECT
	AVG(Sales)
	
FROM
	sales_data
WHERE
	year_id = 2005;
	
-- Calculating the overall average sales 
SELECT
	avg(Sales)
	
FROM
	sales_data;


-- Calculating the max sales for the year 2003 
SELECT
	MAX(Sales)
	
FROM
	sales_data
WHERE
	year_id = 2003;

-- Calculating the max sales for the year 2004
SELECT
	MAX(Sales)
	
FROM
	sales_data
WHERE
	year_id = 2004;

-- Calculating the max sales for the year 2005
SELECT
	MAX(Sales)
	
FROM
	sales_data
WHERE
	year_id = 2005;
	
-- Calculating the overall max sales

SELECT
	MAX(Sales)
	
FROM
	sales_data;

	
-- Calculate  the min sales for the year 2003 
SELECT
	min(Sales)
	
FROM
	sales_data
WHERE
	year_id = 2003;
	
-- calculating the min sales for the year 2004
SELECT
	min(Sales)
	
FROM
	sales_data
WHERE
	year_id = 2004;
	
-- calculating the min sales for the year 2005 
SELECT
	min(Sales)
	
FROM
	sales_data
WHERE
	year_id = 2005;

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

		

