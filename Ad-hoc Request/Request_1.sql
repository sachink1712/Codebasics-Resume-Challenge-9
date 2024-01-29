/*
Business Request 1
To identify hign-value products that are currently being heavily discounted
*/
SELECT DISTINCT(fev.product_code), dpr.product_name, fev.base_price, fev.promo_type
FROM dim_products AS dpr
JOIN fact_events AS fev
ON dpr.product_code = fev.product_code
WHERE fev.base_price > 500 AND fev.promo_type = "BOGOF";
