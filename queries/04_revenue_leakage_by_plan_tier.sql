-- ================================================
-- Query: Revenue Leakage by Plan Tier
-- Business Question: Which plan tier is bleeding
--                   the most revenue?
-- Table(s): subscriptions
-- Notes: Sums monthly_price for churned customers
--        grouped by plan tier. Growth tier is the
--        highest priority — most churned customers
--        combined with meaningful contract value
--        (~$499/customer vs ~$999 for Pro).
-- ================================================

SELECT
  plan_tier,
  COUNT(*) AS churned_customers,
  SUM(monthly_price) AS lost_revenue
FROM public.subscriptions
WHERE status = 'churned'
GROUP BY plan_tier
ORDER BY lost_revenue DESC;
