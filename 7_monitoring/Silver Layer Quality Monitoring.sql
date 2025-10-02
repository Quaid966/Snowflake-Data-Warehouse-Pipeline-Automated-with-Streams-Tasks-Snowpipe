-- =====================================================
-- COMPREHENSIVE DATA QUALITY MONITORING VIEW
-- Purpose: Centralized monitoring of all data quality checks
-- across Silver layer tables
-- =====================================================
USE SCHEMA  DWH.MONITORING;
CREATE OR REPLACE VIEW DWH.MONITORING.VW_DATA_QUALITY_DASHBOARD AS
WITH QUALITY_CHECKS AS (
    -- ====================================================================
    -- CRM_CUST_INFO Quality Checks
    -- ====================================================================
    
    -- Primary Key Integrity Check
    SELECT 
        'CRM_CUST_INFO' AS TABLE_NAME,
        'PRIMARY_KEY_INTEGRITY' AS CHECK_TYPE,
        'Critical' AS SEVERITY,
        COUNT(*) AS TOTAL_RECORDS,
        COUNT(CASE WHEN cst_id IS NULL THEN 1 END) AS FAILED_RECORDS,
        LISTAGG(DISTINCT CASE WHEN cst_id IS NULL THEN 'NULL_PRIMARY_KEY' END, ', ') WITHIN GROUP (ORDER BY 1) AS FAILURE_TYPES,
        CURRENT_TIMESTAMP() AS CHECK_TIMESTAMP
    FROM DWH.SILVER.CRM_CUST_INFO
    WHERE cst_id IS NULL
    
    UNION ALL
    
    SELECT 
        'CRM_CUST_INFO',
        'PRIMARY_KEY_DUPLICATES',
        'Critical',
        COUNT(*),
        COUNT(CASE WHEN dup_count > 1 THEN 1 END),
        'DUPLICATE_KEYS',
        CURRENT_TIMESTAMP()
    FROM (
        SELECT cst_id, COUNT(*) as dup_count
        FROM DWH.SILVER.CRM_CUST_INFO
        GROUP BY cst_id
        HAVING COUNT(*) > 1
    )
    
    UNION ALL
    
    -- Data Cleanliness - Unwanted Spaces
    SELECT 
        'CRM_CUST_INFO',
        'DATA_CLEANLINESS_SPACES',
        'Medium',
        COUNT(*),
        COUNT(CASE WHEN cst_key != TRIM(cst_key) OR cst_firstname != TRIM(cst_firstname) OR cst_lastname != TRIM(cst_lastname) THEN 1 END),
        'LEADING_TRAILING_SPACES',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.CRM_CUST_INFO
    
    UNION ALL
    
    -- Data Standardization - Marital Status
    SELECT 
        'CRM_CUST_INFO',
        'DATA_STANDARDIZATION_MARITAL',
        'Low',
        COUNT(*),
        COUNT(CASE WHEN cst_marital_status  not IN  ('Married', 'Single', 'n/a') THEN 1 END),
        'INVALID_MARITAL_STATUS_CODES',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.CRM_CUST_INFO
    
    UNION ALL
    
    -- Data Standardization - Gender
    SELECT 
        'CRM_CUST_INFO',
        'DATA_STANDARDIZATION_GENDER',
        'Low',
        COUNT(*),
        COUNT(CASE WHEN cst_gndr Not IN ('Male', 'Female', 'n/a') THEN 1 END),
        'INVALID_GENDER_CODES',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.CRM_CUST_INFO
    
    -- ====================================================================
    -- CRM_PRD_INFO Quality Checks
    -- ====================================================================
    
    UNION ALL
    
    -- Primary Key Integrity
    SELECT 
        'CRM_PRD_INFO',
        'PRIMARY_KEY_INTEGRITY',
        'Critical',
        COUNT(*),
        COUNT(CASE WHEN prd_id IS NULL THEN 1 END),
        'NULL_PRIMARY_KEY',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.CRM_PRD_INFO
    WHERE prd_id IS NULL
    
    UNION ALL
    
    SELECT 
        'CRM_PRD_INFO',
        'PRIMARY_KEY_DUPLICATES',
        'Critical',
        COUNT(*),
        COUNT(CASE WHEN dup_count > 1 THEN 1 END),
        'DUPLICATE_KEYS',
        CURRENT_TIMESTAMP()
    FROM (
        SELECT prd_id, COUNT(*) as dup_count
        FROM DWH.SILVER.CRM_PRD_INFO
        GROUP BY prd_id
        HAVING COUNT(*) > 1
    )
    
    UNION ALL
    
    -- Business Rule - Cost Validation
    SELECT 
        'CRM_PRD_INFO',
        'BUSINESS_RULE_COST',
        'High',
        COUNT(*),
        COUNT(CASE WHEN prd_cost < 0 OR prd_cost IS NULL THEN 1 END),
        'INVALID_COST_VALUES',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.CRM_PRD_INFO
    
    UNION ALL
    
    -- Date Logic Validation
    SELECT 
        'CRM_PRD_INFO',
        'DATE_LOGIC_VALIDATION',
        'High',
        COUNT(*),
        COUNT(CASE WHEN prd_end_dt < prd_start_dt THEN 1 END),
        'INVALID_DATE_ORDER',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.CRM_PRD_INFO
    
    -- ====================================================================
    -- CRM_SALES_DETAILS Quality Checks
    -- ====================================================================
    
    UNION ALL
    
    -- Date Logic Validation
    SELECT 
        'CRM_SALES_DETAILS',
        'DATE_LOGIC_VALIDATION',
        'High',
        COUNT(*),
        COUNT(CASE WHEN sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt THEN 1 END),
        'INVALID_SALES_DATE_ORDER',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.CRM_SALES_DETAILS
    
    UNION ALL
    
    -- Mathematical Consistency
    SELECT 
        'CRM_SALES_DETAILS',
        'MATHEMATICAL_CONSISTENCY',
        'Critical',
        COUNT(*),
        COUNT(CASE WHEN sls_sales != sls_quantity * sls_price THEN 1 END),
        'SALES_CALCULATION_MISMATCH',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.CRM_SALES_DETAILS
    
    UNION ALL
    
    -- Data Completeness & Positive Values
    SELECT 
        'CRM_SALES_DETAILS',
        'DATA_COMPLETENESS_FINANCIAL',
        'Critical',
        COUNT(*),
        COUNT(CASE WHEN sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL THEN 1 END),
        'NULL_FINANCIAL_VALUES',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.CRM_SALES_DETAILS
    
    UNION ALL
    
    SELECT 
        'CRM_SALES_DETAILS',
        'POSITIVE_VALUE_VALIDATION',
        'High',
        COUNT(*),
        COUNT(CASE WHEN sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0 THEN 1 END),
        'NON_POSITIVE_FINANCIAL_VALUES',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.CRM_SALES_DETAILS
    
    -- ====================================================================
    -- ERP_CUST_GNDR Quality Checks
    -- ====================================================================
    
    UNION ALL
    
    -- Date Range Validation
    SELECT 
        'ERP_CUST_GNDR',
        'DATE_RANGE_VALIDATION',
        'Medium',
        COUNT(*),
        COUNT(CASE WHEN bdate > CURRENT_DATE() THEN 1 END),
        'FUTURE_BIRTH_DATES',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.ERP_CUST_GNDR
    
    UNION ALL
    
    -- Gender Standardization
    SELECT 
        'ERP_CUST_GNDR',
        'DATA_STANDARDIZATION_GENDER',
        'Low',
        COUNT(*),
        COUNT(CASE WHEN gen  Not IN ('Male', 'Female', 'n/a') THEN 1 END),
        'INVALID_GENDER_CODES',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.ERP_CUST_GNDR
    
    -- ====================================================================
    -- ERP_CUST_LOC Quality Checks
    -- ====================================================================
    
    UNION ALL
    
    -- Country Code Standardization
    SELECT 
        'ERP_CUST_LOC',
        'DATA_STANDARDIZATION_COUNTRY',
        'Low',
        COUNT(*),
        COUNT(CASE WHEN  cntry in ('US', 'USA', 'DE','AU' )THEN 1 END),
        'INVALID_COUNTRY_CODE_LENGTH',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.ERP_CUST_LOC
    
    -- ====================================================================
    -- ERP_PRD_CAT Quality Checks
    -- ====================================================================
    
    UNION ALL
    
    -- Data Cleanliness
    SELECT 
        'ERP_PRD_CAT',
        'DATA_CLEANLINESS_SPACES',
        'Medium',
        COUNT(*),
        COUNT(CASE WHEN cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance) THEN 1 END),
        'LEADING_TRAILING_SPACES',
        CURRENT_TIMESTAMP()
    FROM DWH.SILVER.ERP_PRD_CAT
)
SELECT 
    TABLE_NAME,
    CHECK_TYPE,
    SEVERITY,
    TOTAL_RECORDS,
    FAILED_RECORDS,
    CASE 
        WHEN TOTAL_RECORDS = 0 THEN 100.00
        ELSE ROUND((1 - FAILED_RECORDS / NULLIF(TOTAL_RECORDS, 0)) * 100, 2) 
    END AS QUALITY_SCORE_PCT,
    CASE 
        WHEN FAILED_RECORDS = 0 THEN 'PASS'
        WHEN FAILED_RECORDS > 0 AND FAILED_RECORDS <= TOTAL_RECORDS * 0.01 THEN 'WARNING'
        ELSE 'FAIL'
    END AS STATUS,
    FAILURE_TYPES,
    CHECK_TIMESTAMP,
    -- Additional calculated fields for reporting
    CASE 
        WHEN SEVERITY = 'Critical' AND FAILED_RECORDS > 0 THEN 'IMMEDIATE_ACTION_REQUIRED'
        WHEN SEVERITY = 'High' AND FAILED_RECORDS > 0 THEN 'REVIEW_REQUIRED'
        WHEN SEVERITY IN ('Medium', 'Low') AND FAILED_RECORDS > 0 THEN 'MONITOR'
        ELSE 'HEALTHY'
    END AS ACTION_REQUIRED
FROM QUALITY_CHECKS
ORDER BY 
    CASE SEVERITY 
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2 
        WHEN 'Medium' THEN 3
        WHEN 'Low' THEN 4
    END,
    QUALITY_SCORE_PCT ASC,
    TABLE_NAME;

-- =====================================================
-- DATA QUALITY SUMMARY DASHBOARD
-- High-level overview of data quality across all tables
-- =====================================================

CREATE OR REPLACE VIEW DWH.MONITORING.VW_DATA_QUALITY_SUMMARY AS
SELECT 
    TABLE_NAME,
    COUNT(*) AS TOTAL_CHECKS,
    SUM(CASE WHEN STATUS = 'PASS' THEN 1 ELSE 0 END) AS PASSED_CHECKS,
    SUM(CASE WHEN STATUS = 'FAIL' THEN 1 ELSE 0 END) AS FAILED_CHECKS,
    SUM(CASE WHEN STATUS = 'WARNING' THEN 1 ELSE 0 END) AS WARNING_CHECKS,
    ROUND(AVG(QUALITY_SCORE_PCT), 2) AS AVG_QUALITY_SCORE,
    
    -- Severity Breakdown
    COUNT(CASE WHEN SEVERITY = 'Critical' THEN 1 END) AS CRITICAL_CHECKS,
    COUNT(CASE WHEN SEVERITY = 'Critical' AND STATUS = 'FAIL' THEN 1 END) AS CRITICAL_FAILURES,
    
    COUNT(CASE WHEN SEVERITY = 'High' THEN 1 END) AS HIGH_CHECKS,
    COUNT(CASE WHEN SEVERITY = 'High' AND STATUS = 'FAIL' THEN 1 END) AS HIGH_FAILURES,
    
    -- Overall Health Status
    CASE 
        WHEN COUNT(CASE WHEN SEVERITY = 'Critical' AND STATUS = 'FAIL' THEN 1 END) > 0 THEN 'CRITICAL'
        WHEN COUNT(CASE WHEN SEVERITY = 'High' AND STATUS = 'FAIL' THEN 1 END) > 0 THEN 'WARNING'
        WHEN AVG(QUALITY_SCORE_PCT) >= 99.0 THEN 'EXCELLENT'
        WHEN AVG(QUALITY_SCORE_PCT) >= 95.0 THEN 'GOOD'
        ELSE 'NEEDS_IMPROVEMENT'
    END AS OVERALL_HEALTH,
    
    MAX(CHECK_TIMESTAMP) AS LAST_CHECKED
    
FROM DWH.MONITORING.VW_DATA_QUALITY_DASHBOARD
GROUP BY TABLE_NAME
ORDER BY 
    CASE OVERALL_HEALTH
        WHEN 'CRITICAL' THEN 1
        WHEN 'WARNING' THEN 2
        WHEN 'NEEDS_IMPROVEMENT' THEN 3
        WHEN 'GOOD' THEN 4
        WHEN 'EXCELLENT' THEN 5
    END,
    AVG_QUALITY_SCORE ASC;
