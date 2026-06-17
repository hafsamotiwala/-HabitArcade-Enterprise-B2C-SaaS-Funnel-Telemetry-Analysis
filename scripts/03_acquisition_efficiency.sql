-- PHASE 1 ANALYTICS: MARKETING ATTRIBUTION & TOP-OF-FUNNEL EFFICIENCY

USE B2C_SaaS;

-- Query 3.1: Channel ROAS & Unit Economics
SELECT 
    a.acquisition_channel,
    COUNT(DISTINCT a.user_id) AS total_users_acquired,
    ROUND(SUM(a.attribution_cac_usd), 2) AS total_marketing_spend_usd,
    ROUND(SUM(COALESCE(l.gross_revenue_usd, 0)), 2) AS total_revenue_generated_usd,
    ROUND(SUM(COALESCE(l.gross_revenue_usd, 0)) / SUM(a.attribution_cac_usd), 2) AS return_on_ad_spend_roas
FROM enterprise_b2c_acquisition a
LEFT JOIN enterprise_b2c_ledger l ON a.user_id = l.user_id AND l.payment_status = 'Settled_Success'
GROUP BY a.acquisition_channel
ORDER BY return_on_ad_spend_roas DESC;

-- Query 3.2: Channel Efficiency Index (Cost vs. Activation)
SELECT 
    acquisition_channel,
    COUNT(user_id) AS total_signups,
    ROUND(AVG(attribution_cac_usd), 2) AS average_cac_per_user_usd,
    SUM(is_activated_core_funnel) AS total_activated_users,
    ROUND((SUM(is_activated_core_funnel) / COUNT(user_id)) * 100, 2) AS activation_rate_percentage
FROM enterprise_b2c_acquisition
GROUP BY acquisition_channel
ORDER BY activation_rate_percentage DESC;

-- Query 3.3: Platform Performance Grid
SELECT 
    device_platform,
    COUNT(user_id) AS total_signups,
    ROUND(AVG(attribution_cac_usd), 2) AS average_cac_usd,
    ROUND((SUM(is_activated_core_funnel) / COUNT(user_id)) * 100, 2) AS activation_rate_percentage
FROM enterprise_b2c_acquisition
GROUP BY device_platform
ORDER BY average_cac_usd ASC;

-- Query 3.4: The Activation Drop-off (The Leaky Funnel Map)
SELECT 
    country,
    COUNT(user_id) AS total_signups,
    SUM(CASE WHEN is_activated_core_funnel = 0 THEN 1 ELSE 0 END) AS dropped_off_before_activation,
    ROUND((SUM(CASE WHEN is_activated_core_funnel = 0 THEN 1 ELSE 0 END) / COUNT(user_id)) * 100, 2) AS drop_off_rate_percentage
FROM enterprise_b2c_acquisition
GROUP BY country
HAVING total_signups >= 10
ORDER BY drop_off_rate_percentage DESC;

-- Query 3.5: Long-Term Quality Mapping (Channel vs. Retention Metrics)
SELECT 
    a.acquisition_channel,
    COUNT(DISTINCT a.user_id) AS total_users,
    ROUND(AVG(s.account_tenure_months), 1) AS average_customer_tenure_months,
    ROUND((SUM(CASE WHEN s.subscription_lifecycle_status = 'Active' THEN 1 ELSE 0 END) / COUNT(a.user_id)) * 100, 2) AS current_active_rate_percentage
FROM enterprise_b2c_acquisition a
JOIN enterprise_b2c_subscriptions s ON a.user_id = s.user_id
GROUP BY a.acquisition_channel
ORDER BY average_customer_tenure_months DESC;
