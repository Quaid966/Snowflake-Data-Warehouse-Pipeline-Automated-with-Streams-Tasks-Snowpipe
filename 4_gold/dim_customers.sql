-- =============================================================================
-- Create Dimension: GOLD.DIM_CUSTOMERS
-- =============================================================================
CREATE OR REPLACE VIEW DWH.GOLD.DIM_CUSTOMERS AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key, -- surrogate key
    ci.cst_id                              AS customer_id,
    ci.cst_key                             AS customer_number,
    ci.cst_firstname                       AS first_name,
    ci.cst_lastname                        AS last_name,
    la.cntry                               AS country,
    ci.cst_marital_status                  AS marital_status,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr        -- CRM = primary source
        ELSE COALESCE(ca.gen, 'n/a') 
    END                                    AS gender,
    ca.bdate                               AS birthdate,
    ci.cst_create_date                     AS create_date
FROM DWH.SILVER.CRM_CUST_INFO ci
LEFT JOIN DWH.SILVER.ERP_CUST_GNDR ca
    ON ci.cst_key = ca.cid
LEFT JOIN DWH.SILVER.ERP_CUST_LOC la

    ON ci.cst_key = la.cid;
