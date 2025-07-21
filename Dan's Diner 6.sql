SELECT customer_id, product_name, order_date
FROM (
  SELECT 
    s.customer_id,
    s.order_date,
    m.product_name,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rank_order
  FROM sales s
  JOIN members mem ON s.customer_id = mem.customer_id
  JOIN menu m ON s.product_id = m.product_id
  WHERE s.order_date >= mem.join_date
) ranked
WHERE rank_order = 1;
