# Model Explanation — Churn Analysis Methodology

## Analytical Approach

This project uses **Exploratory Data Analysis (EDA)** rather than a predictive model. EDA reveals patterns, distributions, and correlations that directly inform business strategy without requiring the complexity of ML deployment.

### Why EDA First?

Before building a predictive model, EDA:
- Validates data quality and identifies cleaning requirements
- Reveals which features have predictive signal (correlation analysis)
- Identifies business segments for targeted intervention
- Provides interpretable insights for stakeholders
- Guides feature selection for future modeling

### Correlation Analysis Method

1. Binary encode target: `Churn` → 1 (Yes), 0 (No)
2. One-hot encode all categoricals: `pd.get_dummies()`
3. Compute full correlation matrix: `df.corr()`
4. Extract correlations with target: `.corr()['Churn']`
5. Sort and visualize: `.sort_values(ascending=False).plot(kind='bar')`

### Key Predictors Identified (Top Positive Correlation with Churn)

| Feature | Direction | Strength |
|---------|-----------|----------|
| Contract_Month-to-month | Positive | Strong |
| InternetService_Fiber optic | Positive | Moderate-Strong |
| OnlineSecurity_No | Positive | Moderate |
| TechSupport_No | Positive | Moderate |
| PaperlessBilling_Yes | Positive | Moderate |
| SeniorCitizen | Positive | Moderate |

### Key Predictors (Negative Correlation — Protective Factors)

| Feature | Direction | Strength |
|---------|-----------|----------|
| Contract_Two year | Negative | Strong |
| tenure | Negative | Strong |
| Contract_One year | Negative | Moderate |
| InternetService_No | Negative | Moderate |

### Features with Near-Zero Correlation (Not Predictive)

- Gender
- PhoneService
- MultipleLines

---

## Future Modeling Roadmap

### Phase 1: Logistic Regression (Baseline)
- Interpretable coefficients map to business levers
- Good baseline AUC expected (~0.80)
- Output: probability score per customer

### Phase 2: Random Forest
- Captures non-linear interactions (e.g., contract × tenure)
- Feature importance ranking
- Expected AUC improvement to ~0.83–0.85

### Phase 3: Gradient Boosting (XGBoost/LightGBM)
- Best performance expected
- SHAP values for explainability
- Deploy monthly batch scoring against at-risk customer table

### Evaluation Metrics
- **Primary:** AUC-ROC (overall discrimination)
- **Secondary:** Recall (minimize missed churners)
- **Threshold:** Tune precision/recall tradeoff based on retention program capacity
