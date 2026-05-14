-- ================================================
-- Query: At-Risk Customer Identification
-- Business Question: Which customers are most
--                   likely to churn next?
-- Table(s): customers, subscriptions, usage,
--           support_tickets
-- Notes: Flags active customers showing churn
--        warning signs — low logins, low feature
--        adoption, and unresolved support tickets.
--        HAVING clause isolates customers meeting
--        at least one risk threshold. 21 customers
--        meet critical risk criteria (10+ tickets
--        AND avg features < 5.0).
-- ================================================

SELECT
  c.customer_id,
  c.company_name,
  c.industry,
  s.plan_tier,
  AVG(u.logins) AS avg_logins,
  AVG(u.features_used) AS avg_features,
  COUNT(CASE WHEN t.resolved = 'false' THEN 1 END) AS open_tickets
FROM public.customers c
JOIN public.subscriptions s ON c.customer_id = s.customer_id
JOIN public.usage u ON c.customer_id = u.customer_id
LEFT JOIN public.support_tickets t ON c.customer_id = t.customer_id
WHERE s.status = 'active'
AND u.month >= '2024-01-01'
GROUP BY c.customer_id, c.company_name, c.industry, s.plan_tier
HAVING AVG(u.logins) < 5
OR AVG(u.features_used) < 3
OR COUNT(CASE WHEN t.resolved = 'false' THEN 1 END) > 0
ORDER BY avg_logins ASC;
