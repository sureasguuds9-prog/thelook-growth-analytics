-- Executive KPI with definitions matching the Pandas notebook.

WITH buyer_orders AS (
  SELECT user_id, COUNT(*) AS net_orders
  FROM `your-gcp-project-id.thelook_portfolio.order_mart`
  WHERE status NOT IN ('Cancelled', 'Returned')
  GROUP BY user_id
), totals AS (
  SELECT
    COUNT(*) AS orders,
    COUNT(DISTINCT user_id) AS ordering_users,
    SUM(IF(status != 'Cancelled', order_value, 0)) AS gmv,
    SUM(net_revenue) AS net_revenue,
    SUM(gross_profit) AS gross_profit,
    SAFE_DIVIDE(COUNTIF(status = 'Returned'), COUNTIF(status != 'Cancelled')) AS return_rate,
    SAFE_DIVIDE(COUNTIF(status = 'Cancelled'), COUNT(*)) AS cancellation_rate,
    AVG(IF(net_revenue > 0, net_revenue, NULL)) AS aov,
    SAFE_DIVIDE(SUM(IF(status NOT IN ('Cancelled', 'Returned'), item_count, 0)),
                COUNTIF(status NOT IN ('Cancelled', 'Returned'))) AS avg_basket_size
  FROM `your-gcp-project-id.thelook_portfolio.order_mart`
)
SELECT
  t.*,
  SAFE_DIVIDE(gross_profit, net_revenue) AS gross_margin,
  (SELECT SAFE_DIVIDE(COUNTIF(net_orders >= 2), COUNT(*)) FROM buyer_orders) AS repeat_purchase_rate
FROM totals t;
