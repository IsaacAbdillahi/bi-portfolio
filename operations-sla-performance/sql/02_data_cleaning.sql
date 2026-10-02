-- ============================================================
-- Operations & SLA Performance Analysis
-- 02: Data Cleaning
-- Purpose: Remove duplicates, standardise categorical values,
-- resolve missing values, correct invalid SLA thresholds and
-- create data-quality and SLA reporting fields.
-- ============================================================

CREATE OR REPLACE TABLE
    `rugged-truck-508619-j3.operations_sla.clean_cases` AS

WITH cleaned AS (

    SELECT DISTINCT

        * EXCEPT(
            team,
            channel,
            priority,
            sla_hours,
            customer_type,
            assigned_employee
        ),

        -- 1. Standardise team names
        CASE
            WHEN team = 'operations north' THEN 'Operations North'
            WHEN team = 'Client Service' THEN 'Client Services'
            ELSE team
        END AS team,

        -- 2. Standardise channel names
        CASE
            WHEN channel = 'email' THEN 'Email'
            ELSE channel
        END AS channel,

        -- 3. Infer missing priority from SLA hours
        CASE
            WHEN priority IS NULL AND sla_hours = 24 THEN 'Urgent'
            WHEN priority IS NULL AND sla_hours = 48 THEN 'High'
            WHEN priority IS NULL AND sla_hours = 72 THEN 'Medium'
            WHEN priority IS NULL AND sla_hours = 120 THEN 'Low'
            ELSE priority
        END AS priority,

        -- 4. Correct invalid SLA hours using priority
        CASE
            WHEN sla_hours < 0 AND priority = 'Urgent' THEN 24
            WHEN sla_hours < 0 AND priority = 'High' THEN 48
            WHEN sla_hours < 0 AND priority = 'Medium' THEN 72
            WHEN sla_hours < 0 AND priority = 'Low' THEN 120
            ELSE sla_hours
        END AS sla_hours,

        -- 5. Retain unknown customer types without inventing values
        CASE
            WHEN customer_type IS NULL THEN 'Unknown'
            ELSE customer_type
        END AS customer_type,

        -- 6. Retain cases without an assigned employee
        CASE
            WHEN assigned_employee IS NULL THEN 'Unassigned'
            ELSE assigned_employee
        END AS assigned_employee

    FROM `rugged-truck-508619-j3.operations_sla.raw_cases`
),

quality_checks AS (

    SELECT
        *,

        -- 7. Flag invalid completion dates rather than guessing corrections
        CASE
            WHEN completed_date < created_date THEN 'Invalid Date'
            ELSE 'Valid'
        END AS date_quality

    FROM cleaned
),

sla_classification AS (

    SELECT
        *,

        -- 8. Classify SLA performance using cleaned SLA thresholds
        CASE
            WHEN status IN ('Open', 'In Progress', 'Pending')
                THEN 'Active'
            WHEN processing_hours > sla_hours
                THEN 'Breached SLA'
            ELSE 'Met SLA'
        END AS SLA_status

    FROM quality_checks
)

SELECT *
FROM sla_classification;


-- ============================================================
-- VALIDATION
-- Confirm cleaning rules were applied successfully.
-- ============================================================

SELECT
    COUNT(*) AS total_cases,
    COUNTIF(priority IS NULL) AS missing_priority,
    COUNTIF(customer_type IS NULL) AS missing_customer_type,
    COUNTIF(assigned_employee IS NULL) AS missing_assigned_employee,
    COUNTIF(sla_hours < 0) AS negative_sla_hours,
    COUNTIF(date_quality = 'Invalid Date') AS invalid_dates,
    COUNTIF(SLA_status = 'Active') AS active_cases,
    COUNTIF(SLA_status = 'Breached SLA') AS breached_cases,
    COUNTIF(SLA_status = 'Met SLA') AS met_sla_cases

FROM `rugged-truck-508619-j3.operations_sla.clean_cases`;
