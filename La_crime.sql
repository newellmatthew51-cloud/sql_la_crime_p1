-- The objective of this short project is to write queries to derive insights into crime in Los Angeles.
-- The dataset can be found on data.lacity.org.
-- Author: Matthew Newell
-- Date of last update:09/28/2025

-- Create Database
DROP DATABASE IF EXISTS sql_la_crime_p1;
CREATE DATABASE sql_la_crime_p1;
USE sql_la_crime_p1;

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
 
 -- Loading our cleaned into la_crime table data from csv
SET GLOBAL local_infile = 'ON';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Crime_Data_Cleaned_Table.csv' INTO TABLE LA_CRIME
FIELDS TERMINATED BY ','  -- delimiter
IGNORE 1 LINES;  -- Ignoring the header row of csv file

-- A Simple query displaying the amount of robberies in specific areas of LA
SELECT Area, Crime, COUNT(*) AS Count  -- Counting the number of rows for each column
FROM LA_crime                          -- Specifying the table
WHERE Crime = 'ROBBERY'                -- Specifying the type of crime
GROUP BY Area                          -- Displaying the crime count by area
ORDER BY Count DESC;

-- A query showing the proportion of crimes committed aginst reported genders
SELECT Victim_Sex, Crime,
	COUNT(*) AS Gender_case_count,  
    -- Counting number of crimes based on reported sex
	SUM(COUNT(*)) OVER (PARTITION BY CRIME) AS Total_crime_type_count,
    -- Summing number of crimes across reported genders to achieve total crime
	ROUND
		(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY Crime), 2)
        AS Percentage_of_crime_type 
        -- Essentiallty dividing Gender_case_count by Total_crime_type_count
        -- to achieve desired proportion
FROM LA_crime
GROUP BY Victim_Sex, Crime;