SELECT customer_id, product_name, total_orders
FROM (
  SELECT 
    s.customer_id,
    m.product_name,
    COUNT(*) AS total_orders,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS rank_order
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  GROUP BY s.customer_id, m.product_name
) ranked
WHERE rank_order = 1;
