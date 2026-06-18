# 2-Minute Pitch — Telecom Churn Analytics

## Script (Practice until natural)

> "This project analyzes why telecom customers leave — and what the business can do about it.
>
> I worked with a dataset of 7,043 customer records. After cleaning the data in Python, I found that 26.5% of customers are churning — translating to $1.67 million in annual revenue loss.
>
> The biggest driver? Contract type. Month-to-month customers churn at 42.7% — fifteen times higher than two-year contract customers at just 2.8%. Fiber optic internet users are another high-risk group at 41.9% churn, despite being the highest-paying customers.
>
> I built a SQL framework with 7 scripts — covering churn rate by segment, customer lifetime value, revenue loss analysis, and a risk-scoring model to prioritize at-risk customers for retention outreach.
>
> The top recommendation is a contract conversion program targeting month-to-month customers in their first 18 months — projected to protect $264,000 in annual revenue.
>
> The tools I used: Python with Pandas and Seaborn for EDA, SQL with CTEs and window functions for KPI analysis, and Jupyter Notebook for the end-to-end workflow. Everything is documented in the GitHub repository."

---

# 5-Minute Presentation Outline

## Slide 1: Business Problem (30 seconds)
- 7,043 customers, 26.5% churn rate
- $1.67M annual revenue loss
- No visibility into who churns or why

## Slide 2: Methodology (45 seconds)
- Data: 7,043 records, 21 columns
- Cleaned: null handling, feature engineering (tenure groups)
- Analyzed: Python EDA + SQL KPI framework

## Slide 3: Key Finding #1 — Contract Type (60 seconds)
- Show contract churn chart
- Month-to-month: 42.7% | One year: 11.3% | Two year: 2.8%
- "This is the single most actionable lever in the dataset"

## Slide 4: Key Finding #2 — Service & Tenure (60 seconds)
- Fiber optic: 41.9% churn
- Avg tenure at churn: 18 months (vs 37.6 retained)
- "Early tenure is the danger window"

## Slide 5: Business Recommendations (60 seconds)
- Priority 1: Contract conversion program → $264K saved
- Priority 2: Early tenure outreach → $240K saved
- Priority 3: Fiber quality improvement → $600K saved
- Combined: $1.36M of $1.67M revenue protected

## Slide 6: Technical Demonstration (45 seconds)
- Show SQL risk-scoring query
- Show correlation chart from notebook
- Mention: CTEs, window functions, CASE WHEN, feature engineering

## Q&A (remaining time)
- Reference `interview/interview_questions.md` for prep
