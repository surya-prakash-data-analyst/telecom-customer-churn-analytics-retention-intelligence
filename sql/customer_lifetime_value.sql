-- ============================================================
-- CUSTOMER LIFETIME VALUE (CLV) ANALYSIS
-- Telecom Customer Churn Analytics Project
-- ============================================================

-- 1. Simple CLV = avg monthly charge × avg tenure (months retained)
WITH clv_base AS (
    SELECT
        customer_id,
        contract,
        internet_service,
        tenure,
        monthly_charges,
        total_charges,
        churn,
        monthly_charges * tenure AS estimated_clv
    FROM customer_churn
)
SELECT
    contract,
    ROUND(AVG(estimated_clv), 2) AS avg_clv,
    ROUND(MAX(estimated_clv), 2) AS max_clv,
    ROUND(MIN(estimated_clv), 2) AS min_clv,
    COUNT(*) AS customer_count
FROM clv_base
GROUP BY contract
ORDER BY avg_clv DESC;

-- 2. CLV by risk segment
WITH clv_segmented AS (
    SELECT
        customer_id,
        contract,
        tenure,
        monthly_charges,
        churn,
        monthly_charges * tenure AS estimated_clv,
        CASE
            WHEN contract = 'Two year' THEN 'Premium'
            WHEN contract = 'One year' THEN 'Standard'
            ELSE 'Basic'
        END AS value_tier
    FROM customer_churn
)
SELECT
    value_tier,
    COUNT(*) AS customers,
    ROUND(AVG(estimated_clv), 2) AS avg_clv,
    ROUND(SUM(estimated_clv), 2) AS total_clv,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN estimated_clv ELSE 0 END), 2
    ) AS lost_clv_value
FROM clv_segmented
GROUP BY value_tier
ORDER BY avg_clv DESC;

-- 3. Top 10% of customers by CLV
WITH clv_ranked AS (
    SELECT
        customer_id,
        contract,
        internet_service,
        tenure,
        monthly_charges,
        total_charges AS actual_clv,
        churn,
        NTILE(10) OVER (ORDER BY total_charges DESC) AS clv_decile
    FROM customer_churn
)
SELECT
    clv_decile,
    COUNT(*) AS customers,
    ROUND(AVG(actual_clv), 2) AS avg_clv,
    ROUND(SUM(actual_clv), 2) AS total_clv,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct
FROM clv_ranked
GROUP BY clv_decile
ORDER BY clv_decile;

-- 4. CLV recovery: what is lost when customers churn early
SELECT
    CASE
        WHEN tenure < 12  THEN '< 1 year'
        WHEN tenure < 24  THEN '1-2 years'
        WHEN tenure < 36  THEN '2-3 years'
        WHEN tenure < 60  THEN '3-5 years'
        ELSE '5+ years'
    END AS tenure_band,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
    ROUND(AVG(CASE WHEN churn = 'Yes' THEN total_charges END), 2) AS avg_clv_at_churn,
    ROUND(AVG(monthly_charges) * 36, 2) AS potential_3yr_clv,
    ROUND(AVG(monthly_charges) * 36 - AVG(CASE WHEN churn = 'Yes' THEN total_charges END), 2) AS clv_gap
FROM customer_churn
WHERE churn = 'Yes'
GROUP BY tenure_band
ORDER BY churned_customers DESC;
