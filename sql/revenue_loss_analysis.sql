-- ============================================================
-- REVENUE LOSS ANALYSIS
-- Telecom Customer Churn Analytics Project
-- ============================================================

-- 1. Total monthly and annual revenue loss from churned customers
SELECT
    SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END) AS monthly_revenue_lost,
    SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END) * 12 AS annual_revenue_lost,
    SUM(monthly_charges) AS total_monthly_revenue,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END) / SUM(monthly_charges), 2
    ) AS revenue_loss_pct
FROM customer_churn;

-- 2. Revenue loss by contract type
SELECT
    contract,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END), 2) AS monthly_revenue_lost,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END) * 12, 2) AS annual_revenue_lost,
    RANK() OVER (
        ORDER BY SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END) DESC
    ) AS revenue_loss_rank
FROM customer_churn
GROUP BY contract;

-- 3. Revenue at risk — currently retained but high-risk customers (CTE)
WITH high_risk AS (
    SELECT
        customer_id,
        contract,
        internet_service,
        tenure,
        monthly_charges,
        churn,
        CASE
            WHEN contract = 'Month-to-month' AND tenure < 12 THEN 'Highest Risk'
            WHEN contract = 'Month-to-month' AND tenure BETWEEN 12 AND 24 THEN 'High Risk'
            ELSE 'Moderate'
        END AS risk_level
    FROM customer_churn
    WHERE churn = 'No'
)
SELECT
    risk_level,
    COUNT(*) AS at_risk_customers,
    ROUND(SUM(monthly_charges), 2) AS monthly_revenue_at_risk,
    ROUND(SUM(monthly_charges) * 12, 2) AS annual_revenue_at_risk
FROM high_risk
GROUP BY risk_level
ORDER BY annual_revenue_at_risk DESC;

-- 4. Revenue loss by internet service
SELECT
    internet_service,
    SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END) AS monthly_loss,
    ROUND(AVG(CASE WHEN churn = 'Yes' THEN monthly_charges END), 2) AS avg_churner_charge,
    ROUND(AVG(CASE WHEN churn = 'No' THEN monthly_charges END), 2) AS avg_retained_charge
FROM customer_churn
GROUP BY internet_service
ORDER BY monthly_loss DESC;

-- 5. Cumulative revenue contribution by tenure using window functions
WITH tenure_revenue AS (
    SELECT
        tenure,
        SUM(monthly_charges) AS monthly_revenue,
        SUM(total_charges) AS total_lifetime_revenue
    FROM customer_churn
    WHERE churn = 'No'
    GROUP BY tenure
)
SELECT
    tenure,
    monthly_revenue,
    total_lifetime_revenue,
    SUM(total_lifetime_revenue) OVER (ORDER BY tenure) AS cumulative_revenue,
    LAG(total_lifetime_revenue) OVER (ORDER BY tenure) AS prev_tenure_revenue,
    total_lifetime_revenue - LAG(total_lifetime_revenue) OVER (ORDER BY tenure) AS revenue_change
FROM tenure_revenue
ORDER BY tenure;
