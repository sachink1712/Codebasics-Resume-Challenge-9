/*
Business Request 5
To identify the most successful products in terms of incremental revenue
*/
WITH Incremental_revenue AS (
	SELECT dp.product_name, dp.category, 
		SUM(base_price * quantity_sold_before_promo) AS Revenue_before_promotion,
		SUM(base_price * quantity_sold_after_promo) AS Revenue_after_promotion
	FROM dim_products AS dp
    JOIN fact_events AS f
    ON dp.product_code = f.product_code
    GROUP BY dp.category, dp.product_name
)
SELECT product_name, category, 
	(((Revenue_after_promotion - Revenue_before_promotion) / Revenue_before_promotion) * 100) AS IS_percent
    FROM Incremental_revenue
    ORDER BY (((Revenue_after_promotion - Revenue_before_promotion) / Revenue_before_promotion) * 100) DESC
    LIMIT 5;
