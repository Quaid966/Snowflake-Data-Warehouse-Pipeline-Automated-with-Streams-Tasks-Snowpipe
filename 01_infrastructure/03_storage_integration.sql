-- ========================================================
	=> CREATING Storage Integration 
-- ========================================================
CREATE OR REPLACE STORAGE INTEGRATION s3_int
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = S3
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'AWS_ROLE_ARN'
    STORAGE_ALLOWED_LOCATIONS = ('s3://bucket/')

COMMENT = 'Storage integration for S3 bucket DATALAKE32, used for CRM & ERP raw data ingestion';
