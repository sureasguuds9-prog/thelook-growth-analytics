-- Session funnel and segmentation.

WITH session_flags AS (
  SELECT
    session_id,
    ANY_VALUE(traffic_source) AS traffic_source,
    ANY_VALUE(browser) AS browser,
    MAX(IF(event_type IN ('department', 'product'), 1, 0)) AS product_view,
    MAX(IF(event_type = 'cart', 1, 0)) AS cart,
    MAX(IF(event_type = 'purchase', 1, 0)) AS purchase
  FROM `your-gcp-project-id.thelook_portfolio.events`
  GROUP BY session_id
)
SELECT
  COUNT(*) AS sessions,
  SUM(product_view) AS product_view_sessions,
  SUM(cart) AS cart_sessions,
  SUM(purchase) AS purchase_sessions,
  SAFE_DIVIDE(SUM(cart), SUM(product_view)) AS view_to_cart,
  SAFE_DIVIDE(SUM(purchase), SUM(cart)) AS cart_to_purchase,
  AVG(purchase) AS session_purchase_conversion
FROM session_flags;

WITH session_flags AS (
  SELECT
    session_id,
    ANY_VALUE(traffic_source) AS traffic_source,
    ANY_VALUE(browser) AS browser,
    MAX(IF(event_type IN ('department', 'product'), 1, 0)) AS product_view,
    MAX(IF(event_type = 'cart', 1, 0)) AS cart,
    MAX(IF(event_type = 'purchase', 1, 0)) AS purchase
  FROM `your-gcp-project-id.thelook_portfolio.events`
  GROUP BY session_id
)
SELECT
  traffic_source,
  COUNT(*) AS sessions,
  AVG(product_view) AS view_rate,
  AVG(cart) AS cart_rate,
  AVG(purchase) AS purchase_rate
FROM session_flags
GROUP BY traffic_source
ORDER BY purchase_rate DESC;
