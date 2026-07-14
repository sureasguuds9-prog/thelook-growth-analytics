-- Primary keys, referential integrity and impossible chronology.

WITH key_checks AS (
  SELECT 'users' AS table_name, COUNT(*) AS row_count,
         COUNT(DISTINCT id) AS unique_keys, COUNTIF(id IS NULL) AS null_keys
  FROM `your-gcp-project-id.thelook_portfolio.users`
  UNION ALL
  SELECT 'orders', COUNT(*), COUNT(DISTINCT order_id), COUNTIF(order_id IS NULL)
  FROM `your-gcp-project-id.thelook_portfolio.orders`
  UNION ALL
  SELECT 'order_items', COUNT(*), COUNT(DISTINCT id), COUNTIF(id IS NULL)
  FROM `your-gcp-project-id.thelook_portfolio.order_items`
  UNION ALL
  SELECT 'products', COUNT(*), COUNT(DISTINCT id), COUNTIF(id IS NULL)
  FROM `your-gcp-project-id.thelook_portfolio.products`
  UNION ALL
  SELECT 'events', COUNT(*), COUNT(DISTINCT id), COUNTIF(id IS NULL)
  FROM `your-gcp-project-id.thelook_portfolio.events`
)
SELECT
  *,
  row_count - unique_keys AS duplicate_keys
FROM key_checks
ORDER BY row_count DESC;

WITH integrity_checks AS (
  SELECT 'orders_without_user' AS check_name, COUNT(*) AS issue_count
  FROM `your-gcp-project-id.thelook_portfolio.orders` o
  LEFT JOIN `your-gcp-project-id.thelook_portfolio.users` u ON o.user_id = u.id
  WHERE u.id IS NULL
  UNION ALL
  SELECT 'items_without_order', COUNT(*)
  FROM `your-gcp-project-id.thelook_portfolio.order_items` oi
  LEFT JOIN `your-gcp-project-id.thelook_portfolio.orders` o USING (order_id)
  WHERE o.order_id IS NULL
  UNION ALL
  SELECT 'items_without_product', COUNT(*)
  FROM `your-gcp-project-id.thelook_portfolio.order_items` oi
  LEFT JOIN `your-gcp-project-id.thelook_portfolio.products` p ON oi.product_id = p.id
  WHERE p.id IS NULL
  UNION ALL
  SELECT 'shipped_before_created', COUNT(*)
  FROM `your-gcp-project-id.thelook_portfolio.orders`
  WHERE shipped_at IS NOT NULL AND shipped_at < created_at
  UNION ALL
  SELECT 'delivered_before_shipped', COUNT(*)
  FROM `your-gcp-project-id.thelook_portfolio.orders`
  WHERE delivered_at IS NOT NULL AND shipped_at IS NOT NULL AND delivered_at < shipped_at
  UNION ALL
  SELECT 'returned_before_delivered', COUNT(*)
  FROM `your-gcp-project-id.thelook_portfolio.orders`
  WHERE returned_at IS NOT NULL AND delivered_at IS NOT NULL AND returned_at < delivered_at
)
SELECT * FROM integrity_checks ORDER BY check_name;
