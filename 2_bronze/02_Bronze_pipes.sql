-- ========================================================
	-- => CREATING PIPE
-- ========================================================
use schema BRONZE;

--	Pipe for crm_cust_info
CREATE OR REPLACE PIPE DWH.BRONZE.pipe_crm_cust_info
AUTO_INGEST = TRUE
AS
COPY INTO DWH.BRONZE.CRM_CUST_INFO (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date,
    _ingest_ts,
    _source_file,
    _file_row_number
)
FROM (
    SELECT
        $1,  -- cst_id
        $2,  -- cst_key
        $3,  -- cst_firstname
        $4,  -- cst_lastname
        $5,  -- cst_marital_status
        $6,  -- cst_gndr
        $7,  -- cst_create_date
        CURRENT_TIMESTAMP,       -- _ingest_ts
        METADATA$FILENAME,       -- _source_file
        METADATA$FILE_ROW_NUMBER -- _file_row_number
    FROM @DWH.BRONZE.crm_stage
)
PATTERN = 'cust_info.*\.csv'
ON_ERROR = CONTINUE;

--	Pipe for crm_prd_info  
CREATE OR REPLACE PIPE DWH.BRONZE.pipe_crm_prd_info
AUTO_INGEST = TRUE
AS
COPY INTO DWH.BRONZE.CRM_PRD_INFO (
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt,
    _ingest_ts,
    _source_file,
    _file_row_number
)
FROM (
    SELECT
        $1,  -- prd_id
        $2,  -- prd_key
        $3,  -- prd_nm
        $4,  -- prd_cost
        $5,  -- prd_line
        $6,  -- prd_start_dt
        $7,  -- prd_end_dt
        CURRENT_TIMESTAMP,       -- _ingest_ts
        METADATA$FILENAME,       -- _source_file
        METADATA$FILE_ROW_NUMBER -- _file_row_number
    FROM @DWH.BRONZE.crm_stage
)
PATTERN = 'prd_info.*\.csv'
ON_ERROR = CONTINUE;

-- crm_sales_details
CREATE OR REPLACE PIPE DWH.BRONZE.pipe_crm_sales_details
AUTO_INGEST = TRUE
AS
COPY INTO DWH.BRONZE.CRM_SALES_DETAILS (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price,
    _ingest_ts,
    _source_file,
    _file_row_number
)
FROM (
    SELECT
        $1,  -- sls_ord_num
        $2,  -- sls_prd_key
        $3,  -- sls_cust_id
        $4,  -- sls_order_dt
        $5,  -- sls_ship_dt
        $6,  -- sls_due_dt
        $7,  -- sls_sales
        $8,  -- sls_quantity
        $9,  -- sls_price
        CURRENT_TIMESTAMP,       -- _ingest_ts
        METADATA$FILENAME,       -- _source_file
        METADATA$FILE_ROW_NUMBER -- _file_row_number
    FROM @DWH.BRONZE.crm_stage
)
PATTERN = 'sales_details.*\.csv'
ON_ERROR = CONTINUE;

-- erp_cust_loc
CREATE OR REPLACE PIPE DWH.BRONZE.pipe_erp_cust_loc
AUTO_INGEST = TRUE
AS
COPY INTO DWH.BRONZE.ERP_CUST_LOC (
    cid,
    cntry,
    _ingest_ts,
    _source_file,
    _file_row_number
)
FROM (
    SELECT
        $1,  -- cid
        $2,  -- cntry
        CURRENT_TIMESTAMP,       -- _ingest_ts
        METADATA$FILENAME,       -- _source_file
        METADATA$FILE_ROW_NUMBER -- _file_row_number
    FROM @DWH.BRONZE.erp_stage
)
PATTERN = 'LOC_A101_.*\.csv'
ON_ERROR = CONTINUE;

--  erp_cust_gen
CREATE OR REPLACE PIPE DWH.BRONZE.pipe_erp_cust_gen
AUTO_INGEST = TRUE
AS
COPY INTO DWH.BRONZE.ERP_CUST_GNDR (
    cid,
    bdate,
    gen,
    _ingest_ts,
    _source_file,
    _file_row_number
)
FROM (
    SELECT
        $1,  -- cid
        $2,  -- bdate
        $3,  -- gen
        CURRENT_TIMESTAMP,       -- _ingest_ts
        METADATA$FILENAME,       -- _source_file
        METADATA$FILE_ROW_NUMBER -- _file_row_number
    FROM @DWH.BRONZE.erp_stage
)
PATTERN = 'CUST_AZ12_.*\.csv'
ON_ERROR = CONTINUE;

--	erp_prd_cat
CREATE OR REPLACE PIPE DWH.BRONZE.pipe_erp_prd_cat
AUTO_INGEST = TRUE
AS
COPY INTO DWH.BRONZE.ERP_PRD_CAT(
    id,
    cat,
    subcat,
    maintenance,
    _ingest_ts,
    _source_file,
    _file_row_number
)
FROM (
    SELECT
        $1,  -- id
        $2,  -- cat
        $3,  -- subcat
        $4,  -- maintenance
        CURRENT_TIMESTAMP,       -- _ingest_ts
        METADATA$FILENAME,       -- _source_file
        METADATA$FILE_ROW_NUMBER -- _file_row_number
    FROM @DWH.BRONZE.erp_stage
)
PATTERN = 'PX_CAT_G1V2_.*\.csv'

ON_ERROR = CONTINUE;
