# Presentation Slides Outline

## Telecom Customer Churn Analytics — 10-Slide Deck

---

### Slide 1: Title
- Title: Telecom Customer Churn Analytics & Retention Intelligence
- Subtitle: Customer Analytics | Predictive Modeling | Business Intelligence
- Name + date

### Slide 2: Business Problem
- Visual: Revenue funnel showing $1.67M leak
- "7,043 customers. 26.5% churn. $1.67M annual revenue loss."
- One sentence: "This analysis answers: Who churns, why, and how do we stop it?"

### Slide 3: Dataset & Methodology
- 21 features, 7,043 records, 21 columns
- Tools: Python (Pandas, Seaborn), SQL, Jupyter
- Workflow: Clean → EDA → SQL Analysis → Recommendations

### Slide 4: Churn Distribution
- Image: images/01_churn_distribution.png
- 73.5% retained vs 26.5% churned
- Key stat: $74.44 avg monthly charge for churned customers

### Slide 5: Contract Type — #1 Churn Driver
- Image: images/03_contract_analysis.png
- Table: MTM 42.7% | 1-yr 11.3% | 2-yr 2.8%
- "Month-to-month customers churn 15x more than two-year customers"

### Slide 6: Service Type & Tenure
- Image: images/02_tenure_analysis.png
- Fiber optic: 41.9% churn
- Average tenure at churn: 18 months
- "The first 18 months is the retention danger zone"

### Slide 7: Correlation Analysis
- Image: images/correlation_heatmap.png
- Top positive: Contract MTM, Fiber optic, No Security, No Support
- Top negative: Two-year contract, Long tenure
- "Gender, phone service, multiple lines — near-zero impact"

### Slide 8: SQL KPI Framework
- Code snippet from churn_rate_analysis.sql
- Built 7 SQL scripts: churn rate, CLV, segmentation, cohort, revenue loss
- "Risk scoring model identifies which customers to call this week"

### Slide 9: Business Recommendations
- Table: 5 recommendations with revenue impact
- Highlight: Combined $1.36M of $1.67M revenue recoverable
- "3.9x ROI on recommended retention investment"

### Slide 10: Technical Stack & Links
- Python | Pandas | NumPy | Seaborn | Matplotlib
- SQL | CTEs | Window Functions | CASE WHEN
- GitHub: [link] | Contact: [email]
