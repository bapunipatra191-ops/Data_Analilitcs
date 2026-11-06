-- =====================================================
-- E-COMMERCE DATA ANALYTICS PROJECT
-- Database: Brazilian E-Commerce (Olist)
-- Tool: MySQL Workbench
-- =====================================================


-- SECTION 1: DATABASE SELECTION
-- Select the E-Commerce project database

USE ecommerce_db;


-- SECTION 2: PREVIEW ORDERS
-- Display the first 10 records from the orders table

SELECT *
FROM orders_clean
LIMIT 10;


-- SECTION 3: TOTAL ORDERS
-- Calculate the total number of orders in the dataset

SELECT
    COUNT(*) AS total_orders
FROM orders_clean;


-- SECTION 4: ORDER STATUS ANALYSIS
-- Count orders according to their status
-- Example: delivered, shipped, canceled, etc.

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders_clean
GROUP BY order_status
ORDER BY total_orders DESC;
-- =====================================================
-- END OF SECTIONS 1 TO 4
-- =====================================================
-- =====================================================
-- SECTION 5: REVENUE ANALYSIS
-- =====================================================

-- 5.1: TOTAL PRODUCT REVENUE
-- Calculate total revenue from product prices

SELECT
    ROUND(SUM(price), 2) AS total_product_revenue
FROM order_items_clean;


-- 5.2: TOTAL FREIGHT VALUE
-- Calculate total shipping charges

SELECT
    ROUND(SUM(freight_value), 2) AS total_freight
FROM order_items_clean;


-- 5.3: TOTAL PRODUCTS SOLD
-- Count the total number of order items

SELECT
    COUNT(*) AS total_items_sold
FROM order_items_clean;


-- 5.4: AVERAGE PRODUCT PRICE
-- Calculate average product selling price

SELECT
    ROUND(AVG(price), 2) AS average_product_price
FROM order_items_clean;


-- 5.5: HIGHEST PRODUCT PRICE
-- Find the highest product selling price

SELECT
    MAX(price) AS highest_product_price
FROM order_items_clean;


-- 5.6: LOWEST PRODUCT PRICE
-- Find the lowest product selling price

SELECT
    MIN(price) AS lowest_product_price
FROM order_items_clean;

-- =====================================================
-- SECTION 6: MONTHLY REVENUE ANALYSIS
-- =====================================================

-- 6.1: MONTHLY REVENUE
-- Calculate product revenue month by month

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS revenue_month,
    ROUND(SUM(oi.price), 2) AS monthly_revenue
FROM orders_clean o
JOIN order_items_clean oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY revenue_month;


-- 6.2: YEARLY REVENUE
-- Calculate product revenue year by year

SELECT
    YEAR(o.order_purchase_timestamp) AS revenue_year,
    ROUND(SUM(oi.price), 2) AS yearly_revenue
FROM orders_clean o
JOIN order_items_clean oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY revenue_year;


-- 6.3: HIGHEST REVENUE MONTH
-- Find the month with the highest product revenue

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS revenue_month,
    ROUND(SUM(oi.price), 2) AS monthly_revenue
FROM orders_clean o
JOIN order_items_clean oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY monthly_revenue DESC
LIMIT 1;


-- =====================================================
-- END OF SECTION 6
-- =====================================================

-- =====================================================
-- SECTION 7: STATE-WISE REVENUE ANALYSIS
-- =====================================================

-- 7.1: TOTAL REVENUE BY CUSTOMER STATE
-- Identify which states generate the highest revenue

SELECT
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders_clean o
JOIN order_items_clean oi
    ON o.order_id = oi.order_id
JOIN customers_clean c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;


-- 7.2: TOP 5 REVENUE-GENERATING STATES
-- Find the top five states by product revenue

SELECT
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders_clean o
JOIN order_items_clean oi
    ON o.order_id = oi.order_id
JOIN customers_clean c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 5;


-- 7.3: NUMBER OF CUSTOMERS BY STATE
-- Count unique customers in each state

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers_clean
GROUP BY customer_state
ORDER BY total_customers DESC;


-- =====================================================
-- END OF SECTION 7
-- =====================================================
-- =====================================================
-- SECTION 8: PAYMENT ANALYSIS
-- =====================================================

-- 8.1: PAYMENT METHOD ANALYSIS
-- Count transactions by payment type

SELECT
    payment_type,
    COUNT(*) AS total_transactions
FROM payments_clean
GROUP BY payment_type
ORDER BY total_transactions DESC;


-- 8.2: TOTAL PAYMENT VALUE BY PAYMENT TYPE
-- Calculate total payment amount for each method

SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments_clean
GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- 8.3: AVERAGE PAYMENT VALUE
-- Calculate average payment amount

SELECT
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments_clean;


-- 8.4: INSTALLMENT ANALYSIS
-- Find the average number of installments by payment type

SELECT
    payment_type,
    ROUND(AVG(payment_installments), 2) AS average_installments
FROM payments_clean
GROUP BY payment_type
ORDER BY average_installments DESC;


-- 8.5: PAYMENT TYPE TRANSACTION SHARE
-- Calculate percentage share of each payment type

SELECT
    payment_type,
    COUNT(*) AS total_transactions,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM payments_clean),
        2
    ) AS transaction_percentage
FROM payments_clean
GROUP BY payment_type
ORDER BY transaction_percentage DESC;


-- =====================================================
-- END OF SECTION 8
-- =====================================================

-- =====================================================
-- SECTION 9: PRODUCT CATEGORY ANALYSIS
-- =====================================================

-- 9.1: TOP 10 PRODUCT CATEGORIES BY REVENUE

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items_clean oi
JOIN products_clean p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;


-- 9.2: TOP 10 PRODUCT CATEGORIES BY SALES VOLUME

SELECT
    p.product_category_name,
    COUNT(*) AS total_items_sold
FROM order_items_clean oi
JOIN products_clean p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_items_sold DESC
LIMIT 10;


-- 9.3: AVERAGE PRODUCT PRICE BY CATEGORY

SELECT
    p.product_category_name,
    ROUND(AVG(oi.price), 2) AS average_price
FROM order_items_clean oi
JOIN products_clean p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY average_price DESC
LIMIT 10;


-- =====================================================
-- END OF SECTION 9
-- =====================================================


-- =====================================================
-- SECTION 10: CUSTOMER ANALYSIS
-- =====================================================

-- 10.1: TOTAL UNIQUE CUSTOMERS

SELECT
    COUNT(DISTINCT customer_unique_id) AS total_unique_customers
FROM customers_clean;


-- 10.2: TOP 10 CITIES BY CUSTOMER COUNT

SELECT
    customer_city,
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers_clean
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 10;


-- 10.3: REPEAT CUSTOMERS

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        c.customer_unique_id
    FROM orders_clean o
    JOIN customers_clean c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id) > 1
) AS customer_orders;


-- 10.4: AVERAGE ORDERS PER CUSTOMER

SELECT
    ROUND(
        COUNT(DISTINCT o.order_id) /
        COUNT(DISTINCT c.customer_unique_id),
        2
    ) AS average_orders_per_customer
FROM orders_clean o
JOIN customers_clean c
    ON o.customer_id = c.customer_id;


-- =====================================================
-- END OF SECTION 10
-- =====================================================

-- =====================================================
-- SECTION 11: CUSTOMER REVIEW ANALYSIS
-- =====================================================

-- 11.1: AVERAGE REVIEW SCORE

SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM reviews_clean;


-- 11.2: REVIEW SCORE DISTRIBUTION

SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM reviews_clean
GROUP BY review_score
ORDER BY review_score DESC;


-- 11.3: REVIEW SCORE PERCENTAGE

SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM reviews_clean),
        2
    ) AS review_percentage
FROM reviews_clean
GROUP BY review_score
ORDER BY review_score DESC;


-- 11.4: LOW-RATING REVIEWS

SELECT
    COUNT(*) AS low_rating_reviews
FROM reviews_clean
WHERE review_score <= 2;


-- 11.5: HIGH-RATING REVIEWS

SELECT
    COUNT(*) AS high_rating_reviews
FROM reviews_clean
WHERE review_score >= 4;


-- =====================================================
-- END OF SECTION 11
-- =====================================================

-- =====================================================
-- SECTION 12: SELLER ANALYSIS
-- =====================================================

-- 12.1: TOTAL NUMBER OF SELLERS

SELECT
    COUNT(DISTINCT seller_id) AS total_sellers
FROM sellers_clean;


-- 12.2: TOP 10 SELLER STATES

SELECT
    seller_state,
    COUNT(DISTINCT seller_id) AS total_sellers
FROM sellers_clean
GROUP BY seller_state
ORDER BY total_sellers DESC
LIMIT 10;


-- 12.3: TOP 10 SELLERS BY PRODUCT REVENUE

SELECT
    oi.seller_id,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items_clean oi
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 10;


-- 12.4: AVERAGE SELLER REVENUE

SELECT
    ROUND(AVG(seller_revenue), 2) AS average_seller_revenue
FROM (
    SELECT
        seller_id,
        SUM(price) AS seller_revenue
    FROM order_items_clean
    GROUP BY seller_id
) AS seller_summary;


-- =====================================================
-- END OF SECTION 12
-- =====================================================

-- =====================================================
-- SECTION 13: DELIVERY PERFORMANCE ANALYSIS
-- =====================================================

-- 13.1: AVERAGE DELIVERY TIME IN DAYS

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ), 2
    ) AS average_delivery_days
FROM orders_clean
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- 13.2: FASTEST DELIVERY TIME

SELECT
    MIN(
        DATEDIFF(
            order_delivered_customer_date,
            order_purchase_timestamp
        )
    ) AS fastest_delivery_days
FROM orders_clean
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- 13.3: SLOWEST DELIVERY TIME

SELECT
    MAX(
        DATEDIFF(
            order_delivered_customer_date,
            order_purchase_timestamp
        )
    ) AS slowest_delivery_days
FROM orders_clean
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- 13.4: DELIVERY TIME BY CUSTOMER STATE

SELECT
    c.customer_state,
    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ), 2
    ) AS average_delivery_days
FROM orders_clean o
JOIN customers_clean c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY average_delivery_days DESC;


-- =====================================================
-- END OF SECTION 13
-- =====================================================

-- =====================================================
-- SECTION 14: ORDER CANCELLATION ANALYSIS
-- =====================================================

-- 14.1: TOTAL CANCELLED ORDERS

SELECT
    COUNT(*) AS total_cancelled_orders
FROM orders_clean
WHERE order_status = 'canceled';


-- 14.2: CANCELLATION PERCENTAGE

SELECT
    ROUND(
        COUNT(CASE WHEN order_status = 'canceled' THEN 1 END)
        * 100.0 / COUNT(*),
        2
    ) AS cancellation_percentage
FROM orders_clean;


-- 14.3: CANCELLED ORDERS BY MONTH

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(*) AS cancelled_orders
FROM orders_clean
WHERE order_status = 'canceled'
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;


-- 14.4: CANCELLED ORDERS BY CUSTOMER STATE

SELECT
    c.customer_state,
    COUNT(*) AS cancelled_orders
FROM orders_clean o
JOIN customers_clean c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'canceled'
GROUP BY c.customer_state
ORDER BY cancelled_orders DESC;


-- =====================================================
-- END OF SECTION 14
-- =====================================================


-- =====================================================
-- SECTION 15: ADVANCED BUSINESS ANALYSIS
-- =====================================================

-- 15.1: MONTHLY ORDER GROWTH

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(*) AS total_orders
FROM orders_clean
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;


-- 15.2: TOP 10 CUSTOMERS BY ORDER COUNT

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders_clean o
JOIN customers_clean c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC
LIMIT 10;


-- 15.3: REVENUE PER ORDER

SELECT
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT oi.order_id),
        2
    ) AS average_revenue_per_order
FROM order_items_clean oi
JOIN orders_clean o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';


-- 15.4: TOP 10 ORDERS BY PRODUCT VALUE

SELECT
    order_id,
    ROUND(SUM(price), 2) AS order_product_value
FROM order_items_clean
GROUP BY order_id
ORDER BY order_product_value DESC
LIMIT 10;


-- 15.5: FREIGHT VS PRODUCT VALUE

SELECT
    ROUND(SUM(price), 2) AS total_product_value,
    ROUND(SUM(freight_value), 2) AS total_freight_value,
    ROUND(
        SUM(freight_value) * 100.0 / SUM(price),
        2
    ) AS freight_percentage
FROM order_items_clean;


-- =====================================================
-- END OF SECTION 15
-- =====================================================

-- =====================================================
-- SECTION 16: ADVANCED SQL - CASE WHEN
-- =====================================================

-- 16.1: CLASSIFY ORDERS BY STATUS

SELECT
    order_id,
    order_status,
    CASE
        WHEN order_status = 'delivered' THEN 'Successful'
        WHEN order_status = 'canceled' THEN 'Cancelled'
        WHEN order_status = 'shipped' THEN 'In Transit'
        ELSE 'Other Status'
    END AS order_category
FROM orders_clean
LIMIT 20;


-- 16.2: CLASSIFY PRODUCTS BY PRICE

SELECT
    order_id,
    price,
    CASE
        WHEN price >= 500 THEN 'High Value'
        WHEN price >= 100 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS price_category
FROM order_items_clean
LIMIT 20;


-- 16.3: CUSTOMER REVIEW CLASSIFICATION

SELECT
    review_score,
    CASE
        WHEN review_score >= 4 THEN 'Positive'
        WHEN review_score = 3 THEN 'Neutral'
        ELSE 'Negative'
    END AS review_category,
    COUNT(*) AS total_reviews
FROM reviews_clean
GROUP BY
    review_score,
    review_category
ORDER BY review_score DESC;


-- =====================================================
-- END OF SECTION 16
-- =====================================================

-- =====================================================
-- SECTION 17: SUBQUERY ANALYSIS
-- =====================================================

-- 17.1: PRODUCTS ABOVE AVERAGE PRICE

SELECT
    order_id,
    price
FROM order_items_clean
WHERE price > (
    SELECT AVG(price)
    FROM order_items_clean
)
ORDER BY price DESC
LIMIT 20;


-- 17.2: STATES ABOVE AVERAGE REVENUE

SELECT
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders_clean o
JOIN customers_clean c
    ON o.customer_id = c.customer_id
JOIN order_items_clean oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
HAVING SUM(oi.price) > (
    SELECT AVG(state_revenue)
    FROM (
        SELECT
            c2.customer_state,
            SUM(oi2.price) AS state_revenue
        FROM orders_clean o2
        JOIN customers_clean c2
            ON o2.customer_id = c2.customer_id
        JOIN order_items_clean oi2
            ON o2.order_id = oi2.order_id
        WHERE o2.order_status = 'delivered'
        GROUP BY c2.customer_state
    ) AS state_summary
)
ORDER BY total_revenue DESC;


-- =====================================================
-- END OF SECTION 17
-- =====================================================

-- =====================================================
-- SECTION 18: WINDOW FUNCTIONS
-- =====================================================

-- 18.1: RANK TOP 10 PRODUCT CATEGORIES

SELECT
    product_category_name,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM (
    SELECT
        p.product_category_name,
        SUM(oi.price) AS total_revenue
    FROM order_items_clean oi
    JOIN products_clean p
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
) AS category_revenue
LIMIT 10;


-- 18.2: RANK CUSTOMERS BY ORDER COUNT

SELECT
    customer_unique_id,
    total_orders,
    DENSE_RANK() OVER (
        ORDER BY total_orders DESC
    ) AS customer_rank
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders_clean o
    JOIN customers_clean c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
) AS customer_summary
LIMIT 20;


-- =====================================================
-- END OF SECTION 18
-- =====================================================

-- =====================================================
-- SECTION 19: CTE ANALYSIS
-- =====================================================

-- 19.1: MONTHLY REVENUE USING CTE

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS revenue_month,
        SUM(oi.price) AS monthly_revenue
    FROM orders_clean o
    JOIN order_items_clean oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT
    revenue_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue
FROM monthly_sales
ORDER BY revenue_month;


-- =====================================================
-- END OF SECTION 19
-- =====================================================


-- =====================================================
-- SECTION 20: FINAL BUSINESS KPI SUMMARY
-- =====================================================

SELECT
    (SELECT COUNT(*) FROM orders_clean)
        AS total_orders,

    (SELECT COUNT(DISTINCT customer_unique_id)
     FROM customers_clean)
        AS total_customers,

    (SELECT ROUND(SUM(price), 2)
     FROM order_items_clean)
        AS total_product_value,

    (SELECT ROUND(SUM(payment_value), 2)
     FROM payments_clean)
        AS total_payment_value,

    (SELECT COUNT(*)
     FROM orders_clean
     WHERE order_status = 'canceled')
        AS cancelled_orders;


-- =====================================================
-- END OF SQL PROJECT
-- =====================================================




