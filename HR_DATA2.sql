SELECT * FROM tola_db.hr_data;
TRUNCATE hr_data;

LOAD DATA INFILE "\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\HR Data_.csv"
INTO TABLE hr_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

/*SQL Practice Question
 QUESTION 1
Using the HR Management data, your company requires you to delve into data analysis using SQL to 
uncover insights for HR department and visualize the results using Power BI in other to make an 
informed decisions and strategic workforce planning.
NOTE: Clean data if required
1. What is the gender breakdown in the Company?
2. How many employees work remotely for each department?
3. What is the distribution of employees who work remotely and HQ
4. What is the race distribution in the Company?
5. What is the distribution of employee across different states?
6. What is the number of employees whose employment has been terminated
7. Who is/are the longest serving employee in the organization.
8. Return the terminated employees by their race
9. What is the age distribution in the Company?
10. How have employee hire counts varied over time?
11. What is the tenure distribution for each department?
12. What is the average length of employment in the company?
13. Which department has the highest turnover rate?
SHOW GLOBAL VARIABLES LIKE 'local_infile';*/


SELECT * FROM tola_db.hr_data;
-- Question 1
-- What is the gender breakdown in the Company?

SELECT COUNT(DISTINCT gender) FROM hr_data;

-- Question 2
-- 2. How many employees work remotely for each department?
ALTER TABLE hr_data
ADD COLUMN Full_name TEXT AFTER last_name;
SET SQL_SAFE_UPDATES=0;
UPDATE hr_data
SET Full_name=  CONCAT(first_name, " ", last_name);

SELECT department, COUNT(id) Total_employee FROM hr_data
WHERE location = "Remote"
GROUP BY department,location
ORDER BY Total_employee DESC;

-- Question 3
-- 3. What is the distribution of employees who work remotely and HQ
SELECT location, COUNT(id) Total_employee FROM hr_data
WHERE location IN("Remote" AND "Headquarters")
GROUP BY location;

-- Question 4
-- 4. What is the race distribution in the Company?
SELECT race, COUNT(id) Total_employee FROM hr_data
GROUP BY race
ORDER BY Total_employee;

-- Question 5
-- 5. What is the distribution of employee across different states?
SELECT location_state, COUNT(id) Total_employee FROM hr_data
GROUP BY location_state;

-- Question 6
-- 6. What is the number of employees whose employment has been terminated
SELECT* FROM hr_data;

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

-- Question 7
-- 7. Who is/are the longest serving employee in the organization.

SELECT Full_name,New_hiredate,
ROUND(DATEDIFF(CURDATE(),New_hiredate)/365,2) Longest_serving_employee
FROM hr_data
ORDER BY New_hiredate ASC
LIMIT 10;

-- Question 8
-- 8. Return the terminated employees by their race
SELECT Full_name, New_hiredate, race, (SELECT COUNT(DATE(termdate))
FROM hr_data 
WHERE DATE(termdate) < current_date()) AS countof_employee_terminated,
DATE(termdate) Termination_Date
FROM hr_data
WHERE DATE(termdate) < current_date();

-- Question 9
-- 9. What is the age distribution in the Company?
SELECT * FROM hr_data;
SELECT* FROM hr_data;
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


-- Question 10
-- 10. How have employee hire counts varied over time?
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

-- Question 11
-- 11. What is the tenure distribution for each department?

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

-- Question 12
-- 12. What is the average length of employment in the company?
SELECT AVG(CASE WHEN YEAR(termdate)< YEAR(CURRENT_DATE())
THEN ROUND(DATEDIFF(termdate, New_hiredate)/365,0)
ELSE ROUND(DATEDIFF(CURRENT_DATE, New_hiredate)/36,0)
END) AS Average_length_of_employement,
(SELECT SUM(CASE WHEN YEAR(termdate)< YEAR(CURRENT_DATE())
THEN ROUND(DATEDIFF(termdate, New_hiredate)/365, 0) END)
FROM hr_data) AS Summation_of_lenght_of_employement FROM hr_data;

