# Sales Performance Dashboard

## Business Problem
Stakeholders require a clear and consistent view of sales performance to understand revenue trends, identify high-performing products, and detect underperforming regions.

Without a centralised view, it is difficult to monitor performance over time and take informed action.

---

## Objective
To analyse historical sales data using SQL and present key insights through an interactive Power BI dashboard that supports data-driven decision-making.

---

## Data Overview
The dataset contains transactional sales records with the following core fields:
- Order date
- Product
- Region
- Sales amount

The data was cleaned and aggregated using SQL before being visualised in Power BI.

---

## Approach
The analysis was carried out in two stages:

**SQL Analysis**
- Cleaned and standardised raw sales data
- Aggregated sales at a monthly level
- Calculated month-over-month growth using window functions
- Produced reporting-ready datasets

**Power BI Dashboard**
- Modelled aggregated data for analysis
- Built KPIs and trend visuals
- Designed visuals focused on stakeholder usability

---

## Dashboard Preview

### Overview
screenshots/dashboard_overview.png

### Month-over-Month Sales Growth
screenshots/mom_growth.png

---

## Key Insights
- Sales demonstrate clear seasonal patterns, with stronger performance toward year-end
- A small number of products contribute a significant proportion of total revenue
- Certain regions consistently underperform relative to others
- Month-over-month growth highlights periodic volatility, useful for early issue detection

---

## Recommendations
- Focus commercial efforts on high-performing products during peak periods
- Investigate structural or operational challenges in underperforming regions
- Use monthly growth tracking as an early warning indicator for performance changes

---

## Skills Demonstrated
- SQL (CTEs, aggregations, window functions, time-based analysis)
- Power BI (data modelling, DAX, dashboard design)
- Business analysis and stakeholder-focused insight delivery
