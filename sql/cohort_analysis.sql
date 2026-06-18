-- ============================================================
-- COHORT ANALYSIS — CHURN BY TENURE COHORT
-- Telecom Customer Churn Analytics Project
-- ============================================================

-- 1. Assign customers to tenure cohorts
WITH cohorts AS (
    SELECT
        customer_id,
        contract,
        internet_service,
        monthly_charges,
        churn,
        CASE
            WHEN tenure BETWEEN 1 AND 12  THEN 'Cohort 1: 0-1 Year'
            WHEN tenure BETWEEN 13 AND 24 THEN 'Cohort 2: 1-2 Years'
            WHEN tenure BETWEEN 25 AND 36 THEN 'Cohort 3: 2-3 Years'
            WHEN tenure BETWEEN 37 AND 48 THEN 'Cohort 4: 3-4 Years'
            WHEN tenure BETWEEN 49 AND 60 THEN 'Cohort 5: 4-5 Years'
            ELSE                               'Cohort 6: 5+ Years'
        END AS cohort
    FROM customer_churn
)
SELECT
    cohort,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_charge,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END), 2
    ) AS monthly_revenue_lost
FROM cohorts
GROUP BY cohort
ORDER BY cohort;

-- 2. Cohort retention rate (inverse of churn)
WITH cohort_summary AS (
    SELECT
        CASE
            WHEN tenure BETWEEN 1 AND 12  THEN 'Cohort 1: 0-1 Year'
            WHEN tenure BETWEEN 13 AND 24 THEN 'Cohort 2: 1-2 Years'
            WHEN tenure BETWEEN 25 AND 36 THEN 'Cohort 3: 2-3 Years'
            WHEN tenure BETWEEN 37 AND 48 THEN 'Cohort 4: 3-4 Years'
            WHEN tenure BETWEEN 49 AND 60 THEN 'Cohort 5: 4-5 Years'
            ELSE                               'Cohort 6: 5+ Years'
        END AS cohort,
        churn,
        monthly_charges
    FROM customer_churn
)
SELECT
    cohort,
    COUNT(*) AS total,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'No' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS retention_rate_pct,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct,
    -- Compare this cohort's retention vs overall avg using window function
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'No' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) - AVG(
        100.0 * SUM(CASE WHEN churn = 'No' THEN 1 ELSE 0 END) / COUNT(*)
    ) OVER () AS retention_vs_avg
FROM cohort_summary
GROUP BY cohort
ORDER BY cohort;

-- 3. Contract upgrade pathway: cohort churn by contract
SELECT
    CASE
        WHEN tenure BETWEEN 1 AND 12  THEN '0-1 Year'
        WHEN tenure BETWEEN 13 AND 36 THEN '1-3 Years'
        ELSE '3+ Years'
    END AS tenure_band,
    contract,
    COUNT(*) AS customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct,
    LEAD(
        ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2)
    ) OVER (PARTITION BY contract ORDER BY MIN(tenure)) AS next_cohort_churn
FROM customer_churn
GROUP BY tenure_band, contract
ORDER BY tenure_band, churn_rate_pct DESC;
