-- ============================================================
-- TOP AT-RISK CUSTOMERS — RETENTION PRIORITY LIST
-- Telecom Customer Churn Analytics Project
-- ============================================================

-- 1. Top 100 highest-risk retained customers (prioritize for outreach)
WITH risk_scores AS (
    SELECT
        customer_id,
        contract,
        internet_service,
        tenure,
        monthly_charges,
        total_charges,
        churn,
        -- Risk scoring model
        (CASE WHEN contract = 'Month-to-month' THEN 40 ELSE 0 END) +
        (CASE WHEN internet_service = 'Fiber optic' THEN 25 ELSE 0 END) +
        (CASE WHEN tenure < 12 THEN 20 WHEN tenure < 24 THEN 10 ELSE 0 END) +
        (CASE WHEN tech_support = 'No' THEN 10 ELSE 0 END) +
        (CASE WHEN online_security = 'No' THEN 5 ELSE 0 END) AS risk_score
    FROM customer_churn
    WHERE churn = 'No'
)
SELECT
    customer_id,
    contract,
    internet_service,
    tenure,
    ROUND(monthly_charges, 2) AS monthly_charges,
    risk_score,
    DENSE_RANK() OVER (ORDER BY risk_score DESC) AS priority_rank,
    CASE
        WHEN risk_score >= 80 THEN 'CRITICAL — Immediate Outreach'
        WHEN risk_score >= 60 THEN 'HIGH — Outreach This Week'
        WHEN risk_score >= 40 THEN 'MEDIUM — Schedule Call'
        ELSE 'LOW — Monitor Monthly'
    END AS action_required
FROM risk_scores
ORDER BY risk_score DESC
LIMIT 100;

-- 2. High-value at-risk customers (highest revenue exposure)
SELECT
    customer_id,
    contract,
    internet_service,
    monthly_charges,
    tenure,
    ROUND(monthly_charges * (72 - tenure), 2) AS potential_remaining_value,
    RANK() OVER (ORDER BY monthly_charges DESC) AS value_rank
FROM customer_churn
WHERE churn = 'No'
  AND contract = 'Month-to-month'
  AND tenure < 24
ORDER BY monthly_charges DESC
LIMIT 50;

-- 3. Churned customers analysis for win-back campaigns
SELECT
    internet_service,
    payment_method,
    COUNT(*) AS churned_customers,
    ROUND(AVG(tenure), 1) AS avg_tenure_at_churn,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_charge,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_lost
FROM customer_churn
WHERE churn = 'Yes'
GROUP BY internet_service, payment_method
ORDER BY total_monthly_lost DESC;
