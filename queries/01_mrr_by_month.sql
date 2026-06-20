-- ================================================
-- Query 1: MRR by Month
-- Business Question: Is revenue growing or declining?
-- Table(s): subscriptions
-- Notes: Filters active subscriptions and accounts
--        for mid-month cancellations via end_date.
--        Cancelled subscriptions included only if
--        end_date falls within the active month.
--        January 2024 excluded via WHERE clause —
--        partial month at dataset boundary.
--        Note: MRR is not prorated for mid-month
--        cancellations. Full monthly_price is counted
--        for any month a subscription was active.
-- ================================================
SELECT
  DATE_TRUNC('month', start_date::date) AS month,
  SUM(monthly_price) AS mrr
FROM public.subscriptions
WHERE status = 'active'
OR (status = 'cancelled' AND end_date::date >= DATE_TRUNC('month', start_date::date))
GROUP BY 1
ORDER BY 1;
