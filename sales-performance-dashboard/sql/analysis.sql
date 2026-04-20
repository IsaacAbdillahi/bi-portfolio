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
