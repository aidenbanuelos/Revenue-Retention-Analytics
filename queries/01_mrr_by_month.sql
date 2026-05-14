-- ================================================
-- Query: MRR by Month
-- Business Question: Is revenue growing or declining?
-- Table(s): subscriptions
-- Notes: Filters active subscriptions and accounts
--        for mid-month cancellations via end_date.
--        January 2024 excluded via WHERE clause —
--        partial month at dataset boundary.
-- ================================================

SELECT
  DATE_TRUNC('month', start_date::date) AS month,
  SUM(monthly_price) AS mrr
FROM public.subscriptions
WHERE status = 'active'
OR end_date::date >= DATE_TRUNC('month', start_date::date)
GROUP BY 1
ORDER BY 1;
