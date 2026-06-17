-- PHASE 2 & 4 ANALYTICS: RETENTION DIAGNOSTICS & ATTRITION ANALYSIS

USE B2C_SaaS;

-- Query 4.1: The Churn Cliff (Volume Distribution by Lifespan Month)
SELECT 
    s.account_tenure_months,
    COUNT(DISTINCT s.user_id) AS churned_users_count,
    ROUND((COUNT(DISTINCT s.user_id) / SUM(COUNT(DISTINCT s.user_id)) OVER()) * 100, 2) AS percentage_of_total_churn,
    SUM(COUNT(DISTINCT s.user_id)) OVER(ORDER BY s.account_tenure_months ASC) AS cumulative_churned_users
FROM enterprise_b2c_subscriptions s
WHERE s.subscription_lifecycle_status = 'Cancelled_Churned'
GROUP BY s.account_tenure_months
ORDER BY s.account_tenure_months ASC;

-- Query 4.2: Early vs. Mature Churn Segments (Conditional Cohorts)
SELECT 
    a.acquisition_channel,
    COUNT(DISTINCT s.user_id) AS total_churned_users,
    SUM(CASE WHEN s.account_tenure_months <= 2 THEN 1 ELSE 0 END) AS early_churn_count,
    ROUND((SUM(CASE WHEN s.account_tenure_months <= 2 THEN 1 ELSE 0 END) / COUNT(DISTINCT s.user_id)) * 100, 2) AS early_churn_percentage,
    SUM(CASE WHEN s.account_tenure_months >= 6 THEN 1 ELSE 0 END) AS mature_churn_count,
    ROUND((SUM(CASE WHEN s.account_tenure_months >= 6 THEN 1 ELSE 0 END) / COUNT(DISTINCT s.user_id)) * 100, 2) AS mature_churn_percentage
FROM enterprise_b2c_subscriptions s
JOIN enterprise_b2c_acquisition a ON s.user_id = a.user_id
WHERE s.subscription_lifecycle_status = 'Cancelled_Churned'
GROUP BY a.acquisition_channel
ORDER BY total_churned_users DESC;

-- Query 4.3: High-Value Text Mining (Scent of Churn Pipeline)
SELECT 
    a.acquisition_channel,
    v.nps_score_stars,
    v.customer_text_review,
    t.total_habits_logged
FROM enterprise_b2c_customer_feedback v
JOIN enterprise_b2c_subscriptions s ON v.user_id = s.user_id
JOIN enterprise_b2c_acquisition a ON v.user_id = a.user_id
JOIN (
    SELECT user_id, SUM(habits_logged_count) AS total_habits_logged
    FROM enterprise_b2c_product_telemetry
    GROUP BY user_id
) t ON v.user_id = t.user_id
WHERE s.subscription_lifecycle_status = 'Cancelled_Churned'
  AND v.nps_score_stars <= 2 
  AND (
      v.customer_text_review LIKE '%bug%' OR 
      v.customer_text_review LIKE '%crash%' OR 
      v.customer_text_review LIKE '%lose%' OR 
      v.customer_text_review LIKE '%streak%' OR
      v.customer_text_review LIKE '%expensive%'
  )
ORDER BY t.total_habits_logged DESC
LIMIT 20;
