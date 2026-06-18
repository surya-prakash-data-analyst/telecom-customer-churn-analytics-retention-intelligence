# Project Architecture

## System Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                    DATA INGESTION LAYER                          │
│                                                                  │
│   CustomerChurn.csv (7,043 records, 21 columns)                  │
│   Source: Telecom CRM / billing system export                    │
└────────────────────────┬─────────────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────────────┐
│                    DATA CLEANING LAYER                           │
│                                                                  │
│   Tool: Python / Pandas                                          │
│   ├── Type casting (TotalCharges → numeric)                      │
│   ├── Null detection and removal (11 rows, 0.15%)                │
│   ├── Feature engineering (tenure_group bins)                    │
│   ├── Binary encoding (Churn → 0/1)                              │
│   └── Dummy encoding (categoricals → numeric)                    │
└────────────────────────┬─────────────────────────────────────────┘
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
┌─────────────────────┐   ┌──────────────────────┐
│  PYTHON EDA LAYER   │   │   SQL ANALYSIS LAYER  │
│                     │   │                       │
│  Seaborn / Matplotlib│  │  PostgreSQL / SQLite   │
│  ├── Univariate     │   │  ├── churn_rate_analysis│
│  ├── Bivariate      │   │  ├── segmentation      │
│  ├── KDE plots      │   │  ├── revenue_loss       │
│  ├── Correlation    │   │  ├── CLV analysis       │
│  └── Heatmap        │   │  ├── cohort_analysis    │
└─────────────────────┘   │  ├── top_risk           │
                           │  └── interview_queries  │
                           └──────────────────────────┘
              │                     │
              └──────────┬──────────┘
                         ▼
┌──────────────────────────────────────────────────────────────────┐
│                    INSIGHTS & REPORTING LAYER                    │
│                                                                  │
│   ├── Executive Summary (reports/executive_summary.md)          │
│   ├── Stakeholder Report (reports/stakeholder_report.md)        │
│   ├── Business Recommendations (reports/business_recommendations│
│   └── Final Project Report (reports/final_project_report.md)    │
└────────────────────────┬─────────────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────────────┐
│                    PORTFOLIO / OUTPUT LAYER                      │
│                                                                  │
│   GitHub Repository → Recruiter Review → Job Applications       │
│   Interview Prep → Demo Scripts → Pitch Decks                   │
└──────────────────────────────────────────────────────────────────┘
```

## Technology Decisions

| Layer | Technology | Reason |
|-------|------------|--------|
| Data Storage | CSV/XLS | Simple flat file — no DB required for 7K rows |
| EDA | Python + Jupyter | Industry standard, reproducible, visual |
| SQL | PostgreSQL-compatible | Demonstrates BI/reporting skills |
| Visualization | Seaborn + Matplotlib | Professional, customizable charts |
| Documentation | Markdown | GitHub-native, ATS-readable |
| Version Control | Git/GitHub | Industry standard portfolio hosting |

## Scalability Notes

For production scale-up:
- Replace CSV with PostgreSQL or BigQuery
- Add dbt for SQL transformation layer
- Deploy Streamlit dashboard for interactive exploration
- Schedule monthly automated reports via Apache Airflow
- Add ML scoring pipeline (sklearn → pickle → batch scoring)
