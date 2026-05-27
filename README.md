# 👥 Employee Performance Analytics

> An interactive SQL dashboard analyzing workforce data across a U.S. retail chain — covering employee attrition, salary benchmarking, performance trends, store revenue, flight risk scoring, and promotion candidate identification across 150 stores and 9 departments.

---

## 📌 Project Overview

This project provides a comprehensive analysis of HR and operational data using **Microsoft SQL Server** and a custom interactive **HTML dashboard**. The analysis is designed for HR managers and business leaders who need to monitor workforce health, identify retention risks, benchmark compensation, and track store performance across a 3-year period (2022–2024).

---

## 🗂️ Data Model

The project is built on **5 related tables:**

| Table | File | Description |
|---|---|---|
| `dbo.Stores` | `stores.sql` | 150 retail stores — name, city, store type, opening date |
| `dbo.EmployeePerformance` | `employee_performance.sql` | Employee profiles — age, education, salary, job level, manager |
| `dbo.MonthlyPerformance` | `monthly_performance.sql` | Monthly records — rating, training hours, overtime, bonus, satisfaction |
| `dbo.RoleKPIs` | `role_kpis.sql` + `role_kpis_data_02.sql` | Role-specific KPIs + Productivity Index (split into 2 files due to size) |
| `dbo.BusinessOutcomes` | `business_outcomes.sql` | Store-level revenue, CSAT, NPS, waste %, on-time delivery |

**Relationships:**

```
dbo.Stores ──────────────────── dbo.EmployeePerformance
    │                                      │
    └── dbo.BusinessOutcomes               ├── dbo.MonthlyPerformance
                                           └── dbo.RoleKPIs
```

---

## 📊 Dashboard Pages

### Page 1 — Overview
**Purpose:** High-level snapshot of workforce health across all departments and locations.

**KPI Cards:**
- Total Employees · Attrition Rate · Avg Performance · Avg Satisfaction

**Charts:**
- 📊 Attrition rate by department (horizontal bar)
- 📈 Monthly performance trend — top 12 periods
- 🍩 Headcount distribution by department (donut)
- 💰 Average salary by job level (bar)
- 📋 Satisfaction score ranking by department (inline bars)

---

### Page 2 — People & Retention
**Purpose:** Deep dive into attrition patterns, tenure analysis, cohort retention, and flight risk identification.

**KPI Cards:**
- Total Exits · Late Attrition % · Best Cohort Retention · Flight Risk Flagged

**Charts:**
- 📊 Attrition rate by department
- ⏳ Exit volume by tenure length at departure — when do employees actually leave?
- 📈 Cohort retention rate by hire year (2012–2021)
- 📊 Attrition rate by employment type (Full-time vs Part-time vs Contractor vs Seasonal)
- 🚨 Flight risk table — top 15 at-risk active employees with composite score

---

### Page 3 — Performance
**Purpose:** Analysis of performance drivers — seasonality, training effectiveness, absenteeism impact, and age.

**KPI Cards:**
- Peak Month Rating · Optimal Training Range · Absenteeism Alert Threshold · Age vs Perf Gap

**Charts:**
- 📈 Monthly performance trend — top 12 periods
- 📊 Training hours vs performance & satisfaction (grouped bar + dual axis)
- 📉 Absenteeism impact on performance rating (line chart)
- 📊 Performance & satisfaction by age group (grouped bar)

---

### Page 4 — Compensation
**Purpose:** Salary benchmarking across levels and departments, overtime cost analysis, and identification of underpaid high performers.

**KPI Cards:**
- Executive Avg Salary · Entry Avg Salary · Pay Gap Ratio · Underpaid High Performers

**Charts:**
- 📊 Average salary by job level
- 📊 Average salary by department
- 📊 Overtime hours by department with performance overlay (bar + line)
- 📊 Salary deficit — top 10 underpaid high performers (perf ≥ 4.2, below level average)

---

### Page 5 — Talent Management
**Purpose:** Manager effectiveness ranking, promotion fairness validation, education ROI analysis, and promotion pipeline.

**KPI Cards:**
- Top Manager Score · Promotion Performance Uplift · Education Leader · Top Promotion Candidate

**Charts:**
- 📊 Top 10 managers ranked by team performance (horizontal bar)
- 🕸️ Promoted vs Not Promoted — 4-dimension radar chart
- 📊 Education level vs performance and promotion rate (grouped bar + dual axis)
- 📋 Top 15 promotion candidates table — weighted composite score

---

### Page 6 — Store Operations
**Purpose:** Revenue benchmarking across store formats, customer satisfaction drivers, waste efficiency, and employee satisfaction correlation.

**KPI Cards:**
- Top Store Revenue · Bottom Store Revenue · Avg Customer Satisfaction · Low vs High Waste Revenue Ratio

**Charts:**
- 📊 Top 5 vs Bottom 5 stores by total revenue (2022–2024)
- 📊 On-time delivery vs CSAT — counterintuitive relationship
- 📊 Waste percentage → average monthly revenue per store
- 🔵 Scatter plot — employee satisfaction vs store revenue (Regular vs Superstore)

---

## 🛠️ Tools & Techniques

- **Microsoft SQL Server** — all data storage, transformation, and analysis
- **T-SQL** — CTEs, CASE WHEN bucketing, window aggregations, weighted scoring models
- **TRY_CONVERT / DATEDIFF** — safe date parsing and tenure calculation
- **HTML / CSS / JavaScript + Chart.js** — custom single-file interactive dashboard
- **Editorial design system** — IBM Plex fonts, cream/navy/gold palette, zero border-radius aesthetic

---

## 💡 Key Insights

1. **Training sweet spot at 5–9h/month** — employees in this range achieve the highest performance (3.939) and satisfaction (7.529). Training beyond 15h shows diminishing returns.
2. **Late attrition is the real risk** — 37% of departures happen after 3+ years, not during onboarding. Retention programs should target the 12–36 month window.
3. **Salary-performance mismatch** — 15 high performers are paid below their job level average, making them prime targets for competitor poaching.
4. **Promotion system is fair** — promoted employees outperform non-promoted peers by +14.5% on performance and +20.2% on productivity, confirming the evaluation process works correctly.
5. **Store type drives revenue more than service quality** — the $18M gap between Superstore and Express locations is explained by format and city size, not CSAT or NPS scores.

---

## 📁 File Structure

```
hr-analytics/
│
├── stores.sql                     ← DDL + INSERT data (150 stores)
├── employee_performance.sql       ← DDL + INSERT data (7,500 employees)
├── monthly_performance.sql        ← DDL + INSERT data (236,591 records)
├── role_kpis.sql                  ← DDL + INSERT rows 1 – 100,000
├── role_kpis_data_02.sql          ← INSERT rows 100,001 – 236,591 (split due to size)
├── business_outcomes.sql          ← DDL + INSERT data (16,200 records)
│
├── Querry_Human_Resources.sql     ← All 22 analysis queries
│
└── dashboard/
    └── hr_analytics_unified.html  ← Interactive dashboard (6 thematic pages)
```

---

## 🚀 How to Use

**Step 1 — Create the database and tables**

Run SQL files in this exact order to respect foreign key dependencies:

```sql
-- 1. stores.sql                 (create table + insert 150 stores)
-- 2. employee_performance.sql   (create table + insert 7,500 employees)
-- 3. monthly_performance.sql    (create table + insert 236,591 records)
-- 4. role_kpis.sql              (create table + insert rows 1 – 100,000)
-- 5. role_kpis_data_02.sql      (insert rows 100,001 – 236,591)
-- 6. business_outcomes.sql      (create table + insert 16,200 records)
```

**Step 2 — Run the analyses**

```sql
-- Open and execute: Querry_Human_Resources.sql
-- 22 queries separated by comments for easy navigation
```

**Step 3 — View the dashboard**

Open `dashboard/hr_analytics_unified.html` in any browser — no server or installation required.

> **Note:** The dashboard is fully self-contained. All chart data is embedded as JavaScript — no live database connection needed for viewing.

---

## 👤 Author

**Vo Quang Khai**
Data Analyst | Finance & Data Science Background
[LinkedIn](https://www.linkedin.com/in/voquangkhaikg2003/) · [GitHub](https://github.com/voquangkhai2003)
