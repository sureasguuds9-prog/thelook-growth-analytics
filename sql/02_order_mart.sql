-- Materialized analytical mart. Grain: one row per order.

CREATE OR REPLACE TABLE `your-gcp-project-id.thelook_portfolio.order_mart`
CLUSTER BY status, traffic_source, country AS
WITH item_level AS (
  SELECT
    oi.order_id,
    COUNT(*) AS item_count,
    SUM(oi.sale_price) AS order_value,
    SUM(p.cost) AS product_cost,
    SUM(oi.sale_price - p.cost) AS gross_profit_before_status,
    COUNTIF(oi.status = 'Returned') AS returned_item_count
  FROM `your-gcp-project-id.thelook_portfolio.order_items` oi
  LEFT JOIN `your-gcp-project-id.thelook_portfolio.products` p
    ON oi.product_id = p.id
  GROUP BY oi.order_id
)
SELECT
  o.order_id,
  o.user_id,
  o.status,
  o.gender,
  o.created_at AS order_created_at,
  o.shipped_at,
  o.delivered_at,
  o.returned_at,
  COALESCE(i.item_count, 0) AS item_count,
  COALESCE(i.order_value, 0) AS order_value,
  COALESCE(i.product_cost, 0) AS product_cost,
  IF(o.status NOT IN ('Cancelled', 'Returned'), COALESCE(i.order_value, 0), 0) AS net_revenue,
  IF(o.status NOT IN ('Cancelled', 'Returned'), COALESCE(i.order_value - i.product_cost, 0), 0) AS gross_profit,
  TIMESTAMP_DIFF(o.shipped_at, o.created_at, DAY) AS days_to_ship,
  TIMESTAMP_DIFF(o.delivered_at, o.shipped_at, DAY) AS days_in_transit,
  TIMESTAMP_DIFF(o.delivered_at, o.created_at, DAY) AS days_to_deliver,
  u.country,
  u.traffic_source,
  u.age,
  u.gender AS user_gender,
  u.created_at AS user_created_at
FROM `your-gcp-project-id.thelook_portfolio.orders` o
LEFT JOIN item_level i USING (order_id)
LEFT JOIN `your-gcp-project-id.thelook_portfolio.users` u
  ON o.user_id = u.id;
