

--Q1.HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?

 select count (distinct [restaurant_name]) AS Number_of_Restaurants
 from [dbo].[Swiggy] 
 where rating > 4.5

 --Q2.WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?


 SELECT TOP 1 city, COUNT(distinct [restaurant_name] ) AS Number_of_Restaurants
FROM [dbo].[Swiggy] 
GROUP BY city
ORDER BY 2 DESC;


--Q3.HOW MANY RESTAURANTS HAVE THE WORD "PIZZA" IN THEIR NAME?

SELECT COUNT(distinct [restaurant_name] ) AS Number_of_Restaurants_With_Pizza
FROM [dbo].[Swiggy] 
WHERE restaurant_name LIKE '%Pizza%';

--Q4.WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?

SELECT TOP 1 cuisine, COUNT(*) AS Cuisine_Count
FROM [dbo].[Swiggy] 
GROUP BY cuisine
ORDER BY COUNT(*) DESC;

--Q5.WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?

SELECT city, AVG(rating) AS avg_rating_citywise
FROM [dbo].[Swiggy] 
GROUP BY city;

--Q6.WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENUCATEGORY FOR EACH RESTAURANT?


WITH RankedItems AS (
    SELECT 
        restaurant_name, 
        item, 
        price,
        RANK() OVER (PARTITION BY restaurant_name ORDER BY price DESC) AS rnk
    FROM [dbo].[Swiggy]
    WHERE menu_category = 'Recommended'
)

SELECT restaurant_name, item, price AS Highest_Price
FROM RankedItems
WHERE rnk = 1;


--Q7.FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE.


SELECT TOP 5 restaurant_name, MAX(cost_per_person) as max_cost
FROM [dbo].[Swiggy]
WHERE cuisine NOT LIKE '%Indian%'
GROUP BY restaurant_name
ORDER BY max_cost DESC;


--Q8.FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL RESTAURANTS TOGETHER.

--1. Using CTE
WITH RestaurantAverage AS (
    SELECT 
        restaurant_name,
        AVG(cost_per_person) AS avg_cost
    FROM [dbo].[Swiggy]
    GROUP BY restaurant_name
)
SELECT restaurant_name, avg_cost
FROM RestaurantAverage
WHERE avg_cost > (
    SELECT AVG(cost_per_person)
    FROM [dbo].[Swiggy]
);

--2. Using Sub-query
SELECT restaurant_name, AVG(cost_per_person) AS avg_cost
FROM [dbo].[Swiggy]
GROUP BY restaurant_name
HAVING AVG(cost_per_person) > (
    SELECT AVG(cost_per_person)
    FROM [dbo].[Swiggy]
);

--Q9.RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARELOCATED IN DIFFERENT CITIES.

select distinct a.restaurant_name,a.city,b.city
from Swiggy a
join
Swiggy b
on a.restaurant_name=b.restaurant_name
and a.city<>b.city


--Q10.WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE'CATEGORY?

SELECT TOP 1 
    restaurant_name,
    COUNT(item) AS cnt
FROM
    Swiggy
WHERE
    menu_category = 'Main Course'
GROUP BY
    restaurant_name
ORDER BY
    cnt DESC;


--Q11.LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME.

SELECT DISTINCT restaurant_name,
       ROUND((COUNT(CASE WHEN [veg_or_non_veg] = 'Veg' THEN 1 END) * 100.0 / COUNT(*)), 2) AS vegetarian_percentage
FROM swiggy
GROUP BY restaurant_name
HAVING ROUND((COUNT(CASE WHEN [veg_or_non_veg] = 'Veg' THEN 1 END) * 100.0 / COUNT(*)), 2) = 100.00
ORDER BY restaurant_name;


--Q12.WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?

SELECT TOP 1 restaurant_name, 
       AVG(price) AS average_price
FROM [dbo].[Swiggy]
GROUP BY restaurant_name
ORDER BY average_price;

--Q13.WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?

SELECT TOP 5 restaurant_name, 
       count(distinct menu_category) AS cnt_menu_category
FROM [dbo].[Swiggy]
GROUP BY restaurant_name
ORDER BY cnt_menu_category desc;


--Q14.WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?

SELECT TOP 1 
    restaurant_name,
    (COUNT(CASE WHEN [veg_or_non_veg] = 'Non-Veg' THEN 1 END) * 100.0 / COUNT(*)) AS nonvegetarian_percentage
FROM swiggy
GROUP BY restaurant_name
ORDER BY nonvegetarian_percentage DESC;
