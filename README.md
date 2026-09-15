#  SaaS Revenue & Retention Analytics Dashboard

**Stack:** PostgreSQL (Supabase) · Metabase · SQL
**Data range:** January 2023 – May 2024
**Dataset:** 500 synthetic customers · 5 tables · 14,000+ rows

## About This Project

For this project I built a fictional SaaS company called TitanTrack, kind of modeled after ServiceTitan, that serves home service contractors (HVAC, roofing, plumbing, electrical). I made up the data myself in Python so I could practice working with a realistic multi-table dataset instead of just a single CSV.

The question I wanted the dashboard to answer:

> Where is this company losing money, and what could actually be done about it?

## The Business Questions

I tried to build every query around a question I think a real SaaS founder or ops person would actually want answered, not just "can I write this query."

| # | Business Question | Query |
|---|---|---|
| 1 | Is revenue growing or shrinking? | MRR by Month |
| 2 | Are we losing customers, and how fast? | Churn Rate by Month |
| 3 | When payments fail, are we getting that money back? | Failed Payment Recovery by Plan Tier |
| 4 | Which plan tier is losing the most revenue? | Revenue Leakage by Plan Tier |
| 5 | Which customers look like they're about to churn? | At-Risk Customer Identification |

## What I Found

**MRR — growing overall, but pretty bumpy month to month**
MRR ranged from $17,866 to $26,453 over the time period, and the overall trend goes up, which is good. But it's not a smooth line up — there's a decent amount of up-and-down between months. (I want to go back and actually calculate the average month-over-month % change instead of eyeballing it, so treat that specific number as a TODO for now rather than something I've confirmed.) My guess is that new customers were signing up, but churn was inconsistent enough to cancel out a lot of that growth some months.

*What I'd recommend:* Focus more on keeping existing customers than on getting new ones. It seems like reducing churn even a little would matter more than growing the customer base at this point.

**Churn — spikes that don't look seasonal**
Most months, churn stayed between 1.75–3.51%, but there were two big spikes: 8.77% in August 2023 and 12.28% in March 2024. Since they don't line up with any obvious season or pattern, I don't think there's one clean thing to fix — it's probably a few different things going wrong at different times.

*What I'd recommend:* Some kind of early warning system that looks at usage and support tickets, so the company can catch unhappy customers before they actually leave instead of just finding out after they're gone.

**Failed payment recovery — feels like a company-wide issue, not a tier thing**
Recovery rates were really close across all three tiers: Growth 58.67%, Pro 64.97%, Starter 56.59%. Since they're all in a similar range, I don't think this is a "one tier has a problem" situation — it looks more like the whole payment recovery process (dunning emails, retry logic, whatever they're doing) just isn't working that well for anyone, and somewhere around 35-43% of failed payments across the board are never recovered.

*What I'd recommend:* Look at fixing the recovery process for the whole company at once rather than tier by tier. Even a 10% improvement here would add up — I estimated around $4K/month in recovered revenue — and every customer who falls through this crack is real lost revenue every single month.

**Revenue leakage — Growth tier seems like the biggest problem**
Growth tier lost the most total revenue: $11,477 across 23 churned customers (about $499 each). Pro tier lost less overall ($9,990) even though each Pro customer is worth almost 2x as much. So Growth is kind of the worst combo — a lot of customers leaving, and each one is worth a decent amount of money.

*What I'd recommend:* A retention program specifically for Growth tier customers. Based on the numbers, cutting Growth churn by even 30% would recover more money than getting rid of all Starter tier churn entirely.

**At-risk customers — trying to be proactive instead of reactive**
I flagged customers as "at-risk" if they had: average logins below 5, average features used below 3, or any open support tickets.

That flagged 231 customers total. Of those, 21 hit a more serious threshold — 10+ open tickets AND feature usage under 5.0, which to me signals someone who's both frustrated and checked out. Growth tier had the most at-risk customers (85). 14 customers were really disengaged (feature usage under 4.0), including 3 Pro accounts, which matter more because Pro customers pay the most.

*What I'd recommend:* Reach out to those 3 at-risk Pro accounts first. They're each worth $999/month, so saving even one of them basically pays for the whole retention effort.

## Dashboard 

![Churn Rate by Month](screenshots/churn_rate_by_month.png)
*Churn spiked to 12.28% in March 2024, the highest recorded rate. Non-seasonal pattern indicates no single fixable trigger.*

![Failed Payment Recovery by Plan Tier](screenshots/failed_payment_recovery.png)
*Recovery rates consistent across tiers (57–65%), revealing a systemic dunning gap rather than a tier specific problem.*

![Revenue Leakage by Plan Tier](screenshots/revenue_leakage.png)
*Growth tier leads in total lost revenue ($11,477) despite Pro customers having nearly 2x the individual contract value.*



## SQL Queries

```
queries/
├── 01_mrr_by_month.sql
├── 02_churn_rate_by_month.sql
├── 03_failed_payment_recovery.sql
├── 04_revenue_leakage_by_plan_tier.sql
└── 05_at_risk_customers.sql
```

## Data Model

5 tables, all in PostgreSQL via Supabase:

| Table | Rows | What's in it |
|---|---|---|
| customers | 500 | Company name, industry, plan tier, signup date |
| subscriptions | 500 | Plan tier, MRR, status, churn date |
| payments | ~5,865 | Payment attempts, status, whether it was recovered |
| usage | ~5,787 | Monthly logins and features used per customer |
| support_tickets | ~1,549 | Open ticket count per customer |

I generated this synthetically in Python, but I tried to build in patterns that would show up in real data, like usage dropping off before someone churns.

## Sample Dataset

The at-risk customer list from Query 5 is in `/data`:

```
data/at_risk_customers_may_2024.csv
```

231 flagged customers, with these fields:

- `customer_id`
- `company_name`
- `industry` — HVAC, roofing, plumbing, or electrical
- `plan_tier` — Starter, Growth, or Pro
- `avg_logins`
- `avg_features`
- `open_tickets`

## A Few Notes on the Data

- I excluded January 2024 MRR from the trend chart since it's a partial month right at the edge of the dataset.
- Same with June 2024 churn — partial month, and including it made the churn rate look way higher than it should.
- The at-risk list is a snapshot from May 5, 2024, not something that updates live.

## Tools I Used

- **Supabase** — hosted the PostgreSQL database and I used its SQL editor
- **Metabase** — for the dashboard and charts
- **SQL** — all the actual analysis
- **Python** — to generate the synthetic dataset




