-- Average Sales and Transactions per Region
SELECT
  region,
  AVG(sales) AS avg_sales,
  AVG(transactions) AS avg_transactions
FROM clean_weekly_sales
GROUP BY region;

-- Monthly Sales Growth Rate
SELECT
  month_number,
  calendar_year,
  (SUM(sales) - LAG(SUM(sales)) OVER (ORDER BY calendar_year, month_number)) /
  LAG(SUM(sales)) OVER (ORDER BY calendar_year, month_number) * 100 AS sales_growth_rate
FROM clean_weekly_sales
GROUP BY calendar_year, month_number
ORDER BY calendar_year, month_number;


-- Top 5 Performing Customers by Total Sales
SELECT
  customer_type,
  customer,
  SUM(sales) AS total_sales
FROM clean_weekly_sales
GROUP BY customer_type, customer
ORDER BY total_sales DESC
LIMIT 5;

-- Sales Distribution by Segment
SELECT
  segment,
  SUM(sales) AS total_sales
FROM clean_weekly_sales
GROUP BY segment
ORDER BY total_sales DESC;


-- Average Transaction Value Trend Over Years
SELECT
  calendar_year,
  AVG(avg_transaction) AS avg_transaction_trend
FROM clean_weekly_sales
GROUP BY calendar_year
ORDER BY calendar_year;

