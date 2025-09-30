# Snowflake-Data-Warehouse-Pipeline-Automated-with-Streams-Tasks-Snowpipe
![Snowflake](https://img.shields.io/badge/Snowflake-Data%20Platform-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)
![AWS S3](https://img.shields.io/badge/AWS%20S3-Object%20Storage-569A31?style=for-the-badge&logo=amazons3&logoColor=white)
![AWS IAM](https://img.shields.io/badge/AWS%20IAM-Access%20Control-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Medallion Architecture](https://img.shields.io/badge/Medallion%20Architecture-Data%20Layering-FF6B35?style=for-the-badge&logo=layers&logoColor=white)
![ETL](https://img.shields.io/badge/ETL%20Pipeline-Data%20Processing-004880?style=for-the-badge&logo=apacheairflow&logoColor=white)
![Data Quality](https://img.shields.io/badge/Data%20Quality-Validation%20Framework-00A876?style=for-the-badge&logo=sonarqube&logoColor=white)
![CDC](https://img.shields.io/badge/CDC-Stream%20Processing-8A2BE2?style=for-the-badge&logo=git&logoColor=white)
![RBAC](https://img.shields.io/badge/RBAC-Security%20Model-D4AF37?style=for-the-badge&logo=key&logoColor=white)


## 📋 Project Overview

This project establishes a robust Extract, Transform, Load (ETL) pipeline within Snowflake, designed to integrate and process data from both Customer Relationship Management (CRM) and Enterprise Resource Planning (ERP) systems. The primary purpose is to consolidate disparate business data into a unified data warehouse (DWH) with a multi-layered architecture: Bronze, Silver, and Gold. This structure ensures data quality, consistency, and readiness for analytical and reporting purposes.

The pipeline ingests raw data from an S3 bucket (datalake) into the Bronze layer, where it undergoes minimal transformation. Subsequently, data is cleaned, standardized, and integrated in the Silver layer. Finally, the Gold layer provides curated, business-ready data models (fact and dimension tables) optimized for reporting and advanced analytics. The system leverages Snowflake's features such as warehouses, databases, schemas, stages, pipes, streams, and tasks to automate data ingestion, transformation, and quality checks. It also includes role-based access control for data analysts.

## ✨ Features
- **Multi-Layered Data Architecture**: Implements a Medallion Architecture (Bronze, Silver, Gold) for progressive data refinement.
  - **Bronze Layer**: Raw data ingestion from S3, minimal transformations.
  - **Silver Layer**: Cleaned, standardized, and integrated data from CRM and ERP sources.
  - **Gold Layer**: Curated, business-ready data models (dimension and fact tables) for analytics.
- **Automated Data Ingestion**: Utilizes Snowflake Storage Integrations and Pipes for automatic ingestion of CSV files from AWS S3 into the Bronze layer.
- **Data Streaming**: Employs Snowflake Streams to capture changes in Bronze layer tables, triggering subsequent transformations to the Silver layer.
- **Scheduled ETL Tasks**: Orchestrates data transformations from Bronze to Silver using Snowflake Tasks with defined schedules (e.g., every 1 minute).
- **Data Quality Checks**: Includes SQL-based quality checks for the Silver and Gold layers to ensure data integrity, consistency, and accuracy (e.g., null/duplicate primary keys,    unwanted spaces, data standardization, invalid date ranges, referential integrity).
- **CRM Data Processing**: Handles customer information, product details, and sales transaction data from CRM sources.
- **ERP Data Processing**: Manages customer gender, location, and product category data from ERP sources.
- **Data Standardization**: Standardizes data types, formats, and values (e.g., converting marital status codes, gender codes, country abbreviations, date formats).
- **Dimension and Fact Tables**: Creates DIM_CUSTOMERS, DIM_PRODUCTS, and FACT_SALES views in the Gold layer for simplified analytical querying.
- **Role-Based Access Control (RBAC)**: Sets up a data_analyst_team role with specific permissions to access the Gold layer, ensuring secure data access.
- **Warehouse Management**: Defines and uses a dedicated etl_wh warehouse for ETL operations, with auto-suspend and auto-resume capabilities.

## 🧰 Technologies Used
### ☁️ Cloud Storage (AWS)
* **AWS S3** – Raw data lake storage
* **AWS SQS** – Event-driven notifications
* **IAM Role for S3 Integration** – Grants Snowflake secure access to S3

### 🏛️ Cloud Data Warehouse (Snowflake)
* **Snowflake** – Primary cloud data warehouse platform
  * **External Stages** – To reference data in S3
  * **Storage Integration** – Secure connectivity between Snowflake & S3 via IAM role
  * **Snowpipe (Auto-ingest)** – Continuous file ingestion from S3
  * **Streams & Tasks** – Change data capture & orchestration
  * **Views for Gold Layer** – Curated analytical data models

### 🗄️ Data Processing & Modeling
* **SQL / DDL / DML** – Transformations, schema design, and queries
* **Medallion Architecture** – Bronze → Silver → Gold data refinement layers
* **Dimensional Modeling** – Star schema with Fact & Dimension tables
* **ELT Approach** – Extract → Load → Transform methodology
  
## 📋 Prerequisites
- Snowflake account with ACCOUNTADMIN privileges
- AWS account with S3 bucket
- IAM role with S3 access permissions

## 🚀 Installation Instructions
To set up this data pipeline, you will need access to a Snowflake account and an AWS S3 bucket. Follow these steps to deploy the pipeline:
### 1. Snowflake Account Setup:
- Ensure you have an active Snowflake account with appropriate administrative privileges.
### 2. AWS S3 Bucket Configuration:
- Create an S3 bucket (e.g., datalake) to store your raw CRM and ERP data.
- Configure an IAM role in AWS with permissions to access this S3 bucket.
- Note down the ARN of this IAM role, as it will be used to create a Storage Integration in Snowflake.
### 3. Snowflake Objects Deployment:
- The provided SQL script contains all the necessary DDL (Data Definition Language) statements to create the warehouse, database, schemas, stages, pipes, tables, streams, tasks, views, and roles.
- Replace AWS_ROLE_ARN in the CREATE OR REPLACE STORAGE INTEGRATION s3_int statement with the actual ARN of your AWS IAM role.
- Execute the entire SQL script in your Snowflake worksheet.
### 4. Data Ingestion:
- Upload your CRM and ERP CSV files into the datalake S3 bucket, ensuring they are placed in the correct subfolders (e.g., s3://datalake/source_crm/ for CRM data and s3://datalake/source_erp/ for ERP data).
- The Snowflake Pipes, configured with AUTO_INGEST = TRUE, will automatically detect new files in the S3 bucket and ingest them into the respective Bronze layer tables.
### 5. Activate Tasks:
- After deployment, ensure all Snowflake tasks are resumed to enable automated data transformations.

## 📊 Usage
Once the pipeline is set up and data has been ingested and transformed, you can query the curated data models in the DWH.GOLD schema for analytical purposes. The data_analyst_team role has been granted SELECT privileges on these views.
### Example Queries:
1. **Retrieve Customer Information:**
```sql
SELECT * FROM DWH.GOLD.DIM_CUSTOMERS LIMIT 10;
```
Analyze Product Sales:
```sql
SELECT * FROM DWH.GOLD.FACT_SALES LIMIT 10;
```
## 🛠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| Pipe not ingesting data | Check S3 permissions and file formats |
| Task execution failures | Verify stream data and SQL syntax |
| Data quality issues | Review transformation logic in Silver layer |
| Performance problems | Scale warehouse size or optimize queries |

## 📁 Project Structure
```plaintext
Snowflake-Data-Warehouse-Pipeline-Automated-with-Streams-Tasks-Snowpipe/
├── 📂 1_infrastructure/          # Core Snowflake setup
│   ├── 01_warehouse.sql
│   ├── 02_database.sql
│   ├── 03_storage_integration.sql
│   ├── 04_schemas.sql
│   └── 05_pipes.sql
├── 📂 2_bronze/                 # Raw data layer
│   ├── 01_tables.sql
│   ├── 02_stages.sql
│   └── 03_streams.sql
├── 📂 3_silver/                 # Cleaned data layer
│   └── 01_tables.sql
├── 📂 4_gold/                   # Business layer
│   ├── dim_customers.sql
│   ├── dim_products.sql
│   └── fact_sales.sql
├── 📂 5_orchestration/          # ETL automation
│   └── tasks.sql
├── 📂 6_security/               # Access control
│   └── role_user_permissions.sql
├── 📂 7_monitoring/             # Data quality 
│   └── data_quality_checks.sql
├── 📂 8_docs/                   # Documentation
│   ├── data_architecture.png
│   ├── data_flow.png
│   ├── data_integration.png 
│   ├── data_model.png
│   ├── data_dictionary.md
│   └── setup_guide.md
├── 📂 9_Dataset/                # Sample data
│   ├── source_crm/
│   └── source_erp/
└── README.md
```

