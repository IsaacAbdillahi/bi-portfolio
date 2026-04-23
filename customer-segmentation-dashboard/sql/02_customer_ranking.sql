/*
Purpose:
- Rank customers based on total revenue contribution
- Enable comparison of customer value across the full customer base
- Feed downstream segmentation and concentration analysis

Output:
- One row per customer
- Total revenue per customer
- Revenue-based rank (highest revenue = rank 1)
*/

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

-- This dataset is used as input for:
-- 03_customer_segments.sql
