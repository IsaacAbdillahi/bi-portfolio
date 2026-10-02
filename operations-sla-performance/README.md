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

SQL used for this stage:

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

### Cleaning Validation

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

The active operational backlog contained **6,582 cases**.

A fixed reporting snapshot of **31 August 2026** was used to calculate case age consistently.

### Backlog Ageing

| Ageing Bucket | Active Cases |
|---|---:|
| 0–7 days | 84 |
| 8–14 days | 74 |
| 15–30 days | 193 |
| 31–60 days | 318 |
| 60+ days | 5,913 |

Approximately **89.84% of the active backlog was more than 60 days old**.

### Backlog Dashboard

![Backlog Ageing](images/Backlog%20Ageing.png)

The 60+ day backlog was distributed across teams rather than being isolated within a single operational area.

### 60+ Day Backlog by Case Type

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

### 60+ Day Backlog by Priority

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

SQL used for this stage:

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
```

---

## Key Findings

1. **SLA breaches represent a material operational issue.**  
   11,207 of 43,418 completed cases breached SLA, producing an overall breach rate of approximately **25.81%**.

2. **The backlog is heavily aged.**  
   5,913 of 6,582 active cases were more than 60 days old, representing approximately **89.84%** of the active backlog.

3. **High-priority aged cases require attention.**  
   **1,622 High or Urgent cases** were already more than 60 days old.

4. **Performance issues are not concentrated within one team.**  
   The aged backlog was distributed broadly across operational teams.

5. **Case type and priority provide important performance signals.**  
   Complaint and other complex case types showed greater SLA risk, while higher-priority cases were substantially more likely to breach.

6. **Backlog volume and SLA risk should be managed separately.**  
   High-volume aged work does not necessarily represent the same operational problem as high-risk SLA work.

7. **Escalation is associated with poorer SLA performance.**  
   Escalated cases showed substantially higher breach rates, although the analysis does not establish escalation as the cause.

---

## Recommendations

### 1. Prioritise Aged High and Urgent Cases

Create a targeted recovery queue for the **1,622 High/Urgent cases aged over 60 days**, with clear ownership and regular management review.

### 2. Investigate High-Risk Case Types

Review the workflow for Complaints, Transfers and other higher-risk case types to identify delays, hand-offs and process bottlenecks.

### 3. Review Escalation Pathways

Investigate when cases are escalated and whether earlier warning indicators could identify cases at risk of breaching SLA before escalation becomes necessary.

### 4. Separate Backlog and SLA Management Strategies

Use different interventions for:

- **High-volume backlog areas** — capacity, automation and process efficiency
- **High-SLA-risk areas** — specialist intervention, prioritisation and tighter monitoring

### 5. Introduce Proactive Ageing Controls

Use ageing thresholds and dashboard alerts to identify cases approaching critical ageing levels rather than waiting until cases become severely overdue.

---

## Project Structure

```text
operations-sla-performance/
│
├── README.md
│
├── sql/
│   ├── 01_data_profiling.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_sla_analysis.sql
│   ├── 04_backlog_analysis.sql
│   └── 05_reporting_layer.sql
│
├── images/
│   ├── Executive Overview.png
│   ├── SLA Performance.png
│   ├── Backlog Ageing.png
│   └── Operational Drivers.png
│
└── dashboard/
    └── Practice_PowerBI_OperationsSLA.pbix
```

---

## Skills Demonstrated

### SQL

- Data profiling and validation
- Data cleaning
- CTEs
- CASE statements
- Conditional aggregation
- NULL handling
- Date and timestamp analysis
- Business-rule implementation
- SLA classification
- Reporting-layer development

### Power BI

- Data transformation
- Data modelling
- DAX measures
- KPI development
- Interactive filtering
- Conditional formatting
- Dashboard design
- Management reporting

### Business Intelligence

- Translating business questions into analytical requirements
- Identifying operational risks
- Distinguishing backlog volume from SLA risk
- Communicating findings through dashboards
- Developing actionable management recommendations
- Building an end-to-end reporting workflow

---

## Repository Contents

The complete SQL workflow is available in the [`sql`](sql/) folder.

The Power BI dashboard file is available here:

[`Practice_PowerBI_OperationsSLA.pbix`](dashboard/Practice_PowerBI_OperationsSLA.pbix)

Dashboard screenshots are available in the [`images`](images/) folder.

---

## About This Project

This project uses **simulated data** and was created as a portfolio project to demonstrate an end-to-end Business Intelligence workflow within a financial services Operations environment.
