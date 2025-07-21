SELECT
  s.customer_id,
  SUM(
    m.price * 10 *
    (
      1
      + IF(m.product_name = 'sushi', 1, 0)
      + IF(s.order_date BETWEEN mb.join_date AND DATE_ADD(mb.join_date, INTERVAL 6 DAY), 1, 0)
      - IF(m.product_name = 'sushi' AND s.order_date BETWEEN mb.join_date AND DATE_ADD(mb.join_date, INTERVAL 6 DAY), 1, 0)
    )
  ) AS january_points
FROM sales s
JOIN members mb ON s.customer_id = mb.customer_id
JOIN menu m ON s.product_id = m.product_id
WHERE s.customer_id IN ('A', 'B')
  AND s.order_date <= '2021-01-31'
GROUP BY s.customer_id;
