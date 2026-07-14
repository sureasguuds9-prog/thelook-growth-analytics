-- Monthly repeat-purchase retention with zero-activity cells preserved.

WITH net_orders AS (
  SELECT DISTINCT
    user_id,
    DATE_TRUNC(DATE(order_created_at), MONTH) AS order_month
  FROM `your-gcp-project-id.thelook_portfolio.order_mart`
  WHERE status NOT IN ('Cancelled', 'Returned')
), users_with_cohort AS (
  SELECT
    user_id,
    order_month,
    MIN(order_month) OVER (PARTITION BY user_id) AS cohort_month
  FROM net_orders
), cohort_sizes AS (
  SELECT cohort_month, COUNT(DISTINCT user_id) AS cohort_size
  FROM users_with_cohort
  GROUP BY cohort_month
), activity AS (
  SELECT
    cohort_month,
    DATE_DIFF(order_month, cohort_month, MONTH) AS cohort_age,
    COUNT(DISTINCT user_id) AS active_buyers
  FROM users_with_cohort
  GROUP BY cohort_month, cohort_age
), observation AS (
  SELECT MAX(order_month) AS max_order_month FROM net_orders
), eligible_grid AS (
  SELECT
    c.cohort_month,
    age AS cohort_age,
    c.cohort_size
  FROM cohort_sizes c, observation,
  UNNEST(GENERATE_ARRAY(0, LEAST(12, DATE_DIFF(max_order_month, c.cohort_month, MONTH)))) AS age
)
SELECT
  g.cohort_month,
  g.cohort_age,
  COALESCE(a.active_buyers, 0) AS active_buyers,
  g.cohort_size,
  SAFE_DIVIDE(COALESCE(a.active_buyers, 0), g.cohort_size) AS retention
FROM eligible_grid g
LEFT JOIN activity a USING (cohort_month, cohort_age)
ORDER BY cohort_month, cohort_age;
