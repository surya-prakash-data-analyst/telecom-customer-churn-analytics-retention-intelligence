# Data Dictionary — CustomerChurn Dataset

## Dataset: CustomerChurn.csv
- **Records:** 7,043 customers
- **Features:** 21 columns
- **Target:** `Churn` (Yes/No)

## Column Definitions

| Column | Type | Values | Description |
|--------|------|--------|-------------|
| customerID | String | Unique ID | Customer identifier (dropped in modeling) |
| gender | Categorical | Male, Female | Customer gender |
| SeniorCitizen | Binary | 0, 1 | 1 = customer is 65+ years old |
| Partner | Categorical | Yes, No | Has a partner/spouse |
| Dependents | Categorical | Yes, No | Has dependents (children, parents, etc.) |
| tenure | Integer | 0–72 | Months as a customer |
| PhoneService | Categorical | Yes, No | Subscribed to phone service |
| MultipleLines | Categorical | Yes, No, No phone service | Multiple phone lines |
| InternetService | Categorical | DSL, Fiber optic, No | Internet service type |
| OnlineSecurity | Categorical | Yes, No, No internet service | Online security add-on |
| OnlineBackup | Categorical | Yes, No, No internet service | Online backup add-on |
| DeviceProtection | Categorical | Yes, No, No internet service | Device protection add-on |
| TechSupport | Categorical | Yes, No, No internet service | Tech support add-on |
| StreamingTV | Categorical | Yes, No, No internet service | TV streaming service |
| StreamingMovies | Categorical | Yes, No, No internet service | Movie streaming service |
| Contract | Categorical | Month-to-month, One year, Two year | Contract duration |
| PaperlessBilling | Categorical | Yes, No | Enrolled in paperless billing |
| PaymentMethod | Categorical | Electronic check, Mailed check, Bank transfer, Credit card | Payment method |
| MonthlyCharges | Float | $18.25–$118.75 | Monthly bill amount |
| TotalCharges | Float | $18.80–$8,684.80 | Total charges over tenure |
| Churn | Categorical | Yes, No | **TARGET: Did customer leave?** |

## Engineered Features

| Column | Description |
|--------|-------------|
| tenure_group | Tenure binned into 6 groups: 1-12, 13-24, 25-36, 37-48, 49-60, 61-72 months |
| Churn_binary | Churn encoded as 1 (Yes) and 0 (No) for correlation analysis |

## Key Statistics

| Metric | Value |
|--------|-------|
| Total Records | 7,043 |
| Missing Values (TotalCharges) | 11 (0.15%) — dropped |
| Churn Rate | 26.5% |
| Avg Monthly Charges | $64.76 |
| Avg Tenure | 32.4 months |
| Max Tenure | 72 months |
