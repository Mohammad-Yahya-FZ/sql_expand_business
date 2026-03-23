USE magist;
SELECT * FROM orders;
-- How many orders are there in the dataset? 
SELECT COUNT(order_id)  AS total_order FROM orders;

-- Are orders actually delivered?
SELECT order_status,COUNT(*) FROM orders 
GROUP BY order_status;

-- Is Magist having user growth?
SELECT
    YEAR(order_purchase_timestamp) AS year,
    MONTH(order_purchase_timestamp) AS month,
    COUNT(customer_id) AS total_orders
FROM orders
GROUP BY
    YEAR,
    MONTH
ORDER BY
    year,
    month;


-- How many products are there on the products table?
SELECT COUNT(DISTINCT(product_category_name)) FROM products;
SELECT COUNT(DISTINCT(product_id)) FROM products;
-- Which are the categories with the most products?
SELECT  DISTINCT(product_category_name) ,COUNT(*)AS total_product FROM products
GROUP BY product_category_name
ORDER BY total_product DESC;

SELECT 
    product_category_name, 
    COUNT(DISTINCT product_id) AS n_products
FROM
    products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC;

SELECT DISTINCT(product_category_name) ,COUNT(product_id)AS total_product FROM products AS p
LEFT JOIN order_items AS o ON p.product_id=o.product_id 
LEFT JOIN sellers AS s ON o.seller_id=s.seller_id
GROUP BY product_category_name
ORDER BY pro DESC;


-- How many of those products were present in actual transactions? 
SELECT 
    COUNT(DISTINCT product_id) AS n_products
FROM
    order_items;

-- What’s the price for the most expensive and cheapest products?
SELECT 
    MAX(price) AS expensive_product,
    MIN(price) AS chespest_product
FROM
    order_items;
   
   

   SELECT 
    DISTINCT(product_category_name),
    (SELECT 
            MAX(price)
        FROM
            order_items),(SELECT 
		MIN(price)
        FROM
            order_items)
FROM
    products AS p
        INNER JOIN
    order_items AS o ON o.product_id = p.product_id ;
    
  --  What are the highest and lowest payment values?    
    SELECT 
    MAX(payment_value)AS maximum_value
        ,MIN(payment_value)AS minimum_value
FROM
    order_payments
    WHERE payment_value >= '1';
    
    -- What categories of tech products does Magist have?
    SELECT DISTINCT(product_category_name_english) FROM product_category_name_translation
    GROUP BY product_category_name_english;
    
    -- business ralated questions.
    -- What categories of tech products does Magist have?
    SELECT DISTINCT(product_category_name_english)
FROM product_category_name_translation
WHERE product_category_name_english  IN 
    ('computers',
    'electronics',
    'audio',
    'accessories',
    'game','books_technical','mobile');
    
SELECT DISTINCT
    product_category_name, product_category_name_english
FROM
    product_category_name_translation
    
WHERE
    product_category_name_english LIKE '%tech%'
        OR product_category_name_english LIKE '%elec%'
        OR product_category_name_english LIKE '%computer%'
        OR product_category_name_english LIKE '%mobile%'
        OR product_category_name_english LIKE '%tel%'
        OR product_category_name_english LIKE '%audio%'
        AND product_category_name_english != 'books_technical';
        




-- How many products of these tech categories have been sold (within the time window of the database snapshot)? 
-- What percentage does that represent from the overall number of products sold?
    
    SELECT DISTINCT
    (product_category_name_english),
    order_id,
    (SELECT 
            COUNT(order_id) FROM
            product_category_name_translation)
FROM
    product_category_name_translation AS prc
        INNER JOIN
    products AS p ON prc.product_category_name = p.product_category_name
        INNER JOIN
    order_items AS oi ON p.product_id = oi.product_id
        INNER JOIN
    sellers AS s ON oi.seller_id = s.seller_id
WHERE
    product_category_name_english LIKE '%tech%'
        OR product_category_name_english LIKE '%elec%'
        OR product_category_name_english LIKE '%computer%'
        OR product_category_name_english LIKE '%mobile%'
        OR product_category_name_english LIKE '%tel%'
        OR product_category_name_english LIKE '%audio%'
        AND product_category_name_english != 'books_technical';
        
        SELECT
    COUNT(*) AS tech_products_sold,
   COUNT(*) * 100.0 / (SELECT COUNT(*) FROM order_items) AS tech_percentage
   
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation prc
    ON p.product_category_name = prc.product_category_name
WHERE prc.product_category_name_english IN (
    'electronics',
    'computers',
    'telephony',
    'computers_accesories'
);
   
   
   -- What’s the average price of the products being sold?
   SELECT
    COUNT(*) AS tech_products_sold,
   COUNT(*) * 100.0 / (SELECT COUNT(*) FROM order_items) AS tech_percentage,
   ROUND(AVG(price),2)
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation prc
    ON p.product_category_name = prc.product_category_name
WHERE prc.product_category_name_english IN (
    'electronics',
    'computers',
    'telephony',
    'computers_accesories'
);
   -- Are expensive tech products popular? *
   
   SELECT 
    price_level,
    COUNT(*) AS total_sold
FROM
(
    SELECT 
        oi.price,
        
        CASE 
            WHEN oi.price > (
                SELECT AVG(oi2.price)
                FROM order_items oi2
                JOIN products p2 ON oi2.product_id = p2.product_id
                JOIN product_category_name_translation pr2 
                    ON p2.product_category_name = pr2.product_category_name
                WHERE pr2.product_category_name_english IN 
                    ('electronics','computers','audio',
                     'telephony','pc_gamer',
                     'consoles_games','tablets_printing_image')
            )
            THEN 'expensive'
            ELSE 'not_expensive'
        END AS price_level
        
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN product_category_name_translation pr 
        ON p.product_category_name = pr.product_category_name
    WHERE pr.product_category_name_english IN 
        ('electronics','computers','audio',
         'telephony','pc_gamer',
         'consoles_games','tablets_printing_image')
) AS tech_products
GROUP BY price_level;

   
   -- How many months of data are included in the magist database?
 SELECT COUNT(DISTINCT(MONTH(order_purchase_timestamp)))AS total_month
FROM orders;
SELECT
    COUNT(DISTINCT CONCAT(
        YEAR(order_purchase_timestamp),
        '-',
        MONTH(order_purchase_timestamp)
    )) AS total_months
FROM orders;


 SELECT DATE(order_purchase_timestamp), MONTH(order_purchase_timestamp)
 FROM orders;
   
   
   
   

         SELECT
    TIMESTAMPDIFF(
        MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp)
    ) + 1 AS total_months
FROM orders;

   --  How many sellers are there? 
   -- How many Tech sellers are there? What percentage of overall sellers are Tech sellers?
   SELECT COUNT(DISTINCT(seller_id)) FROM sellers;
   
   SELECT 
    COUNT(DISTINCT oi.seller_id) AS tech_sellers,
    (SELECT 
            COUNT(DISTINCT seller_id) AS total_sellers
        FROM
            order_items),
            COUNT(DISTINCT oi.seller_id)*100.0/
            (SELECT COUNT(Distinct seller_id) FROM order_items) AS percentge_tech_sellers
FROM
    order_items AS oi
        JOIN
    products AS p ON oi.product_id = p.product_id
        LEFT JOIN
    product_category_name_translation AS pn ON p.product_category_name = pn.product_category_name
WHERE
    product_category_name_english IN ('electronics' , 'computers',
        'audio',
        'telephony',
        'pc_gamer',
        'consoles_games',
        'tablets_printing_image');
        
         SELECT 
    COUNT(DISTINCT oi.seller_id) AS tech_sellers,
    (SELECT 
            COUNT(DISTINCT seller_id) 
        FROM
            order_items)AS total_sellers,
            COUNT(DISTINCT oi.seller_id)*100.0/
            (SELECT COUNT(Distinct seller_id) FROM order_items) AS percentge_tech_sellers
FROM
    order_items AS oi
        JOIN
    products AS p ON oi.product_id = p.product_id
        LEFT JOIN
    product_category_name_translation AS pn ON p.product_category_name = pn.product_category_name
WHERE
    product_category_name_english LIKE '%tech%'
        OR product_category_name_english LIKE '%elec%'
        OR product_category_name_english LIKE '%computer%'
        OR product_category_name_english LIKE '%tel%'

	;
       
       -- What is the total amount earned by all sellers?
       -- What is the total amount earned by all Tech sellers?
       
       SELECT 
    SUM(Price) AS total_amount
FROM
   
    order_items;
         
         SELECT 
    SUM(Price) AS total_amount_techsellers,
    (SELECT 
            SUM(Price)
        FROM
            order_items) AS total_sell_amoumt
FROM
    order_items AS oi
        JOIN
    products AS p ON oi.product_id = p.product_id
        LEFT JOIN
    product_category_name_translation AS pn ON p.product_category_name = pn.product_category_name
WHERE
    product_category_name_english LIKE '%tech%'
        OR product_category_name_english LIKE '%elec%'
        OR product_category_name_english LIKE '%computer%'
        OR product_category_name_english LIKE '%mobile%'
        OR product_category_name_english LIKE '%tel%';
        

    
-- Can you work out the average monthly income of all sellers? 
-- Can you work out the average monthly income of Tech sellers?-- 
       
      SELECT 
    seller_id,
    SUM(price) AS montly_income,	
    MONTH(order_purchase_timestamp) AS month,
    YEAR(order_purchase_timestamp) AS year
FROM
    order_items AS oi
        JOIN
    orders AS o ON oi.order_id = o.order_id
GROUP BY seller_id , month , year; 
      
      
   SELECT AVG(monthly_income) 
FROM 
(
    SELECT seller_id,
           SUM(price) AS monthly_income,
           MONTH(order_purchase_timestamp) AS month,
           YEAR(order_purchase_timestamp) AS year
    FROM order_items AS oi
    JOIN orders AS o 
        ON oi.order_id = o.order_id
    GROUP BY seller_id, month, year
) AS monthly_table;


    
SELECT 
    AVG(monthly_income) AS avg_monthly_income
FROM
(
    SELECT 
        seller_id,
        SUM(price) AS monthly_income,
        DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS yearandmonth
    FROM orders AS o
    JOIN order_items AS oi 
        ON o.order_id = oi.order_id
    JOIN products AS p 
        ON oi.product_id = p.product_id
    JOIN product_category_name_translation AS pr 
        ON p.product_category_name = pr.product_category_name
    WHERE pr.product_category_name_english IN (
        'electronics', 
        'computers',
        'audio',
        'telephony',
        'pc_gamer',
        'consoles_games',
        'tablets_printing_image'
    )
    GROUP BY seller_id, yearandmonth
) AS monthly_table;

SELECT
    -- Average monthly income of all sellers
    (SELECT AVG(monthly_income)
     FROM (
         SELECT seller_id,
                SUM(price) AS monthly_income,
                DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS yearandmonth
         FROM orders o
         JOIN order_items oi ON o.order_id = oi.order_id
         GROUP BY seller_id, yearandmonth
     ) AS all_sellers) AS avg_monthly_income_all,

    -- Average monthly income of tech sellers
    (SELECT AVG(monthly_income)
     FROM (
         SELECT seller_id,
                SUM(price) AS monthly_income,
                DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS yearandmonth
         FROM orders o
         JOIN order_items oi ON o.order_id = oi.order_id
         JOIN products p ON oi.product_id = p.product_id
         JOIN product_category_name_translation pr ON p.product_category_name = pr.product_category_name
         WHERE pr.product_category_name_english IN (
             'electronics', 
             'computers',
             'telephony',
             'computer_accessories'
         )
         GROUP BY seller_id, yearandmonth
     ) AS tech_sellers
    ) AS avg_monthly_income_tech;
    SELECT 
    ROUND(AVG(all_sellers.monthly_income), 2) AS avg_monthly_all_sellers,
    ROUND(AVG(tech_sellers.monthly_income), 2) AS avg_monthly_tech_sellers,
    ROUND(
        AVG(tech_sellers.monthly_income) 
        / AVG(all_sellers.monthly_income) * 100, 
    2) AS percentage
FROM
(
    -- Monthly income per seller (ALL sellers)
    SELECT 
        seller_id,
        YEAR(order_purchase_timestamp) AS year,
        MONTH(order_purchase_timestamp) AS month,
        SUM(oi.price) AS monthly_income
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY seller_id, year, month
) AS all_sellers
JOIN
(
    -- Monthly income per seller (TECH sellers only)
    SELECT 
        seller_id,
        YEAR(order_purchase_timestamp) AS year,
        MONTH(order_purchase_timestamp) AS month,
        SUM(oi.price) AS monthly_income
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN product_category_name_translation trans 
        ON p.product_category_name = trans.product_category_name
    WHERE product_category_name_english IN (
        'electronics',
        'computers',
        'audio',
        'telephony',
        'pc_gamer',
        'consoles_games',
        'tablets_printing_image'
    )
    GROUP BY seller_id, year, month
) AS tech_sellers
ON all_sellers.seller_id = tech_sellers.seller_id
AND all_sellers.year = tech_sellers.year
AND all_sellers.month = tech_sellers.month;

    

-- What’s the average time between the order being placed and the product being delivered?
SELECT   AVG(TIMESTAMPDIFF(DAY,
        order_purchase_timestamp,
        order_delivered_customer_date)) AS avg_days 
FROM
    orders
    WHERE order_estimated_delivery_date IS NOT NULL;
  

SELECT AVG(TIMESTAMPDIFF(DAY,
        order_purchase_timestamp,
        order_delivered_customer_date)) AS avg_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


SELECT AVG(TIMESTAMPDIFF(HOUR,
        order_purchase_timestamp,
        order_delivered_customer_date)) AS avg_hours
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


-- How many orders are delivered on time vs orders delivered with a delay?

SELECT 
CASE 
WHEN order_delivered_customer_date <=order_estimated_delivery_date THEN 'on time'
ELSE 'delayed'
END AS delivery_status,
COUNT(*) AS num_order
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;

-- Is there any pattern for delayed orders, e.g. big products being delayed more often?

SELECT 
CASE 
WHEN order_delivered_customer_date <=order_estimated_delivery_date THEN 'on time'
ELSE 'delayed'
END AS delivery_status,
CASE
    WHEN product_weight_g > 5000 THEN 'large'
    WHEN product_weight_g > 1000 THEN 'medium'
    ELSE 'small'
END AS product_size,
COUNT(*) AS total_orders

FROM orders AS o
JOIN order_items AS oi ON o.order_id= oi.order_id
JOIN products AS P ON oi.product_id= p.product_id
GROUP BY delivery_status,product_size
ORDER BY total_orders DESC;

SELECT
    CASE 
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 100 THEN "> 100 day Delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 7 AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) < 100 THEN "1 week to 100 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 3 AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) < 7 THEN "4-7 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 1  AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) <= 3 THEN "1-3 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 0  AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) < 1 THEN "less than 1 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) <= 0 THEN 'On time' 
    END AS "delay_range", 
    AVG(product_weight_g) AS weight_avg,
    MAX(product_weight_g) AS max_weight,
    MIN(product_weight_g) AS min_weight,
    SUM(product_weight_g) AS sum_weight,
    COUNT(DISTINCT a.order_id) AS orders_count
FROM orders a
LEFT JOIN order_items b
    USING (order_id)
LEFT JOIN products c
    USING (product_id)
WHERE order_estimated_delivery_date IS NOT NULL
AND order_delivered_customer_date IS NOT NULL
AND order_status = 'delivered'
GROUP BY delay_range;



SELECT
    CASE
        WHEN p.product_weight_g < 1000 THEN 'light'
        WHEN p.product_weight_g BETWEEN 1000 AND 2000 THEN 'medium'
        ELSE 'heavy'
    END AS weight_category,
    SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) AS Dlayed,
    COUNT(o.order_id) AS total_orders
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
JOIN products AS p ON p.product_id = oi.product_id
JOIN customers AS c ON o.customer_id = c.customer_id
JOIN geo AS g ON c.customer_zip_code_prefix = g.zip_code_prefix
WHERE g.state IS NOT NULL
GROUP BY weight_category
ORDER BY weight_category DESC;