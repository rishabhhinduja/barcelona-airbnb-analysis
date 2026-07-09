# 🏘️ Barcelona Airbnb: End-to-End Market Analytics & Data Engineering Pipeline

## 📌 Project Overview
This project is an end-to-end data engineering and analytics pipeline designed to process, model, and analyze 16 years of short-term rental market data from Airbnb Barcelona. The primary objective is to transform raw, heavily nested, and unstructured datasets into a Kimball-compliant Star/Snowflake schema, enabling advanced temporal and financial analysis of real estate assets, host consolidation, and market trends.

*(Note: The data engineering, ETL, and SQL modeling phases are complete. The Power BI Presentation layer is currently in development).*

## 🛠️ Tech Stack & Tools
* **Languages:** Python (Pandas, NumPy), T-SQL
* **Database:** Microsoft SQL Server
* **Visualization (EDA):** Plotly
* **Methodology:** Dimensional Modeling (Star/Snowflake Schema), ETL/ELT pipeline design

---

## 🏗️ Architecture & Engineering Workflow

### Phase 1: Python ETL & Visual EDA
* **Data Wrangling:** Processed raw CSV datasets using `pandas`, handling missing values, standardizing datatypes, and formatting strings.
* **Outlier Detection:** Utilized `plotly` to build interactive box plots, identifying severe skews in listing prices and review counts to inform downstream SQL filters.
* **JSON Explosion:** Engineered custom Python logic to parse and explode nested JSON arrays (e.g., property amenities), flattening them into a 440,000-row relational bridge dataset for granular market filtering.

### Phase 2: Enterprise Database Architecture
* **Schema Design:** Designed and deployed the DDL scripts to create a relational architecture in SQL Server.
* **Data Integrity:** Enforced primary and foreign key constraints, deliberately upgrading specific columns to `BIGINT` to prevent arithmetic overflow from Airbnb's massive ID structures.
* **Bulk Load Pipeline:** Executed efficient bulk insert scripts to load hundreds of thousands of rows from the Python-cleaned flat files directly into the data warehouse.

### Phase 3: Dimensional Modeling & Feature Engineering (Advanced SQL)
* **Dynamic Time Intelligence:** Engineered a T-SQL Stored Procedure to auto-generate a continuous 20-year Date Dimension, enabling robust Year-over-Year (YoY) comparative analysis without relying on static external files.
* **Algorithmic Churn Modeling:** Designed an advanced Common Table Expression (CTE) using `DATEDIFF` logic to calculate the precise historical lifespan of properties, dynamically categorizing them as "Active," "Low Performing," or "Dead" based on transaction gaps.
* **Dimensional Conforming:** Transformed and melted wide, unstructured review categories into a lean metrics table (`Property_Category_Scores`) optimized for front-end visual performance.

### Phase 4: The Presentation Layer
* **Financial Proxy Modeling:** Deployed `vw_fact_reviews` to bake a 70% review-to-booking mathematical proxy directly into the server layer, locking down estimated revenue calculations as a single source of truth.
* **Data Marts:** Created final presentation-layer views (`vw_dim_property`, `vw_dim_host`) to consolidate business logic, safely handle bidirectional filter traps in Snowflake schemas, and prepare the dataset for direct VertiPaq engine ingestion.

---

## 📊 Key Business Insights (SQL EDA)
Before moving to the visualization tool, advanced SQL querying revealed the following market realities:

1. **Market Consolidation:** A single Mega-Host manages over 270 properties, driving an estimated baseline revenue of over 13 Million through strategic asset placement.
2. **Neighborhood Dominance:** The Eixample district holds the highest transaction density, capturing over 660,000 estimated bookings and a minimum revenue floor of 344 Million over a 15-year period.
3. **Property Optimization:** "Entire rental units" vastly outperform private or shared rooms, driving the overwhelming majority of market volume (1 Million+ estimated bookings) and representing the most lucrative asset class.

---

## 🚀 Next Steps
* **Power BI Integration:** Connect the optimized SQL views to Power BI.
* **Dashboard Development:** Build an executive-level interactive dashboard to visualize market concentration, property health statuses, and geographic revenue heatmaps.
