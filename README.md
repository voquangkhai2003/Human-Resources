# 👥 Employee Performance Analytics
> SQL · Microsoft SQL Server · Interactive Dashboard

Phân tích toàn diện dữ liệu nhân sự của một chuỗi bán lẻ với **7,500 nhân viên**, **150 cửa hàng** trên toàn quốc, giai đoạn 2022–2024. Dự án trả lời **22 câu hỏi kinh doanh** thông qua SQL thuần và dashboard trực quan tương tác.

---

## 🗂️ Cấu trúc Project

```
hr-analytics/
│
├── stores.sql                    ← DDL + INSERT 150 cửa hàng
├── employee_performance.sql      ← DDL bảng nhân viên
├── monthly_performance.sql       ← DDL bảng hiệu suất tháng
├── role_kpis.sql                 ← DDL bảng KPI theo vai trò
├── business_outcomes.sql         ← DDL bảng kết quả kinh doanh
│
├── Querry_Human_Resources.sql    ← 22 câu query phân tích chính
│
└── dashboard/
    └── hr_analytics_unified.html ← Interactive dashboard (22 analyses)
```

---

## 🗃️ Database Schema

**Database:** `HumanResources` · **Platform:** Microsoft SQL Server

| Bảng | File | Mô tả | Số dòng |
|------|------|-------|---------|
| `dbo.Stores` | `stores.sql` | 150 cửa hàng: tên, thành phố, loại, ngày mở | 150 |
| `dbo.EmployeePerformance` | `employee_performance.sql` | Hồ sơ nhân viên: tuổi, học vấn, lương, cấp bậc | 7,500 |
| `dbo.MonthlyPerformance` | `monthly_performance.sql` | Hiệu suất tháng: rating, training, overtime, bonus | 236,591 |
| `dbo.RoleKPIs` | `role_kpis.sql` | 3 KPI theo vai trò + Productivity Index | 236,591 |
| `dbo.BusinessOutcomes` | `business_outcomes.sql` | Doanh thu, CSAT, NPS, Waste theo cửa hàng/tháng | 16,200 |

### Relationships

```
dbo.Stores ──────────────── dbo.EmployeePerformance
    │                                │
    └── dbo.BusinessOutcomes         ├── dbo.MonthlyPerformance
                                     └── dbo.RoleKPIs
```

---

## ⚙️ Cách chạy

### Bước 1 — Tạo Database & Bảng

```sql
-- Chạy lần lượt theo thứ tự:
-- 1. stores.sql              (tạo bảng + insert data 150 stores)
-- 2. employee_performance.sql
-- 3. monthly_performance.sql
-- 4. role_kpis.sql
-- 5. business_outcomes.sql
```

### Bước 2 — Import Data

Import file CSV tương ứng vào từng bảng (SQL Server Import Wizard hoặc `BULK INSERT`).

### Bước 3 — Chạy Phân tích

```sql
-- Chạy toàn bộ 22 query:
Querry_Human_Resources.sql
```

---

## ❓ 22 Câu hỏi được giải đáp

### Part 1 — Core Analysis (`Querry_Human_Resources.sql`)

| # | Câu hỏi | Kết quả chính |
|---|---------|--------------|
| Q1 | Tỷ lệ nghỉ việc theo bộ phận | **19.9%** tổng — Logistics & HR cao nhất (22.2%) |
| Q2a | Lương trung bình theo Job Level | Executive **$111K** → Entry **$23K** (gap 4.8×) |
| Q2b | Lương trung bình theo Department | IT cao nhất ($28.5K), Customer Service thấp nhất |
| Q3 | Top 12 tháng hiệu suất cao nhất | Tháng **11–12** và **tháng 1** đỉnh cao nhất |
| Q4 | Top 10 Manager xuất sắc | Nicholas Fitzgerald dẫn đầu (avg team 3.802) |
| Q5 | Training vs Performance | **5–9h/tháng** là ngưỡng tối ưu (perf 3.939) |
| Q6 | Top 5 cửa hàng doanh thu | NY Superstore #81: **$24.3M** |
| Q7 | Satisfaction theo phòng ban | Store Operations hạnh phúc nhất (7.323/10) |
| Q8 | Productivity theo vai trò | Fresh Foods Director đứng đầu (1.559) |
| Q9 | Ứng viên thăng tiến | Top 15 theo weighted score |
| Q10 | Tuổi vs Hiệu suất | Tương quan yếu — tuổi không quyết định |
| A1 | Tenure lúc nghỉ việc | **37%** nghỉ sau 3+ năm |

### Part 2 — Extended Analysis

| # | Phân tích | Phát hiện chính |
|---|-----------|----------------|
| A2 | Flight Risk Scoring | Logistics & IT nguy cơ cao nhất |
| A3 | Underpaid High Performers | 15 nhân viên perf ≥ 4.2 bị trả lương thấp hơn avg |
| A4 | Overtime Analysis | IT overtime nhiều nhất (8.33h) nhưng perf thấp nhất |
| A5 | Cohort Retention | 2012–2013 retention **86%** — kỳ cựu gắn bó nhất |
| A6 | OTD vs CSAT | OTD thấp hơn → CSAT cao hơn (kết quả bất ngờ) |
| A7 | Absenteeism Impact | Tuyến tính rõ ràng — ngưỡng đỏ: 4–5 ngày/tháng |
| A8 | Promotion Fairness | Promoted group vượt trội +14.5% perf, +20.2% productivity |
| A9 | Education vs Performance | Master's dẫn đầu; PhD bất ngờ xếp thứ 3 |
| A10 | Employment Type | Seasonal attrition **56.5%** vs Full-time **13.5%** |
| A11 | Employee Sat → Revenue | Tương quan dương giữa satisfaction và doanh thu |
| A12 | Waste → Revenue | Waste < 1.5% có doanh thu gấp **4.5×** nhóm cao |

---

## 💡 Key Findings

**1. Training Sweet Spot**
Nhân viên được đào tạo 5–9h/tháng có performance cao nhất (3.939). Trên 15h không mang lại lợi ích thêm — *"training overload effect"*.

**2. Late Attrition Problem**
37% nhân viên nghỉ đã làm trên 3 năm. Cần chương trình giữ chân tập trung ở mốc 12–36 tháng, không chỉ giai đoạn đầu.

**3. Salary-Performance Mismatch**
15 nhân viên có performance ≥ 4.2/5 đang bị trả lương dưới mức trung bình của cấp bậc — nhóm rủi ro nghỉ việc cao nhất.

**4. Promotion System Works**
Nhân viên được thăng tiến có performance cao hơn **14.5%** và productivity cao hơn **20.2%** — hệ thống đánh giá hoạt động công bằng.

**5. Store Type Drives Revenue**
Khoảng cách doanh thu Superstore ($24M) vs Express ($5.9M) chủ yếu do loại cửa hàng và địa điểm, không phải CSAT hay OTD.

---

## 🛠️ Tech Stack

```
Microsoft SQL Server    ← Database & toàn bộ phân tích
T-SQL                   ← Queries: CTE, CASE WHEN, Window Functions
HTML / CSS / JavaScript ← Dashboard
Chart.js                ← Visualizations (bar, line, radar, scatter, doughnut)
```

---

## 👤 Author

**Vo Quang Khai**
Data Analyst | Finance & Data Science Background
[LinkedIn](https://www.linkedin.com/in/voquangkhaikg2003/) · [GitHub](https://github.com/voquangkhai2003)
