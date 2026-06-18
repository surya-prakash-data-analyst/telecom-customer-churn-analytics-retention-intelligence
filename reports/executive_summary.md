# Executive Summary — Telecom Customer Churn Analytics

**Project:** Telecom Customer Churn Analytics & Retention Intelligence
**Date:** 2024
**Analyst:** Data Analytics Portfolio Project

---

## The Problem

A mid-size telecom provider with 7,043 active customers is losing **26.5% of its customer base annually** — equivalent to 1,869 customers. At an average monthly charge of $74.44 per churned customer, this translates to:

- **Monthly Revenue Loss:** $139,131
- **Annual Revenue Loss:** $1,669,572

This analysis was conducted to identify who is churning, why, and what retention actions will have the greatest business impact.

---

## Key Findings

### 1. Contract Type is the Strongest Churn Driver
- Month-to-month customers churn at **42.7%** — 15x higher than two-year contract customers (2.8%)
- 55% of the customer base is on month-to-month contracts, creating significant revenue exposure

### 2. Fiber Optic Customers Are High-Value and High-Risk
- Fiber optic customers have the highest monthly charges (~$80–90) but churn at **41.9%**
- This represents the highest revenue-loss segment due to the combination of high charges + high churn

### 3. Early Tenure is the Danger Window
- Average tenure at churn: **18.0 months** vs 37.6 months for retained customers
- Customers in their first 12–18 months are at maximum risk

### 4. Senior Citizens Need Dedicated Retention Programs
- Senior citizen churn rate: **41.7%** vs 26.5% overall
- Possible causes: complexity of service, pricing sensitivity, lack of tech support

### 5. Add-On Services Reduce Churn Significantly
- Customers without Online Security or Tech Support churn at approximately 2x the rate of customers with these services
- These add-ons create "stickiness" that improves retention

---

## Recommended Actions

| Priority | Action | Expected Outcome |
|----------|--------|-----------------|
| 🔴 1 | Offer discounted annual plan to month-to-month customers in months 1–18 | Reduce MTM churn 20–30% |
| 🔴 2 | Implement automated early-tenure outreach (months 6, 12, 18) | Intervene before churn decision |
| 🟡 3 | Audit fiber optic service quality; implement SLA improvement | Reduce fiber churn from 41.9% |
| 🟡 4 | Bundle OnlineSecurity + TechSupport at onboarding (free for 3 months) | Increase add-on adoption |
| 🟢 5 | Senior citizen simplified plan + dedicated support | Reduce 41.7% senior churn |

---

## Financial Impact of Recommendations

If the top two actions reduce month-to-month churn by 25%:
- Customers saved: ~500 per year
- Revenue protected: ~$37,000/month, ~$444,000/year

This represents a **26% reduction in annual revenue loss** from churn.

---

*Full analysis: see `notebooks/Churn_Analysis_EDA.ipynb` and `reports/final_project_report.md`*
