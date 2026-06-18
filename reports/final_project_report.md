# Final Project Report — Telecom Customer Churn Analytics

## 1. Project Overview

This project analyzes customer churn behavior for a telecom provider using a dataset of 7,043 customer records. The analysis uses Python (Pandas, Seaborn, Matplotlib) for EDA, SQL for KPI reporting, and produces actionable business recommendations for a customer retention strategy.

---

## 2. Methodology

### 2.1 Data Collection
- Dataset: `CustomerChurn.csv` — 7,043 rows, 21 columns
- Source: Telecom customer records including demographics, services, charges, and churn status

### 2.2 Data Cleaning
- Converted `TotalCharges` from string to numeric (pandas `to_numeric` with `errors='coerce'`)
- Identified and removed 11 rows with null TotalCharges (0.15% of data — acceptable to drop)
- Engineered `tenure_group` feature: binned into 6 12-month intervals
- Dropped non-predictive `customerID` and raw `tenure` columns after engineering
- Binary-encoded `Churn`: Yes=1, No=0

### 2.3 Exploratory Data Analysis
- Univariate analysis: countplots of all categorical features split by churn
- Bivariate analysis: KDE plots for MonthlyCharges and TotalCharges by churn status
- Correlation analysis: all predictors correlated with `Churn` binary variable
- Heatmap: full correlation matrix to identify collinear features

### 2.4 SQL Analysis
- Built 7 SQL scripts covering: churn rate by segment, customer segmentation, revenue loss, CLV, cohort analysis, at-risk customers, and interview queries
- Used window functions (RANK, DENSE_RANK, LAG, LEAD, NTILE), CTEs, CASE WHEN, aggregations, and subqueries

---

## 3. Results Summary

| Metric | Value |
|--------|-------|
| Total Customers | 7,043 |
| Churn Rate | 26.5% |
| Monthly Revenue Lost | $139,131 |
| Annual Revenue Lost | $1,669,572 |
| Avg Tenure at Churn | 18.0 months |
| Avg Tenure (Retained) | 37.6 months |
| Highest Risk Contract | Month-to-month (42.7% churn) |
| Highest Risk Service | Fiber optic (41.9% churn) |
| Highest Risk Demographic | Senior citizens (41.7% churn) |

---

## 4. Key Insight Hierarchy

Ranked by correlation strength with churn:

1. **Contract type** — Month-to-month: strongest positive correlation with churn
2. **No online security** — Absence of security service correlates strongly with churn
3. **No tech support** — Absence of support correlates strongly with churn
4. **Fiber optic internet** — Fiber optic service positively correlated with churn
5. **Tenure** — Strong negative correlation (longer tenure = lower churn)
6. **Two-year contract** — Strong negative correlation with churn
7. **Gender / Phone service / Multiple lines** — Near-zero correlation (not predictive)

---

## 5. Technical Stack Used

- **Python:** Pandas, NumPy, Matplotlib, Seaborn
- **SQL:** PostgreSQL-compatible queries with CTEs, window functions, CASE WHEN
- **Environment:** Jupyter Notebook
- **Version Control:** Git/GitHub

---

## 6. Limitations

- Dataset is a snapshot in time; no time-series of churn events
- No customer satisfaction scores or support ticket data
- No marketing campaign history to isolate intervention effects
- Class imbalance (73.5% retained vs 26.5% churned) requires attention in any predictive modeling

---

## 7. Conclusion

The analysis confirms that contract type, service type (fiber optic), early tenure, and absence of add-on services are the primary churn drivers. The top recommendation — a contract conversion program targeting month-to-month customers in their first 18 months — has the highest ROI potential and the clearest implementation path.

The data supports an actionable retention strategy that, if successfully executed, could reduce annual churn revenue loss by $1M+ (60–80% improvement).

---

*See `reports/business_recommendations.md` for detailed action plans.*
*See `sql/` for full KPI reporting framework.*
*See `notebooks/Churn_Analysis_EDA.ipynb` for complete Python analysis.*
