SELECT 
  WEEK(registration_date, 0) AS week_number,
  COUNT(*) AS runners_signed_up
FROM runners
GROUP BY week_number
ORDER BY week_number;



SELECT 
  runner_id,
  AVG(
    TIMESTAMPDIFF(MINUTE, co.order_time, STR_TO_DATE(ro.pickup_time, '%Y-%m-%d %H:%i:%s'))
  ) AS avg_arrival_minutes
FROM runner_orders ro
JOIN customer_orders co ON ro.order_id = co.order_id
WHERE ro.pickup_time IS NOT NULL
GROUP BY runner_id;



SELECT 
  ro.order_id,
  COUNT(co.pizza_id) AS num_pizzas,
  TIMESTAMPDIFF(MINUTE, co.order_time, STR_TO_DATE(ro.pickup_time, '%Y-%m-%d %H:%i:%s')) AS prep_time_minutes
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.pickup_time IS NOT NULL
GROUP BY ro.order_id;



SELECT 
  co.customer_id,
  ROUND(AVG(CAST(REPLACE(ro.distance, 'km', '') AS DECIMAL(5,2))), 2) AS avg_distance_km
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null')
GROUP BY co.customer_id;



SELECT 
  MAX(CAST(SUBSTRING_INDEX(ro.duration, ' ', 1) AS UNSIGNED)) -
  MIN(CAST(SUBSTRING_INDEX(ro.duration, ' ', 1) AS UNSIGNED)) AS duration_difference_minutes
FROM runner_orders ro
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null');



SELECT 
  runner_id,
  order_id,
  ROUND(
    CAST(REPLACE(distance, 'km', '') AS DECIMAL(5,2)) /
    (CAST(SUBSTRING_INDEX(duration, ' ', 1) AS DECIMAL(5,2)) / 60),
    2
  ) AS avg_speed_kmph
FROM runner_orders
WHERE cancellation IS NULL OR cancellation IN ('', 'null')
  AND distance IS NOT NULL
  AND duration IS NOT NULL;
  
  
  
  SELECT 
  runner_id,
  COUNT(CASE WHEN cancellation IS NULL OR cancellation IN ('', 'null') THEN 1 END) AS successful_deliveries,
  COUNT(*) AS total_orders,
  ROUND(
    COUNT(CASE WHEN cancellation IS NULL OR cancellation IN ('', 'null') THEN 1 END) / COUNT(*) * 100, 
    2
  ) AS success_rate_percentage
FROM runner_orders
GROUP BY runner_id;




