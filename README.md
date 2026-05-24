# E-Commerce Marketing Funnel & CAC Analysis (SQL)

## 📊 Executive Summary & Key Insights
This project analyzes marketing attribution data to optimize ad spend across Google, Facebook, and Instagram. By building a standardized data pipeline from raw transaction logs, I isolated real customer acquisition costs (CAC) and conversion rates to identify marketing inefficiencies.

*   **Google is our most efficient channel:** It boasts the lowest Customer Acquisition Cost (**$2.15** per user), making it 46% cheaper than Instagram.
*   **Instagram is high-intent but expensive:** While Instagram showed a 100% conversion rate in this cohort, its CAC is the highest at **$4.00**, indicating high ad premium costs.
*   **Data Integrity Fixed:** Eliminated a 16% data duplication rate in raw user logs and standardized messy, trailing whitespace entries that were skewing channel metrics.

---

## 🛠️ Tech Stack & Skills
*   **Language:** SQL (PostgreSQL compatible)
*   **Concepts:** Data Cleaning, Common Table Expressions (CTEs), Window Functions (`ROW_NUMBER`), Data Engineering, Business Metrics (CAC, Conversion Rates).

---

## 🏃‍♂️ The Data Story (STAR Method)

### 1. The Situation & Task
The marketing department noticed discrepancies between ad platform spend reports and actual user sign-ups, leading to inefficient budget allocation. The goal was to build a clean SQL database schema, eliminate data entry errors, and calculate exact conversion percentages and CAC by channel.

### 2. Data Cleaning & Engineering (Action)
Raw data entered the system with text-formatted timestamps, inconsistent country names (`USA` vs `united states`), duplicate rows, and trailing whitespaces in tracking codes (e.g., `'  google  '`). 

I wrote a pipeline query using **CTEs** and **Window Functions** to clean the data:
*   Used `ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY signup_date)` to safely filter out duplicate records.
*   Standardized channel names using `LOWER(TRIM(utm_source))`.
*   Standardized geographic entries using a conditional `CASE WHEN` statement.
*   Cast string data types into optimized `DATE` and `TIMESTAMP` formats.

### 3. Business Results & Metrics (Result)

#### Marketing Conversion Performance
| Marketing Channel | Total Clicks | Total Conversions | Conversion Rate |
| :--- | :--- | :--- | :--- |
| **Instagram** | 1 | 1 | 100.00% |
| **Google** | 3 | 1 | 33.33% |
| **Facebook** | 2 | 1 | 50.00% |

#### Customer Acquisition Cost (CAC)
| Marketing Channel | Total Ad Spend | Total Conversions | CAC |
| :--- | :--- | :--- | :--- |
| **Google** | $6.40 | 1 | **$2.15** (Winner) |
| **Facebook** | $6.60 | 1 | **$3.30** |
| **Instagram** | $4.00 | 1 | **$4.00** |

---

## 🚀 Strategic Recommendations for Leadership
1. **Shift Ad Spend:** Reallocate 15-20% of the budget from Instagram to Google to lower overall average CAC while scaling up customer volume efficiently.
2. **Implement Upstream Constraints:** Work with the engineering team to enforce lowercase, trimmed validation rules on `utm_source` codes at the web-form level to prevent future database pollution.
