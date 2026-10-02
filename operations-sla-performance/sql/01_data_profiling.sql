-- ============================================================
-- Operations & SLA Performance Analysis
-- 01: Data Profiling
-- Purpose: Assess the raw dataset for completeness, duplicates,
-- inconsistencies and invalid values before data cleaning.
-- ============================================================


-- 1. DATASET OVERVIEW
-- Compare total rows with unique case IDs to identify duplicates.

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT case_id) AS unique_cases
FROM `rugged-truck-508619-j3.operations_sla.raw_cases`;


-- 2. DUPLICATE CASE IDs
-- Identify case IDs appearing more than once.

SELECT
    case_id,
    COUNT(*) AS total_cases
FROM `rugged-truck-508619-j3.operations_sla.raw_cases`
GROUP BY case_id
HAVING COUNT(*) > 1;


-- 3. MISSING VALUES
-- Profile NULL values across important operational fields.

SELECT
    COUNTIF(completed_date IS NULL) AS missing_completed_date,
    COUNTIF(processing_hours IS NULL) AS missing_processing_hours,
    COUNTIF(priority IS NULL) AS missing_priority,
    COUNTIF(assigned_employee IS NULL) AS missing_assigned_employee,
    COUNTIF(customer_type IS NULL) AS missing_customer_type
FROM `rugged-truck-508619-j3.operations_sla.raw_cases`;


-- 4. MISSING COMPLETION DATA BY STATUS
-- Determine whether missing completion information represents
-- data-quality issues or legitimately active cases.

SELECT
    status,
    COUNT(*) AS total_cases,
    COUNTIF(completed_date IS NULL) AS missing_completed_date,
    COUNTIF(processing_hours IS NULL) AS missing_processing_hours
FROM `rugged-truck-508619-j3.operations_sla.raw_cases`
GROUP BY status
ORDER BY total_cases DESC;


-- 5. TEAM PROFILE
-- Identify inconsistent team naming conventions.

SELECT
    team,
    COUNT(*) AS total_cases
FROM `rugged-truck-508619-j3.operations_sla.raw_cases`
GROUP BY team
ORDER BY total_cases DESC;


-- 6. CHANNEL PROFILE
-- Identify inconsistent channel naming conventions.

SELECT
    channel,
    COUNT(*) AS total_cases
FROM `rugged-truck-508619-j3.operations_sla.raw_cases`
GROUP BY channel
ORDER BY total_cases DESC;


-- 7. PRIORITY AND SLA VALIDATION
-- Review the relationship between priority and SLA thresholds.

SELECT
    priority,
    sla_hours,
    COUNT(*) AS total_cases
FROM `rugged-truck-508619-j3.operations_sla.raw_cases`
GROUP BY priority, sla_hours
ORDER BY priority;


-- 8. INVALID COMPLETION DATES
-- Identify cases completed before their recorded creation date.

SELECT
    COUNT(*) AS invalid_date_rows
FROM `rugged-truck-508619-j3.operations_sla.raw_cases`
WHERE completed_date < created_date;


-- 9. NON-POSITIVE PROCESSING HOURS
-- Flag zero or negative processing times for investigation.

SELECT
    COUNT(*) AS non_positive_processing_hours
FROM `rugged-truck-508619-j3.operations_sla.raw_cases`
WHERE processing_hours <= 0;
