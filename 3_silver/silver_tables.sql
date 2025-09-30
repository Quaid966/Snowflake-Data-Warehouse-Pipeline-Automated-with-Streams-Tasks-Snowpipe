-- ========================================================
	=> CREATING TABLE IN Silver SCHEMA
-- ========================================================
USE SCHEMA DWH.SILVER
--	cust_info (CRM Customers – standardized)
CREATE OR REPLACE TABLE DWH.SILVER.crm_cust_info (
    cst_id            INT,
    cst_key           STRING,
    cst_firstname     STRING,
    cst_lastname       STRING,
    cst_marital_status STRING,
    cst_gndr           STRING,
    cst_create_date    DATE,
    _ingested_at       TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP
)
COMMENT = 'Cleaned customer info from CRM (Bronze -> Silver). Standardized column names and datatypes.';

--	prd_info (CRM Products – cleaned)
CREATE OR REPLACE TABLE DWH.SILVER.crm_prd_info (
    prd_id             INT,
    cat_id             STRING,
    prd_key            STRING,
    prd_nm             STRING,
    prd_cost           INTEGER,
    prd_line           STRING,
    prd_start_dt       DATE,
    prd_end_dt         DATE,
    _ingested_at       TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP
)
COMMENT = 'Cleaned product info from CRM. Dates standardized.';

--	sales_details (CRM Sales Orders – standardized)
CREATE OR REPLACE TABLE DWH.SILVER.crm_sales_details (
    sls_ord_num           STRING,
    sls_prd_key           STRING,
    sls_cust_id           INTEGER,
    sls_order_dt          DATE,
    sls_ship_dt           DATE,
    sls_due_dt            DATE,
    sls_sales             INTEGER,
    sls_quantity          INTEGER,
    sls_price             INTEGER,
    _ingested_at          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP
)
COMMENT = 'Cleaned sales transactions from CRM with standardized dates.';

--	cust_gndr (ERP Customer Gender & Birthdate)
CREATE OR REPLACE TABLE DWH.SILVER.erp_cust_gndr (
    cid                STRING,
    bdate              DATE,
    gen                STRING,
    _ingested_at       TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP
)
COMMENT = 'Customer gender and birthdate from ERP system. Cleaned and standardized.';

--	cust_loc (ERP Customer Location)
CREATE OR REPLACE TABLE DWH.SILVER.erp_cust_loc (
    cid                STRING,
    cntry              STRING,
    _ingested_at       TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP
)
COMMENT = 'Customer location info from ERP. Standardized country field.';

--	prd_cat (ERP Product Category Hierarchy)
CREATE OR REPLACE TABLE DWH.SILVER.erp_prd_cat (
    id                 STRING,
    cat                STRING,
    subcat             STRING,
    maintenance        STRING,
    _ingested_at       TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP
)
COMMENT = 'Product categories and subcategories from ERP system.';