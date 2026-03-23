SELECT Department,
  COUNT(*) AS total,
  SUM(CASE WHEN Exit_Date IS NOT NULL AND Exit_Date != ''
       THEN 1 ELSE 0 END) AS left_count,
  ROUND(100.0 * SUM(CASE WHEN Exit_Date IS NOT NULL
       AND Exit_Date != '' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_rate
FROM dbo.EmployeePerformance
GROUP BY Department
ORDER BY attrition_rate DESC;

SELECT Job_Level,
  ROUND(AVG(CAST(Base_Salary_Annual AS FLOAT)), 0) AS avg_salary,
  COUNT(*) AS employee_count
FROM dbo.EmployeePerformance
GROUP BY Job_Level
ORDER BY avg_salary DESC;

SELECT Department,
  ROUND(AVG(CAST(Base_Salary_Annual AS FLOAT)), 0) AS avg_salary
FROM dbo.EmployeePerformance
GROUP BY Department
ORDER BY avg_salary DESC;

SELECT TOP 12 Year_Month,
  ROUND(AVG(CAST(Performance_Rating AS FLOAT)), 3) AS avg_rating,
  COUNT(*) AS records
FROM dbo.MonthlyPerformance
GROUP BY Year_Month
ORDER BY avg_rating DESC;

SELECT TOP 10 e.Manager_Id, e.Manager_Name,
  COUNT(DISTINCT e.Employee_Id) AS team_size,
  ROUND(AVG(CAST(mp.Performance_Rating AS FLOAT)), 3) AS avg_team_perf
FROM dbo.EmployeePerformance e
JOIN dbo.MonthlyPerformance mp ON e.Employee_Id = mp.Employee_Id
WHERE e.Manager_Id IS NOT NULL
GROUP BY e.Manager_Id, e.Manager_Name
HAVING COUNT(DISTINCT e.Employee_Id) >= 3
ORDER BY ROUND(AVG(CAST(mp.Performance_Rating AS FLOAT)), 3) DESC;

SELECT
  CASE
    WHEN CAST(Training_Hours AS FLOAT) < 5  THEN '0-4h'
    WHEN CAST(Training_Hours AS FLOAT) < 10 THEN '5-9h'
    WHEN CAST(Training_Hours AS FLOAT) < 15 THEN '10-14h'
    WHEN CAST(Training_Hours AS FLOAT) < 20 THEN '15-19h'
    ELSE '20h+'
  END AS training_bucket,
  ROUND(AVG(CAST(Performance_Rating AS FLOAT)), 3) AS avg_perf,
  ROUND(AVG(CAST(Employee_Satisfaction AS FLOAT)), 3) AS avg_satisfaction
FROM dbo.MonthlyPerformance
GROUP BY
  CASE
    WHEN CAST(Training_Hours AS FLOAT) < 5  THEN '0-4h'
    WHEN CAST(Training_Hours AS FLOAT) < 10 THEN '5-9h'
    WHEN CAST(Training_Hours AS FLOAT) < 15 THEN '10-14h'
    WHEN CAST(Training_Hours AS FLOAT) < 20 THEN '15-19h'
    ELSE '20h+'
  END
ORDER BY training_bucket;

SELECT TOP 5 b.Store_Id, s.Store_Name, s.City,
  ROUND(SUM(CAST(b.Sales_Actual AS FLOAT)), 0) AS total_revenue,
  ROUND(AVG(CAST(b.Customer_Satisfaction AS FLOAT)), 2) AS avg_csat,
  ROUND(AVG(CAST(b.Nps_Score AS FLOAT)), 1) AS avg_nps
FROM dbo.BusinessOutcomes b
JOIN dbo.Stores s ON b.Store_Id = s.Store_Id
GROUP BY b.Store_Id, s.Store_Name, s.City
ORDER BY ROUND(SUM(CAST(b.Sales_Actual AS FLOAT)), 0) DESC;

SELECT e.Department,
  ROUND(AVG(CAST(mp.Employee_Satisfaction AS FLOAT)), 3) AS avg_satisfaction,
  ROUND(AVG(CAST(mp.Engagement_Index AS FLOAT)), 3) AS avg_engagement,
  COUNT(DISTINCT e.Employee_Id) AS employee_count
FROM dbo.EmployeePerformance e
JOIN dbo.MonthlyPerformance mp ON e.Employee_Id = mp.Employee_Id
GROUP BY e.Department
ORDER BY ROUND(AVG(CAST(mp.Employee_Satisfaction AS FLOAT)), 3) DESC;

SELECT TOP 15 e.Job_Role,
  ROUND(AVG(CAST(rk.Productivity_Index AS FLOAT)), 3) AS avg_productivity,
  ROUND(AVG(CAST(mp.Performance_Rating AS FLOAT)), 3) AS avg_performance,
  COUNT(DISTINCT e.Employee_Id) AS emp_count
FROM dbo.EmployeePerformance e
JOIN dbo.RoleKPIs rk ON e.Employee_Id = rk.Employee_Id
JOIN dbo.MonthlyPerformance mp ON e.Employee_Id = mp.Employee_Id
  AND rk.Year_Month = mp.Year_Month
GROUP BY e.Job_Role
ORDER BY ROUND(AVG(CAST(rk.Productivity_Index AS FLOAT)), 3) DESC;

SELECT TOP 15 e.Employee_Id, e.Full_Name, e.Department,
  e.Job_Role, e.Job_Level,
  ROUND(AVG(CAST(mp.Performance_Rating AS FLOAT)), 3) AS avg_perf,
  ROUND(AVG(CAST(mp.Employee_Satisfaction AS FLOAT)), 3) AS avg_satisfaction,
  ROUND(AVG(CAST(rk.Productivity_Index AS FLOAT)), 3) AS avg_productivity,
  ROUND(
    AVG(CAST(mp.Performance_Rating AS FLOAT)) * 0.4 +
    AVG(CAST(mp.Employee_Satisfaction AS FLOAT)) * 0.1 +
    AVG(CAST(rk.Productivity_Index AS FLOAT)) * 0.5,
    3) AS promotion_score
FROM dbo.EmployeePerformance e
JOIN dbo.MonthlyPerformance mp ON e.Employee_Id = mp.Employee_Id
JOIN dbo.RoleKPIs rk ON e.Employee_Id = rk.Employee_Id
  AND mp.Year_Month = rk.Year_Month
WHERE (e.Exit_Date = '' OR e.Exit_Date IS NULL)
  AND e.Job_Level != 'Executive'
GROUP BY e.Employee_Id, e.Full_Name, e.Department,
  e.Job_Role, e.Job_Level
HAVING COUNT(*) >= 6
ORDER BY ROUND(
    AVG(CAST(mp.Performance_Rating AS FLOAT)) * 0.4 +
    AVG(CAST(mp.Employee_Satisfaction AS FLOAT)) * 0.1 +
    AVG(CAST(rk.Productivity_Index AS FLOAT)) * 0.5,3) DESC;

SELECT
  CASE
    WHEN CAST(e.Age AS INT) < 25 THEN 'Under 25'
    WHEN CAST(e.Age AS INT) < 30 THEN '25-29'
    WHEN CAST(e.Age AS INT) < 35 THEN '30-34'
    WHEN CAST(e.Age AS INT) < 40 THEN '35-39'
    WHEN CAST(e.Age AS INT) < 45 THEN '40-44'
    WHEN CAST(e.Age AS INT) < 50 THEN '45-49'
    ELSE '50+'
  END AS age_group,
  ROUND(AVG(CAST(mp.Performance_Rating AS FLOAT)), 3) AS avg_perf,
  ROUND(AVG(CAST(mp.Employee_Satisfaction AS FLOAT)), 3) AS avg_satisfaction,
  COUNT(DISTINCT e.Employee_Id) AS emp_count
FROM dbo.EmployeePerformance e
JOIN dbo.MonthlyPerformance mp ON e.Employee_Id = mp.Employee_Id
GROUP BY 
  CASE
    WHEN CAST(e.Age AS INT) < 25 THEN 'Under 25'
    WHEN CAST(e.Age AS INT) < 30 THEN '25-29'
    WHEN CAST(e.Age AS INT) < 35 THEN '30-34'
    WHEN CAST(e.Age AS INT) < 40 THEN '35-39'
    WHEN CAST(e.Age AS INT) < 45 THEN '40-44'
    WHEN CAST(e.Age AS INT) < 50 THEN '45-49'
    ELSE '50+'
  END
ORDER BY MIN(CAST(e.Age AS INT));

WITH parsed AS (
  SELECT Employee_Id,
    TRY_CONVERT(DATE, Hire_Date, 103) AS hire_dt,
    TRY_CONVERT(DATE, Exit_Date, 103) AS exit_dt
  FROM dbo.EmployeePerformance
  WHERE Exit_Date IS NOT NULL AND Exit_Date != ''
),
tenured AS (
  SELECT Employee_Id,
    DATEDIFF(MONTH, hire_dt, exit_dt) AS tenure_months
  FROM parsed
  WHERE hire_dt IS NOT NULL AND exit_dt IS NOT NULL
)
SELECT
  CASE
    WHEN tenure_months < 6  THEN '< 6 months'
    WHEN tenure_months < 12 THEN '6-12 months'
    WHEN tenure_months < 24 THEN '1-2 years'
    WHEN tenure_months < 36 THEN '2-3 years'
    ELSE '3+ years'
  END AS tenure_bucket,
  COUNT(*) AS exited,
  ROUND(AVG(CAST(tenure_months AS FLOAT)), 1) AS avg_months
FROM tenured
GROUP BY
  CASE
    WHEN tenure_months < 6  THEN '< 6 months'
    WHEN tenure_months < 12 THEN '6-12 months'
    WHEN tenure_months < 24 THEN '1-2 years'
    WHEN tenure_months < 36 THEN '2-3 years'
    ELSE '3+ years'
  END
ORDER BY MIN(tenure_months);

SELECT TOP 15 e.Employee_Id, e.Full_Name, e.Department, e.Job_Role,
  ROUND(AVG(CAST(mp.Absenteeism_Days AS FLOAT)), 2) AS avg_absent,
  ROUND(AVG(CAST(mp.Employee_Satisfaction AS FLOAT)), 2) AS avg_satisfaction,
  ROUND(AVG(CAST(mp.Performance_Rating AS FLOAT)), 2) AS avg_perf,
  ROUND(
    (AVG(CAST(mp.Absenteeism_Days AS FLOAT)) * 0.3) +
    ((10 - AVG(CAST(mp.Employee_Satisfaction AS FLOAT))) * 0.4) +
    ((5 - AVG(CAST(mp.Performance_Rating AS FLOAT))) * 0.3)
  , 2) AS flight_risk_score
FROM dbo.EmployeePerformance e
JOIN dbo.MonthlyPerformance mp ON e.Employee_Id = mp.Employee_Id
WHERE (e.Exit_Date IS NULL OR e.Exit_Date = '')
GROUP BY e.Employee_Id, e.Full_Name, e.Department, e.Job_Role, e.Job_Level
HAVING COUNT(*) >= 6
ORDER BY flight_risk_score DESC;

WITH level_avg AS (
  SELECT Job_Level,
    AVG(CAST(Base_Salary_Annual AS FLOAT)) AS level_avg_salary
  FROM dbo.EmployeePerformance GROUP BY Job_Level
),
emp_perf AS (
  SELECT e.Employee_Id, e.Full_Name, e.Department, e.Job_Role, e.Job_Level,
    CAST(e.Base_Salary_Annual AS FLOAT) AS salary,
    AVG(CAST(mp.Performance_Rating AS FLOAT)) AS avg_perf
  FROM dbo.EmployeePerformance e
  JOIN dbo.MonthlyPerformance mp ON e.Employee_Id = mp.Employee_Id
  WHERE (e.Exit_Date IS NULL OR e.Exit_Date = '')
  GROUP BY e.Employee_Id, e.Full_Name, e.Department,
           e.Job_Role, e.Job_Level, e.Base_Salary_Annual
  HAVING COUNT(*) >= 6
)
SELECT TOP 15 ep.Full_Name, ep.Department, ep.Job_Role, ep.Job_Level,
  ROUND(ep.salary, 0) AS salary,
  ROUND(la.level_avg_salary, 0) AS level_avg,
  ROUND(ep.salary - la.level_avg_salary, 0) AS salary_gap,
  ROUND(ep.avg_perf, 3) AS avg_perf
FROM emp_perf ep
JOIN level_avg la ON ep.Job_Level = la.Job_Level
WHERE ep.avg_perf >= 4.2 AND ep.salary < la.level_avg_salary
ORDER BY salary_gap ASC;

SELECT e.Department,
  ROUND(AVG(CAST(mp.Overtime_Hours AS FLOAT)), 2) AS avg_overtime,
  ROUND(AVG(CAST(mp.Performance_Rating AS FLOAT)), 3) AS avg_perf,
  ROUND(AVG(CAST(mp.Employee_Satisfaction AS FLOAT)), 3) AS avg_satisfaction
FROM dbo.EmployeePerformance e
JOIN dbo.MonthlyPerformance mp ON e.Employee_Id = mp.Employee_Id
GROUP BY e.Department
ORDER BY avg_overtime DESC;

SELECT
  YEAR(CONVERT(DATE, Hire_Date, 103)) AS hire_year,
  COUNT(*) AS total_hired,
  SUM(CASE WHEN Exit_Date IS NULL OR Exit_Date = ''
       THEN 1 ELSE 0 END) AS still_active,
  ROUND(100.0 * SUM(CASE WHEN Exit_Date IS NULL OR Exit_Date = ''
       THEN 1 ELSE 0 END) / COUNT(*), 1) AS retention_rate
FROM dbo.EmployeePerformance
GROUP BY YEAR(CONVERT(DATE, Hire_Date, 103))
ORDER BY hire_year;

SELECT
  CASE
    WHEN CAST(On_Time_Delivery AS FLOAT) < 85 THEN '< 85%'
    WHEN CAST(On_Time_Delivery AS FLOAT) < 90 THEN '85–90%'
    WHEN CAST(On_Time_Delivery AS FLOAT) < 95 THEN '90–95%'
    ELSE '95–100%'
  END AS otd_bucket,
  ROUND(AVG(CAST(Customer_Satisfaction AS FLOAT)), 3) AS avg_csat,
  ROUND(AVG(CAST(Nps_Score AS FLOAT)), 2) AS avg_nps
FROM dbo.BusinessOutcomes
GROUP BY
  CASE
    WHEN CAST(On_Time_Delivery AS FLOAT) < 85 THEN '< 85%'
    WHEN CAST(On_Time_Delivery AS FLOAT) < 90 THEN '85–90%'
    WHEN CAST(On_Time_Delivery AS FLOAT) < 95 THEN '90–95%'
    ELSE '95–100%'
  END
ORDER BY MIN(CAST(On_Time_Delivery AS FLOAT));

SELECT
  CASE
    WHEN CAST(Absenteeism_Days AS FLOAT) = 0  THEN '0 days'
    WHEN CAST(Absenteeism_Days AS FLOAT) <= 1 THEN '1 day'
    WHEN CAST(Absenteeism_Days AS FLOAT) <= 3 THEN '2–3 days'
    WHEN CAST(Absenteeism_Days AS FLOAT) <= 5 THEN '4–5 days'
    ELSE '6+ days'
  END AS absent_bucket,
  ROUND(AVG(CAST(Performance_Rating AS FLOAT)), 3) AS avg_perf,
  ROUND(AVG(CAST(Employee_Satisfaction AS FLOAT)), 3) AS avg_satisfaction
FROM dbo.MonthlyPerformance
GROUP BY
  CASE
    WHEN CAST(Absenteeism_Days AS FLOAT) = 0  THEN '0 days'
    WHEN CAST(Absenteeism_Days AS FLOAT) <= 1 THEN '1 day'
    WHEN CAST(Absenteeism_Days AS FLOAT) <= 3 THEN '2–3 days'
    WHEN CAST(Absenteeism_Days AS FLOAT) <= 5 THEN '4–5 days'
    ELSE '6+ days'
  END
ORDER BY MIN(CAST(Absenteeism_Days AS FLOAT));

SELECT mp.Promotion_Flag,
  ROUND(AVG(CAST(mp.Performance_Rating AS FLOAT)), 3) AS avg_perf,
  ROUND(AVG(CAST(mp.Employee_Satisfaction AS FLOAT)), 3) AS avg_satisfaction,
  ROUND(AVG(CAST(rk.Productivity_Index AS FLOAT)), 3) AS avg_productivity,
  ROUND(AVG(CAST(mp.Training_Hours AS FLOAT)), 2) AS avg_training,
  COUNT(*) AS records
FROM dbo.MonthlyPerformance mp
JOIN dbo.RoleKPIs rk
  ON mp.Employee_Id = rk.Employee_Id AND mp.Year_Month = rk.Year_Month
GROUP BY mp.Promotion_Flag;

SELECT e.Education_Level,
  COUNT(DISTINCT e.Employee_Id) AS emp_count,
  ROUND(AVG(CAST(mp.Performance_Rating AS FLOAT)), 3) AS avg_perf,
  ROUND(AVG(CAST(mp.Employee_Satisfaction AS FLOAT)), 3) AS avg_satisfaction,
  ROUND(100.0 * SUM(CASE WHEN mp.Promotion_Flag = 'TRUE'
         THEN 1 ELSE 0 END) / COUNT(*), 3) AS promotion_rate_pct
FROM dbo.EmployeePerformance e
JOIN dbo.MonthlyPerformance mp ON e.Employee_Id = mp.Employee_Id
GROUP BY e.Education_Level
ORDER BY avg_perf DESC;

SELECT e.Employment_Type,
  COUNT(DISTINCT e.Employee_Id) AS emp_count,
  ROUND(AVG(CAST(mp.Performance_Rating AS FLOAT)), 3) AS avg_perf,
  ROUND(AVG(CAST(mp.Employee_Satisfaction AS FLOAT)), 3) AS avg_satisfaction
FROM dbo.EmployeePerformance e
JOIN dbo.MonthlyPerformance mp ON e.Employee_Id = mp.Employee_Id
GROUP BY e.Employment_Type
ORDER BY avg_perf DESC;

SELECT Employment_Type,
  COUNT(*) AS total,
  SUM(CASE WHEN Exit_Date IS NOT NULL AND Exit_Date != ''
       THEN 1 ELSE 0 END) AS exited,
  ROUND(100.0 * SUM(CASE WHEN Exit_Date IS NOT NULL AND Exit_Date != ''
       THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_rate
FROM dbo.EmployeePerformance
GROUP BY Employment_Type
ORDER BY attrition_rate DESC;

WITH store_sat AS (
  SELECT e.Store_Id,
    ROUND(AVG(CAST(mp.Employee_Satisfaction AS FLOAT)), 3) AS avg_emp_sat,
    COUNT(DISTINCT e.Employee_Id) AS emp_count
  FROM dbo.EmployeePerformance e
  JOIN dbo.MonthlyPerformance mp ON e.Employee_Id = mp.Employee_Id
  GROUP BY e.Store_Id
  HAVING COUNT(DISTINCT e.Employee_Id) >= 5
),
store_rev AS (
  SELECT Store_Id,
    ROUND(SUM(CAST(Sales_Actual AS FLOAT)), 0) AS total_revenue
  FROM dbo.BusinessOutcomes
  GROUP BY Store_Id
)
SELECT TOP 20 ss.Store_Id, s.Store_Name, s.Store_Type,
  ss.avg_emp_sat, sr.total_revenue
FROM store_sat ss
JOIN store_rev sr ON ss.Store_Id = sr.Store_Id
JOIN dbo.Stores s ON ss.Store_Id = s.Store_Id
ORDER BY ss.avg_emp_sat DESC;

SELECT
  CASE
    WHEN CAST(Waste_Percentage AS FLOAT) < 1.5 THEN '< 1.5%'
    WHEN CAST(Waste_Percentage AS FLOAT) < 2.5 THEN '1.5–2.5%'
    WHEN CAST(Waste_Percentage AS FLOAT) < 3.5 THEN '2.5–3.5%'
    ELSE '3.5%+'
  END AS waste_bucket,
  ROUND(AVG(CAST(Sales_Actual AS FLOAT)), 0) AS avg_revenue,
  ROUND(AVG(CAST(Customer_Satisfaction AS FLOAT)), 3) AS avg_csat
FROM dbo.BusinessOutcomes
GROUP BY
  CASE
    WHEN CAST(Waste_Percentage AS FLOAT) < 1.5 THEN '< 1.5%'
    WHEN CAST(Waste_Percentage AS FLOAT) < 2.5 THEN '1.5–2.5%'
    WHEN CAST(Waste_Percentage AS FLOAT) < 3.5 THEN '2.5–3.5%'
    ELSE '3.5%+'
  END
ORDER BY MIN(CAST(Waste_Percentage AS FLOAT));