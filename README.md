# sql_expand_business
Analysis of expanding to Brazil Market
___
# Eniac Brazil Market Expansion Analysis

# Project Overview
Eniac is a Spain-founded online marketplace specializing in Apple products and curated premium accessories, distinguished by its personalized and human-centered tech support. Following its IPO, the company faces strong investor pressure to scale globally while preserving its customer-first identity. To support this growth, a Data Department was created to strengthen data infrastructure and enable data-driven decision-making. The team includes a Head of Data, a Data Scientist building a recommender system, and a Data Analyst bridging data and business. The project aims to drive scalable growth, enhance cross-selling, and align analytics with Eniac’s overall business strategy.

# 📊 Dataset & Sources
**Source**: Magist Brazilian eCommerce Public Dataset (Olist) – available on Kaggle\

**Size**: ~100,000 orders, 9 main tables, 30+ features, covering the period from 2016 to 2018\
**Key Features**:
  -  order_id, customer_id, order_status
  -  order_purchase_timestamp, order_delivered_customer_date
  -  price, freight_value
  -  product_category_name
  -  payment_type, payment_value
  -  customer_state

**Notes**:
- Data stored across multiple relational tables (required joins).
- Missing values in delivery dates for canceled or unavailable orders.
- Product categories originally in Portuguese (translation required).
- Outliers in freight cost and delivery time cleaned for analysis.
- Time-based fields converted to datetime format for trend analysis.

# Key Findings & Results
**Strong overall market**, weak premium segment: While Magist generated €13.6M total revenue (2016–2018), the Tech segment contributed only €1.6M, indicating limited traction in higher-value categories.
**Significant price mismatch**: Eniac’s average item price is €540, whereas Magist’s tech average is only €102 — a gap of over 5x, suggesting weak demand for premium products in the current market.
**Operationally reliable logistics**: Average delivery time is 12.5 days, outperforming the estimated 23.4 days, indicating strong logistics execution and service reliability.
**Limited scalability signal in premium tech**: Only 444 tech sellers and 15.4K tech products sold over two years suggest that high-end tech demand remains niche.
**High external risk exposure**: 2018 macroeconomic instability, currency volatility, and weak consumer purchasing power increase financial and brand risk for immediate entry.
## Business Impact
Brazil is a large and attractive long-term opportunity, but current premium demand and economic instability make immediate expansion high risk. A delayed entry preserves capital and brand positioning while monitoring market recovery signals.

## 🛠️ Technologies Used
**Programming**:
- SQL\
**Tools**:
- SQL environment (for querying and aggregation)
- Spreadsheet software (for tabular analysis and reporting)\
**Approach**:
- Relational data analysis using SQL (joins, aggregations, filtering, grouping)
- Exploratory data analysis through structured tables

 # **How to Use This Project**
## Main Analysis:
Review the core SQL analysis inside /queries/exploratory_analysis.sql.
If included, open /notebooks/market_analysis.ipynb for a structured business walkthrough of the findings.
## Data:
Use the dataset provided in the /data folder.
Ensure all tables are imported into your SQL environment before running queries.
## Run the Analysis:
Open your preferred SQL tool (MySQL, PostgreSQL, or similar).
Import the raw tables.
Execute the queries in the /queries folder step by step.
Export results if you want to recreate the visualisations.
## Reproducing Visualisations:
Use the aggregated query outputs.
Recreate charts in Excel, Google Sheets, or a notebook environment.
Match the metrics shown in the /images folder.
## Dependencies:
SQL-compatible database environment
Spreadsheet software (for charts and reporting)
No additional libraries or advanced setup required
For best understanding, start with the README.md, then review the SQL queries to see how each business insight was derived
- Domain research on Brazilian eCommerce market conditions, macroeconomic risks, and premium tech demand to support business conclusions\
Focus was placed on extracting business insights directly from structured data rather than building predictive models.
