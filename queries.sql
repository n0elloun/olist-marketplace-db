SELECT s.seller_id, s.seller_state, ROUND(SUM(oi.price)::numeric, 2) AS total_revenue,
RANK() OVER (PARTITION BY s.seller_state ORDER BY SUM(oi.price) DESC) AS rank_in_state
FROM sellers s
JOIN order_items oi ON oi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_state
ORDER BY s.seller_state, rank_in_state;

SELECT s.seller_id, s.seller_city, s.seller_state, COUNT(DISTINCT oi.order_id) AS order_count,
ROUND(SUM(oi.price)::numeric, 2) AS total_revenue
FROM sellers s
JOIN order_items oi ON oi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_city, s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;
