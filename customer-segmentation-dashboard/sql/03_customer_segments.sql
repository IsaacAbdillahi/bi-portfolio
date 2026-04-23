/*
Purpose:
- Segment customers into value-based tiers using total revenue contribution
- Translate analytical rankings into business-friendly customer segments
- Enable targeted analysis and insight delivery in Power BI

Segmentation Logic:
- Customers are split into revenue-based buckets using NTILE
- Buckets are mapped to High / Medium / Low value segments

Output:
- One row per customer
- Total revenue per customer
- Assigned customer value segment
*/

WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(sales_amount) AS total_revenue
    FROM customer_sales
    GROUP BY customer_id
),

customer_ranked AS (
    SELECT
        customer_id,
        total_revenue,
        NTILE(5) OVER (ORDER BY total_revenue DESC) AS revenue_bucket
    FROM customer_revenue
)

SELECT
    customer_id,
    total_revenue,
    CASE
        WHEN revenue_bucket = 1 THEN 'High Value'
        WHEN revenue_bucket IN (2, 3, 4) THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_ranked
ORDER BY total_revenue DESC;

-- This dataset is used directly in:
-- Power BI customer segmentation dashboards
