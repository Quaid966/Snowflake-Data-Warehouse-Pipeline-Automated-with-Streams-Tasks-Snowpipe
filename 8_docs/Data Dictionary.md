# Data Dictionary

## 📋 Overview
This document provides detailed information about the data models, tables, and fields used in the 'Snowflake Data Warehouse Pipeline Automated with Streams, Tasks & Snowpipe' project following Medallion Architecture.

---

## 🏗️ Architecture Layers

### Bronze Layer (Raw Data)
**Schema**: `DWH.BRONZE`  
**Purpose**: Raw data ingestion from source systems with minimal transformations

### Silver Layer (Cleaned Data) 
**Schema**: `DWH.SILVER`  
**Purpose**: Cleaned, standardized, and validated data

### Gold Layer (Business Data)
**Schema**: `DWH.GOLD`  
**Purpose**: Business-ready dimensional models for analytics

---

## 📊 Bronze Layer Tables

### CRM_CUST_INFO
**Source**: CRM System  
**Description**: Raw customer information from CRM

| Field | Data Type | Description | Source |
|-------|-----------|-------------|---------|
| CST_ID | INTEGER | Customer identifier | CRM System |
| CST_KEY | STRING | Customer key | CRM System |
| CST_FIRSTNAME | STRING | Customer first name | CRM System |
| CST_LASTNAME | STRING | Customer last name | CRM System |
| CST_MARITAL_STATUS | STRING | Marital status code | CRM System |
| CST_GNDR | STRING | Gender code | CRM System |
| CST_CREATE_DATE | STRING | Account creation date | CRM System |
| _INGEST_TS | TIMESTAMP_NTZ | Data ingestion timestamp | System |
| _SOURCE_FILE | STRING | Source file name | S3 File |
| _FILE_ROW_NUMBER | INTEGER | Original file row number | System |

### CRM_PRD_INFO  
**Source**: CRM System  
**Description**: Raw product information from CRM

| Field | Data Type | Description | Source |
|-------|-----------|-------------|---------|
| PRD_ID | INTEGER | Product identifier | CRM System |
| PRD_KEY | STRING | Product key | CRM System |
| PRD_NM | STRING | Product name | CRM System |
| PRD_COST | INTEGER | Product cost | CRM System |
| PRD_LINE | STRING | Product line code | CRM System |
| PRD_START_DT | DATE | Product start date | CRM System |
| PRD_END_DT | DATE | Product end date | CRM System |
| _INGEST_TS | TIMESTAMP_NTZ | Data ingestion timestamp | System |
| _SOURCE_FILE | STRING | Source file name | S3 File |
| _FILE_ROW_NUMBER | INTEGER | Original file row number | System |

### CRM_SALES_DETAILS
**Source**: CRM System  
**Description**: Raw sales transaction data from CRM

| Field | Data Type | Description | Source |
|-------|-----------|-------------|---------|
| SLS_ORD_NUM | STRING | Sales order number | CRM System |
| SLS_PRD_KEY | STRING | Product key | CRM System |
| SLS_CUST_ID | INTEGER | Customer identifier | CRM System |
| SLS_ORDER_DT | INTEGER | Order date (YYYYMMDD) | CRM System |
| SLS_SHIP_DT | INTEGER | Ship date (YYYYMMDD) | CRM System |
| SLS_DUE_DT | INTEGER | Due date (YYYYMMDD) | CRM System |
| SLS_SALES | INTEGER | Sales amount | CRM System |
| SLS_QUANTITY | INTEGER | Quantity sold | CRM System |
| SLS_PRICE | INTEGER | Unit price | CRM System |
| _INGEST_TS | TIMESTAMP_NTZ | Data ingestion timestamp | System |
| _SOURCE_FILE | STRING | Source file name | S3 File |
| _FILE_ROW_NUMBER | INTEGER | Original file row number | System |

### ERP_CUST_GNDR
**Source**: ERP System  
**Description**: Raw customer gender data from ERP

| Field | Data Type | Description | Source |
|-------|-----------|-------------|---------|
| CID | STRING | Customer identifier | ERP System |
| BDATE | DATE | Birth date | ERP System |
| GEN | STRING | Gender code | ERP System |
| _INGEST_TS | TIMESTAMP_NTZ | Data ingestion timestamp | System |
| _SOURCE_FILE | STRING | Source file name | S3 File |
| _FILE_ROW_NUMBER | INTEGER | Original file row number | System |

### ERP_CUST_LOC
**Source**: ERP System  
**Description**: Raw customer location data from ERP

| Field | Data Type | Description | Source |
|-------|-----------|-------------|---------|
| CID | STRING | Customer identifier | ERP System |
| CNTRY | STRING | Country code | ERP System |
| _INGEST_TS | TIMESTAMP_NTZ | Data ingestion timestamp | System |
| _SOURCE_FILE | STRING | Source file name | S3 File |
| _FILE_ROW_NUMBER | INTEGER | Original file row number | System |

### ERP_PRD_CAT
**Source**: ERP System  
**Description**: Raw product category data from ERP

| Field | Data Type | Description | Source |
|-------|-----------|-------------|---------|
| ID | STRING | Product identifier | ERP System |
| CAT | STRING | Category name | ERP System |
| SUBCAT | STRING | Subcategory name | ERP System |
| MAINTENANCE | STRING | Maintenance type | ERP System |
| _INGEST_TS | TIMESTAMP_NTZ | Data ingestion timestamp | System |
| _SOURCE_FILE | STRING | Source file name | S3 File |
| _FILE_ROW_NUMBER | INTEGER | Original file row number | System |

---

## ✨ Silver Layer Tables

### CRM_CUST_INFO
**Description**: Cleaned and standardized customer information

| Field | Data Type | Description | Transformation Rules |
|-------|-----------|-------------|---------------------|
| CST_ID | INTEGER | Customer identifier | Primary key |
| CST_KEY | STRING | Customer key | No transformation |
| CST_FIRSTNAME | STRING | Customer first name | TRIM() |
| CST_LASTNAME | STRING | Customer last name | TRIM() |
| CST_MARITAL_STATUS | STRING | Marital status | M→Married, S→Single |
| CST_GNDR | STRING | Gender | M→Male, F→Female |
| CST_CREATE_DATE | DATE | Account creation date | Convert to DATE |
| _INGESTED_AT | TIMESTAMP_NTZ | Load timestamp | System timestamp |

### CRM_PRD_INFO
**Description**: Cleaned and standardized product information

| Field | Data Type | Description | Transformation Rules |
|-------|-----------|-------------|---------------------|
| PRD_ID | INTEGER | Product identifier | Primary key |
| CAT_ID | STRING | Category identifier | Extract from PRD_KEY |
| PRD_KEY | STRING | Product key | Substring transformation |
| PRD_NM | STRING | Product name | No transformation |
| PRD_COST | INTEGER | Product cost | COALESCE with 0 |
| PRD_LINE | STRING | Product line | M→Mountain, R→Road, S→Other Sales, T→Touring |
| PRD_START_DT | DATE | Product start date | Convert to DATE |
| PRD_END_DT | DATE | Product end date | Calculated end date |
| _INGESTED_AT | TIMESTAMP_NTZ | Load timestamp | System timestamp |

### CRM_SALES_DETAILS
**Description**: Cleaned and validated sales transactions

| Field | Data Type | Description | Transformation Rules |
|-------|-----------|-------------|---------------------|
| SLS_ORD_NUM | STRING | Sales order number | No transformation |
| SLS_PRD_KEY | STRING | Product key | No transformation |
| SLS_CUST_ID | INTEGER | Customer identifier | Foreign key |
| SLS_ORDER_DT | DATE | Order date | Convert from integer |
| SLS_SHIP_DT | DATE | Ship date | Convert from integer |
| SLS_DUE_DT | DATE | Due date | Convert from integer |
| SLS_SALES | INTEGER | Sales amount | Validate calculation |
| SLS_QUANTITY | INTEGER | Quantity sold | No transformation |
| SLS_PRICE | INTEGER | Unit price | Validate calculation |
| _INGESTED_AT | TIMESTAMP_NTZ | Load timestamp | System timestamp |

### ERP_CUST_GNDR
**Description**: Standardized customer gender information

| Field | Data Type | Description | Transformation Rules |
|-------|-----------|-------------|---------------------|
| CID | STRING | Customer identifier | Remove 'NASA' prefix |
| BDATE | DATE | Birth date | Validate not future date |
| GEN | STRING | Gender | Standardize to Male/Female |
| _INGESTED_AT | TIMESTAMP_NTZ | Load timestamp | System timestamp |

### ERP_CUST_LOC
**Description**: Standardized customer location information

| Field | Data Type | Description | Transformation Rules |
|-------|-----------|-------------|---------------------|
| CID | STRING | Customer identifier | Remove hyphens |
| CNTRY | STRING | Country | US→United States, DE→Germany |
| _INGESTED_AT | TIMESTAMP_NTZ | Load timestamp | System timestamp |

### ERP_PRD_CAT
**Description**: Standardized product categorization

| Field | Data Type | Description | Transformation Rules |
|-------|-----------|-------------|---------------------|
| ID | STRING | Product identifier | No transformation |
| CAT | STRING | Category name | TRIM() |
| SUBCAT | STRING | Subcategory name | TRIM() |
| MAINTENANCE | STRING | Maintenance type | TRIM() |
| _INGESTED_AT | TIMESTAMP_NTZ | Load timestamp | System timestamp |

---

## 💎 Gold Layer Views

### DIM_CUSTOMERS
**Description**: Unified customer dimension for analytics

| Field | Data Type | Description | Source Tables |
|-------|-----------|-------------|---------------|
| CUSTOMER_KEY | INTEGER | Surrogate key | Generated sequence |
| CUSTOMER_ID | INTEGER | Customer identifier | CRM_CUST_INFO |
| CUSTOMER_NUMBER | STRING | Customer key | CRM_CUST_INFO |
| FIRST_NAME | STRING | Customer first name | CRM_CUST_INFO |
| LAST_NAME | STRING | Customer last name | CRM_CUST_INFO |
| COUNTRY | STRING | Customer country | ERP_CUST_LOC |
| MARITAL_STATUS | STRING | Marital status | CRM_CUST_INFO |
| GENDER | STRING | Gender | CRM_CUST_INFO, ERP_CUST_GNDR |
| BIRTHDATE | DATE | Birth date | ERP_CUST_GNDR |
| CREATE_DATE | DATE | Account creation date | CRM_CUST_INFO |

### DIM_PRODUCTS
**Description**: Unified product dimension for analytics

| Field | Data Type | Description | Source Tables |
|-------|-----------|-------------|---------------|
| PRODUCT_KEY | INTEGER | Surrogate key | Generated sequence |
| PRODUCT_ID | INTEGER | Product identifier | CRM_PRD_INFO |
| PRODUCT_NUMBER | STRING | Product key | CRM_PRD_INFO |
| PRODUCT_NAME | STRING | Product name | CRM_PRD_INFO |
| CATEGORY_ID | STRING | Category identifier | CRM_PRD_INFO |
| CATEGORY | STRING | Product category | ERP_PRD_CAT |
| SUBCATEGORY | STRING | Product subcategory | ERP_PRD_CAT |
| MAINTENANCE | STRING | Maintenance type | ERP_PRD_CAT |
| COST | INTEGER | Product cost | CRM_PRD_INFO |
| PRODUCT_LINE | STRING | Product line | CRM_PRD_INFO |
| START_DATE | DATE | Product start date | CRM_PRD_INFO |

### FACT_SALES
**Description**: Sales fact table for transactional analysis

| Field | Data Type | Description | Source Tables |
|-------|-----------|-------------|---------------|
| ORDER_NUMBER | STRING | Sales order number | CRM_SALES_DETAILS |
| PRODUCT_KEY | INTEGER | Product foreign key | DIM_PRODUCTS |
| CUSTOMER_KEY | INTEGER | Customer foreign key | DIM_CUSTOMERS |
| ORDER_DATE | DATE | Order date | CRM_SALES_DETAILS |
| SHIPPING_DATE | DATE | Ship date | CRM_SALES_DETAILS |
| DUE_DATE | DATE | Due date | CRM_SALES_DETAILS |
| SALES_AMOUNT | INTEGER | Sales amount | CRM_SALES_DETAILS |
| QUANTITY | INTEGER | Quantity sold | CRM_SALES_DETAILS |
| PRICE | INTEGER | Unit price | CRM_SALES_DETAILS |

---

## 🔍 Data Quality Views

### VIEW_DATA_QUALITY_DASHBOARD
**Purpose**: Monitor data quality across Silver layer

| Field | Data Type | Description |
|-------|-----------|-------------|
| TABLE_NAME | VARCHAR | Name of the table being checked |
| CHECK_TYPE | VARCHAR | Type of quality check |
| SEVERITY | VARCHAR | Critical/High/Medium/Low |
| TOTAL_RECORDS | NUMBER | Total records checked |
| FAILED_RECORDS | NUMBER | Records failing the check |
| QUALITY_SCORE_PCT | NUMBER | Quality score percentage |
| STATUS | VARCHAR | PASS/FAIL/WARNING |
| FAILURE_TYPES | VARCHAR | Description of failures |
| ACTION_REQUIRED | VARCHAR | Recommended action |

### VIEW_GOLD_QUALITY_DASHBOARD  
**Purpose**: Monitor data quality across Gold layer

| Field | Data Type | Description |
|-------|-----------|-------------|
| TABLE_NAME | VARCHAR | Name of the table/view being checked |
| CHECK_TYPE | VARCHAR | Type of quality check |
| SEVERITY | VARCHAR | Critical/High/Medium/Low |
| TOTAL_RECORDS | NUMBER | Total records checked |
| FAILED_RECORDS | NUMBER | Records failing the check |
| QUALITY_SCORE_PCT | NUMBER | Quality score percentage |
| STATUS | VARCHAR | PASS/FAIL/WARNING |
| FAILURE_TYPES | VARCHAR | Description of failures |
| ACTION_REQUIRED | VARCHAR | Recommended action |

---

## 📈 Monitoring Views

### VIEW_DATA_QUALITY_SUMMARY
**Purpose**: Summary of data quality across all tables

| Field | Data Type | Description |
|-------|-----------|-------------|
| TABLE_NAME | VARCHAR | Table name |
| TOTAL_CHECKS | NUMBER | Total quality checks performed |
| PASSED_CHECKS | NUMBER | Checks that passed |
| FAILED_CHECKS | NUMBER | Checks that failed |
| AVG_QUALITY_SCORE | NUMBER | Average quality score |
| OVERALL_HEALTH | VARCHAR | Overall health status |

### VIEW_GOLD_QUALITY_SUMMARY
**Purpose**: Summary of Gold layer data quality

| Field | Data Type | Description |
|-------|-----------|-------------|
| TABLE_NAME | VARCHAR | Gold layer view name |
| TOTAL_CHECKS | NUMBER | Total quality checks |
| PASSED_CHECKS | NUMBER | Checks that passed |
| FAILED_CHECKS | NUMBER | Checks that failed |
| AVG_QUALITY_SCORE | NUMBER | Average quality score |
| OVERALL_HEALTH | VARCHAR | Overall health status |

---
##🔐 Security Roles & Access Control
### **DATA_ANALYST_TEAM** 
**Purpose**: Read-only access to Gold layer and monitoring views
#### 👥 Users Created:
- **ANALYST_JOHN_SMITH** - Senior Data Analyst
- **ANALYST_SARA_CHEN** - Junior Data Analyst
- 
#### ✅ Permissions Granted:
| Permission | Scope | Purpose |
|------------|-------|---------|
| **SELECT** | All Gold layer views (`DIM_CUSTOMERS`, `DIM_PRODUCTS`, `FACT_SALES`) | Business intelligence & reporting |
| **SELECT** | All Monitoring views (data quality dashboards) | Data quality monitoring |
| **USAGE** | `DATA_ANALYST_WH` warehouse | Query execution |
| **USAGE** | `DWH` database | Database access |
| **USAGE** | `DWH.GOLD` schema | Gold layer access |
| **USAGE** | `DWH.MONITORING` schema | Monitoring access |

---

## 📝 Notes

- All timestamps are in TIMESTAMP_NTZ (no timezone) format
- Currency amounts use INTEGER for simplicity in this implementation
- Foreign key relationships are maintained in the Gold layer
- Data lineage is tracked through _INGEST_TS and _SOURCE_FILE fields

---