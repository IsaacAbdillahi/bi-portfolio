-- Customer revenue ranking
-- This query ranks customers by total revenue contribution
-- Window functions are used to enable analytical comparisons

WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(sales_amount) AS total_revenue
    FROM customer_sales
    GROUP BY customer_id
)

SELECT
    customer_id,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM customer_revenue
ORDER BY revenue_rank;
``
