-- Share-safe checks. Every result should be TRUE or zero.

SELECT
  COUNT(*) AS mart_rows,
  COUNT(DISTINCT order_id) AS unique_orders,
  COUNT(*) = COUNT(DISTINCT order_id) AS one_row_per_order,
  COUNTIF(order_id IS NULL) AS null_order_ids,
  COUNTIF(net_revenue < 0) AS negative_net_revenue
FROM `your-gcp-project-id.thelook_portfolio.order_mart`;

SELECT
  status,
  COUNT(*) AS orders,
  SUM(net_revenue) AS net_revenue,
  SUM(gross_profit) AS gross_profit
FROM `your-gcp-project-id.thelook_portfolio.order_mart`
GROUP BY status
ORDER BY orders DESC;
