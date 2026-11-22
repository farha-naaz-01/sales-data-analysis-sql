-- DATA CLEANING

-- 1. City spelling check
SELECT DISTINCT city FROM sales_data;

-- 2. Date range check
SELECT MIN(order_date), MAX(order_date) FROM sales_data;

-- 3. NULL / invalid values check
SELECT * FROM sales_data
WHERE total_sales IS NULL OR profit IS NULL OR total_sales <= 0;

-- BUSINESS ANALYSIS

-- 1. City-wise orders

SELECT city, COUNT(*) AS total_orders
FROM sales_data
GROUP BY city
ORDER BY total_orders DESC;

-- 2. Category-wise orders

SELECT product_category, COUNT(*) AS total_orders
FROM sales_data
GROUP BY product_category
ORDER BY total_orders DESC;

-- 3. Month-wise trend

SELECT DATE_TRUNC('month', order_date) AS month, COUNT(*) AS orders
FROM sales_data
GROUP BY month
ORDER BY month;

-- 4. Top product in each region
SELECT region, product_name, orders
FROM (
    SELECT region, product_name, COUNT(*) AS orders,
           RANK() OVER (PARTITION BY region ORDER BY COUNT(*) DESC) AS rnk
    FROM sales_data
    GROUP BY region, product_name
) t
WHERE rnk = 1;

-- 5. Top customers by revenue
SELECT customer_name, SUM(total_sales) AS revenue, COUNT(*) AS orders
FROM sales_data
GROUP BY customer_name
ORDER BY revenue DESC;

-- 6. Product-wise revenue (highest to lowest)
SELECT product_name, SUM(total_sales) AS revenue
FROM sales_data
GROUP BY product_name
ORDER BY revenue DESC;

-- 7. Region-wise revenue and profit
SELECT region, SUM(total_sales) AS revenue, SUM(profit) AS total_profit
FROM sales_data
GROUP BY region
ORDER BY revenue DESC;

-- 8. Sales rep performance
SELECT sales_rep, SUM(total_sales) AS revenue, COUNT(*) AS orders
FROM sales_data
GROUP BY sales_rep
ORDER BY revenue DESC;

-- 9. Discount vs average profit
SELECT discount, ROUND(AVG(profit), 2) AS avg_profit
FROM sales_data
GROUP BY discount
ORDER BY discount;

-- 10. Payment method analysis
SELECT payment_method, COUNT(*) AS orders, SUM(total_sales) AS revenue
FROM sales_data
GROUP BY payment_method
ORDER BY orders DESC;	