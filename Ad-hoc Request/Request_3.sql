/*
Business Request 3
To help in evaluating the financial impact of our promotion campaigns
*/
SELECT campaign_name, 
SUM(base_price * quantity_sold_before_promo) AS Revenue_before_promo, 
SUM(base_price * quantity_sold_after_promo) AS Revenue_after_promo
from dim_campaigns as dcmp
JOIN fact_events AS fev
ON dcmp.campaign_id = fev.campaign_id
GROUP BY dcmp.campaign_name;
