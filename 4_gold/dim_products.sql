-- =============================================================================
-- Create Dimension: GOLD.DIM_PRODUCTS
-- =============================================================================
CREATE OR REPLACE VIEW DWH.GOLD.DIM_PRODUCTS AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- surrogate key
    pn.prd_id         AS product_id,
    pn.prd_key        AS product_number,
    pn.prd_nm         AS product_name,
    pn.cat_id         AS category_id,
    pc.cat            AS category,
    pc.subcat         AS subcategory,
    pc.maintenance    AS maintenance,
    pn.prd_cost       AS cost,
    pn.prd_line       AS product_line,
    pn.prd_start_dt   AS start_date
FROM DWH.SILVER.CRM_PRD_INFO pn
LEFT JOIN DWH.SILVER.ERP_PRD_CAT pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL; -- Only active products