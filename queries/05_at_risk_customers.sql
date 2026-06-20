-- All at-risk customers (meets at least one threshold)
SELECT
  c.customer_id,
  c.company_name,
  c.industry,
  s.plan_tier,
  ROUND(AVG(u.logins), 2) AS avg_logins,
  ROUND(AVG(u.features_used), 2) AS avg_features,
  COUNT(CASE WHEN t.resolved = FALSE THEN 1 END) AS open_tickets
FROM public.customers c
JOIN public.subscriptions s ON c.customer_id = s.customer_id
JOIN public.usage u ON c.customer_id = u.customer_id
LEFT JOIN public.support_tickets t ON c.customer_id = t.customer_id
WHERE s.status = 'active'
AND u.month >= '2024-01-01'
GROUP BY c.customer_id, c.company_name, c.industry, s.plan_tier
HAVING AVG(u.logins) < 5
OR AVG(u.features_used) < 3
OR COUNT(CASE WHEN t.resolved = FALSE THEN 1 END) > 0
ORDER BY open_tickets DESC, avg_logins ASC;
