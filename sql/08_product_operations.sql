-- Category economics and aged inventory by distribution center.

SELECT
  p.category,
  COUNT(*) AS sold_items,
  SUM(IF(oi.status NOT IN ('Cancelled', 'Returned'), oi.sale_price, 0)) AS net_revenue,
  SUM(IF(oi.status NOT IN ('Cancelled', 'Returned'), oi.sale_price - p.cost, 0)) AS gross_profit,
  SAFE_DIVIDE(
    SUM(IF(oi.status NOT IN ('Cancelled', 'Returned'), oi.sale_price - p.cost, 0)),
    SUM(IF(oi.status NOT IN ('Cancelled', 'Returned'), oi.sale_price, 0))
  ) AS gross_margin,
  SAFE_DIVIDE(COUNTIF(oi.status = 'Returned'), COUNTIF(oi.status != 'Cancelled')) AS item_return_rate
FROM `your-gcp-project-id.thelook_portfolio.order_items` oi
JOIN `your-gcp-project-id.thelook_portfolio.products` p ON oi.product_id = p.id
GROUP BY p.category
HAVING sold_items >= 500
ORDER BY net_revenue DESC;

WITH snapshot AS (
  SELECT GREATEST(MAX(created_at), MAX(sold_at)) AS snapshot_at
  FROM `your-gcp-project-id.thelook_portfolio.inventory_items`
)
SELECT
  dc.name AS distribution_center,
  COUNTIF(i.sold_at IS NULL) AS unsold_units,
  SUM(IF(i.sold_at IS NULL, i.cost, 0)) AS unsold_cost,
  COUNTIF(i.sold_at IS NULL AND TIMESTAMP_DIFF(snapshot_at, i.created_at, DAY) > 180) AS aged_units_180d,
  SUM(IF(i.sold_at IS NULL AND TIMESTAMP_DIFF(snapshot_at, i.created_at, DAY) > 180, i.cost, 0)) AS aged_cost_180d
FROM `your-gcp-project-id.thelook_portfolio.inventory_items` i
CROSS JOIN snapshot
JOIN `your-gcp-project-id.thelook_portfolio.distribution_centers` dc
  ON i.product_distribution_center_id = dc.id
GROUP BY distribution_center
ORDER BY aged_cost_180d DESC;
