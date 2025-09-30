-- ========================================================
	=> CREATING Streams on Bronze Tables
-- ========================================================
-- Customer Info Stream
CREATE OR REPLACE STREAM DWH.BRONZE.stream_crm_cust_info
ON TABLE DWH.BRONZE.CRM_CUST_INFO
APPEND_ONLY = TRUE
COMMENT = 'Stream to capture changes from CRM Customer Info for Bronze → Silver ETL';

-- Product Info Stream
CREATE OR REPLACE STREAM DWH.BRONZE.stream_crm_prd_info
ON TABLE DWH.BRONZE.CRM_PRD_INFO
APPEND_ONLY = TRUE
COMMENT = 'Stream to capture changes from CRM Product Info for Bronze → Silver ETL';

-- Sales Details Stream
CREATE OR REPLACE STREAM DWH.BRONZE.stream_crm_sales_details
ON TABLE DWH.BRONZE.CRM_SALES_DETAILS
APPEND_ONLY = TRUE
COMMENT = 'Stream to capture changes from CRM Sales Details for Bronze → Silver ETL';

-- ERP Customer Gender Stream
CREATE OR REPLACE STREAM DWH.BRONZE.stream_erp_cust_gndr
ON TABLE DWH.BRONZE.ERP_CUST_GNDR
APPEND_ONLY = TRUE
COMMENT = 'Stream to capture changes from ERP Customer Gender for Bronze → Silver ETL';

-- ERP Customer Location Stream
CREATE OR REPLACE STREAM DWH.BRONZE.stream_erp_cust_loc
ON TABLE DWH.BRONZE.ERP_CUST_LOC
APPEND_ONLY = TRUE
COMMENT = 'Stream to capture changes from ERP Customer Location for Bronze → Silver ETL';

-- ERP Product Category Stream
CREATE OR REPLACE STREAM DWH.BRONZE.stream_erp_prd_cat
ON TABLE DWH.BRONZE.ERP_PRD_CAT
APPEND_ONLY = TRUE
COMMENT = 'Stream to capture changes from ERP Product Category for Bronze → Silver ETL';
