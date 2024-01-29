/*
Business Request 2
To assist in optimizing our retail operations
*/
SELECT city, COUNT(store_id) AS "Number_of_Stores"
FROM dim_stores
GROUP BY city
ORDER BY Number_of_Stores DESC;
