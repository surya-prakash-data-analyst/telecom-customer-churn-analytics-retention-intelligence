-- ============================================================
-- INTERVIEW QUERIES — Common SQL Interview Questions
-- Solved using this Churn Analytics project dataset
-- ============================================================

-- Q1. Find duplicate customer IDs
SELECT customer_id, COUNT(*) AS occurrences
FROM customer_churn
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Q2. Second highest monthly charge
SELECT MAX(monthly_charges) AS second_highest
FROM customer_churn
WHERE monthly_charges < (SELECT MAX(monthly_charges) FROM customer_churn);

-- Q3. Customers who pay above average monthly charges
SELECT customer_id, monthly_charges
FROM customer_churn
WHERE monthly_charges > (SELECT AVG(monthly_charges) FROM customer_churn)
ORDER BY monthly_charges DESC;

-- Q4. Running total of monthly charges by tenure using window function
SELECT
    tenure,
    monthly_charges,
    SUM(monthly_charges) OVER (ORDER BY tenure ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM customer_churn
ORDER BY tenure
LIMIT 20;

-- Q5. Rank customers by monthly charges within each contract type
SELECT
    customer_id,
    contract,
    monthly_charges,
    RANK() OVER (PARTITION BY contract ORDER BY monthly_charges DESC) AS charge_rank
FROM customer_churn;

-- Q6. Year-over-year comparison equivalent — tenure-based
SELECT
    CASE WHEN tenure <= 36 THEN 'First 3 Years' ELSE 'Beyond 3 Years' END AS period,
    COUNT(*) AS customers,
    ROUND(AVG(monthly_charges), 2) AS avg_charge,
    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer_churn
GROUP BY period;

-- Q7. Churn rate change between contract types using LAG
WITH contract_churn AS (
    SELECT
        contract,
        ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_pct
    FROM customer_churn
    GROUP BY contract
)
SELECT
    contract,
    churn_pct,
    LAG(churn_pct) OVER (ORDER BY churn_pct DESC) AS prev_contract_churn,
    churn_pct - LAG(churn_pct) OVER (ORDER BY churn_pct DESC) AS churn_diff
FROM contract_churn;

-- Q8. SELF JOIN — customers with same contract and similar charges
SELECT
    a.customer_id AS customer_a,
    b.customer_id AS customer_b,
    a.contract,
    a.monthly_charges AS charges_a,
    b.monthly_charges AS charges_b
FROM customer_churn a
JOIN customer_churn b
    ON a.contract = b.contract
    AND ABS(a.monthly_charges - b.monthly_charges) < 1
    AND a.customer_id < b.customer_id
LIMIT 10;

-- Q9. Customers with all add-on services (subquery)
SELECT customer_id, monthly_charges, churn
FROM customer_churn
WHERE customer_id IN (
    SELECT customer_id
    FROM customer_churn
    WHERE online_security = 'Yes'
      AND online_backup = 'Yes'
      AND device_protection = 'Yes'
      AND tech_support = 'Yes'
);

-- Q10. Pivot-style churn rate by contract and internet service
SELECT
    internet_service,
    ROUND(100.0 * SUM(CASE WHEN contract = 'Month-to-month' AND churn = 'Yes' THEN 1 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN contract = 'Month-to-month' THEN 1 ELSE 0 END), 0), 2) AS mtm_churn_pct,
    ROUND(100.0 * SUM(CASE WHEN contract = 'One year' AND churn = 'Yes' THEN 1 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN contract = 'One year' THEN 1 ELSE 0 END), 0), 2) AS one_yr_churn_pct,
    ROUND(100.0 * SUM(CASE WHEN contract = 'Two year' AND churn = 'Yes' THEN 1 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN contract = 'Two year' THEN 1 ELSE 0 END), 0), 2) AS two_yr_churn_pct
FROM customer_churn
GROUP BY internet_service;
