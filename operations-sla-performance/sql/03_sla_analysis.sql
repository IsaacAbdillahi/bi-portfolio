-- ============================================================
-- Operations & SLA Performance Analysis
-- 03: SLA Analysis
-- Purpose: Analyse SLA performance across operational teams,
-- case types, priorities and key operational characteristics.
-- Only completed cases are included in SLA breach calculations.
-- ============================================================


-- 1. OVERALL SLA PERFORMANCE

SELECT
    COUNT(*) AS completed_cases,
    COUNTIF(SLA_status = 'Breached SLA') AS breached_cases,

    ROUND(
        100 * SAFE_DIVIDE(
            COUNTIF(SLA_status = 'Breached SLA'),
            COUNT(*)
        ),
        2
    ) AS breach_rate_pct

FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
WHERE SLA_status != 'Active';


-- 2. SLA PERFORMANCE BY TEAM

SELECT
    team,
    COUNT(*) AS completed_cases,
    COUNTIF(SLA_status = 'Breached SLA') AS breached_cases,

    ROUND(
        100 * SAFE_DIVIDE(
            COUNTIF(SLA_status = 'Breached SLA'),
            COUNT(*)
        ),
        2
    ) AS breach_rate_pct

FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
WHERE SLA_status != 'Active'
GROUP BY team
ORDER BY breach_rate_pct DESC;


-- 3. SLA PERFORMANCE BY CASE TYPE

SELECT
    case_type,
    COUNT(*) AS completed_cases,
    COUNTIF(SLA_status = 'Breached SLA') AS breached_cases,

    ROUND(
        100 * SAFE_DIVIDE(
            COUNTIF(SLA_status = 'Breached SLA'),
            COUNT(*)
        ),
        2
    ) AS breach_rate_pct

FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
WHERE SLA_status != 'Active'
GROUP BY case_type
ORDER BY breach_rate_pct DESC;


-- 4. SLA PERFORMANCE BY PRIORITY

SELECT
    priority,
    COUNT(*) AS completed_cases,
    COUNTIF(SLA_status = 'Breached SLA') AS breached_cases,

    ROUND(
        100 * SAFE_DIVIDE(
            COUNTIF(SLA_status = 'Breached SLA'),
            COUNT(*)
        ),
        2
    ) AS breach_rate_pct

FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
WHERE SLA_status != 'Active'
GROUP BY priority
ORDER BY breach_rate_pct DESC;


-- 5. SLA PERFORMANCE BY ESCALATION
-- Association only; this does not establish that escalation
-- causes SLA breaches.

SELECT
    escalated,
    COUNT(*) AS completed_cases,
    COUNTIF(SLA_status = 'Breached SLA') AS breached_cases,

    ROUND(
        100 * SAFE_DIVIDE(
            COUNTIF(SLA_status = 'Breached SLA'),
            COUNT(*)
        ),
        2
    ) AS breach_rate_pct

FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
WHERE SLA_status != 'Active'
GROUP BY escalated
ORDER BY breach_rate_pct DESC;


-- 6. SLA PERFORMANCE BY REOPENED STATUS

SELECT
    reopened,
    COUNT(*) AS completed_cases,
    COUNTIF(SLA_status = 'Breached SLA') AS breached_cases,

    ROUND(
        100 * SAFE_DIVIDE(
            COUNTIF(SLA_status = 'Breached SLA'),
            COUNT(*)
        ),
        2
    ) AS breach_rate_pct

FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
WHERE SLA_status != 'Active'
GROUP BY reopened
ORDER BY breach_rate_pct DESC;


-- 7. COMPLAINT SLA PERFORMANCE BY PRIORITY
-- Drill-down into complaints to determine whether poor SLA
-- performance remains visible across different priority levels.

SELECT
    priority,
    COUNT(*) AS completed_cases,
    COUNTIF(SLA_status = 'Breached SLA') AS breached_cases,

    ROUND(
        100 * SAFE_DIVIDE(
            COUNTIF(SLA_status = 'Breached SLA'),
            COUNT(*)
        ),
        2
    ) AS breach_rate_pct

FROM `rugged-truck-508619-j3.operations_sla.clean_cases`
WHERE SLA_status != 'Active'
    AND case_type = 'Complaint'
GROUP BY priority
ORDER BY breach_rate_pct DESC;
