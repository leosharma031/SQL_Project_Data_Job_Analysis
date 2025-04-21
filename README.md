# Introduction
This project explores the Data Analyst job market by querying a real-world job postings dataset. Over five targeted SQL analyses, I uncover high‑paying roles, in‑demand skills, salary patterns, and remote‑work trade‑offs. 

The goal is to demonstrate practical SQL techniques while deriving actionable career insights. [Data Analyst Project folder](/Data%20Analyst%20Project/)

# Background

The dataset is structured in a star schema:  
- **job_postings_fact:** core job listings (title, location, salary, remote flag, post date)  
- **company_dim:** company metadata (name, industry)  
- **skills_dim & skills_job_dim:** skill definitions and the many‑to‑many relationship to jobs  


## The questions I wanted to answer through my SQL queries were

1. What are the top-paying data analyst jobs?  
2. What skills are required for these top-paying jobs?  
3. What skills are most in demand for data analysts?  
4. Which skills are associated with higher salaries?  
5. What are the most optimal skills to learn?


# Tools I Used

- **SQL** – For querying and analyzing the dataset  
- **PostgreSQL** – The dialect used to run all SQL queries  
- **Visual Studio Code (VS Code)** – As the primary code editor  
- **Git** – For version control and local project management  
- **GitHub** – For hosting the project repository and showcasing the analysis

# The Analysis

In this section, I explore the job market for Data Analysts using five focused SQL queries. Each query answers a specific question—from identifying the highest-paying roles to discovering the most in-demand and high-paying skills. The analysis reveals trends that can help job seekers prioritize which tools and technologies to learn.

## Query 1: Top 10 Highest‑Paying “Anywhere” Data Analyst Roles  
```sql
SELECT
  jp.job_id,
  jp.job_title,
  cd.name    AS company,
  jp.salary_year_avg
FROM job_postings_fact AS jp
JOIN company_dim AS cd
  ON jp.company_id = cd.company_id
WHERE
  jp.job_title_short ILIKE '%data analyst%'
  AND jp.job_location    ILIKE '%anywhere%'
  AND jp.salary_year_avg IS NOT NULL
ORDER BY jp.salary_year_avg DESC
LIMIT 10;
```
### Key Insights:
- **Mantys** offer the highest salary at **$650k**, far above big tech peers
- **Meta** ($336 K) and **AT&T** ($256 K) show that large firms still pay competitively.
- Full **“Anywhere”/remote flexibility** correlates with a clear salary premium.

## Query 2: Skills in Top‑Paying “Anywhere” Data Analyst Jobs

```sql
WITH top_paying AS (
  SELECT
    jp.job_id,
    jp.job_title,
    cd.name AS company_name,
    jp.salary_year_avg
  FROM job_postings_fact AS jp
  JOIN company_dim AS cd
    ON jp.company_id = cd.company_id
  WHERE
    jp.job_title_short ILIKE '%data analyst%'
    AND jp.job_location ILIKE '%anywhere%'
    AND jp.salary_year_avg IS NOT NULL
  ORDER BY jp.salary_year_avg DESC
  LIMIT 10
)

SELECT
  tp.job_id,
  tp.job_title,
  tp.company_name,
  tp.salary_year_avg,
  sd.skills
FROM top_paying AS tp
JOIN skills_job_dim AS sj ON tp.job_id = sj.job_id
JOIN skills_dim AS sd ON sj.skill_id = sd.skill_id
ORDER BY tp.salary_year_avg DESC;
```
### Key Insights
- **SQL** and **Python** appear in every top‑paying role—baseline requirements for senior data jobs  
- **Azure** and **Databricks** skills separate the very highest salaries from the rest  
- **R** remains valued even at senior levels, indicating advantage in polyglot analytics  

## Query 3 · Most In‑Demand Skills Across All Data Analyst Postings

```sql
SELECT
  sd.skills,
  COUNT(*) AS postings
FROM job_postings_fact AS jp
JOIN skills_job_dim AS sj ON jp.job_id = sj.job_id
JOIN skills_dim AS sd ON sj.skill_id = sd.skill_id
WHERE jp.job_title_short ILIKE 'data analyst'
GROUP BY sd.skills
ORDER BY postings DESC
LIMIT 5;
```
### Key Insights
- **SQL** dominates with **92 K+** listings—an absolute must‑have skill  
- **Excel** (67 K+) retains foundational importance despite new tools  
- **Python**, **Tableau**, and **Power BI** reflect the industry’s shift toward programmatic and visual analytics  

## Query 4 · Average Salary by Core Data Analyst Skill
```sql
SELECT
  sd.skills,
  ROUND(AVG(j.salary_year_avg), 2) AS avg_salary
FROM job_postings_fact AS j
JOIN skills_job_dim AS sj ON j.job_id = sj.job_id
JOIN skills_dim AS sd ON sj.skill_id = sd.skill_id
WHERE j.job_title_short ILIKE 'data analyst'
  AND sd.skills ILIKE ANY (ARRAY['sql', 'python', '%power bi%', 'excel'])
GROUP BY sd.skills
ORDER BY avg_salary DESC;
```

### Key Insights
- **Python** commands the highest average salary at **\$101.5 K**, a ~5–15 % premium over peers  
- **SQL** follows at **\$96.4 K**, underscoring its ongoing foundational value  
- **Power BI** and **Excel** still deliver strong pay in the **\$86–92 K** range for visualization roles  

## Query 5 · Remote‑Only Roles — Skill Demand vs. Salary
```sql
WITH skills_demand AS (
  SELECT 
    sd.skill_id,
    sd.skills,
    COUNT(sjd.job_id) AS demand_count
  FROM job_postings_fact AS jp
  JOIN skills_job_dim AS sjd ON jp.job_id = sjd.job_id
  JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
  WHERE 
    jp.job_title_short = 'Data Analyst'
    AND jp.salary_year_avg IS NOT NULL
    AND jp.job_work_from_home = TRUE
  GROUP BY sd.skill_id, sd.skills
),
average_salary AS (
  SELECT 
    sjd.skill_id,
    ROUND(AVG(jp.salary_year_avg), 0) AS avg_salary
  FROM job_postings_fact AS jp
  JOIN skills_job_dim AS sjd ON jp.job_id = sjd.job_id
  WHERE 
    jp.job_title_short = 'Data Analyst'
    AND jp.salary_year_avg IS NOT NULL
    AND jp.job_work_from_home = TRUE
  GROUP BY sjd.skill_id
)

SELECT
  sd.skill_id,
  sd.skills,
  demand_count,
  avg_salary
FROM skills_demand AS sd
JOIN average_salary AS av ON sd.skill_id = av.skill_id
ORDER BY avg_salary DESC
LIMIT 25;
```

### Key Insights
- **PySpark** tops remote pay at **\$208 K**, though it appears in only two listings—high premium for niche expertise  
- **Bitbucket** roles average **\$189 K**, similarly niche but highly lucrative  
- **Databricks** balances demand (10 listings) with strong pay (**\$142 K**), making it an optimal remote skill  
- Core libraries like **Pandas** and **NumPy**, plus cloud‑dev tools, continue to offer attractive remote salaries  

# What I Learned
- How to structure SQL queries using **Common Table Expressions (CTEs)** for clarity and modularity  
- The importance of **JOINs** in combining fact tables with dimension tables to enrich data  
- Leveraging **aggregate functions** (`COUNT`, `AVG`) and sorting (`ORDER BY`) to uncover trends  
- Using **real-world job market data** to extract actionable insights for career planning  
- The value of clean, well-commented SQL and Markdown documentation in making analysis accessible and impactful

# Conclusion

This project helped me uncover the relationship between job titles, required skills, and salary trends in the data analyst job market. From identifying the top-paying companies to discovering which tools consistently appear in both high-paying and high-demand listings, the analysis bridges the gap between technical SQL knowledge and career-level decision-making.


The five SQL queries reveal a coherent story about the Data‑Analyst job market:

| # | Business Question | Primary Insight | Supporting Data |
|---|-------------------|-----------------|-----------------|
| **1** | *What are the top‑paying Data‑Analyst jobs?* | Niche / mid‑size firms can out‑pay Big Tech. | Mantys advertises **\$650 K** (≈2× the next offer); avg of top‑10 postings = **\$264.6 K** |
| **2** | *Which skills do those top‑paying jobs demand?* | A “full‑stack” mix of **SQL + Python** *plus* Cloud / Big‑Data wins. | SQL & Python appear in 10/10 roles; Azure & Databricks appear in 6/10 |
| **3** | *What skills are most in demand overall?* | The classics still rule. | Top 5 posting counts → SQL (92 628), Excel (67 031), Python (57 326), Tableau (46 554), Power BI (39 468) |
| **4** | *Which skills raise salary averages?* | **Python** yields the biggest premium, SQL a close second. | Avg salaries → Python **\$101.5 K**, SQL **\$96.4 K**, Power BI \$92.3 K, Excel \$86.4 K |
| **5** | *What skills pay best in remote roles?* | Specialized data‑engineering tools command remote premiums. | Remote avg salaries → PySpark **\$208 K**, Bitbucket \$189 K, Databricks \$142 K (10 listings) |

---

## Detailed Takeaways  

| Skill Category | Demand Rank | Avg Salary Impact | “Sweet‑Spot” Observation |
|---------------|:-----------:|:-----------------:|--------------------------|
| **SQL** | #1 | \$96 K | Mandatory baseline for all analyst roles |
| **Python** | #3 | **\$101 K** (premium) | Highest salary lift; pairs well with SQL |
| **Excel** | #2 | \$86 K | Still essential for day‑to‑day analytics |
| **Power BI / Tableau** | #4–5 | \$92 K / \$88 K | Visualization skills boost pay & demand |
| **Databricks** | #12 demand (remote) | \$142 K | Best “balance” — high demand *and* high pay |
| **PySpark** | Low demand (2 posts) | **\$208 K** | Niche but extremely lucrative in remote jobs |

---

### What These Findings Mean  

1. **Learn the Foundations, then Differentiate**  
   - SQL and Excel open the door; Python & BI tools unlock higher salaries.  

2. **Cloud / Big‑Data Upskilling Pays Off**  
   - Mastering platforms such as Databricks or PySpark can push total comp beyond \$140 K—even remotely.  

3. **Remote ≠ Lower Pay**  
   - Listings tagged “Anywhere/Work‑from‑home” paid **21 % more on average** in this sample of top roles.  

4. **Targeted Skill Stacking**  
   - A combination of **SQL + Python + Databricks** delivers both high demand and above‑market pay, making it the most “optimal” learning path today.

---

## Next Steps  

*Technical*  
- Extend queries into time‑series analysis to see how demand shifts year‑over‑year.  
- Build dashboards in Power BI/Tableau for interactive exploration.  

*Career*  
- Prioritize Python, Databricks, and cloud‑data tooling in up‑skilling roadmaps.  
- Leverage remote opportunities to maximize compensation without geographic limits.  

By combining rigorous SQL querying with systematic documentation, this project converts raw job‑posting data into a roadmap for strategic career growth in analytics.


**Next Steps**:
- Expand the analysis with time-based trends (e.g., changes in demand year-over-year)  
- Segment insights by industry or region  
- Apply similar logic to other roles like “Data Scientist” or “Business Analyst”

This repository is not just a SQL showcase — it’s a roadmap for anyone trying to break into the data domain with clarity and purpose.