\copy geolocation FROM 'data/olist_geolocation_dataset.csv' DELIMITER ',' CSV HEADER;

\copy customers (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state) FROM 'data/olist_customers_dataset.csv' DELIMITER ',' CSV HEADER;

UPDATE customers c
SET geolocation_lat = g.geolocation_lat,
    geolocation_lng = g.geolocation_lng
FROM geolocation g
WHERE c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;

\copy sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state) FROM 'data/olist_sellers_dataset.csv' DELIMITER ',' CSV HEADER;

UPDATE sellers s
SET geolocation_lat = g.geolocation_lat,
    geolocation_lng = g.geolocation_lng
FROM geolocation g
WHERE s.seller_zip_code_prefix = g.geolocation_zip_code_prefix;

DROP TABLE geolocation;

\copy categories (category_name, category_name_english) FROM 'data/product_category_name_translation.csv' DELIMITER ',' CSV HEADER;

INSERT INTO categories (category_name, category_name_english)
VALUES ('unknown', 'unknown')
ON CONFLICT DO NOTHING;

\copy products_temp FROM 'data/olist_products_dataset.csv' DELIMITER ',' CSV HEADER;

INSERT INTO products
SELECT pt.product_id, COALESCE(c.category_id, (SELECT category_id FROM categories WHERE category_name = 'unknown')), pt.product_name_lenght,
pt.product_description_lenght, pt.product_photos_qty, pt.product_weight_g, pt.product_length_cm, pt.product_height_cm, pt.product_width_cm
FROM products_temp pt
LEFT JOIN categories c ON c.category_name = pt.category_name;

DROP TABLE products_temp;

\copy orders FROM 'data/olist_orders_dataset.csv' DELIMITER ',' CSV HEADER;

CREATE TEMP TABLE order_items_stage (
    order_id varchar,
    order_item_id varchar,
    product_id varchar,
    seller_id varchar,
    shipping_limit_date timestamp,
    price float,
    freight_value float
);

\copy order_items_stage FROM 'data/olist_order_items_dataset.csv' DELIMITER ',' CSV HEADER;

INSERT INTO order_items
SELECT * FROM order_items_stage
WHERE order_id   IN (SELECT order_id   FROM orders)
  AND product_id IN (SELECT product_id FROM products)
  AND seller_id  IN (SELECT seller_id  FROM sellers);

DROP TABLE order_items_stage;

\copy order_payments FROM 'data/olist_order_payments_dataset.csv' DELIMITER ',' CSV HEADER;

CREATE TEMP TABLE order_reviews_stage (
    review_id varchar,
    order_id varchar,
    review_score integer,
    review_comment_title varchar,
    review_comment_message varchar,
    review_creation_date timestamp,
    review_answer_timestamp timestamp
);

\copy order_reviews_stage FROM 'data/olist_order_reviews_dataset.csv' DELIMITER ',' CSV HEADER;

INSERT INTO order_reviews
SELECT * FROM order_reviews_stage
WHERE order_id IN (SELECT order_id FROM orders)
ON CONFLICT (review_id) DO NOTHING;

DROP TABLE order_reviews_stage;
