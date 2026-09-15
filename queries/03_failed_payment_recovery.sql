-- ================================================
-- Query 3: Failed Payment Recovery by Plan Tier
-- Business Question: When payments fail, are we
--                   recovering the money?
-- Table(s): payments, subscriptions

SELECT
  s.plan_tier,
  COUNT(*) AS total_failed,
  COUNT(CASE WHEN p.recovered = TRUE THEN 1 END) AS recovered_count,
  ROUND(
    100.0 * COUNT(CASE WHEN p.recovered = TRUE THEN 1 END) / COUNT(*),
  2) AS recovery_rate_percent
FROM public.payments p
JOIN public.subscriptions s ON p.customer_id = s.customer_id
WHERE p.status = 'failed'
GROUP BY s.plan_tier
ORDER BY recovery_rate_percent DESC;
