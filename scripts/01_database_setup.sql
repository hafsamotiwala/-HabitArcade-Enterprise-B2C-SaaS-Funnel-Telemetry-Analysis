-- DATABASE ARCHITECTURE CONFIGURATION

SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS B2C_SaaS;
CREATE DATABASE B2C_SaaS;
USE B2C_SaaS;

-- 1. ACQUISITION Table
CREATE TABLE IF NOT EXISTS enterprise_b2c_acquisition (
    user_id VARCHAR(50) PRIMARY KEY,
    signup_timestamp DATETIME,
    country CHAR(2),
    device_platform VARCHAR(20),
    acquisition_channel VARCHAR(50),
    marketing_campaign VARCHAR(100),
    attribution_cac_usd DECIMAL(10, 2),
    is_activated_core_funnel TINYINT(1)
);

-- 2. SUBSCRIPTIONS Table
CREATE TABLE IF NOT EXISTS enterprise_b2c_subscriptions (
    user_id VARCHAR(50) PRIMARY KEY,
    current_subscription_tier VARCHAR(50),
    subscription_lifecycle_status VARCHAR(30),
    account_tenure_months INT,
    FOREIGN KEY (user_id) REFERENCES enterprise_b2c_acquisition(user_id)
);

-- 3. LEDGER Table
CREATE TABLE IF NOT EXISTS enterprise_b2c_ledger (
    transaction_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50),
    transaction_timestamp DATETIME,
    transaction_type VARCHAR(30),
    sku_name VARCHAR(100),
    gross_revenue_usd DECIMAL(10, 2) DEFAULT 0.00,
    payment_status VARCHAR(30),
    payment_processor VARCHAR(30),
    FOREIGN KEY (user_id) REFERENCES enterprise_b2c_acquisition(user_id)
);

-- 4. TELEMETRY LOGS Table
CREATE TABLE IF NOT EXISTS enterprise_b2c_product_telemetry (
    session_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50),
    session_date DATE,
    app_opens_count INT DEFAULT 0,
    habits_logged_count INT DEFAULT 0,
    streaks_maintained_days INT DEFAULT 0,
    premium_filters_applied INT DEFAULT 0,
    social_shares_executed INT DEFAULT 0,
    total_screen_time_seconds INT DEFAULT 0,
    ad_impressions_served INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES enterprise_b2c_acquisition(user_id)
);

-- 5. VOICE OF CUSTOMER Table
CREATE TABLE IF NOT EXISTS enterprise_b2c_customer_feedback (
    user_id VARCHAR(50) PRIMARY KEY,
    nps_score_stars TINYINT,
    customer_text_review TEXT,
    support_tickets_submitted_count INT DEFAULT 0,
    app_crashes_recorded_lifetime INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES enterprise_b2c_acquisition(user_id)
);

SET FOREIGN_KEY_CHECKS = 1;
