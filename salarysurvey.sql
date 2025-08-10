create database salarysurvey;
use salarysurvey;
#1. Average Salary by Industry and Gender
SELECT Industry, Gender, ROUND(AVG(Annual_Salary),2) AS avg_salary
FROM salary_survey
GROUP BY Industry, Gender;
#2. Total Salary Compensation by Job Title
SELECT Job_Title,
       SUM(Annual_Salary + Additional_Compensation) AS Total_compesation
FROM salary_survey
GROUP BY Job_Title
ORDER BY Total_compesation desc;
#3. Salary Distribution by Education Level
SELECT
    Level_of_Education,
    MIN(Annual_Salary) AS min_salary,
    MAX(Annual_Salary) AS max_salary,
    ROUND(AVG(Annual_Salary), 2) AS Avg_salary
FROM salary_survey
GROUP BY Level_of_Education
ORDER BY avg_salary DESC;
#4. Number of Employees by Industry and Years of Experience
SELECT
    Industry,
    Years_of_Experience,
    COUNT(*) AS Employee_count
FROM salary_survey
GROUP BY Industry, Years_of_Experience
ORDER BY Industry, Years_of_Experience;
#5. Median Salary by Age Range and Gender
WITH ranked AS (
    SELECT
        Age,
        Gender,
        Annual_Salary,
        ROW_NUMBER() OVER (PARTITION BY Age, Gender ORDER BY Annual_Salary) AS rn,
        COUNT(*) OVER (PARTITION BY Age, Gender) AS total_count
    FROM salary_survey
)
SELECT
    Age,
    Gender,
    ROUND(AVG(Annual_Salary), 2) AS median_salary
FROM ranked
WHERE rn IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))
GROUP BY Age, Gender
ORDER BY Age, Gender;
#6. Top Salary in Each Country
SELECT s1.Country,
       s1.Job_Title,
       s1.Annual_Salary
FROM salary_survey s1
JOIN (
    SELECT Country, MAX(Annual_Salary) AS max_salary
    FROM salary_survey
    GROUP BY Country
) s2
    ON s1.Country = s2.Country
    AND s1.Annual_Salary = s2.max_salary
ORDER BY s1.Country;
#7. Average Salary by City and Industry
SELECT
    City,
    Industry,
    ROUND(AVG(Annual_Salary), 2) AS avg_salary
FROM salary_survey
GROUP BY City, Industry
ORDER BY City, Industry;
#8. Percentage of Employees with Additional Monetary Compensation by Gender
SELECT
    Gender,
    ROUND(
        100.0 * SUM(CASE WHEN Additional_Compensation > 0 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS percentage_with_comp
FROM salary_survey
GROUP BY Gender
ORDER BY percentage_with_comp DESC;
#9. Total Compensation by Job Title and Years of Experience
SELECT
    Job_Title,
    Years_of_Experience,
    SUM(Annual_Salary + COALESCE(Additional_Compensation, 0)) AS total_compensation
FROM salary_survey
GROUP BY Job_Title, Years_of_Experience
ORDER BY total_compensation DESC;
#10. Average Salary by Industry, Gender, and Education Level
SELECT
    Industry,
    Gender,
    Level_of_Education,
    ROUND(AVG(Annual_Salary), 2) AS avg_salary
FROM salary_survey
GROUP BY Industry, Gender, Level_of_Education
ORDER BY Industry, Gender, Level_of_Education;

