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
| `dbo.Stores` | `stores.sql` | 150 retail stores — name, city, type, opening date |
| `dbo.EmployeePerformance` | `employee_performance.sql` | Employee profiles — age, education, salary, job level, manager |
| `dbo.MonthlyPerformance` | `monthly_performance.sql` | Monthly records — rating, training hours, overtime, bonus, satisfaction |
| `dbo.RoleKPIs` | `role_kpis.sql` + `role_kpis_02.sql` | Role-specific KPIs + Productivity Index (split into 2 files due to size) |
| `dbo.BusinessOutcomes` | `business_outcomes.sql` | Store-level revenue, CSAT, NPS, waste %, on-time delivery |

**Relationships:**

```
dbo.Stores ──────────────────── dbo.EmployeePerformance
    │                                      │
    └── dbo.BusinessOutcomes               ├── dbo.MonthlyPerformance
                                           └── dbo.RoleKPIs
```

---

## 📊 Analyses — 22 Questions Answered

### Part 1 — Core Analysis

| # | Question | Key Finding |
|---|----------|-------------|
| Q1 | Attrition rate by department | **19.9%** overall — Logistics & HR highest at **22.2%** |
| Q2 | Average salary by job level & department | Executive **$111K** → Entry **$23K** (4.8× gap) |
| Q3 | Top months by performance rating | **Nov–Dec** and **Jan** consistently peak |
| Q4 | Top 10 managers by team performance | Nicholas Fitzgerald leads (avg team score 3.802) |
| Q5 | Does more training = higher performance? | **5–9h/month** is the optimal range (perf 3.939) |
| Q6 | Top 5 vs bottom 5 stores by revenue | NY Superstore #81: **$24.3M** vs Express stores ~$5.9M |
| Q7 | Employee satisfaction by department | Store Operations happiest (7.323/10) |
| Q8 | Productivity index by job role | Fresh Foods Director leads (1.559) |
| Q9 | Promotion candidates | Top 15 by weighted score (Perf×0.4 + Prod×0.5 + Sat×0.1) |
| Q10 | Age vs performance | Weak correlation — age does not determine performance |

### Part 2 — Extended Analysis

| # | Analysis | Key Finding |
|---|----------|-------------|
| A1 | Tenure at exit | **37%** of leavers had 3+ years tenure — "late attrition" risk |
| A2 | Flight risk scoring | Logistics & IT have highest concentration of at-risk employees |
| A3 | Underpaid high performers | 15 employees with perf ≥ 4.2 earn below their level average |
| A4 | Overtime by department | IT works most overtime (8.33h) but has lowest performance |
| A5 | Cohort retention by hire year | 2012–2013 cohort retains **86%** — most loyal group |
| A6 | On-time delivery vs CSAT | Unexpected: lower OTD → higher CSAT (human service effect) |
| A7 | Absenteeism impact | Linear decline — red threshold at **4–5 absent days/month** |
| A8 | Promotion fairness | Promoted group outperforms by **+14.5% perf, +20.2% productivity** |
| A9 | Education vs performance | Master's leads; PhD unexpectedly ranks 3rd |
| A10 | Employment type comparison | Seasonal attrition **56.5%** vs Full-time **13.5%** |
| A11 | Employee satisfaction → store revenue | Positive correlation between staff satisfaction and revenue |
| A12 | Waste % → revenue impact | Waste < 1.5% stores earn **4.5× more** than high-waste stores |

---

## 🛠️ Tools & Techniques

- **Microsoft SQL Server** — all data storage and analysis
- **T-SQL** — CTEs, CASE WHEN bucketing, window aggregations, weighted scoring models
- **TRY_CONVERT / DATEDIFF** — safe date parsing and tenure calculation
- **HTML / CSS / JavaScript + Chart.js** — interactive single-file dashboard
- **Sidebar navigation** — 22 analyses accessible from a fixed left panel

---

## 💡 Key Insights

1. **Training sweet spot at 5–9h/month** — employees in this range achieve the highest performance (3.939) and satisfaction (7.529). Training beyond 15h shows no added benefit.
2. **Late attrition is the real risk** — 37% of departures happen after 3+ years, not in the first few months. Retention programs should target the 12–36 month window.
3. **Salary-performance mismatch** — 15 high performers are paid below their job level average, making them prime targets for competitor poaching.
4. **Promotion system is fair** — promoted employees outperform non-promoted peers by 14.5% on performance and 20.2% on productivity, confirming the evaluation process works.
5. **Store type drives revenue more than service quality** — the $18M gap between Superstore and Express stores is explained by store format and location, not CSAT or NPS scores.

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
    └── hr_analytics_unified.html  ← Interactive dashboard (all 22 analyses)
```

---

## 🚀 How to Use

**Step 1 — Create the database and tables**

Run the SQL files in this exact order (foreign key dependencies):

```sql
-- 1. stores.sql                 (create table + insert 150 stores)
-- 2. employee_performance.sql   (create table + insert employees)
-- 3. monthly_performance.sql    (create table + insert monthly records)
-- 4. role_kpis.sql              (create table + insert rows 1 – 100,000)
-- 5. role_kpis_02.sql           (insert rows 100,001 – 236,591)
-- 6. business_outcomes.sql      (create table + insert store outcomes)
```

**Step 2 — Run the analyses**

```sql
-- Open and run: Querry_Human_Resources.sql
-- All 22 queries are separated by comments for easy navigation
```

**Step 3 — View the dashboard**

Open `dashboard/hr_analytics_unified.html` in any browser — no server required.

> **Note:** The dashboard is fully self-contained (all data embedded as JavaScript). No database connection needed for viewing.

---

## 👤 Author

**Vo Quang Khai**
Data Analyst | Finance & Data Science Background
[LinkedIn](https://www.linkedin.com/in/voquangkhaikg2003/) · [GitHub](https://github.com/voquangkhai2003)
