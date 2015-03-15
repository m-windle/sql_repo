----------------------------
--    MASATOSHI WINDLE    --
--        100913032       --
----------------------------

--1
SELECT category_name, COUNT(product_id), MAX(list_price)
FROM categories c, products p
WHERE c.category_id = p.category_id
GROUP BY category_name
ORDER BY COUNT(product_id) DESC;

--2
SELECT c.email_address, SUM(oi.item_price * oi.quantity) as "Item Price Total", SUM(oi.discount_amount * oi.quantity)
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
  JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.email_address
ORDER BY "Item Price Total" DESC;

--3
SELECT c.email_address, COUNT(o.order_id) as "Number of Orders", SUM((oi.item_price - oi.discount_amount) * oi.quantity)
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
  JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.email_address
HAVING COUNT(o.order_id) > 1
ORDER BY 3 DESC; 

--4
SELECT product_name, SUM((oi.item_price - oi.discount_amount) * oi.quantity) as "Total Amount"
FROM products p JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY ROLLUP(product_name);

--5
SELECT c.email_address, COUNT(DISTINCT oi.product_id) AS "Number of Different Products"
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
  JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.email_address
HAVING COUNT(DISTINCT oi.product_id) > 1
ORDER BY 2 DESC;

--6
SELECT DISTINCT category_name
FROM categories c
WHERE c.category_id IN (SELECT p.category_id FROM products p)
ORDER BY category_name;

--7
SELECT product_name, list_price
FROM products
WHERE list_price > (SELECT AVG(list_price) FROM products)
ORDER BY list_price DESC;

--8
SELECT category_name
FROM categories c
WHERE NOT EXISTS (SELECT category_id FROM products p WHERE p.category_id = c.category_id);

--9
SELECT product_name, discount_percent
FROM products p1
WHERE NOT EXISTS (SELECT * FROM products p2 WHERE p1.discount_percent = p2.discount_percent AND NOT p1.product_id = p2.product_id) 
ORDER BY product_name;

--10
SELECT DISTINCT c1.email_address, o1.order_id, o1.order_date AS "Min Date"
FROM orders o1 JOIN customers c1 ON o1.customer_id = c1.customer_id
WHERE o1.order_date = (SELECT MIN(o2.order_date) FROM orders o2 WHERE o2.customer_id = c1.customer_id);

