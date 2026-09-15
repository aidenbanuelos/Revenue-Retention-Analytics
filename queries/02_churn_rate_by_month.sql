-- ================================================
-- Query 2: Churn Rate by Month
-- Business Question: Are we losing customers and how fast?
-- Table(s): subscriptions

SELECT
  DATE_TRUNC('month',
    CASE
      WHEN s.status = 'churned' THEN s.end_date::date
      ELSE s.start_date::date
    END
  ) AS month,
  COUNT(CASE WHEN s.status = 'churned' THEN 1 END) AS churned,
  COUNT(CASE WHEN s.status IN ('active', 'churned') THEN 1 END) AS active_at_start,
  ROUND(
    100.0 * COUNT(CASE WHEN s.status = 'churned' THEN 1 END) /
    NULLIF(COUNT(CASE WHEN s.status IN ('active', 'churned') THEN 1 END), 0),
  2) AS churn_rate_percent
FROM public.subscriptions s
GROUP BY 1
ORDER BY 1;
 
