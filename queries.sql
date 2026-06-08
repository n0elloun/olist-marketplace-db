SELECT customer_id, customer_city, customer_state
FROM customers
WHERE customer_state = 'SP'
ORDER BY customer_city;

SELECT order_id, customer_id, order_status, order_purchase_timestamp
FROM orders
WHERE order_purchase_timestamp > '2017-12-31'
ORDER BY order_purchase_timestamp;

SELECT review_id, order_id, review_score, review_creation_date::date
FROM order_reviews
WHERE review_score BETWEEN 1 AND 3
ORDER BY review_score, review_creation_date;

SELECT order_status, COUNT(order_id) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

SELECT c.category_name_english, COUNT(p.product_id) AS product_count
FROM categories c
LEFT JOIN products p ON p.category_id = c.category_id
GROUP BY c.category_name_english
ORDER BY product_count DESC;

SELECT payment_type, COUNT(*) AS usage_count, ROUND(AVG(payment_value)::numeric, 2) AS avg_value
FROM order_payments
GROUP BY payment_type
ORDER BY usage_count DESC;

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
