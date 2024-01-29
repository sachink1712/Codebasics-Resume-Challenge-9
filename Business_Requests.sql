# To understand the tables
SELECT * FROM dim_campaigns;
SELECT * FROM dim_products;
SELECT * FROM dim_stores;
SELECT * FROM fact_events;

# Business Request 1
# To identify hign-value products that are currently being heavily discounted
SELECT DISTINCT(fev.product_code), dpr.product_name, fev.base_price, fev.promo_type
FROM dim_products AS dpr
JOIN fact_events AS fev
ON dpr.product_code = fev.product_code
WHERE fev.base_price > 500 AND fev.promo_type = "BOGOF";

# Business Request 2
# To assist in optimizing our retail operations
SELECT city, COUNT(store_id) AS "Number_of_Stores"
FROM dim_stores
GROUP BY city
ORDER BY Number_of_Stores DESC;

# To change start_date and end_date to date formate
DELETE FROM dim_campaigns
WHERE campaign_id = 'campaign_id';
ALTER TABLE dim_campaigns
MODIFY COLUMN start_date DATE;
ALTER TABLE dim_campaigns
MODIFY COLUMN end_date DATE;

# Business Request 3
# To help in evaluating the financial impact of our promotion campaigns
SELECT campaign_name, 
SUM(base_price * quantity_sold_before_promo) AS Revenue_before_promo, 
SUM(base_price * quantity_sold_after_promo) AS Revenue_after_promo
from dim_campaigns as dcmp
JOIN fact_events AS fev
ON dcmp.campaign_id = fev.campaign_id
GROUP BY dcmp.campaign_name;

# Business Request 4
# To find category wise success and impact of the diwali campaign in incremental sales
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


# Business Request 5
# To identify the most successful products in terms of incremental revenue
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
    
