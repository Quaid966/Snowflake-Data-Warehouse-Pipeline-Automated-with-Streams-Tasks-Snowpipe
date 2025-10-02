-- ========================================================
	--=> CREATING Bronze SCHEMA 
-- ========================================================
CREATE SCHEMA IF NOT EXISTS DWH.BRONZE
COMMENT = 'Bronze layer schema - raw ingestion of CRM and ERP data from S3 with minimal transformations';

-- ========================================================
	--=> CREATING TABLE IN Silver SCHEMA
-- ========================================================
CREATE SCHEMA IF NOT EXISTS DWH.SILVER
COMMENT = 'Cleaned and standardized data model for CRM & ERP sources, transformed from Bronze layer';

-- ========================================================
	--=> CREATING GOLD SCHEMA
-- ========================================================
CREATE SCHEMA IF NOT EXISTS DWH.GOLD
COMMENT = 'Curated business-ready data models (fact and dimension tables) built from Silver layer for reporting and analytics.';

-- ========================================================
	--=> CREATING TASKS Schema
-- ========================================================
CREATE SCHEMA IF NOT EXISTS DWH.TASKS
COMMENT = 'Schema to manage Snowflake tasks for orchestrating Bronze → Silver → Gold pipeline';

-- ========================================================
	--=> CREATING MONITORING Schema
-- ========================================================
CREATE SCHEMA DWH.MONITORING;

COMMENT = 'Centralized monitoring data quality';
