SELECT 
  pn.pizza_name,
  pt.topping_name
FROM pizza_recipes pr
JOIN pizza_names pn ON pr.pizza_id = pn.pizza_id
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, pr.toppings) > 0
ORDER BY pn.pizza_name, pt.topping_name;



SELECT 
  pt.topping_name,
  COUNT(*) AS extra_count
FROM customer_orders co
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, REPLACE(co.extras, 'null', '')) > 0
WHERE co.extras IS NOT NULL AND co.extras != ''
GROUP BY pt.topping_name
ORDER BY extra_count DESC
LIMIT 1;



SELECT 
  pt.topping_name,
  COUNT(*) AS exclusion_count
FROM customer_orders co
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, REPLACE(co.exclusions, 'null', '')) > 0
WHERE co.exclusions IS NOT NULL AND co.exclusions != ''
GROUP BY pt.topping_name
ORDER BY exclusion_count DESC
LIMIT 1;



SELECT 
  co.order_id,
  pn.pizza_name,
  CONCAT_WS(
    ' - ',
    pn.pizza_name,
    IF(TRIM(REPLACE(co.exclusions, 'null', '')) != '', 
       CONCAT('Exclude ', GROUP_CONCAT(DISTINCT pt1.topping_name ORDER BY pt1.topping_name SEPARATOR ', ')), 
       NULL),
    IF(TRIM(REPLACE(co.extras, 'null', '')) != '', 
       CONCAT('Extra ', GROUP_CONCAT(DISTINCT pt2.topping_name ORDER BY pt2.topping_name SEPARATOR ', ')), 
       NULL)
  ) AS order_description
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
LEFT JOIN pizza_toppings pt1 ON FIND_IN_SET(pt1.topping_id, co.exclusions) > 0
LEFT JOIN pizza_toppings pt2 ON FIND_IN_SET(pt2.topping_id, co.extras) > 0
GROUP BY co.order_id, co.pizza_id, co.exclusions, co.extras;



SELECT
  co.order_id,
  CONCAT(
    pn.pizza_name, ': ',
    GROUP_CONCAT(
      CASE 
        WHEN FIND_IN_SET(pt.topping_id, co.extras) > 0 THEN CONCAT('2x', pt.topping_name)
        ELSE pt.topping_name
      END
      ORDER BY pt.topping_name
      SEPARATOR ', '
    )
  ) AS ingredient_list
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN pizza_recipes pr ON pr.pizza_id = co.pizza_id
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, pr.toppings) > 0
GROUP BY co.order_id, co.pizza_id, co.extras;



SELECT 
  pt.topping_name,
  COUNT(*) AS total_used
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
JOIN pizza_recipes pr ON pr.pizza_id = co.pizza_id
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, pr.toppings) > 0
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null')
GROUP BY pt.topping_name
ORDER BY total_used DESC;








