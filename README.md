# B2C SaaS Funnel Telemetry & Customer Retention Audit

##  Project Overview
This repository contains a modular database analytics pipeline designed to audit marketing efficiency, find product funnel bottlenecks, and engineer predictive churn triggers. The analysis uses raw, un-aggregated telemetry logs, financial ledgers, and user feedback tables from **HabitArcade**, a gamified B2C subscription platform.

The core objective is to identify financial leakage points across the entire customer lifecycle, specifically tracking unit economics (CAC/LTV) and system-induced churn variables.

---

##  Deployment & Execution Order

To reproduce this analytical database environment locally in MySQL, execute the files in the `scripts/` directory in the following sequence:

1. **`01_database_setup.sql`**
   Run this to initialize the database `B2C_SaaS` and build the five baseline tables with strict type mappings and foreign key relationships.

2. **`02_data_ingestion.sql`**
   Ensure your source CSV data files are located in your MySQL secure server directory (`/Uploads/`). Run this script to safely disable foreign key constraints, clear existing entries, execute bulk imports using standard newline configurations, and verify total imported row counts.

3. **`03_acquisition_efficiency.sql`**
   Run these queries to analyze top-of-funnel channels, regional drop-off zones, and initial onboarding conversions.

4. **`04_churn_diagnostics.sql`**
   Execute this file to extract exact month-over-month customer churn pacing and run targeted string searches over user text reviews to pinpoint technical friction.

5. **`05_predictive_alerts.sql`**
   Run these production-style alert mechanisms to dynamically catch at-risk power users whose daily habit tracking falls below 50% of their baseline, and pull real-time feeds of users experiencing crash-related streak failures.

---

**Repository Maintainer:** Hafsa | Product Analyst and Funnel Strategist
