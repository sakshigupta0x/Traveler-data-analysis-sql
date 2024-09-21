CREATE DATABASE travel;
USE travel;

ALTER TABLE `travel tourist dataset`
RENAME to tourist;

# EDA on tourist table
SELECT  * FROM tourist;
#No of Rows
SELECT COUNT(*) from tourist;

#Checking for duplicates
SELECT COUNT(DISTINCT `traveler name`) from tourist;

SELECT `traveler name`, COUNT(*) FROM tourist
GROUP BY `traveler name`
HAVING COUNT(*)>1;

SELECT * from tourist
WHERE `traveler name` in (SELECT `traveler name` FROM tourist
                           GROUP BY `traveler name`
						   HAVING COUNT(*)>1) 
ORDER BY `traveler name` ;

DESCRIBE tourist;

# Checking distinct entries
SELECT DISTINCT nationality FROM tourist;

#Renaming columns
ALTER TABLE tourist
RENAME COLUMN `Traveler name` TO name ;

ALTER TABLE tourist
RENAME COLUMN `Traveler age` to age;

ALTER TABLE tourist
RENAME COLUMN `Traveler gender` to gender;

ALTER TABLE tourist
RENAME COLUMN `Traveler nationality` to nationality;

ALTER TABLE tourist
RENAME COLUMN `Duration (days)` to duration;

ALTER TABLE tourist
RENAME COLUMN `ï»¿Trip ID` TO ID;

#Changing columns to correct datatype
UPDATE tourist
SET `Start date` = str_to_date(`Start date` , '%m/%d/%Y' );
UPDATE tourist
SET `End date` = str_to_date(`End date` , '%m/%d/%Y' );

#This is a user filled survery based data so there are duplicates values 
SELECT DISTINCT `Transportation Type` FROM Tourist;

UPDATE tourist
SET `Transportation Type` = 'Flight'
WHERE `Transportation Type`= 'Plane' OR `Transportation Type`= 'Airplane';

SELECT DISTINCT nationality FROM Tourist;
SELECT * FROM country_data;

UPDATE Tourist, country_data
SET Tourist.nationality =  country_data.nationality
WHERE Tourist.nationality in (SELECT country from country_data) AND Tourist.nationality=country_data.country ;

UPDATE Tourist
SET Tourist.nationality =  'American'
WHERE Tourist.nationality='USA';

# Some destination column onlu contain city so updating it to include the country based on other entries
UPDATE tourist, (SELECT * FROM tourist) AS temp
SET tourist.destination= temp.destination
WHERE tourist.destination NOT LIKE '%,%' AND  temp.destination LIKE CONCAT('%',tourist.destination ,'%');

#Adding column 
ALTER TABLE tourist
ADD month VARCHAR(9)
AFTER duration;

UPDATE tourist
SET month= MONTHNAME(`Start date`);

ALTER TABLE tourist
ADD destination_country VARCHAR(25)
AFTER destination;

UPDATE tourist
SET destination_country=TRIM(SUBSTRING(Destination,LOCATE(',',Destination)+1));


ALTER TABLE tourist
ADD total_cost INT;

UPDATE tourist
SET total_cost = `Accommodation cost`+`Transportation cost`;

# DELETING Columns
ALTER TABLE tourist
DROP COLUMN `End date`;

ALTER TABLE tourist
DROP COLUMN `Start date`;

ALTER TABLE tourist
DROP COLUMN Destination;

#Summaries
SELECT * from tourist;

SELECT AVG(duration) as Average_duration, MAX(duration) as Highest_duration, MIN(duration) AS Least_Duration FROM tourist;

SELECT AVG(age) as Average_age, MAX(Age) as Highest_Age, MIN(age) AS Minimum_age
From tourist;

SELECT AVG( `Accommodation cost`) as Average_Accommodation_cost, 
 MAX(`Accommodation cost`) as Highest_Accommodation_cost, MIN(`Accommodation cost`) AS Minimum_Accommodation_cost
From tourist;

SELECT AVG( `Transportation cost`) as Average_Transportation_cost, 
 MAX(`Transportation cost`) as Highest_Transportation_cost, MIN(`Transportation cost`) AS Minimum_Transportation_cost
From tourist;

SELECT AVG( `Transportation cost`) as Average_Transportation_cost, 
 MAX(`Transportation cost`) as Highest_Transportation_cost, MIN(`Transportation cost`) AS Minimum_Transportation_cost
From tourist;

SELECT AVG( `Total_cost`) as Average_Total_cost, 
 MAX(`Total_cost`) as Highest_Total_cost, MIN(`Total_cost`) AS Minimum_Total_cost
From tourist;

SELECT destination_country, COUNT(destination_country) as Count
FROM tourist
GROUP BY destination_country
ORDER BY Count DESC;

SELECT month, COUNT(month) as Count
FROM tourist
GROUP BY month
ORDER BY Count DESC;

SELECT gender, COUNT(gender) as Count
FROM tourist
GROUP BY gender
ORDER BY Count DESC;

SELECT nationality, COUNT(nationality) as Count
FROM tourist
GROUP BY nationality
ORDER BY Count DESC;

SELECT `Accommodation type`, COUNT(`Accommodation type`) as Count
FROM tourist
GROUP BY `Accommodation type`
ORDER BY Count DESC;

SELECT COUNT(*)
FROM tourist
GROUP BY nationality
ORDER BY Count DESC;

SELECT  nationality, COUNT(*) as Total , SUM(CASE WHEN gender='male' THEN 1 ELSE 0 END) AS Male,
                           SUM(CASE WHEN gender='female' THEN 1 ELSE 0 END) AS Female
FROM tourist
GROUP BY nationality
ORDER BY Total DESC;

#Looking at Data of Indian TRavellers
SELECT * FROM tourist
WHERE nationality="Indian";

SELECT * FROM tourist
WHERE nationality="American";


#Month wise Dat
SELECT  Month, ROUND(avg(total_cost),0) as Average_Cost, count(month)  AS Number_of_Trips, ROUND(AVG(Duration),1) as Average_Days,
 MAX(`Accommodation Type`) as Preferred_Accomodation, MAX(`Transportation Type`) AS Preferred_Transport
FROM tourist
GROUP BY month
ORDER BY Number_of_Trips DESC;

#Destination wise Data
SELECT  destination_country, ROUND(avg(total_cost),0) as Average_Cost, count(month)  AS Number_of_Trips, ROUND(AVG(Duration),1) as Average_Days,
MAX(`Accommodation Type`) as Preferred_Accomodation, MAX(`Transportation Type`) AS Preferred_Transport, MAX(month) AS Busiest_Month
FROM tourist
GROUP BY destination_country
ORDER BY Number_of_Trips DESC;

# transport related DATA
SELECT  `Transportation Type`, count(month)  AS Number_of_Trips,ROUND(avg(`Transportation Cost`),0) as Average_Transport_Cost, 
MAX(`Accommodation Type`) as Preferred_Accomodation,  MAX(month) AS Busiest_Month
FROM tourist
GROUP BY `Transportation Type`
ORDER BY Number_of_Trips DESC;




