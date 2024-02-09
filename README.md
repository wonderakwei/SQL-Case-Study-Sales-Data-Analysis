# SQL Case Study 1: Data Mart Analysis

## Overview
Explore the sales and performance of Data Dart, a venture that underwent significant changes in June 2020, introducing sustainable packaging methods across its supply chain. The objective is to quantify the impact of these changes on sales performance and various business areas.

## Data Schema (WEEKLY_SALES TABLE)
- **Columns:**
  - week_date (date)
  - region (varchar(20))
  - platform (varchar(20))
  - segment (varchar(10))
  - customer (varchar(20))
  - transactions (int)
  - sales (int)

## Case Study Questions

### A. Data Cleansing Steps
Execute a single query to cleanse the data and create a new table (`clean_weekly_sales`) in the `data_mart` schema, incorporating the following transformations:

1. Add a `week_number` as the second column based on `week_date`.
2. Add a `month_number` reflecting the calendar month for each `week_date`.
3. Introduce a `calendar_year` column (2018, 2019, or 2020).
4. Insert a new column, `age_band`, based on specific mappings from the original `segment`.
5. Add a `demographic` column based on mappings from the first letter in the `segment` values.
6. Ensure all null string values are replaced with "unknown" in the `segment`, `age_band`, and `demographic` columns.
7. Generate an `avg_transaction` column, calculated as sales divided by transactions (rounded to 2 decimal places) for each record.

### B. Data Exploration
Answer the following questions by querying the cleansed data:

1. Identify missing week numbers in the dataset.
2. Determine the total transactions for each year.
3. Calculate the total sales for each region per month.
4. Obtain the total count of transactions for each platform.
5. Calculate the percentage of sales for Retail vs. Shopify each month.
6. Determine the percentage of sales by demographic for each year.
7. Identify the `age_band` and `demographic` values contributing the most to Retail sales.
