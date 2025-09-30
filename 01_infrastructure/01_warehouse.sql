-- ========================================================
-- ETL WAREHOUSE FOR PROCESSING TASKS
-- ========================================================
CREATE WAREHOUSE IF NOT EXISTS etl_wh
WITH 
WAREHOUSE_SIZE = 'MEDIUM'              -- Larger size for ETL processing power
WAREHOUSE_TYPE = 'STANDARD'            -- STANDARD for general ETL tasks
AUTO_SUSPEND = 180                     -- Suspend after 3 mins (shorter for cost optimization)
AUTO_RESUME = TRUE                     -- Auto-resume when tasks trigger
MIN_CLUSTER_COUNT = 1                  -- Minimum clusters always running
MAX_CLUSTER_COUNT = 3                  -- Scale up during heavy ETL loads
SCALING_POLICY = 'ECONOMY'             -- Cost-effective scaling
COMMENT = 'Dedicated warehouse for ETL tasks, data processing, and pipeline operations';

-- ========================================================
-- DATA WAREHOUSE FOR DATA ANALYST TEAM
-- ========================================================
CREATE WAREHOUSE IF NOT EXISTS data_analyst_wh
WITH 
WAREHOUSE_SIZE = 'MEDIUM'              -- Balanced size for analytical queries
WAREHOUSE_TYPE = 'STANDARD'            -- STANDARD for analytical workloads
AUTO_SUSPEND = 600                     -- Suspend after 10 minutes
AUTO_RESUME = TRUE                     -- Auto-resume when queries come in
MIN_CLUSTER_COUNT = 1                  -- Minimum clusters for quick response
MAX_CLUSTER_COUNT = 3                  -- Scale for concurrent users
SCALING_POLICY = 'STANDARD'            -- Standard scaling for user queries
COMMENT = 'Warehouse for data analyst team queries and reporting';