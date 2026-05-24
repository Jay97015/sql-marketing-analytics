-- STEP 1: DATA CLEANING & STANDARDIZATION

-- Create a clean users table by removing duplicates and fixing data types
CREATE TABLE clean_users AS
WITH deduplicated_users AS (
    SELECT 
        user_id,
        signup_date,
        country,
        email,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY signup_date ASC) as row_num
    FROM raw_users
)
SELECT 
    user_id,
    CAST(signup_date AS DATE) AS signup_date,
    CASE 
        WHEN LOWER(country) IN ('uk', 'united kingdom') THEN 'United Kingdom'
        WHEN LOWER(country) IN ('united states', 'us', 'usa') THEN 'United States'
        ELSE INITCAP(country)
    END AS country,
    COALESCE(LOWER(email), 'no-email@company.com') AS email
FROM deduplicated_users
WHERE row_num = 1 
  AND user_id IS NOT NULL;

-- Create a clean marketing clicks table by trimming whitespaces
CREATE TABLE clean_marketing_clicks AS
SELECT 
    click_id,
    user_id,
    LOWER(TRIM(utm_source)) AS utm_source,
    COALESCE(ad_spend, 0.00) AS ad_spend,
    CAST(click_timestamp AS TIMESTAMP) AS click_timestamp,
    converted
FROM raw_marketing_clicks;

-- STEP 2: BUSINESS METRICS & INSIGHTS

-- Metric 1: Conversion Rate by Channel
SELECT 
    utm_source AS marketing_channel,
    COUNT(click_id) AS total_clicks,
    SUM(converted) AS total_conversions,
    ROUND((SUM(converted)::NUMERIC / COUNT(click_id)::NUMERIC) * 100, 2) AS conversion_rate_percentage
FROM clean_marketing_clicks
GROUP BY utm_source
ORDER BY conversion_rate_percentage DESC;

-- Metric 2: Customer Acquisition Cost (CAC)
SELECT 
    utm_source AS marketing_channel,
    SUM(ad_spend) AS total_ad_spend,
    SUM(converted) AS total_conversions,
    ROUND(SUM(ad_spend) / NULLIF(SUM(converted), 0), 2) AS customer_acquisition_cost
FROM clean_marketing_clicks
GROUP BY utm_source
ORDER BY customer_acquisition_cost ASC;
