-- Preview the sales_data table
SELECT *
FROM sales_data;

-- Retrieve the sales numbers of each product line by quarter and year
SELECT
    product_line,
	qtr_id,
	year_id,
    SUM(sales) as revenue
FROM sales_data
GROUP BY product_line, year_id, qtr_id
ORDER BY year_id, qtr_id;

-- Get total sales for each year
SELECT SUM(Sales), year_id
FROM sales_data
GROUP BY year_id
ORDER BY year_id;

-- Calculate the total sales across all years
SELECT SUM(Sales)
FROM sales_data;

-- Compute the average sales for each year
SELECT ROUND(AVG(Sales),2), year_id
FROM sales_data
GROUP BY year_id
ORDER BY year_id;

-- Calculate the overall average sales across all years
SELECT avg(Sales)	
FROM sales_data;

-- Get the highest sales value for each year
SELECT MAX(Sales), year_id
FROM sales_data
GROUP BY year_id
ORDER BY year_id;

-- Determine the highest sales value across all years
SELECT MAX(Sales)
FROM sales_data;

-- Get the lowest sales value for each year
SELECT min(Sales), year_id
FROM sales_data
GROUP BY year_id
ORDER BY year_id;

-- Determine the lowest sales value across all years
SELECT min(Sales)
FROM sales_data;

-- Identify top-selling products and their associated revenue
SELECT
	product_code,
	product_line,
	SUM(quantity_ordered) as total_amount_ordered,
	SUM(sales) as total_revenue
FROM sales_data
GROUP BY product_code, product_line
ORDER BY SUM(quantity_ordered) DESC;

-- Identify top customers by order frequency and total revenue
SELECT
	customer_name,
	COUNT(customer_name) AS times_ordered,
	SUM(sales) AS total_revenue
FROM sales_data
GROUP BY customer_name
ORDER BY times_ordered DESC;

-- Explore the relationship between customers and products, filtering by customers who've ordered at least twice
SELECT
	customer_name,
	product_code,
	product_line,
	COUNT(customer_name) AS number_of_company_orders,
	SUM(quantity_ordered) as amount_of_products_ordered,
	SUM(sales) AS total_revenue
FROM sales_data
GROUP BY customer_name, product_code, product_line
HAVING COUNT(customer_name) >= 2
ORDER BY number_of_company_orders DESC, amount_of_products_ordered DESC, total_revenue DESC;

-- Using a CTE to limit the results to top 2 products per customer
WITH NumberedOrders AS (
    SELECT
        customer_name,
        product_code,
        product_line,
        COUNT(*) AS number_of_company_orders,
        SUM(quantity_ordered) as amount_of_products_ordered,
        SUM(sales) AS total_revenue,
        ROW_NUMBER() OVER(PARTITION BY customer_name ORDER BY COUNT(*) DESC) AS row_num
    FROM sales_data
    GROUP BY customer_name, product_code, product_line
)
SELECT
    customer_name,
    product_code,
    product_line,
    number_of_company_orders,
    amount_of_products_ordered,
    total_revenue,
	row_num
FROM NumberedOrders
WHERE row_num <= 2
ORDER BY number_of_company_orders DESC, total_revenue DESC, amount_of_products_ordered DESC, customer_name DESC;

-- Categorize orders based on sales amount
SELECT
	order_number,
	sales,
	CASE  
		WHEN sales < 1000 THEN 'small'
		WHEN sales < 6000 THEN 'medium'
		ELSE 'large'
	END AS order_size
FROM sales_data
ORDER BY sales DESC;

-- Creating a view to categorize sales orders by size
DROP VIEW IF EXISTS sale_order_size;
CREATE VIEW sale_order_size AS (
    SELECT
	    order_number,
	    sales,
	    CASE  
		    WHEN sales < 1000 THEN 'small'
		    WHEN sales < 6000 THEN 'medium'
		    ELSE 'large'
	    END AS order_size
    FROM sales_data
    ORDER BY sales DESC
);
SELECT * FROM sale_order_size;

-- Aggregate sales data by month for the year 2003
SELECT 
    EXTRACT(MONTH FROM TO_DATE(ORDER_DATE, 'MM/DD/YYYY HH24:MI')) AS MONTH, 
    SUM(SALES) AS TOTAL_SALES 
FROM sales_data 
WHERE EXTRACT(YEAR FROM TO_DATE(ORDER_DATE, 'MM/DD/YYYY HH24:MI')) = 2003
GROUP BY MONTH 
ORDER BY MONTH;

-- Create a temporary table to hold product revenue data
DROP TABLE IF EXISTS product_revenue;
CREATE TEMP TABLE product_revenue AS(
    SELECT
	    product_code,
	    product_line,
	    SUM(quantity_ordered) as total_amount_ordered,
	    SUM(sales) as total_revenue
    FROM sales_data
    GROUP BY product_code, product_line
);
SELECT * FROM product_revenue;

-- Retrieve the top 3 sales records for each product line
SELECT
	*
FROM(
		SELECT
		product_line,
		sales,
		MAX(Sales) OVER(PARTITION BY product_line) AS max_sales,
		RANK() OVER(PARTITION BY product_line ORDER BY sales DESC) AS row_number
	FROM sales_data) AS S
WHERE S.row_number < 4;
