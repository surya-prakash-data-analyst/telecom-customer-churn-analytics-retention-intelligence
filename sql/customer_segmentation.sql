-- ============================================================
-- CUSTOMER SEGMENTATION
-- Telecom Customer Churn Analytics Project
-- ============================================================

-- 1. Risk segment classification using CASE WHEN
SELECT
    customer_id,
    contract,
    internet_service,
    tenure,
    monthly_charges,
    churn,
    CASE
        WHEN contract = 'Month-to-month' AND internet_service = 'Fiber optic' AND tenure < 12
            THEN 'CRITICAL RISK'
        WHEN contract = 'Month-to-month' AND tenure < 24
            THEN 'HIGH RISK'
        WHEN contract = 'Month-to-month' AND tenure >= 24
            THEN 'MEDIUM RISK'
        WHEN contract = 'One year'
            THEN 'LOW RISK'
        WHEN contract = 'Two year'
            THEN 'MINIMAL RISK'
        ELSE 'REVIEW'
    END AS risk_segment
FROM customer_churn;

-- 2. Segment summary with aggregation
WITH risk_classified AS (
    SELECT
        customer_id,
        contract,
        internet_service,
        tenure,
        monthly_charges,
        churn,
        CASE
            WHEN contract = 'Month-to-month' AND internet_service = 'Fiber optic' AND tenure < 12
                THEN 'CRITICAL RISK'
            WHEN contract = 'Month-to-month' AND tenure < 24
                THEN 'HIGH RISK'
            WHEN contract = 'Month-to-month' AND tenure >= 24
                THEN 'MEDIUM RISK'
            WHEN contract = 'One year'
                THEN 'LOW RISK'
            WHEN contract = 'Two year'
                THEN 'MINIMAL RISK'
            ELSE 'REVIEW'
        END AS risk_segment
    FROM customer_churn
)
SELECT
    risk_segment,
    COUNT(*) AS customer_count,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS actual_churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_charge,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_revenue
FROM risk_classified
GROUP BY risk_segment
ORDER BY churn_rate_pct DESC;

-- 3. Value segment: high-value vs low-value customers
WITH value_segments AS (
    SELECT
        customer_id,
        monthly_charges,
        tenure,
        churn,
        NTILE(4) OVER (ORDER BY monthly_charges) AS charge_quartile,
        NTILE(4) OVER (ORDER BY tenure) AS tenure_quartile
    FROM customer_churn
)
SELECT
    charge_quartile,
    COUNT(*) AS customers,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct,
    DENSE_RANK() OVER (
        ORDER BY 100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) DESC
    ) AS churn_risk_rank
FROM value_segments
GROUP BY charge_quartile
ORDER BY charge_quartile;

-- 4. Multi-dimensional segmentation
SELECT
    contract,
    internet_service,
    CASE WHEN tech_support = 'Yes' THEN 'Has Support' ELSE 'No Support' END AS support_status,
    COUNT(*) AS customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate_pct,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_charge
FROM customer_churn
GROUP BY contract, internet_service, support_status
HAVING COUNT(*) > 20
ORDER BY churn_rate_pct DESC
LIMIT 15;
