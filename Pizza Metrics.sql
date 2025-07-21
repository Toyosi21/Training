SELECT COUNT(*) AS total_pizzas
FROM customer_orders;



SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM customer_orders;



SELECT runner_id, COUNT(*) AS successful_orders
FROM runner_orders
WHERE cancellation IS NULL OR cancellation IN ('', 'null')
GROUP BY runner_id;


SELECT pn.pizza_name, COUNT(*) AS delivered_count
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null')
GROUP BY pn.pizza_name;



SELECT customer_id, pn.pizza_name, COUNT(*) AS total
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null')
GROUP BY customer_id, pn.pizza_name
ORDER BY customer_id;



SELECT order_id, COUNT(*) AS pizzas_count
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null')
GROUP BY order_id
ORDER BY pizzas_count DESC
LIMIT 1;



SELECT 
  co.customer_id,
  SUM(
    CASE 
      WHEN (exclusions IS NOT NULL AND exclusions NOT IN ('', 'null'))
        OR (extras IS NOT NULL AND extras NOT IN ('', 'null')) 
      THEN 1 ELSE 0 
    END
  ) AS with_changes,
  SUM(
    CASE 
      WHEN (exclusions IS NULL OR exclusions IN ('', 'null'))
        AND (extras IS NULL OR extras IN ('', 'null')) 
      THEN 1 ELSE 0 
    END
  ) AS no_changes
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null')
GROUP BY co.customer_id;



SELECT COUNT(*) AS both_exclusions_and_extras
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null')
AND (exclusions IS NOT NULL AND exclusions NOT IN ('', 'null'))
AND (extras IS NOT NULL AND extras NOT IN ('', 'null'));



SELECT HOUR(order_time) AS order_hour, COUNT(*) AS total_orders
FROM customer_orders
GROUP BY order_hour
ORDER BY order_hour;



SELECT 
  DAYNAME(order_time) AS order_day, 
  COUNT(*) AS total_orders
FROM customer_orders
GROUP BY order_day
ORDER BY FIELD(order_day, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');


