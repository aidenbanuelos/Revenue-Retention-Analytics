-- ================================================
-- Query 2: Churn Rate by Month
-- Business Question: Are we losing customers and how fast?
-- Table(s): subscriptions
-- Notes: Calculates churn rate as a percentage of
--        total subscriptions per month. Churned
--        subscriptions are grouped by end_date
--        (when churn occurred), not start_date.
--        June 2024 excluded — partial month inflates rate.
--        Non-seasonal spikes in Aug 2023 (8.77%)
--        and Mar 2024 (12.28%) are key findings.
-- ================================================
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
 
