-- ================================================
-- Query 1: MRR by Month
-- Business Question: Is revenue growing or declining?
-- Table(s): subscriptions

SELECT
  DATE_TRUNC('month', start_date::date) AS month,
  SUM(monthly_price) AS mrr
FROM public.subscriptions
WHERE status = 'active'
OR (status = 'cancelled' AND end_date::date >= DATE_TRUNC('month', start_date::date))
GROUP BY 1
ORDER BY 1;
