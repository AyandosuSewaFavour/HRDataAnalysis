SELECT * FROM tola_db.hr_data;
TRUNCATE hr_data;

LOAD DATA INFILE "\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\HR Data_.csv"
INTO TABLE hr_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\HR Data_.csv"
INTO TABLE hr_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\HR DATA_.csv"
INTO TABLE hr_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


SHOW VARIABLES LIKE 'secure_file_priv';

SET GLOBAL local_infile =0;

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
SELECT COUNT(DISTINCT gender) FROM hr_data;
SELECT  gender FROM hr_data;

-- Question 2
ALTER TABLE hr_data
ADD COLUMN Full_name TEXT AFTER last_name;
SET SQL_SAFE_UPDATES=0;
UPDATE hr_data
SET Full_name=  CONCAT(first_name, " ", last_name);

SELECT Full_name,department,location FROM hr_data
WHERE location = "Remote";
