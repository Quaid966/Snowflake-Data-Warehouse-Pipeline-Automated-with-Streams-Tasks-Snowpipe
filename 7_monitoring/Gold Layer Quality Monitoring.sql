-- =====================================================
-- GOLD LAYER DATA QUALITY MONITORING VIEW
-- Purpose: Comprehensive quality checks for Gold layer
-- dimension and fact tables
-- =====================================================

CREATE OR REPLACE VIEW DWH.gold.VIEW_GOLD_QUALITY_DASHBOARD AS
WITH GOLD_QUALITY_CHECKS AS (
    -- ====================================================================
    -- DIM_CUSTOMERS Quality Checks
    -- ====================================================================
    
    -- Check for Uniqueness of Customer Key
    SELECT 
        'DIM_CUSTOMERS' AS TABLE_NAME,
        'PRIMARY_KEY_UNIQUENESS' AS CHECK_TYPE,
        'Critical' AS SEVERITY,
        COUNT(customer_key) AS TOTAL_RECORDS,
        COUNT(CASE WHEN duplicate_count > 1 THEN 1 END) AS FAILED_RECORDS,
        'DUPLICATE_CUSTOMER_KEYS' AS FAILURE_TYPES,
        CURRENT_TIMESTAMP() AS CHECK_TIMESTAMP
    FROM (
        SELECT 
            customer_key,
            COUNT(*) AS duplicate_count
        FROM DWH.GOLD.DIM_CUSTOMERS
        GROUP BY customer_key
        HAVING COUNT(*) > 1
    )
    
    UNION ALL
    
    -- Check for NULL Customer Keys
    SELECT 
        'DIM_CUSTOMERS',
        'PRIMARY_KEY_NULL_VALUES',
        'Critical',
        COUNT(*),
        COUNT(CASE WHEN customer_key IS NULL THEN 1 END),
        'NULL_CUSTOMER_KEYS',
        CURRENT_TIMESTAMP()
    FROM DWH.GOLD.DIM_CUSTOMERS
    
    -- ====================================================================
    -- DIM_PRODUCTS Quality Checks
    -- ====================================================================
    
    UNION ALL
    
    -- Check for Uniqueness of Product Key
    SELECT 
        'DIM_PRODUCTS',
        'PRIMARY_KEY_UNIQUENESS',
        'Critical',
        COUNT(*),
        COUNT(CASE WHEN duplicate_count > 1 THEN 1 END),
        'DUPLICATE_PRODUCT_KEYS',
        CURRENT_TIMESTAMP()
    FROM (
        SELECT 
            product_key,
            COUNT(*) AS duplicate_count
        FROM DWH.GOLD.DIM_PRODUCTS
        GROUP BY product_key
        HAVING COUNT(*) > 1
    )
    
    UNION ALL
    
    -- Check for NULL Product Keys
    SELECT 
        'DIM_PRODUCTS',
        'PRIMARY_KEY_NULL_VALUES',
        'Critical',
        COUNT(*),
        COUNT(CASE WHEN product_key IS NULL THEN 1 END),
        'NULL_PRODUCT_KEYS',
        CURRENT_TIMESTAMP()
    FROM DWH.GOLD.DIM_PRODUCTS
    
    -- ====================================================================
    -- FACT_SALES Quality Checks
    -- ====================================================================

    UNION ALL

    -- Check Data Model Connectivity (Comprehensive)
    SELECT 
        'FACT_SALES',
        'DATA_MODEL_CONNECTIVITY',
        'Critical',
        COUNT(*),
        COUNT(CASE WHEN c.customer_key IS NULL OR p.product_key IS NULL THEN 1 END),
        'BROKEN_DATA_MODEL_RELATIONSHIPS',
        CURRENT_TIMESTAMP()
    FROM DWH.GOLD.FACT_SALES f
    LEFT JOIN DWH.GOLD.DIM_CUSTOMERS c ON f.customer_key = c.customer_key
    LEFT JOIN DWH.GOLD.DIM_PRODUCTS p ON f.product_key = p.product_key
    WHERE c.customer_key IS NULL OR p.product_key IS NULL
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
    -- Action required based on severity and failure count
    CASE 
        WHEN SEVERITY = 'Critical' AND FAILED_RECORDS > 0 THEN 'IMMEDIATE_ACTION_REQUIRED'
        WHEN SEVERITY = 'High' AND FAILED_RECORDS > 0 THEN 'REVIEW_REQUIRED'
        WHEN SEVERITY IN ('Medium', 'Low') AND FAILED_RECORDS > 0 THEN 'MONITOR'
        ELSE 'HEALTHY'
    END AS ACTION_REQUIRED
FROM GOLD_QUALITY_CHECKS
ORDER BY 
    CASE SEVERITY 
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2 
        WHEN 'Medium' THEN 3
        WHEN 'Low' THEN 4
    END,
    QUALITY_SCORE_PCT ASC,
    TABLE_NAME;

    --select * from DWH.MONITORING.VW_GOLD_QUALITY_DASHBOARD 

    -- =====================================================
-- GOLD LAYER QUALITY SUMMARY DASHBOARD
-- High-level overview of Gold layer data quality
-- =====================================================

CREATE OR REPLACE VIEW DWH.gold.VIEW_GOLD_QUALITY_SUMMARY AS
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
        WHEN AVG(QUALITY_SCORE_PCT) >= 99.5 THEN 'EXCELLENT'
        WHEN AVG(QUALITY_SCORE_PCT) >= 98.0 THEN 'GOOD'
        ELSE 'NEEDS_IMPROVEMENT'
    END AS OVERALL_HEALTH,
    
    MAX(CHECK_TIMESTAMP) AS LAST_CHECKED
    
FROM DWH.MONITORING.VW_GOLD_QUALITY_DASHBOARD
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

-- select 8 FROM DWH.MONITORING.VW_GOLD_QUALITY_SUMMARY