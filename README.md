# HR Data Employee Reduction Analysis

## Overview
HR is a department that deals with employees informations accross other departments and sector.

Aim: The aim of this analysis is to delve into dataset using SQL to 
uncover insights for HR department and visualize the results using Power BI in other to make an 
informed decisions and strategic workforce planning.

### Tools.

- SQL - For data cleaning and uncovering inisghts.
- Power BI - For Visualization.
- Power BI- Data Modelling

### Tasks Perfomance through the entire workflow.
- Data Cleaning and Inspection
- Building of Relational Model.
- Writing of SQL Script for uncovering insights.
- Desighning an interactive dashboard.
 
### Exploratory Data Analysis
1.To see the gender breakdown in the Company?

 ``` sql
SELECT COUNT(DISTINCT gender) FROM hr_data;
```
2. To see how many employees work remotely for each department?
``` sql
ALTER TABLE hr_data
ADD COLUMN Full_name TEXT AFTER last_name;
SET SQL_SAFE_UPDATES=0;
UPDATE hr_data
SET Full_name=  CONCAT(first_name, " ", last_name);

SELECT department, COUNT(id) Total_employee FROM hr_data
WHERE location = "Remote"
GROUP BY department,location
ORDER BY Total_employee DESC;
```
 3. What is the distribution of employees who work remotely and HQ?
``` sql
SELECT location, COUNT(id) Total_employee FROM hr_data
WHERE location IN("Remote" AND "Headquarters")
GROUP BY location;
```
4. What is the race distribution in the Company?
``` sql
SELECT race, COUNT(id) Total_employee FROM hr_data
GROUP BY race
ORDER BY Total_employee;
```
 5. What is the distribution of employee across different states?
``` sql
SELECT location_state, COUNT(id) Total_employee FROM hr_data
GROUP BY location_state;
```
 6. What is the number of employees whose employment has been terminated?
``` sql
ALTER TABLE hr_data
ADD COLUMN New_hiredate DATE AFTER hire_date;
SET SQL_SAFE_UPDATES=0;
UPDATE hr_data
SET New_hiredate=CASE
WHEN hire_date LIKE "%/%/%"
THEN STR_TO_DATE(hire_date,"%m/%d/%Y")
ELSE STR_TO_DATE(hire_date, "%m-%d-%Y")
END;

SELECT New_hiredate, (SELECT COUNT(DATE(termdate))
FROM hr_data 
WHERE DATE(termdate) < current_date()) AS countof_employee_terminated,
DATE(termdate) Termination_Date
FROM hr_data
WHERE DATE(termdate) < current_date();
```
 7. Who is/are the longest serving employee in the organization?

``` sql
SELECT Full_name,New_hiredate,
ROUND(DATEDIFF(CURDATE(),New_hiredate)/365,2) Longest_serving_employee
FROM hr_data
ORDER BY New_hiredate ASC
LIMIT 10;
```
 8. To eturn the terminated employees by their race
``` sql
SELECT Full_name, New_hiredate, race, (SELECT COUNT(DATE(termdate))
FROM hr_data 
WHERE DATE(termdate) < current_date()) AS countof_employee_terminated,
DATE(termdate) Termination_Date
FROM hr_data
WHERE DATE(termdate) < current_date();
``` 
 9. What is the age distribution in the Company?
``` sql
SELECT * FROM hr_data;
SET SQL_SAFE_UPDATES = 0;
UPDATE hr_data
SET birthdate = STR_TO_DATE(birthdate, "%m/%d/%Y");
SELECT birthdate, COUNT(id) Total_employee FROM hr_data
GROUP BY birthdate
ORDER BY birthdate ASC;

SET SQL_SAFE_UPDATES=0;
UPDATE hr_data SET birthdate = REPLACE(birthdate, "_","-");
ALTER TABLE hr_data
ADD COLUMN Format_birthdate DATE AFTER birthdate; 

UPDATE hr_data SET Format_birthdate= str_to_date(birthdate, "%m/%d/%Y");
UPDATE hr_data SET Format_birthdate = STR_TO_DATE(birthdate, "%m-%d-%Y");
UPDATE hr_data SET Format_birthdate= DATE_SUB(Format_birthdate, INTERVAL 100 YEAR)
WHERE Format_birthdate > CURDATE();

UPDATE hr_data SET AGE=(SELECT ROUND(DATEDIFF(CURDATE(), birthdate)/365,0));
SELECT* FROM hr_data;
SELECT id,first_name,last_name,birthdate,AGE,
CASE WHEN AGE BETWEEN 12 AND 27 THEN "12 - 27"
 WHEN AGE BETWEEN 28 AND 43 THEN "28 - 43"
  WHEN AGE BETWEEN 44 AND 59 THEN "44 - 59"
  ELSE "AGE GROUP ABOVE 59"
  END AS AGE_GROUP
  FROM hr_data;
```

 10. How has employee hire counts varied over time?
``` sql
SET SQL_SAFE_UPDATES = 0;
UPDATE hr_data
SET hire_date = STR_TO_DATE(hire_date, "%m/%d/%Y");

SELECT hire_date, COUNT(id) Total_employee FROM hr_data
GROUP BY hire_date
ORDER BY Total_employee DESC;
SELECT
CASE 
WHEN YEAR (New_hiredate) BETWEEN 2000 AND 2005 THEN "2000 -2005"
WHEN YEAR (New_hiredate) BETWEEN 2006 AND 2010 THEN "2006 -2010"
WHEN YEAR (New_hiredate) BETWEEN 2011 AND 2015 THEN "2011 -2015"
WHEN YEAR (New_hiredate) BETWEEN 2016 AND 2020 THEN "2016 -2020"
ELSE "YEAR ABOVE 2020"
END AS YEAR_GROUP, COUNT(id)
FROM hr_data
GROUP BY YEAR_GROUP
ORDER BY YEAR_GROUP DESC;
``` 
 11. What is the tenure distribution for each department?
``` sql
SELECT department, New_hiredate, DATE(termdate),
CASE WHEN YEAR(termdate) < YEAR(CURDATE()) THEN ROUND(DATEDIFF(termdate, New_hiredate)/365,0)
ELSE ROUND(DATEDIFF(CURDATE(), New_hiredate)/365,0)
END AS TENURE
FROM hr_data
ORDER BY TENURE DESC;

SELECT department,
CASE WHEN YEAR(termdate) < YEAR(CURDATE()) THEN ROUND(DATEDIFF(termdate, New_hiredate)/365,0)
ELSE ROUND(DATEDIFF(CURDATE(), New_hiredate)/365,0)
END AS TENURE
FROM hr_data
ORDER BY TENURE DESC;
```

 12. What is the average length of employment in the company?
``` sql
SELECT AVG(CASE WHEN YEAR(termdate)< YEAR(CURRENT_DATE())
THEN ROUND(DATEDIFF(termdate, New_hiredate)/365,0)
ELSE ROUND(DATEDIFF(CURRENT_DATE, New_hiredate)/36,0)
END) AS Average_length_of_employement,
(SELECT SUM(CASE WHEN YEAR(termdate)< YEAR(CURRENT_DATE())
THEN ROUND(DATEDIFF(termdate, New_hiredate)/365, 0) END)
FROM hr_data) AS Summation_of_lenght_of_employement FROM hr_data;
```


 
