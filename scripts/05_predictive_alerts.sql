-- PHASE 3 & 5 ANALYTICS: PREDICTIVE INTERVENTIONS & ALERT AUTOMATIONS

USE B2C_SaaS;

-- Query 5.1: The Real-Time Churn Warning System (The Dynamic Performance Slope)
WITH user_daily_behavior AS (
    SELECT 
        user_id,
        session_date,
        habits_logged_count,
        AVG(habits_logged_count) OVER(
            PARTITION BY user_id 
            ORDER BY session_date 
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS historical_daily_baseline
    FROM enterprise_b2c_product_telemetry
),
recent_slopes AS (
    SELECT 
        user_id,
        session_date,
        habits_logged_count,
        ROUND(historical_daily_baseline, 2) AS historical_daily_baseline,
        ROUND(
            AVG(habits_logged_count) OVER(
                PARTITION BY user_id 
                ORDER BY session_date 
                ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
            ), 
            2
        ) AS current_3day_avg,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY session_date DESC) AS recency_rank
    FROM user_daily_behavior
)
SELECT 
    r.user_id,
    s.current_subscription_tier,
    s.account_tenure_months,
    r.historical_daily_baseline,
    r.current_3day_avg,
    ROUND((r.current_3day_avg / r.historical_daily_baseline) * 100, 1) AS current_performance_percentage
FROM recent_slopes r
JOIN enterprise_b2c_subscriptions s ON r.user_id = s.user_id
WHERE r.recency_rank = 1 
  AND s.subscription_lifecycle_status = 'Active'
  AND r.historical_daily_baseline > 2.0 
  AND r.current_3day_avg <= (r.historical_daily_baseline * 0.50) 
ORDER BY r.current_3day_avg ASC;

-- Query 5.2: Churn Cliff Down-sell Target Generation Engine
SELECT 
    s.user_id,
    s.current_subscription_tier,
    s.account_tenure_months,
    v.app_crashes_recorded_lifetime,
    v.support_tickets_submitted_count,
    a.acquisition_channel
FROM enterprise_b2c_subscriptions s
JOIN enterprise_b2c_customer_feedback v ON s.user_id = v.user_id
JOIN enterprise_b2c_acquisition a ON s.user_id = a.user_id
WHERE s.subscription_lifecycle_status = 'Active'
  AND s.current_subscription_tier IN ('Quarterly_Elite', 'Annual_Legend')
  AND s.account_tenure_months BETWEEN 4 AND 7
  AND (v.app_crashes_recorded_lifetime > 0 OR v.support_tickets_submitted_count >= 2)
ORDER BY s.account_tenure_months DESC, v.app_crashes_recorded_lifetime DESC;

-- Query 5.3: Streak Rescue Automation Feed (LAG Disruption Capturer)
WITH daily_streak_changes AS (
    SELECT 
        user_id,
        session_date,
        streaks_maintained_days,
        total_screen_time_seconds,
        LAG(streaks_maintained_days, 1) OVER(
            PARTITION BY user_id 
            ORDER BY session_date
        ) AS previous_day_streak
    FROM enterprise_b2c_product_telemetry
)
SELECT 
    d.user_id,
    d.session_date,
    d.previous_day_streak AS broken_streak_length,
    ROUND(d.total_screen_time_seconds / 60, 1) AS session_minutes_spent,
    s.current_subscription_tier
FROM daily_streak_changes d
JOIN enterprise_b2c_subscriptions s ON d.user_id = s.user_id
WHERE s.subscription_lifecycle_status = 'Active'
  AND d.streaks_maintained_days = 0 
  AND d.previous_day_streak >= 7
ORDER BY d.previous_day_streak DESC, d.session_date DESC;
