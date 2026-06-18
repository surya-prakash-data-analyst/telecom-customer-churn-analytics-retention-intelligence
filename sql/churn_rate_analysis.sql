-- ============================================================
-- CHURN RATE ANALYSIS
-- Telecom Customer Churn Analytics Project
-- ============================================================

-- 1. Overall churn rate
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct
FROM customer_churn;

-- 2. Churn rate by contract type
SELECT
    contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct,
    RANK() OVER (ORDER BY
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) DESC
    ) AS risk_rank
FROM customer_churn
GROUP BY contract
ORDER BY churn_rate_pct DESC;

-- 3. Churn rate by internet service type
SELECT
    internet_service,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct
FROM customer_churn
GROUP BY internet_service
ORDER BY churn_rate_pct DESC;

-- 4. Churn rate by tenure group (CTE)
WITH tenure_buckets AS (
    SELECT
        *,
        CASE
            WHEN tenure BETWEEN 1 AND 12   THEN '1-12 months'
            WHEN tenure BETWEEN 13 AND 24  THEN '13-24 months'
            WHEN tenure BETWEEN 25 AND 36  THEN '25-36 months'
            WHEN tenure BETWEEN 37 AND 48  THEN '37-48 months'
            WHEN tenure BETWEEN 49 AND 60  THEN '49-60 months'
            WHEN tenure BETWEEN 61 AND 72  THEN '61-72 months'
        END AS tenure_group
    FROM customer_churn
)
SELECT
    tenure_group,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct
FROM tenure_buckets
GROUP BY tenure_group
ORDER BY tenure_group;

-- 5. Churn rate by payment method
SELECT
    payment_method,
    COUNT(*) AS customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct
FROM customer_churn
GROUP BY payment_method
ORDER BY churn_rate_pct DESC;

-- 6. Senior citizen churn vs non-senior
SELECT
    CASE WHEN senior_citizen = 1 THEN 'Senior' ELSE 'Non-Senior' END AS segment,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct
FROM customer_churn
GROUP BY senior_citizen;

-- 7. Monthly churn trend using window function
WITH monthly_data AS (
    SELECT
        contract,
        churn,
        monthly_charges,
        AVG(monthly_charges) OVER (PARTITION BY contract) AS avg_charge_by_contract,
        AVG(monthly_charges) OVER () AS overall_avg_charge
    FROM customer_churn
)
SELECT DISTINCT
    contract,
    ROUND(avg_charge_by_contract, 2) AS avg_contract_charge,
    ROUND(overall_avg_charge, 2) AS overall_avg,
    ROUND(avg_charge_by_contract - overall_avg_charge, 2) AS charge_vs_avg
FROM monthly_data
ORDER BY avg_contract_charge DESC;
