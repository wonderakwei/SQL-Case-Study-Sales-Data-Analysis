-- Data Cleansing Process

-- Create a new table named 'clean_weekly_sales'
CREATE TABLE clean_weekly_sales AS
SELECT
  week_date,
  WEEK(week_date) AS week_number,
  MONTH(week_date) AS month_number,
  YEAR(week_date) AS calendar_year,
  region,
  platform,
  -- Handling null values in the 'segment' column
  CASE
    WHEN segment IS NULL THEN 'Unknown'
    ELSE segment
  END AS segment,
  -- Mapping 'segment' values to 'age_band'
  CASE
    WHEN RIGHT(segment, 1) = '1' THEN 'Young Adults'
    WHEN RIGHT(segment, 1) = '2' THEN 'Middle Aged'
    WHEN RIGHT(segment, 1) IN ('3', '4') THEN 'Retirees'
    ELSE 'Unknown'
  END AS age_band,
  -- Mapping 'segment' values to 'demographic'
  CASE
    WHEN LEFT(segment, 1) = 'C' THEN 'Couples'
    WHEN LEFT(segment, 1) = 'F' THEN 'Families'
    ELSE 'Unknown'
  END AS demographic,
  customer_type,
  transactions,
  sales,
  -- Calculating average transaction value
  ROUND(sales / transactions, 2) AS avg_transaction
FROM weekly_sales;

-- Display the first 10 records from the clean_weekly_sales table
SELECT * FROM clean_weekly_sales LIMIT 10;

-- Data Exploration

-- 1. Which week numbers are missing from the dataset?
CREATE TABLE seq100 (x INT NOT NULL AUTO_INCREMENT PRIMARY KEY);
INSERT INTO seq100 VALUES (),(),(),(),(),(),(),(),(),();
-- Repeat the above insert statement to generate a sequence of numbers
INSERT INTO seq100 SELECT x + 50 FROM seq100;
CREATE TABLE seq52 AS (SELECT x FROM seq100 LIMIT 52);
SELECT DISTINCT x AS week_day FROM seq52 WHERE x NOT IN (SELECT DISTINCT week_number FROM clean_weekly_sales);

-- Display all distinct week numbers in the clean_weekly_sales table
SELECT DISTINCT week_number FROM clean_weekly_sales;

-- 2. How many total transactions were there for each year in the dataset?
SELECT
  calendar_year,
  SUM(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY calendar_year;

-- 3. What are the total sales for each region for each month?
SELECT
  month_number,
  region,
  SUM(sales) AS total_sales
FROM clean_weekly_sales
GROUP BY month_number, region
ORDER BY month_number, region;

-- 4. What is the total count of transactions for each platform?
SELECT
  platform,
  SUM(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY platform;

-- 5. What is the percentage of sales for Retail vs Shopify for each month?
WITH cte_monthly_platform_sales AS (
  SELECT
    month_number, calendar_year,
    platform,
    SUM(sales) AS monthly_sales
  FROM clean_weekly_sales
  GROUP BY month_number, calendar_year, platform
)
SELECT
  month_number, calendar_year,
  ROUND(
    100 * MAX(CASE WHEN platform = 'Retail' THEN monthly_sales ELSE NULL END) /
      SUM(monthly_sales),
    2
  ) AS retail_percentage,
  ROUND(
    100 * MAX(CASE WHEN platform = 'Shopify' THEN monthly_sales ELSE NULL END) /
      SUM(monthly_sales),
    2
  ) AS shopify_percentage
FROM cte_monthly_platform_sales
GROUP BY month_number, calendar_year
ORDER BY month_number, calendar_year;

-- 6. What is the percentage of sales by demographic for each year in the dataset?
SELECT
  calendar_year,
  demographic,
  SUM(sales) AS yearly_sales,
  ROUND(
    100 * SUM(sales) /
      SUM(SUM(sales)) OVER (PARTITION BY demographic),
    2
  ) AS percentage
FROM clean_weekly_sales
GROUP BY calendar_year, demographic
ORDER BY calendar_year, demographic;

-- 7. Which age_band and demographic values contribute the most to Retail sales?
SELECT
  age_band,
  demographic,
  SUM(sales) AS total_sales
FROM clean_weekly_sales
WHERE platform = 'Retail'
GROUP BY age_band, demographic
ORDER BY total_sales DESC;
