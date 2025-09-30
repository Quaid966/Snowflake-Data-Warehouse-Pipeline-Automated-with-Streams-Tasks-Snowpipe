-- =============================================================================
-- Create Fact: GOLD.FACT_SALES
-- =============================================================================
CREATE OR REPLACE VIEW DWH.GOLD.FACT_SALES AS
SELECT
    sd.sls_ord_num   AS order_number,
    pr.product_key   AS product_key,
    cu.customer_key  AS customer_key,
    sd.sls_order_dt  AS order_date,
    sd.sls_ship_dt   AS shipping_date,
    sd.sls_due_dt    AS due_date,
    sd.sls_sales     AS sales_amount,
    sd.sls_quantity  AS quantity,
    sd.sls_price     AS price
FROM DWH.SILVER.CRM_SALES_DETAILS sd
LEFT JOIN DWH.GOLD.DIM_PRODUCTS pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN DWH.GOLD.DIM_CUSTOMERS cu
    ON sd.sls_cust_id = cu.customer_id;