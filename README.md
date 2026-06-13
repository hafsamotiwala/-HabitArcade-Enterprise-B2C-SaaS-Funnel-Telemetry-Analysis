# -HabitArcade-Enterprise-B2C-SaaS-Funnel-Telemetry-Analysis
## 📖 Database Schema & Codebook

### 1. ACQUISITION Table (`enterprise_b2c_acquisition.csv`)
Stores top-of-funnel marketing attribution, localized demographics, and initial onboarding metrics.

| Column | Description |
| :--- | :--- |
| `user_id` | Unique identifier for each individual app user. |
| `signup_timestamp` | The exact timestamp when the user registered an account. |
| `country` | Two-letter ISO country code of the user (e.g., US, GB, BR). |
| `device_platform` | The mobile hardware or system interface used (iOS, Android, Web). |
| `acquisition_channel` | The specific marketing channel that captured the click (e.g., TikTok Ads, Meta Ads). |
| `marketing_campaign` | The specific creative campaign name associated with the marketing spend. |
| `attribution_cac_usd` | Localized Customer Acquisition Cost in USD, weighted by country and device platform. |
| `is_activated_core_funnel` | Binary flag (1/0) indicating if the user finished onboarding and logged their first habit. |

---

### 2. SUBSCRIPTIONS Table (`enterprise_b2c_subscriptions.csv`)
Tracks macro account lifecycle states, current pricing tiers, and real-world tenure metrics for the user base.

| Column | Description |
| :--- | :--- |
| `user_id` | Unique identifier linking back to the user's acquisition profile. |
| `current_subscription_tier` | The user's active billing tier (`Free_Tier`, `Monthly_Adventurer`, `Quarterly_Elite`, `Annual_Legend`). |
| `subscription_lifecycle_status` | The account state (`Non_Paying` for free users, `Active`, `Cancelled_Churned`, or `Paused`). |
| `account_tenure_months` | Total cumulative months the user has retained a paid subscription. |

---

### 3. LEDGER Table (`enterprise_b2c_ledger.csv`)
Captures transactional data streams including subscription entries, microtransactions, and payment gateway rejections.

| Column | Description |
| :--- | :--- |
| `transaction_id` | Unique financial record identifier generated per transaction event. |
| `user_id` | Reference to the associated user initiating the payment. |
| `transaction_timestamp` | The exact time processing occurred (including the 7-day conversion offset from trial). |
| `transaction_type` | The cash category classification (`Subscription_Renewal` vs. `In_App_Purchase`). |
| `sku_name` | The name of the stock-keeping unit purchased (e.g., `Annual_Legend`, `Avatar_Cosmetic_Pack`). |
| `gross_revenue_usd` | The dollar value captured. Defaults to 0.00 if processing errors or failures occur. |
| `payment_status` | The execution state (`Settled_Success`, `Failed_Insufficient_Funds`, `Gateway_Error`). |
| `payment_processor` | The billing engine handling the checkout (`Stripe`, `Apple_IAP`, `Google_Play_Billing`). |

---

### 4. TELEMETRY LOGS Table (`enterprise_b2c_product_telemetry.csv`)
A high-volume product behavioral database logging daily features used, gamification activity, screen-time sessions, and ad network monetization data.

| Column | Description |
| :--- | :--- |
| `session_id` | Unique token created for every discrete interaction window. |
| `user_id` | Reference to the associated active user. |
| `session_date` | The specific calendar date of the interaction. |
| `app_opens_count` | Number of times the app was launched throughout that specific day. |
| `habits_logged_count` | Number of habit items checked off (main core-feature product metric). |
| `streaks_maintained_days` | Number of sequential days the user has maintained their gamified habit streak. |
| `premium_filters_applied` | Number of times premium app customizations were used during the session. |
| `social_shares_executed` | Frequency of sharing progress out to social loops (viral engine indicator). |
| `total_screen_time_seconds` | Total interactive platform time logged in seconds. |
| `ad_impressions_served` | Number of native ad blocks shown (monetization tracking built specifically for free users). |

---

### 5. VOICE OF CUSTOMER Table (`enterprise_b2c_customer_feedback.csv`)
Combines engineering quality telemetry with customer sentiment markers to highlight customer experience vulnerabilities.

| Column | Description |
| :--- | :--- |
| `user_id` | Reference to the evaluating user. |
| `nps_score_stars` | The app store or in-app rating submitted by the user (1 to 5 stars). |
| `customer_text_review` | Qualitative written feedback left by the user highlighting satisfaction or app friction. |
| `support_tickets_submitted_count` | Total customer support tickets logged over the user's lifetime. |
| `app_crashes_recorded_lifetime` | Total technical app crashes encountered, indicating product health stability. |
