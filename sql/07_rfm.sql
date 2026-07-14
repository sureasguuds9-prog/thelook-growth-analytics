-- RFM scoring and actionable segments.

WITH reference AS (
  SELECT DATE_ADD(MAX(DATE(order_created_at)), INTERVAL 1 DAY) AS reference_date
  FROM `your-gcp-project-id.thelook_portfolio.order_mart`
), base AS (
  SELECT
    user_id,
    DATE_DIFF(MAX(DATE(order_created_at)), MAX(reference_date), DAY) * -1 AS recency_days,
    COUNT(*) AS frequency,
    SUM(net_revenue) AS monetary
  FROM `your-gcp-project-id.thelook_portfolio.order_mart`, reference
  WHERE status NOT IN ('Cancelled', 'Returned')
  GROUP BY user_id
), scored AS (
  SELECT
    *,
    NTILE(5) OVER (ORDER BY recency_days DESC, user_id) AS r_score,
    NTILE(5) OVER (ORDER BY frequency ASC, user_id) AS f_score,
    NTILE(5) OVER (ORDER BY monetary ASC, user_id) AS m_score
  FROM base
)
SELECT
  *,
  CASE
    WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
    WHEN r_score >= 3 AND f_score >= 4 THEN 'Loyal Customers'
    WHEN r_score = 5 AND f_score <= 2 THEN 'New Customers'
    WHEN r_score <= 2 AND f_score >= 4 AND m_score >= 4 THEN 'High Value At Risk'
    WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
    WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost Customers'
    ELSE 'Potential Loyalists'
  END AS segment
FROM scored;
