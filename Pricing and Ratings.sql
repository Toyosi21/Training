SELECT 
  SUM(CASE 
      WHEN pn.pizza_name = 'Meatlovers' THEN 12
      WHEN pn.pizza_name = 'Vegetarian' THEN 10
  END) AS total_revenue
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null');



SELECT 
  SUM(
    CASE 
      WHEN pn.pizza_name = 'Meatlovers' THEN 12
      WHEN pn.pizza_name = 'Vegetarian' THEN 10
    END
  ) +
  SUM(
    CASE 
      WHEN co.extras IS NOT NULL AND TRIM(co.extras) != '' AND TRIM(co.extras) != 'null'
      THEN LENGTH(REPLACE(co.extras, ' ', '')) - LENGTH(REPLACE(REPLACE(co.extras, ' ', ''), ',', '')) + 1
      ELSE 0
    END
  ) AS total_revenue_with_extras
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null');



CREATE TABLE runner_ratings (
  order_id INT PRIMARY KEY,
  rating INT CHECK (rating BETWEEN 1 AND 5)
);

-- Sample insert for successful orders
INSERT INTO runner_ratings (order_id, rating) VALUES
  (1, 4), (2, 5), (3, 4), (4, 3), (5, 5), (7, 4), (8, 5), (10, 4);
  
  
  
  SELECT
  co.customer_id,
  co.order_id,
  ro.runner_id,
  rr.rating,
  co.order_time,
  STR_TO_DATE(ro.pickup_time, '%Y-%m-%d %H:%i:%s') AS pickup_time,
  TIMESTAMPDIFF(MINUTE, co.order_time, STR_TO_DATE(ro.pickup_time, '%Y-%m-%d %H:%i:%s')) AS time_to_pickup,
  CAST(SUBSTRING_INDEX(ro.duration, ' ', 1) AS UNSIGNED) AS delivery_duration_minutes,
  ROUND(
    CAST(SUBSTRING_INDEX(REPLACE(ro.distance, 'km', ''), ' ', 1) AS DECIMAL(5,2)) /
    (CAST(SUBSTRING_INDEX(ro.duration, ' ', 1) AS DECIMAL(5,2)) / 60),
    2
  ) AS avg_speed_kph,
  COUNT(*) AS total_pizzas
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
JOIN runner_ratings rr ON co.order_id = rr.order_id
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null')
GROUP BY co.order_id;



SELECT
  SUM(
    CASE
      WHEN pn.pizza_name = 'Meatlovers' THEN 12
      WHEN pn.pizza_name = 'Vegetarian' THEN 10
    END
  ) AS total_revenue,
  SUM(
    0.30 * CAST(
      REPLACE(REPLACE(ro.distance, 'km', ''), ' ', '') AS DECIMAL(5,2)
    )
  ) AS total_runner_cost,
  SUM(
    CASE
      WHEN pn.pizza_name = 'Meatlovers' THEN 12
      WHEN pn.pizza_name = 'Vegetarian' THEN 10
    END
  ) -
  SUM(
    0.30 * CAST(
      REPLACE(REPLACE(ro.distance, 'km', ''), ' ', '') AS DECIMAL(5,2)
    )
  ) AS net_profit
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null');
