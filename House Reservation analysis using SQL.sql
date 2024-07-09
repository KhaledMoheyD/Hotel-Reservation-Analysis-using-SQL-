/*
Project Title: Hotel Reservation Analysis with SQL 

Project Description:
	We will work with a hotel reservation dataset to gain insights into guest preferences, 
	booking trends, and other key factors that impact the hotel's operations. We will use SQL to query and 
	analyze the data, as well as answer specific questions about the dataset. 

Questions to answer: 
	1. What is the total number of reservations in the dataset?  
	2. Which meal plan is the most popular among guests?  
	3. What is the average price per room for reservations involving children?  
	4. How many reservations were made for the year 20XX (replace XX with the desired year)?  
	5. What is the most commonly booked room type?  
	6. How many reservations fall on a weekend (no_of_weekend_nights > 0)?  
	7. What is the highest and lowest lead time for reservations?  
	8. What is the most common market segment type for reservations?  
	9. How many reservations have a booking status of "Confirmed"?  
	10. What is the total number of adults and children across all reservations?  
	11. What is the average number of weekend nights for reservations involving children?  
	12. How many reservations were made in each month of the year? 
	13. What is the average number of nights (both weekend and weekday) spent by guests for each room 
	type?  
	14. For reservations involving children, what is the most common room type, and what is the average 
	price for that room type?  
	15. Find the market segment type that generates the highest average price per room. 
	
	Created By: Khaled Mohey Elden
	
	Creation Date: 25/6/2024
*/

-- First of all, we need to change the data type of the arrival_date to datetime instead of TEXT

CREATE TABLE Hotel_Reservations(
	Booking_ID INTEGER,
    no_of_adults INTEGER,
    no_of_children INTEGER,
    no_of_weekend_nights INTEGER,
    no_of_week_nights INTEGER,
    type_of_meal_plan TEXT,
    room_type_reserved TEXT,
    lead_time INTEGER,
    arrival_date DATE,
    market_segment_type TEXT,
    avg_price_per_room REAL,
    booking_status TEXT
);

INSERT INTO Hotel_Reservations
SELECT 
	Booking_ID ,
    no_of_adults ,
    no_of_children ,
    no_of_weekend_nights ,
    no_of_week_nights ,
    type_of_meal_plan ,
    room_type_reserved ,
    lead_time ,
    arrival_date ,
    market_segment_type ,
    avg_price_per_room ,
    booking_status 
FROM
 Hotel_Reservations_old

DROP TABLE Hotel_Reservations_old
	


-- Q1- What is the total number of reservations in the dataset? 

SELECT 
	COUNT(Booking_ID) AS Total_Reservations
FROM
	Hotel_Reservations;

	
	
	
	
	
	
	
	
-- Q2- Which meal plan is the most popular among guests? 

SELECT
	type_of_meal_plan AS Meal_Plan,
	COUNT(type_of_meal_plan) AS Count_of_Meal_Plan
FROM	
	Hotel_Reservations
GROUP BY
	Meal_Plan
ORDER BY
	Count_of_Meal_Plan DESC;
	

	
-- Q3- What is the average price per room for reservations involving children? 

SELECT 
	ROUND(AVG(avg_price_per_room),2) AS 'Average Price Per Room'
FROM
	Hotel_Reservations
WHERE
	no_of_children <> 0;


	
-- Q4- How many reservations were made for the year 2018?

SELECT
	COUNT(Booking_ID) AS 'Number of Reservations in 2018'
FROM
	Hotel_Reservations
WHERE
	arrival_date LIKE '%2018';
	
	
	
-- Q5- What is the most commonly booked room type? 

SELECT
	room_type_reserved AS Room_Type,
	COUNT(room_type_reserved) AS Number_of_Reservations
FROM
	Hotel_Reservations
GROUP BY
	room_type_reserved
ORDER BY
	Number_of_Reservations DESC;
	

	
-- Q6- How many reservations fall on a weekend (no_of_weekend_nights > 0)?

SELECT
	COUNT(Booking_ID) AS 'Number of Reservations'
FROM
	Hotel_Reservations
WHERE
	no_of_weekend_nights > 0;

	
-- Q7- What is the highest and lowest lead time for reservations?

SELECT
	MAX(lead_time) AS Highest_lead_time,
	MIN(lead_time) AS Lowest_lead_time
FROM
	Hotel_Reservations;
	
	
-- Q8- What is the most common market segment type for reservations?

SELECT
	market_segment_type,
	COUNT(market_segment_type) AS 'Frequency of Type'
FROM
	Hotel_Reservations
GROUP BY
	market_segment_type
ORDER BY
	market_segment_type DESC;

	
	
	
-- Q9- How many reservations have a booking status of "Confirmed"? 

SELECT
	COUNT(booking_status) AS 'Number of Confirmed Booking Status'
FROM 
	Hotel_Reservations
WHERE
	booking_status = 'Not_Canceled';
	
	
	
	
-- Q10- What is the total number of adults and children across all reservations?

SELECT
	SUM(no_of_adults) AS 'Total Number of Adults',
	SUM(no_of_children) AS 'Total Number of Children',
	SUM(no_of_adults + no_of_children) AS 'Total Number of Guests'

FROM
	Hotel_Reservations;
	


-- Q11- What is the average number of weekend nights for reservations involving children?

SELECT
	AVG(no_of_weekend_nights) AS Average_no_of_weekend_nights
FROM
	Hotel_Reservations
WHERE
	no_of_children <> 0;

	
	
	
-- Q12- How many reservations were made in each month of the year?

SELECT
	strftime('%Y',SUBSTR(arrival_date, 7, 4) || '-' || SUBSTR (arrival_date, 4,2) || '-' || SUBSTR(arrival_date, 1,2))AS Year,
	strftime('%m', SUBSTR(arrival_date, 7, 4) || '-' || SUBSTR (arrival_date, 4,2) || '-' || SUBSTR(arrival_date, 1,2))AS Month,
	COUNT(Booking_ID) AS Total_Reservations
FROM
	Hotel_Reservations
	
GROUP BY
	Year, Month
	
	
	
	
	
/* Q13- What is the average number of nights (both weekend and weekday) spent by guests for each room 
	type? */
	
SELECT
	room_type_reserved AS Room_Type,
	ROUND(AVG(no_of_week_nights + no_of_weekend_nights),2) AS Average_Number_of_Nights
FROM
	Hotel_Reservations
GROUP BY
	room_type_reserved;
	

	
	
	
/* Q14- For reservations involving children, what is the most common room type, and what is the average 
	price for that room type? */
	
SELECT
	room_type_reserved AS Room_Type,
	COUNT(room_type_reserved) AS Total_Reservations,
	ROUND(AVG(avg_price_per_room), 2) AS Average_Price
FROM
	Hotel_Reservations
WHERE
	no_of_children > 0 
GROUP BY 
	room_type_reserved
ORDER BY
	Total_Reservations DESC;
	
	
	
	
	
-- Q15- Find the market segment type that generates the highest average price per room.

SELECT
	market_segment_type,
	ROUND(AVG(avg_price_per_room), 2) AS Average_Price_Per_Room
FROM
	Hotel_Reservations
GROUP BY
	market_segment_type
ORDER BY
	Average_Price_Per_Room DESC;
 
 
 
 
 
 
 
 
 
 