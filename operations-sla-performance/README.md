# Operations & SLA Performance Analysis

## Project Overview

This end-to-end Business Intelligence project analyses operational case performance within a simulated financial services Operations department.

The objective was to identify where SLA breaches were occurring, understand the scale and composition of the operational backlog, investigate potential performance drivers, and provide management with actionable insights.

The project demonstrates the complete BI workflow:

**Raw Data → Data Profiling → Data Cleaning → SQL Analysis → Reporting Layer → Power BI Dashboard → Business Recommendations**

### Tools Used

- **Google BigQuery** — SQL data cleaning, transformation and analysis
- **SQL** — CTEs, CASE statements, aggregation, data-quality checks and business logic
- **Power BI** — data modelling, DAX measures, KPI reporting and interactive dashboards
- **GitHub** — project documentation and version control

---

## Business Question

> **Where are SLA breaches occurring, what is driving the backlog, and which areas should management focus on to improve operational performance?**

The analysis focused on:

- Overall SLA performance
- Performance by team
- Performance by case type
- Performance by priority
- Escalated and reopened cases
- Active backlog ageing
- High-priority aged cases
- Operational performance drivers

---

## Executive Dashboard

![Executive Overview](images/Executive%20Overview.png)

The Executive Overview provides management with a high-level view of case volumes, SLA performance and backlog ageing.

---

## Dataset

The simulated dataset represents operational case management activity within a financial services environment.

The raw dataset contained **50,075 rows representing 50,000 unique cases**.

Key fields included:

- Case ID
- Created and completed dates
- Case type
- Team
- Priority
- SLA threshold
- Processing time
- Case status
- Assigned employee
- Channel
- Escalation status
- Reopened status
- Customer type

The dataset intentionally contained data-quality issues to replicate a realistic operational reporting environment.

---

## Data Profiling

Before cleaning the data, I profiled the raw dataset to identify completeness and quality issues.

The profiling process identified:

- **75 duplicate rows**
- Missing priority values
- Missing assigned employees
- Missing customer types
- Inconsistent team naming
- Inconsistent channel naming
- Negative SLA thresholds
- Invalid completion dates
- Missing completion information on active cases

Further investigation showed that missing completion dates and processing times were expected for active cases rather than automatically representing data-quality errors.

SQL used for this stage can be found in:

[`01_data_profiling.sql`](sql/01_data_profiling.sql)

---

## Data Cleaning

A reproducible SQL cleaning pipeline was created in BigQuery.

The cleaning process:

- Removed duplicate records
- Standardised team names
- Standardised channel names
- Inferred missing priority using SLA thresholds
- Corrected invalid negative SLA thresholds
- Categorised missing customer types as `Unknown`
- Categorised missing employee assignments as `Unassigned`
- Flagged invalid completion dates rather than inventing replacement dates
- Created an SLA classification for reporting

Cases were classified as:

- **Met SLA**
- **Breached SLA**
- **Active**

Following cleaning, the dataset contained exactly **50,000 unique cases**.

Final validation produced:

| Metric | Result |
|---|---:|
| Total Cases | 50,000 |
| Active Cases | 6,582 |
| Breached SLA | 11,207 |
| Met SLA | 32,211 |
| Invalid Dates Flagged | 20 |

SQL used for this stage:

[`02_data_cleaning.sql`](sql/02_data_cleaning.sql)

---

## SLA Performance Analysis

SLA performance was analysed across teams, case types, priorities and operational characteristics.

Only completed cases were included when calculating SLA breach rates.

There were:

- **43,418 completed cases**
- **11,207 SLA breaches**
- An overall SLA breach rate of approximately **25.81%**

The analysis investigated SLA performance by:

- Team
- Case type
- Priority
- Escalation
- Reopened status
- Complaint priority

### SLA Performance Dashboard

![SLA Performance](images/SLA%20Performance.png)

The analysis indicated that SLA performance varied much more substantially by **case characteristics and priority** than by team.

Complaint cases were a particularly important area for investigation, while higher-priority work showed substantially greater SLA risk.

Escalated cases were also associated with considerably higher breach rates. This should be interpreted as an **association rather than evidence that escalation itself causes SLA breaches**.

SQL used for this stage:

[`03_sla_analysis.sql`](sql/03_sla_analysis.sql)

---

## Backlog & Ageing Analysis

The active operational backlog contained:

**6,582 cases**

A fixed reporting snapshot of **31 August 2026** was used to calculate case age consistently.

The ageing analysis produced:

| Ageing Bucket | Active Cases |
|---|---:|
| 0–7 days | 84 |
| 8–14 days | 74 |
| 15–30 days | 193 |
| 31–60 days | 318 |
| 60+ days | 5,913 |

This means approximately **89.84% of the active backlog was more than 60 days old**.

### Backlog Dashboard

![Backlog Ageing](images/Backlog%20Ageing.png)

The 60+ day backlog was distributed across teams rather than being isolated within a single operational area.

The largest 60+ day backlog by case type included:

| Case Type | 60+ Day Cases |
|---|---:|
| Fee Query | 893 |
| Payment Query | 875 |
| Document Review | 832 |
| Account Update | 793 |
| Transfer | 756 |
| New Account | 689 |
| Withdrawal | 606 |
| Complaint | 469 |

Priority analysis identified:

| Priority | 60+ Day Cases |
|---|---:|
| Medium | 2,769 |
| Low | 1,522 |
| High | 1,279 |
| Urgent | 343 |

This resulted in **1,622 High or Urgent cases already more than 60 days old**, creating a clear management priority.

SQL used for this stage:

[`04_backlog_analysis.sql`](sql/04_backlog_analysis.sql)

---

## Operational Drivers

The final stage investigated additional characteristics associated with operational performance.

These included:

- Escalation
- Reopened cases
- Channel
- Customer type
- Case type

### Operational Drivers Dashboard

![Operational Drivers](images/Operational%20Drivers.png)

The analysis showed that performance issues were not explained by one team or one customer channel alone.

Instead, the strongest patterns appeared around the **type, priority and complexity of operational work**.

This distinction is important because backlog **volume** and SLA **risk** do not necessarily occur in the same areas.

For example, Fee Queries represented the largest volume of 60+ day cases, while Complaints presented a stronger SLA-performance concern.

---

## Reporting Layer

A final analysis-ready reporting table was created specifically for Power BI.

The reporting layer added:

- SLA classification
- Active case age
- Ageing buckets
- Numeric ageing bucket sort order
- Data-quality flags

This separated the reporting model from the raw operational data and provided a consistent dataset for dashboard development.

SQL:

[`05_reporting_layer.sql`](sql/05_reporting_layer.sql)

---

## Power BI Measures

Key DAX measures used in the dashboard included:

```DAX
Total Cases =
COUNTROWS(analysis_cases)

Completed Cases =
CALCULATE(
    [Total Cases],
    analysis_cases[SLA_status] <> "Active"
)

Active Backlog =
CALCULATE(
    [Total Cases],
    analysis_cases[SLA_status] = "Active"
)

Breached Cases =
CALCULATE(
    [Total Cases],
    analysis_cases[SLA_status] = "Breached SLA"
)

SLA Breach Rate =
DIVIDE(
    [Breached Cases],
    [Completed Cases],
    0
)

60+ Day Backlog =
CALCULATE(
    [Total Cases],
    analysis_cases[ageing_bucket] = "60+ days"
)

60+ Backlog Rate =
DIVIDE(
    [60+ Day Backlog],
    [Active Backlog],
    0
)

High/Urgent 60+ Backlog =
CALCULATE(
    [60+ Day Backlog],
    analysis_cases[priority] IN {"High", "Urgent"}
)
