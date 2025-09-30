-- ========================================================
	=> CREATING TASKS IN TASKS Schema
-- ========================================================

CREATE OR REPLACE TASK DWH.TASKS.TASK_CRM_CUST_INFO_TO_SILVER
WAREHOUSE = ETL_WH
SCHEDULE = '1 MINUTES'  -- every 
WHEN SYSTEM$STREAM_HAS_DATA ('DWH.BRONZE.STREAM_CRM_CUST_INFO')
AS
INSERT INTO DWH.SILVER.CRM_CUST_INFO
SELECT  
    cst_id,
    cst_key,
    TRIM(cst_firstname) as cst_firstname,
    TRIM(cst_lastname) as cst_lastname,
    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'n/a'
    END as cst_marital_status,
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        ELSE 'n/a'
    END as cst_gndr,
    cst_create_date,
    CURRENT_TIMESTAMP
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
    FROM DWH.BRONZE.STREAM_CRM_CUST_INFO
    WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1;


--	Product Info
CREATE OR REPLACE TASK DWH.TASKS.task_crm_prd_info_to_silver
WAREHOUSE = ETL_WH
SCHEDULE = '1 MINUTES'  -- every hour
WHEN SYSTEM$STREAM_HAS_DATA ('DWH.BRONZE.stream_crm_prd_info')
AS
INSERT INTO DWH.SILVER.CRM_PRD_INFO
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
    SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
    prd_nm,
    COALESCE(prd_cost,0) as prd_cost,
    CASE
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END as prd_line,
    CAST(prd_start_dt AS DATE) as prd_start_dt ,
    CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY           prd_start_dt) - 1 AS DATE) AS prd_end_dt,
    -- CURRENT_TIMESTAMP
    CURRENT_TIMESTAMP,   -- populate _ingest_ts
    -- METADATA$FILENAME,   -- populate _source_file
    -- METADATA$FILE_ROW_NUMBER -- populate _file_row_number
FROM DWH.BRONZE.stream_crm_prd_info;



--	Sales Details

CREATE OR REPLACE TASK DWH.TASKS.task_crm_sales_details_to_silver
WAREHOUSE = ETL_WH
SCHEDULE = '2 MINUTES'  -- every hour
WHEN SYSTEM$STREAM_HAS_DATA ('DWH.BRONZE.stream_crm_sales_details')
AS
INSERT INTO DWH.SILVER.crm_sales_details
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::TEXT) <> 8 THEN NULL ELSE CAST(sls_order_dt::TEXT AS DATE) END AS sls_order_dt,
    CASE WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::TEXT) <> 8 THEN NULL ELSE CAST(sls_ship_dt::TEXT AS DATE) END AS sls_ship_dt,
    CASE WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::TEXT) <> 8 THEN NULL ELSE CAST(sls_due_dt::TEXT AS DATE) END AS sls_due_dt,
    CASE 
        WHEN sls_sales <> sls_quantity * ABS(sls_price) OR sls_sales IS NULL OR sls_sales <= 0 
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE 
        WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity,0)
        ELSE sls_price
    END AS sls_price,
    CURRENT_TIMESTAMP
FROM DWH.BRONZE.stream_crm_sales_details;


--	ERP Customer Gender
CREATE OR REPLACE TASK DWH.TASKS.task_erp_cust_gndr_to_silver
WAREHOUSE = ETL_WH
SCHEDULE = '1 MINUTES'  -- every hour
WHEN SYSTEM$STREAM_HAS_DATA ('DWH.BRONZE.stream_erp_cust_gndr')
AS
INSERT INTO DWH.SILVER.ERP_CUST_GNDR
SELECT
    CASE WHEN cid LIKE 'NASA%' THEN SUBSTRING(cid,4,LENGTH(cid)) END AS cid,
    CASE WHEN bdate > CURRENT_DATE THEN NULL ELSE bdate END AS bdate,
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
        WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
        ELSE 'n/a'
    END AS gen,
    CURRENT_TIMESTAMP
FROM DWH.BRONZE.stream_erp_cust_gndr;

	

--	ERP Customer Location
CREATE OR REPLACE TASK DWH.TASKS.task_erp_cust_loc_to_silver
WAREHOUSE = ETL_WH
SCHEDULE = '1 MINUTES'  -- every hour
WHEN SYSTEM$STREAM_HAS_DATA ('DWH.BRONZE.stream_erp_cust_loc')
AS
INSERT INTO DWH.SILVER.ERP_CUST_LOC
SELECT
    REPLACE(cid,'-','') as cid,
    CASE 
        WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry,
    CURRENT_TIMESTAMP
FROM DWH.BRONZE.STREAM_ERP_CUST_LOC;


--	ERP Product Category
CREATE OR REPLACE TASK DWH.TASKS.task_erp_prd_cat_to_silver
WAREHOUSE = ETL_WH
SCHEDULE = '1 MINUTES'  -- every hour
WHEN SYSTEM$STREAM_HAS_DATA ('DWH.BRONZE.stream_erp_prd_cat')
AS
INSERT INTO DWH.SILVER.ERP_PRD_CAT
SELECT
    id,
    cat,
    subcat,
    maintenance,
    CURRENT_TIMESTAMP
FROM DWH.BRONZE.stream_erp_prd_cat;


ALTER TASK DWH.TASKS.task_crm_cust_info_to_silver RESUME;
ALTER TASK DWH.TASKS.task_crm_prd_info_to_silver RESUME;
ALTER TASK DWH.TASKS.task_crm_sales_details_to_silver RESUME;
ALTER TASK DWH.TASKS.task_erp_cust_gndr_to_silver RESUME;
ALTER TASK DWH.TASKS.task_erp_cust_loc_to_silver RESUME;
ALTER TASK DWH.TASKS.task_erp_prd_cat_to_silver RESUME;
