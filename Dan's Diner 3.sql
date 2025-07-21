SELECT customer_id, product_name
FROM (
  SELECT 
    s.customer_id,
    s.order_date,
    m.product_name,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rank_order
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
) ranked
WHERE rank_order = 1;
