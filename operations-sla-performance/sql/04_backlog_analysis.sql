-- ============================================================
-- Operations & SLA Performance Analysis
-- 04: Backlog Analysis
-- Purpose: Analyse the size, age and composition of the active
-- operational backlog using a fixed reporting snapshot.
-- Reporting snapshot: 2026-08-31 23:44:39 UTC
-- ============================================================


-- 1. ACTIVE BACKLOG BY AGEING BUCKET

WITH active_cases AS (

    SELECT
        case_id,

        TIMESTAMP_DIFF(
            TIMESTAMP('2026-08-31 23:44:39'),
            created_date,
            DAY
        ) AS age_days

    FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
    WHERE SLA_status = 'Active'
),

ageing AS (

    SELECT
        *,

        CASE
            WHEN age_days <= 7 THEN '0-7 days'
            WHEN age_days <= 14 THEN '8-14 days'
            WHEN age_days <= 30 THEN '15-30 days'
            WHEN age_days <= 60 THEN '31-60 days'
            ELSE '60+ days'
        END AS ageing_bucket

    FROM active_cases
)

SELECT
    ageing_bucket,
    COUNT(*) AS active_cases

FROM ageing

GROUP BY ageing_bucket

ORDER BY
    CASE ageing_bucket
        WHEN '0-7 days' THEN 1
        WHEN '8-14 days' THEN 2
        WHEN '15-30 days' THEN 3
        WHEN '31-60 days' THEN 4
        WHEN '60+ days' THEN 5
    END;


-- 2. 60+ DAY BACKLOG RATE

WITH active_cases AS (

    SELECT
        case_id,

        TIMESTAMP_DIFF(
            TIMESTAMP('2026-08-31 23:44:39'),
            created_date,
            DAY
        ) AS age_days

    FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
    WHERE SLA_status = 'Active'
)

SELECT
    COUNT(*) AS active_backlog,
    COUNTIF(age_days > 60) AS backlog_60_plus,

    ROUND(
        100 * SAFE_DIVIDE(
            COUNTIF(age_days > 60),
            COUNT(*)
        ),
        2
    ) AS backlog_60_plus_rate

FROM active_cases;


-- 3. 60+ DAY BACKLOG BY TEAM

WITH active_cases AS (

    SELECT
        case_id,
        team,

        TIMESTAMP_DIFF(
            TIMESTAMP('2026-08-31 23:44:39'),
            created_date,
            DAY
        ) AS age_days

    FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
    WHERE SLA_status = 'Active'
)

SELECT
    team,
    COUNT(*) AS backlog_60_plus

FROM active_cases

WHERE age_days > 60

GROUP BY team
ORDER BY backlog_60_plus DESC;


-- 4. 60+ DAY BACKLOG BY CASE TYPE

WITH active_cases AS (

    SELECT
        case_id,
        case_type,

        TIMESTAMP_DIFF(
            TIMESTAMP('2026-08-31 23:44:39'),
            created_date,
            DAY
        ) AS age_days

    FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
    WHERE SLA_status = 'Active'
)

SELECT
    case_type,
    COUNT(*) AS backlog_60_plus

FROM active_cases

WHERE age_days > 60

GROUP BY case_type
ORDER BY backlog_60_plus DESC;


-- 5. 60+ DAY BACKLOG BY PRIORITY

WITH active_cases AS (

    SELECT
        case_id,
        priority,

        TIMESTAMP_DIFF(
            TIMESTAMP('2026-08-31 23:44:39'),
            created_date,
            DAY
        ) AS age_days

    FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
    WHERE SLA_status = 'Active'
)

SELECT
    priority,
    COUNT(*) AS backlog_60_plus

FROM active_cases

WHERE age_days > 60

GROUP BY priority
ORDER BY backlog_60_plus DESC;


-- 6. HIGH AND URGENT 60+ DAY BACKLOG

WITH active_cases AS (

    SELECT
        case_id,
        priority,

        TIMESTAMP_DIFF(
            TIMESTAMP('2026-08-31 23:44:39'),
            created_date,
            DAY
        ) AS age_days

    FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
    WHERE SLA_status = 'Active'
)

SELECT
    COUNT(*) AS high_urgent_60_plus_backlog

FROM active_cases

WHERE age_days > 60
    AND priority IN ('High', 'Urgent');


-- 7. TEN OLDEST ACTIVE CASES

WITH active_cases AS (

    SELECT
        case_id,
        priority,
        team,
        case_type,

        TIMESTAMP_DIFF(
            TIMESTAMP('2026-08-31 23:44:39'),
            created_date,
            DAY
        ) AS age_days

    FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
    WHERE SLA_status = 'Active'
)

SELECT
    case_id,
    priority,
    team,
    case_type,
    age_days

FROM active_cases

ORDER BY age_days DESC
LIMIT 10;
