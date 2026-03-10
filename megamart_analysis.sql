/* =====================================================
   MEGAMART SALES ANALYSIS PROJECT
   Database: megamart_db
   Description: SQL analysis for sales, customers,
   products, and business insights
   ===================================================== */

USE megamart_db;

--------------------------------------------------------
-- DATA QUALITY CHECKS
--------------------------------------------------------

-- 1. Find duplicate customer emails
SELECT email
FROM customers
GROUP BY email
HAVING COUNT(email) > 1;

-- 2. Average product price
SELECT ROUND(AVG(price),2) AS avg_product_price
FROM products;

-- 3. Minimum and Maximum order value per customer
WITH customer_summary AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name,' ',c.last_name) AS customer_name,
        SUM(o.total_amount) AS total_spend,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)

SELECT 
    customer_id,
    customer_name,
    total_spend,
    total_orders,
    total_spend / total_orders AS avg_order_value
FROM customer_summary
ORDER BY avg_order_value DESC;

-- 4. Customer distribution by city
SELECT 
    city,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

--------------------------------------------------------
-- SALES PERFORMANCE ANALYSIS
--------------------------------------------------------

-- TASK 4: Monthly sales performance
-- Track revenue, order count, and average order value

SELECT *,
       revenue / total_orders AS avg_order_value
FROM (
        SELECT 
            DATE_FORMAT(o.order_date,'%Y-%m') AS year_month,
            SUM(o.total_amount) AS revenue,
            COUNT(DISTINCT o.order_id) AS total_orders
        FROM orders o
        JOIN order_items oi
            ON o.order_id = oi.order_id
        WHERE o.order_status = 'Completed'
        GROUP BY DATE_FORMAT(o.order_date,'%Y-%m')
     ) t;

--------------------------------------------------------

-- TASK 5: Top 10 revenue driving cities

SELECT *
FROM (
        SELECT 
            c.city,
            SUM(o.total_amount) AS revenue,
            RANK() OVER(ORDER BY SUM(o.total_amount) DESC) AS city_rank
        FROM orders o
        JOIN order_items oi
            ON o.order_id = oi.order_id
        JOIN customers c
            ON c.customer_id = o.customer_id
        WHERE o.order_status = 'Completed'
        GROUP BY c.city
     ) t
WHERE city_rank <= 10;

--------------------------------------------------------

-- TASK 6: Payment method contribution

SELECT 
    COALESCE(NULLIF(payment_method,''),'Unknown') AS payment_method,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue,
    CONCAT(
        ROUND(
            SUM(total_amount) /
            SUM(SUM(total_amount)) OVER() * 100
        ,2),'%') AS revenue_share
FROM orders
GROUP BY payment_method
ORDER BY total_revenue DESC;

--------------------------------------------------------

-- TASK 7: Order status funnel analysis

SELECT 
    order_status,
    COUNT(order_id) AS total_orders,
    CONCAT(
        ROUND(
            COUNT(order_id) * 100 /
            SUM(COUNT(order_id)) OVER()
        ,2),'%') AS percentage
FROM orders
GROUP BY order_status
ORDER BY percentage DESC;

--------------------------------------------------------

-- TASK 8: Repeat purchase behaviour

SELECT COUNT(*) AS repeat_customers
FROM (
        SELECT 
            customer_id,
            COUNT(order_id) AS total_orders
        FROM orders
        GROUP BY customer_id
        HAVING COUNT(order_id) > 1
     ) t;

--------------------------------------------------------

-- TASK 9: Monthly cohort retention analysis

WITH customer_cohort AS (
        SELECT 
            customer_id,
            DATE_FORMAT(signup_date,'%Y-%m-01') AS cohort_month
        FROM customers
),

customer_activity AS (
        SELECT 
            cc.customer_id,
            cc.cohort_month,
            DATE_FORMAT(o.order_date,'%Y-%m-01') AS order_month,
            TIMESTAMPDIFF(
                MONTH,
                cc.cohort_month,
                DATE_FORMAT(o.order_date,'%Y-%m-01')
            ) AS month_number
        FROM customer_cohort cc
        JOIN orders o
            ON cc.customer_id = o.customer_id
)

SELECT 
    cohort_month,
    month_number,
    COUNT(DISTINCT customer_id) AS retained_customers
FROM customer_activity
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;

--------------------------------------------------------

-- TASK 10: High revenue months

SELECT 
    DATE_FORMAT(order_date,'%Y-%m') AS year_month,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY DATE_FORMAT(order_date,'%Y-%m')
ORDER BY total_sales DESC;

--------------------------------------------------------
-- CUSTOMER INSIGHTS
--------------------------------------------------------

-- TASK 11: Evaluate long term customer revenue

SELECT 
    customer_id,
    total_orders,
    total_spent
FROM vw_customer_clv
ORDER BY total_spent DESC;

--------------------------------------------------------

-- TASK 12: Identify top 100 customers

SELECT 
    customer_id,
    total_orders,
    total_spent
FROM vw_customer_clv
ORDER BY total_spent DESC, total_orders DESC
LIMIT 100;

--------------------------------------------------------

-- TASK 13: RFM customer segmentation

WITH customer_scores AS (

    SELECT 
        customer_name,
        NTILE(5) OVER (ORDER BY COALESCE(recency,999) ASC) AS R,
        NTILE(5) OVER (ORDER BY COALESCE(frequency,0) DESC) AS F,
        NTILE(5) OVER (ORDER BY COALESCE(monetary_value,0) DESC) AS M
    FROM vw_rfm

)

SELECT 
    customer_name,
    R,F,M,

    CASE
        WHEN R>=4 AND F>=4 AND M>=4 THEN 'Champions'
        WHEN R>=3 AND F>=3 THEN 'Loyal Customers'
        WHEN R>=3 AND F<=2 THEN 'Potential Loyalists'
        WHEN R<=2 AND F>=3 THEN 'At Risk'
        WHEN R<=1 AND F<=1 THEN 'Lost Customers'
        ELSE 'Needs Attention'
    END AS segment_label

FROM customer_scores
ORDER BY R DESC, F DESC;

--------------------------------------------------------

-- TASK 14: High churn risk customers

SELECT 
    c.customer_id,
    TIMESTAMPDIFF(
        DAY,
        MAX(o.order_date),
        CURDATE()
    ) AS recency_days
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING recency_days >= 180
    OR MAX(o.order_date) IS NULL;

--------------------------------------------------------

-- TASK 15: Cities with highest average order value

SELECT 
    c.city,
    AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY avg_order_value DESC
LIMIT 10;

--------------------------------------------------------
-- PRODUCT & CATEGORY INSIGHTS
--------------------------------------------------------

-- TASK 16: Top selling products

SELECT
    p.product_name,
    SUM(oi.quantity) AS total_units_sold,
    DENSE_RANK() OVER(
        ORDER BY SUM(oi.quantity) DESC
    ) AS product_rank
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name;

--------------------------------------------------------

-- TASK 17: Category profitability

SELECT 
    p.category,
    SUM(oi.price_at_purchase) AS total_revenue,
    SUM(SUM(oi.price_at_purchase)) OVER() AS overall_revenue,
    ROUND(
        SUM(oi.price_at_purchase) /
        SUM(SUM(oi.price_at_purchase)) OVER() * 100
    ,2) AS revenue_contribution_percent
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category;

--------------------------------------------------------

-- TASK 18: Low performing products (SKUs)

SELECT 
    p.product_id,
    COALESCE(
        SUM(oi.price_at_purchase * oi.quantity),0
    ) AS total_sales,
    COALESCE(
        SUM(oi.quantity),0
    ) AS total_quantity
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id
HAVING COALESCE(SUM(oi.quantity),0) < 10;

--------------------------------------------------------
-- END OF PROJECT
--------------------------------------------------------
