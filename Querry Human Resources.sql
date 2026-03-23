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
    CONVERT(DATE, STUFF(STUFF(Hire_Date,3,0,'/'),6,0,'/'), 103) AS hire_dt,
    CONVERT(DATE, STUFF(STUFF(Exit_Date,3,0,'/'),6,0,'/'), 103) AS exit_dt
  FROM dbo.Employees
  WHERE Exit_Date IS NOT NULL AND Exit_Date != ''
),
tenured AS (
  SELECT Employee_Id,
    DATEDIFF(MONTH, hire_dt, exit_dt) AS tenure_months
  FROM parsed
)
SELECT
  CASE
    WHEN tenure_months < 6  THEN '< 6 months'
    WHEN tenure_months < 12 THEN '6–12 months'
    WHEN tenure_months < 24 THEN '1–2 years'
    WHEN tenure_months < 36 THEN '2–3 years'
    ELSE '3+ years'
  END AS tenure_bucket,
  COUNT(*) AS exited,
  ROUND(AVG(CAST(tenure_months AS FLOAT)), 1) AS avg_months
FROM tenured
GROUP BY
  CASE
    WHEN tenure_months < 6  THEN '< 6 months'
    WHEN tenure_months < 12 THEN '6–12 months'
    WHEN tenure_months < 24 THEN '1–2 years'
    WHEN tenure_months < 36 THEN '2–3 years'
    ELSE '3+ years'
  END
ORDER BY MIN(tenure_months);