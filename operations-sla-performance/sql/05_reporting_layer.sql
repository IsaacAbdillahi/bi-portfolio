-- ============================================================
-- Operations & SLA Performance Analysis
-- 05: Reporting Layer
-- Purpose: Create the final analysis-ready dataset used for
-- Power BI reporting, including backlog age, ageing buckets
-- and a numeric ageing sort order.
-- Reporting snapshot: 2026-08-31 23:44:39 UTC
-- ============================================================

CREATE OR REPLACE TABLE
    `rugged-truck-508619-j3.operations_sla.analysis_cases` AS

WITH base AS (

    SELECT
        case_id,
        created_date,
        completed_date,
        case_type,
        team,
        priority,
        sla_hours,
        processing_hours,
        status,
        assigned_employee,
        channel,
        escalated,
        reopened,
        customer_type,
        date_quality,
        SLA_status,

        -- Calculate backlog age only for active cases
        CASE
            WHEN SLA_status = 'Active' THEN
                TIMESTAMP_DIFF(
                    TIMESTAMP('2026-08-31 23:44:39'),
                    created_date,
                    DAY
                )
            ELSE NULL
        END AS age_days

    FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
),

reporting AS (

    SELECT
        *,

        -- Group active cases into management-friendly ageing buckets
        CASE
            WHEN age_days IS NULL THEN NULL
            WHEN age_days <= 7 THEN '0-7 days'
            WHEN age_days <= 14 THEN '8-14 days'
            WHEN age_days <= 30 THEN '15-30 days'
            WHEN age_days <= 60 THEN '31-60 days'
            ELSE '60+ days'
        END AS ageing_bucket

    FROM base
),

ageing_order AS (

    SELECT
        *,

        -- Numeric sort order for Power BI ageing visuals
        CASE
            WHEN ageing_bucket IS NULL THEN NULL
            WHEN ageing_bucket = '0-7 days' THEN 1
            WHEN ageing_bucket = '8-14 days' THEN 2
            WHEN ageing_bucket = '15-30 days' THEN 3
            WHEN ageing_bucket = '31-60 days' THEN 4
            WHEN ageing_bucket = '60+ days' THEN 5
        END AS ageing_bucket_order

    FROM reporting
)

SELECT *
FROM ageing_order;


-- ============================================================
-- VALIDATION
-- Confirm final reporting dataset matches expected totals.
-- ============================================================

SELECT
    COUNT(*) AS total_cases,
    COUNTIF(SLA_status = 'Active') AS active_cases,
    COUNTIF(SLA_status = 'Breached SLA') AS breached_cases,
    COUNTIF(SLA_status = 'Met SLA') AS met_sla_cases,
    COUNTIF(ageing_bucket = '60+ days') AS backlog_60_plus,

    COUNTIF(
        ageing_bucket = '60+ days'
        AND priority IN ('High', 'Urgent')
    ) AS high_urgent_60_plus

FROM `rugged-truck-508619-j3.operations_sla.analysis_cases`;
