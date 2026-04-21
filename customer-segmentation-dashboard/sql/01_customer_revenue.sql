-- Customer revenue base
-- This query aggregates total revenue per customer
-- and forms the foundation for ranking and segmentation analysis

SELECT
    customer_id,
    SUM(sales_amount) AS total_revenue
FROM customer_sales
GROUP BY customer_id
ORDER BY total_revenue DESC;
``
