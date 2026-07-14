-- Monthly dynamics; the final incomplete month is excluded.

WITH max_month AS (
  SELECT DATE_TRUNC(MAX(DATE(order_created_at)), MONTH) AS last_month
  FROM `your-gcp-project-id.thelook_portfolio.order_mart`
)
SELECT
  DATE_TRUNC(DATE(order_created_at), MONTH) AS month,
  COUNTIF(status NOT IN ('Cancelled', 'Returned')) AS net_orders,
  COUNT(DISTINCT IF(status NOT IN ('Cancelled', 'Returned'), user_id, NULL)) AS buyers,
  SUM(net_revenue) AS net_revenue,
  SUM(gross_profit) AS gross_profit,
  SAFE_DIVIDE(SUM(gross_profit), SUM(net_revenue)) AS margin,
  SAFE_DIVIDE(COUNTIF(status = 'Returned'), COUNTIF(status != 'Cancelled')) AS return_rate
FROM `your-gcp-project-id.thelook_portfolio.order_mart`, max_month
WHERE DATE_TRUNC(DATE(order_created_at), MONTH) < last_month
GROUP BY month
ORDER BY month;
