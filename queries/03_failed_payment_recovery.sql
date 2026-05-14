-- ================================================
-- Query: Failed Payment Recovery by Plan Tier
-- Business Question: When payments fail, are we
--                   recovering the money?
-- Table(s): payments, subscriptions
-- Notes: Joins payments to subscriptions to get
--        plan tier context. Filters on failed
--        payments only. Recovery rates are
--        consistent across tiers (57-65%),
--        revealing a systemic dunning gap rather
--        than a tier-specific problem.
-- ================================================

SELECT
  s.plan_tier,
  COUNT(*) AS total_failed,
  COUNT(CASE WHEN recovered = 'true' THEN 1 END) AS recovered_count,
  ROUND(100.0 * COUNT(CASE WHEN recovered = 'true' THEN 1 END) / COUNT(*), 2) AS recovery_rate_percent
FROM public.payments p
JOIN public.subscriptions s ON p.customer_id = s.customer_id
WHERE p.status = 'failed'
GROUP BY s.plan_tier;
