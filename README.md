LA Crime SQL Project
Project Overview

Project Title: LA Crime Analysis
Database: LA Crime 2020 to Present
https://data.lacity.org/Public-Safety/Crime-Data-from-2020-to-Present/2nrs-mtv8/about_data

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore and analyze crime data.

Project Structure
1. Database and Table Setup

```sql
-- Create Database
DROP DATABASE IF EXISTS sql_la_crime_p1;
CREATE DATABASE sql_la_crime_p1;
USE sql_la_crime_p1;
```

```sql
-- Create Table
DROP TABLE IF EXISTS LA_CRIME;
Create Table LA_Crime
		(
            DR_NO INT PRIMARY KEY,
            Date_Reported DATE,
            Date_Occurred DATE,
            Time_Occurred TIME,
            Area VARCHAR(15),
            Crime VARCHAR(70),
            Victim_Age INT,
            Victim_Sex VARCHAR(1),
            Victim_Descent VARCHAR(1),
            Premise_Description VARCHAR(80),
            Status_Description VARCHAR(15),
            Location VARCHAR(40)
		);
 ```

2. Loading in our cleaned data from csv
```sql
 -- Loading our cleaned, la_crime data from excel into our table
SET GLOBAL local_infile = 'ON';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Crime_Data_Cleaned_Table.csv' INTO TABLE LA_CRIME
FIELDS TERMINATED BY ','  -- delimiter
IGNORE 1 LINES;  -- Ignoring the header row of csv file
```

3. Writing queries to analyze data

```sql
-- A Simple query displaying the amount of robberies in specific areas of LA
SELECT Area, Crime, COUNT(*) AS Count  -- Counting the number of rows for each column
FROM LA_crime                          -- Specifying the table
WHERE Crime = 'ROBBERY'                -- Specifying the type of crime
GROUP BY Area                          -- Displaying the crime count by area
ORDER BY Count DESC;
```

```sql
-- A query showing the proportion of crimes committed aginst reported genders
SELECT Victim_Sex, Crime,
	COUNT(*) AS Gender_case_count,  
    -- Counting number of crimes based on reported sex
	SUM(COUNT(*)) OVER (PARTITION BY CRIME) AS Total_crime_type_count,
    -- Summing number of crimes across genders to achieve total crime
	ROUND
		(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY Crime), 2)
        AS Percentage_of_crime_type 
        -- Essentiallty dividing Gender_case_count by Total_crime_type_count
        -- to achieve desired proportion
FROM LA_crime
GROUP BY Victim_Sex, Crime;
```

Findings
From our first query, we can see that the highest amount of robberies occur at 77th Street and the lowest number of robberies occur at West LA.
From our second query, we can surmise that in Los Angeles, crimes like Arson occur disproportionately against men (47%) when compared to women. Crimes that are sexual in nature, such as Lewd Conduct, occur at a much higher proportion against women (80% for women and 18% for men).

Conclusion
The objective of this project is to demonstrate technical skills often used by data analysts in SQL, such as partitioning, grouping, ordering, where clauses, and count functions. One aspect of this project that deserves more attention is the cleaning and prepartion of data. While I did some basic cleaning function to prepare the data to be imported into MySQL, it deserves more attention for this project. For example, some fields, such as victim_sex, have a significant amount of missing data. I did not want to omit this data as it could potentially skew the results of my analysis, considering some crimes may be less likely for an officer to properly identify a victim's sex. More attention will be given to the issue of missing data as I continue to work on this project.

Author - Matthew Newell
