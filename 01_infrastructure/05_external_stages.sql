-- ========================================================
	-- => CREATING external stages
-- ========================================================
-- Create Stage for CRM Source Data
 CREATE OR REPLACE STAGE DWH.BRONZE.crm_stage
    STORAGE_INTEGRATION = s3_int
    URL = 's3://bucket/source_crm/'    --PASTE HERE YOUR source_CRM S3 URL
    FILE_FORMAT = (TYPE = CSV FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE)
COMMENT = 'External stage for CRM data (cust_info, prd_info, sales_details) from s3://bucket/source_crm/';

-- ========================================================
	-- => CREATING external stages
-- ========================================================
-- Create Stage for ERP Source Data
 CREATE OR REPLACE STAGE DWH.BRONZE.erp_stage
    STORAGE_INTEGRATION = s3_int
    URL = 's3://bucket/source_erp/'     --PASTE HERE YOUR source_erp S3 URL
    FILE_FORMAT = (TYPE = CSV FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE)
COMMENT = 'External stage for ERP data (cust, loc, prd_cat) from s3://bucket/source_erp/';
