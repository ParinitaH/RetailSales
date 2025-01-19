--Data Exploration
SELECT MAX(quantity) FROM retail_sales;

SELECT COUNT(*) FROM retail_sales

SELECT COUNT(DISTINCT customer_id) FROM retail_sales

SELECT DISTINCT category FROM retail_sales

--Data Analysis

--Retrieve all columns that made sales on 2022-11-05.

SELECT * FROM retail_sales
WHERE sales_date = '2022-11-05'

--Retrieve all columns where the category is 'clothing' and the quantity sold is more than 3 in the month of November-2022.
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 3
  AND sales_date >= '2022-11-01' 
  AND sales_date < '2022-12-01';


--find total sales (TotalSales) for each category

SELECT category, SUM(total_sales) AS TotalSales FROM retail_sales
GROUP BY category

--find average age of customers who purchased from the 'beauty' category.

SELECT ROUND(AVG(age),0) AS Avg_age FROM retail_sales
WHERE category = 'Beauty'

--Retrieve all transactions where the total sales are above 1000.

SELECT transaction_id,gender, SUM(total_sales) AS TotalSales FROM retail_sales
WHERE total_sales > 1000
GROUP BY transaction_id

--Retrieve total transactions made by each gender and each category

SELECT category,gender, COUNT(*)AS total_transaction FROM retail_sales
GROUP BY gender, category
ORDER BY 1

--calculate the average sale for each month. Find out best selling month in each year

SELECT year, month, AVG_Sales FROM (
SELECT 
  EXTRACT(YEAR FROM sales_date) AS year,
  EXTRACT(MONTH FROM sales_date) AS month,
  ROUND(AVG(total_sales),2) AS Avg_Sales,
  RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sales_date) ORDER BY AVG(total_sales)DESC) AS rank
FROM retail_sales
GROUP BY 1,2
) AS T1
WHERE rank = 1


--find the top 5 customers based on the highest total sales 

SELECT customer_id,SUM(total_sales) AS TotalSales FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC LIMIT 5

-- find the number of unique customers who purchased items from each category.

SELECT COUNT(DISTINCT customer_id) AS TotalCustomers, category FROM retail_sales
GROUP BY 2

--create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sales AS (SELECT *,
   CASE
   WHEN EXTRACT(HOUR FROM sales_time) < 12 THEN 'Morning'
   WHEN EXTRACT(HOUR FROM sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
  ELSE 'Evening'
  END AS Shift
FROM retail_sales)

SELECT COUNT(transaction_id),shift FROM hourly_sales
GROUP BY Shift

