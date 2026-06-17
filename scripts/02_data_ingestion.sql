-- HIGH-BULK INGESTION RUNTIME PIPELINE
USE B2C_SaaS;

SET FOREIGN_KEY_CHECKS = 0;

-- Flush stale iterations
TRUNCATE TABLE enterprise_b2c_acquisition;
TRUNCATE TABLE enterprise_b2c_subscriptions;
TRUNCATE TABLE enterprise_b2c_ledger;
TRUNCATE TABLE enterprise_b2c_product_telemetry;
TRUNCATE TABLE enterprise_b2c_customer_feedback;

-- 1. Load ACQUISITION
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/enterprise_b2c_acquisition.csv'
INTO TABLE enterprise_b2c_acquisition
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- 2. Load SUBSCRIPTIONS
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/enterprise_b2c_subscriptions.csv'
INTO TABLE enterprise_b2c_subscriptions
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- 3. Load LEDGER
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/enterprise_b2c_ledger.csv'
INTO TABLE enterprise_b2c_ledger
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- 4. Load TELEMETRY LOGS
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/enterprise_b2c_product_telemetry.csv'
INTO TABLE enterprise_b2c_product_telemetry
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- 5. Load VOICE OF CUSTOMER
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/enterprise_b2c_customer_feedback.csv'
INTO TABLE enterprise_b2c_customer_feedback
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;

SET FOREIGN_KEY_CHECKS = 1;

-- Database Record Verification Run
SHOW TABLES;

SELECT 'acquisition' AS table_name, COUNT(*) AS row_count FROM enterprise_b2c_acquisition
UNION ALL
SELECT 'subscriptions', COUNT(*) FROM enterprise_b2c_subscriptions
UNION ALL
SELECT 'ledger', COUNT(*) FROM enterprise_b2c_ledger
UNION ALL
SELECT 'telemetry', COUNT(*) FROM enterprise_b2c_product_telemetry
UNION ALL
SELECT 'feedback', COUNT(*) FROM enterprise_b2c_customer_feedback;
