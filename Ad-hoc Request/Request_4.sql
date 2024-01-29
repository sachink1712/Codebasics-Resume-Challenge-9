/*
Business Request 4
To find category wise success and impact of the diwali campaign in incremental sales
*/
WITH Diwali_sales AS (
	SELECT p.category, SUM(quantity_sold_before_promo) AS sales_before_promo, SUM(quantity_sold_after_promo) AS sales_after_promo
	FROM fact_events AS f
	JOIN dim_products AS p
	ON f.product_code = p.product_code
    WHERE f.campaign_id = "CAMP_DIW_01"
	GROUP BY p.category
    )
SELECT category, (((sales_after_promo - sales_before_promo) / sales_before_promo) * 100) AS ISU_percent,
RANK() OVER (ORDER BY ((sales_after_promo - sales_before_promo) / sales_before_promo) DESC ) AS Rank_order
FROM Diwali_sales
ORDER BY Rank_order;
