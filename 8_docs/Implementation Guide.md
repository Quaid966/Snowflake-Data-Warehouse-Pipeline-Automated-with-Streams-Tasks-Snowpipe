# Snowflake Data Warehouse Pipeline Implementation Guide

## Overview
This implementation guide provides step-by-step instructions for setting up an automated data pipeline in Snowflake using modern data engineering practices with streams, tasks, and Snowpipe.

## Prerequisites
- Snowflake account with appropriate privileges
- AWS account with S3 access
- Basic knowledge of SQL and cloud infrastructure

## Architecture Components
- **Bronze Layer**: Raw data ingestion from S3
- **Silver Layer**: Cleaned and validated data
- **Gold Layer**: Business-ready dimensional models
- **Orchestration**: Automated data processing with tasks
- **Monitoring**: Data quality checks and validation

---

## Phase 1: Infrastructure Setup

### 1.1 Create Warehouse
```sql
-- Execute: 1_infrastructure/01_warehouse.sql
-- Creates virtual warehouse for compute resources
```

### 1.2 Create Database
```sql
-- Execute: 1_infrastructure/02_database.sql
-- Establishes main database for the data warehouse
```

### 1.3 Configure Storage Integration

#### AWS IAM Role Setup:
1. Create IAM role in AWS Console
2. Attach policy: `AmazonS3ReadOnlyAccess`
3. Copy the Role ARN for Snowflake configuration

#### S3 Bucket Configuration:
1. Create S3 bucket with name: `your-company-data-lake`
2. Uncheck 'Block all public access' 
3. Create folders: `source_crm/` and `source_erp/`
4. Note bucket location: `s3://your-bucket-name`

#### Snowflake Storage Integration:
```sql
-- Execute: 1_infrastructure/03_storage_integration.sql
-- Creates secure connection between Snowflake and S3
-- Parameters needed:
--   storage_aws_role_arn: [Paste AWS Role ARN]
--   storage_allowed_locations: [Paste S3 bucket location]
```

#### Complete AWS IAM Trust Relationship:
1. Execute: `describe storage integration s3_int;`
2. Copy `STORAGE_AWS_IAM_USER_ARN` and `STORAGE_AWS_EXTERNAL_ID`
3. Update AWS IAM Role Trust Relationship policy:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "STORAGE_AWS_IAM_USER_ARN"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "STORAGE_AWS_EXTERNAL_ID"
        }
      }
    }
  ]
}
```

### 1.4 Create Schemas
```sql
-- Execute: 1_infrastructure/04_schemas.sql
-- Creates organized schema structure for each data layer
```

### 1.5 Create External Stages
```sql
-- Execute: 1_infrastructure/05_external_stages.sql
-- Creates stages for CRM and ERP data sources
-- Replace S3 URLs with your actual bucket paths
```

#### Verification:
```sql
LIST @stage_crm_source;
LIST @stage_erp_source;
-- Successful execution confirms integration is working
```

---

## Phase 2: Bronze Layer (Raw Data Ingestion)

### 2.1 Create Bronze Tables
```sql
-- Execute: 2_bronze/01_tables.sql
-- Creates tables for storing raw, unprocessed data
```

### 2.2 Create Snowpipes for Automated Ingestion
```sql
-- Execute: 2_bronze/02_pipes.sql
-- Creates pipes for automatic data loading from S3
```

#### Configure S3 Event Notifications:
1. For pipe, run: `DESCRIBE PIPE pipe_name;`
2. Copy the `NOTIFICATION_CHANNEL` (SQS ARN)
3. In S3 bucket, create Event Notification:
   - Event types: `s3:ObjectCreated:Put`
   - Destination: SQS Queue
   - SQS Queue ARN: Paste the notification channel

### 2.3 Create Streams for Change Data Capture
```sql
-- Execute: 2_bronze/03_streams.sql
-- Creates streams to track data changes for processing
```

---

## Phase 3: Silver Layer (Cleaned Data)

### 3.1 Create Silver Tables
```sql
-- Execute: 3_silver/01_tables.sql
-- Creates tables for cleaned, validated, and enriched data
```

---

## Phase 4: Gold Layer (Business Data Model)

### 4.1 Create Gold Views
```sql
-- Execute each file in 4_gold/ directory:
-- dim_customers.sql    - Customer dimension view
-- dim_products.sql     - Product dimension view  
-- fact_sales.sql       - Sales fact view
```

---

## Phase 5: Orchestration & Automation

### 5.1 Create Processing Tasks
```sql
-- Execute: 5_orchestration/tasks.sql
-- Creates automated tasks for data pipeline processing
-- Bronze → Silver → Gold data flow automation
```

---

## Phase 6: Security & Access Control

### 6.1 Configure Roles & Permissions
```sql
-- Execute: 6_security/role_user_permissions.sql
-- Creates roles and grants appropriate privileges
-- Implements principle of least privilege
```

---

## Phase 7: Data Quality & Monitoring

### 7.1 Implement Quality Checks
```sql
-- Execute: 7_monitoring/data_quality_checks.sql
-- Creates monitoring views for data quality validation
-- Includes both Silver and Gold layer quality checks
```

---

## Phase 8: Validation & Testing

### 8.1 Data Pipeline Verification
1. Upload sample files to S3 buckets:
   - `s3://your-bucket/source_crm/`
   - `s3://your-bucket/source_erp/`

2. Monitor pipeline execution:
```sql
-- Check pipe status
SELECT SYSTEM$PIPE_STATUS('DWH.BRONZE.PIPE_CRM_CUST_INFO');
SELECT SYSTEM$PIPE_STATUS('DWH.BRONZE.PIPE_ERP_CUST_GEN');

-- Verify data flow
SELECT * FROM DWH.BRONZE.CRM_CUST_INFO LIMIT 10;
SELECT * FROM DWH.SILVER.CRM_CUST_INFO LIMIT 10;
SELECT * FROM DWH.GOLD.DIM_CUSTOMERS LIMIT 10;
```

### 8.2 Quality Assurance
```sql
-- Execute quality checks
SELECT * FROM DWH.MONITORING.VW_GOLD_QUALITY_DASHBOARD;
SELECT * FROM DWH.MONITORING.VW_GOLD_QUALITY_SUMMARY ;
```

---

## Troubleshooting

### Common Issues:

1. **Storage Integration Fails**:
   - Verify IAM role trust relationship
   - Check S3 bucket permissions
   - Confirm external IDs match

2. **Snowpipe Not Loading**:
   - Verify S3 event notifications
   - Check pipe status with `SYSTEM$PIPE_STATUS()`
   - Confirm file format compatibility

3. **Streams Not Capturing Changes**:
   - Check stream latency with `SHOW STREAMS`
   - Verify data is being inserted into source tables

### Monitoring Commands:
```sql
-- Check task execution history
SELECT * FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY());

-- Monitor stream usage
SELECT * FROM TABLE(INFORMATION_SCHEMA.STREAM_HISTORY());

-- Check pipe load history
SELECT * FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
  TABLE_NAME => 'bronze.crm_raw'
));
```

This implementation provides a complete, automated data pipeline from raw S3 data to business-ready analytics views with proper quality monitoring and security controls.
