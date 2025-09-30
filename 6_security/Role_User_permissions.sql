-- ========================================================
-- CREATE DATA ANALYST TEAM ROLE AND USERS
-- ========================================================

-- Set context
USE ROLE SECURITYADMIN;

-- ========================================================
-- CREATE DATA ANALYST ROLE
-- ========================================================

CREATE OR REPLACE ROLE DATA_ANALYST_TEAM
COMMENT = 'Role for data analysts with read-only access to Gold layer for business intelligence and reporting';

-- ========================================================
-- GRANT DATABASE AND SCHEMA PRIVILEGES
-- ========================================================

-- Grant usage on database
GRANT USAGE ON DATABASE DWH TO ROLE DATA_ANALYST_TEAM;

-- Grant usage on Gold schema (read-only access)
GRANT USAGE ON SCHEMA DWH.GOLD TO ROLE DATA_ANALYST_TEAM;

-- Grant usage on Monitoring schema (for data quality checks)
GRANT USAGE ON SCHEMA DWH.MONITORING TO ROLE DATA_ANALYST_TEAM;

-- Grant select on all current and future views in Gold schema
GRANT SELECT ON ALL VIEWS IN SCHEMA DWH.GOLD TO ROLE DATA_ANALYST_TEAM;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA DWH.GOLD TO ROLE DATA_ANALYST_TEAM;

-- Grant select on monitoring views
GRANT SELECT ON ALL VIEWS IN SCHEMA DWH.MONITORING TO ROLE DATA_ANALYST_TEAM;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA DWH.MONITORING TO ROLE DATA_ANALYST_TEAM;

-- ========================================================
-- GRANT WAREHOUSE PRIVILEGES
-- ========================================================

GRANT USAGE ON WAREHOUSE 'DATA_ANALYST_WH' TO ROLE DATA_ANALYST_TEAM;

-- ========================================================
-- CREATE DATA ANALYST USERS
-- ========================================================

-- User 1: Senior Data Analyst
CREATE OR REPLACE USER Da_Ali_Khan
    PASSWORD = 'TempPassword123!'  -- User will be forced to change on first login
    MUST_CHANGE_PASSWORD = TRUE
    DEFAULT_WAREHOUSE = 'DATA_ANALYST_WH'
    DEFAULT_ROLE = 'DATA_ANALYST_TEAM'
    DEFAULT_NAMESPACE = 'DWH.GOLD'
    COMMENT = 'Senior Data Analyst - Business Intelligence Team'
    EMAIL = 'ali.khan@company.com'
    DISPLAY_NAME = 'Ali Khan';

-- User 2: Junior Data Analyst  
CREATE OR REPLACE USER Da_Sana_CHEN
    PASSWORD = 'TempPassword456!'  -- User will be forced to change on first login
    MUST_CHANGE_PASSWORD = TRUE
    DEFAULT_WAREHOUSE = 'DATA_ANALYST_WH'
    DEFAULT_ROLE = 'DATA_ANALYST_TEAM'
    DEFAULT_NAMESPACE = 'DWH.GOLD'
    COMMENT = 'Junior Data Analyst - Business Intelligence Team'
    EMAIL = 'sana.chen@company.com'
    DISPLAY_NAME = 'Sana Chen';
