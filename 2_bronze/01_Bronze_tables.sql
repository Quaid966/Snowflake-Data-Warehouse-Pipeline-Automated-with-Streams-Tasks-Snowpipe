-- ========================================================
	=> CREATE TABLEs IN Bronze SCHEMA
-- ========================================================
USE SCHEMA DWH.BRONZE

CREATE OR REPLACE TABLE DWH.BRONZE.crm_cust_info (
    cst_id              integer,
    cst_key             STRING,
    cst_firstname       STRING,
    cst_lastname        STRING,
    cst_marital_status  STRING,
    cst_gndr            STRING,
    cst_create_date     STRING,
    _ingest_ts   TIMESTAMP_NTZ,
    _source_file STRING,
    _file_row_number INTEGER 
)
COMMENT = 'Raw CRM customer info ingested from source_crm/cust_info....';


CREATE OR REPLACE TABLE DWH.BRONZE.crm_prd_info (
    prd_id        INTEGER,
    prd_key       STRING,
    prd_nm        STRING,
    prd_cost      INTEGER,
    prd_line      STRING,
    prd_start_dt  DATE,
    prd_end_dt    DATE,
    _ingest_ts   TIMESTAMP_NTZ,
    _source_file STRING ,
    _file_row_number INTEGER 
)
COMMENT = 'Raw CRM product info ingested from source_crm/prd_info...';


CREATE OR REPLACE TABLE DWH.BRONZE.crm_sales_details (
    sls_ord_num    STRING,
    sls_prd_key    STRING,
    sls_cust_id    INTEGER,
    sls_order_dt   INTEGER,
    sls_ship_dt    INTEGER,
    sls_due_dt     INTEGER,
    sls_sales      INTEGER,
    sls_quantity   INTEGER,
    sls_price      INTEGER,
    _ingest_ts   TIMESTAMP_NTZ,
    _source_file STRING,
    _file_row_number INTEGER 
)
COMMENT = 'Raw CRM sales details ingested from source_crm/sale_details...';


CREATE OR REPLACE TABLE DWH.BRONZE.erp_cust_gndr (
    cid       STRING,
    bdate     DATE,
    gen       STRING,
    _ingest_ts   TIMESTAMP_NTZ,
    _source_file STRING,
    _file_row_number INTEGER 
)
COMMENT = 'Raw ERP customer gender info ingested from source_erp/CUST_AZ12...';


CREATE OR REPLACE TABLE DWH.BRONZE.erp_cust_loc (
    cid        STRING,
    cntry      STRING,
    _ingest_ts   TIMESTAMP_NTZ,
    _source_file STRING,
    _file_row_number INTEGER 
)
COMMENT = 'Raw ERP customer location info ingested from source_erp/LOC_A101...';


CREATE OR REPLACE TABLE DWH.BRONZE.erp_prd_cat (
    id           STRING,
    cat          STRING,
    subcat       STRING,
    maintenance  STRING,
    _ingest_ts   TIMESTAMP_NTZ,
    _source_file STRING,
    _file_row_number INTEGER 
)
COMMENT = 'Raw ERP product category info ingested from source_erp/PX_CAT_G1V2...';