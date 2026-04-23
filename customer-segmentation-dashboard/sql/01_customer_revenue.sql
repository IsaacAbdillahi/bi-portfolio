-- Customer revenue base
-- This query aggregates total revenue per customer
-- and forms the foundation for ranking and segmentation analysis

/*
Purpose:
- Aggregate transactional sales data to a customer level
- Create a revenue base used for customer ranking and segmentation
- Feed downstream SQL queries and Power BI models

Output:
- One row per customer
- Total revenue per customer
*/

SELECT
    customer_id,
    SUM(sales_amount) AS total_revenue
FROM customer_sales
GROUP BY customer_id
ORDER BY total_revenue DESC;
``
