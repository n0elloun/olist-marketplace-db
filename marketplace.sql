DROP DATABASE IF EXISTS marketplace; 
 
CREATE DATABASE marketplace 
    WITH ENCODING 'UTF8'; 
 
\connect marketplace 
 
CREATE TEMP TABLE geolocation ( 
    geolocation_zip_code_prefix varchar, 
    geolocation_lat float, 
    geolocation_lng float, 
    geolocation_city varchar, 
    geolocation_state varchar 
); 
 
CREATE TEMP TABLE products_temp ( 
    product_id varchar, 
    category_name varchar, 
    product_name_lenght integer, 
    product_description_lenght integer, 
    product_photos_qty integer, 
    product_weight_g integer, 
    product_length_cm integer, 
    product_height_cm integer, 
    product_width_cm integer 
); 
 
CREATE TABLE customers ( 
    customer_id varchar PRIMARY KEY, 
    customer_unique_id varchar NOT NULL, 
    customer_zip_code_prefix varchar NOT NULL, 
    customer_city varchar, 
    customer_state varchar, 
    geolocation_lat float, 
    geolocation_lng float 
); 
 
CREATE TABLE categories ( 
  category_id SERIAL PRIMARY KEY, 
  category_name varchar NOT NULL, 
  category_name_english varchar 
); 
 
CREATE TABLE products ( 
  product_id varchar PRIMARY KEY, 
  category_id integer NOT NULL, 
  product_name_lenght integer, 
  product_description_lenght integer, 
  product_photos_qty integer CHECK (product_photos_qty >= 0), 
  product_weight_g integer, 
  product_length_cm integer, 
  product_height_cm integer, 
  product_width_cm integer, 
  FOREIGN KEY (category_id) REFERENCES categories (category_id) 
); 
 
CREATE TABLE sellers ( 
  seller_id varchar PRIMARY KEY, 
  seller_zip_code_prefix varchar, 
  seller_city varchar, 
  seller_state varchar, 
  geolocation_lat float, 
  geolocation_lng float 
); 
 
CREATE TABLE orders ( 
    order_id varchar PRIMARY KEY, 
    customer_id varchar NOT NULL, 
    order_status varchar NOT NULL, 
    order_purchase_timestamp timestamp NOT NULL, 
    order_approved_at timestamp, 
    order_delivered_carrier_date timestamp, 
    order_delivered_customer_date timestamp, 
    order_estimated_delivery_date timestamp, 
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id) 
); 
 
CREATE TABLE order_items ( 
    order_id varchar NOT NULL, 
    order_item_id varchar NOT NULL, 
    product_id varchar NOT NULL, 
    seller_id varchar NOT NULL, 
    shipping_limit_date timestamp, 
    price float NOT NULL CHECK (price >= 0), 
    freight_value float CHECK (freight_value >= 0), 
    FOREIGN KEY (order_id) REFERENCES orders (order_id), 
    FOREIGN KEY (product_id) REFERENCES products (product_id), 
    FOREIGN KEY (seller_id) REFERENCES sellers (seller_id), 
    PRIMARY KEY (order_id, order_item_id) 
); 
 
 
CREATE TABLE order_payments ( 
  order_id varchar NOT NULL, 
  payment_sequential integer NOT NULL, 
  payment_type varchar, 
  payment_installments integer CHECK (payment_installments >= 0), 
  payment_value float CHECK (payment_value >= 0), 
  FOREIGN KEY (order_id) REFERENCES orders (order_id), 
  PRIMARY KEY (order_id, payment_sequential) 
); 
 
CREATE TABLE order_reviews ( 
  review_id varchar PRIMARY KEY, 
  order_id varchar NOT NULL, 
  review_score integer CHECK (review_score BETWEEN 1 AND 5), 
  review_comment_title varchar, 
  review_comment_message varchar, 
  review_creation_date timestamp, 
  review_answer_timestamp timestamp, 
  FOREIGN KEY (order_id) REFERENCES orders (order_id) 
); 
 
CREATE INDEX idx_order_items_product_id 
    ON order_items (product_id); 
 
CREATE INDEX idx_order_items_seller_id 
    ON order_items (seller_id); 
 
CREATE INDEX idx_order_payments_order_id 
    ON order_payments (order_id); 
 
CREATE INDEX idx_order_reviews_order_id 
    ON order_reviews (order_id); 
 
CREATE INDEX idx_orders_order_status 
    ON orders (order_status); 
 
CREATE INDEX idx_orders_order_purchase_timestamp 
    ON orders (order_purchase_timestamp);

CREATE INDEX idx_order_reviews_review_score 
    ON order_reviews (review_score); 
 
CREATE INDEX idx_order_payments_payment_type 
    ON order_payments (payment_type); 
 
CREATE INDEX idx_order_items_price 
    ON order_items (price); 
 
CREATE INDEX idx_orders_customer_id 
    ON orders (customer_id); 
 
CREATE INDEX idx_order_items_shipping_limit_date 
    ON order_items (shipping_limit_date); 
 
CREATE INDEX idx_customers_customer_city 
    ON customers (customer_city); 
 
CREATE INDEX idx_sellers_seller_city 
    ON sellers (seller_city);

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
