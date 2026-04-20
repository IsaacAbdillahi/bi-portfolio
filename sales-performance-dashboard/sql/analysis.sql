-- Monthly sales performance with month-over-month change

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales_amount) AS total_sales
    FROM sales
    GROUP BY 1
)
SELECT
    month,
    total_sales,
    total_sales - LAG(total_sales) OVER (ORDER BY month) AS mom_change
FROM monthly_sales
ORDER BY month;

-- Monthly sales and month-over-month growth

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS sales_month,
        SUM(sales_amount) AS total_sales
    FROM sales
    GROUP BY DATE_TRUNC('month', order_date)
),
monthly_growth AS (
    SELECT
        sales_month,
        total_sales,
        total_sales - LAG(total_sales) OVER (ORDER BY sales_month) AS mom_change
    FROM monthly_sales
)
SELECT
    sales_month,
    total_sales,
    mom_change
FROM monthly_growth
ORDER BY sales_month;
