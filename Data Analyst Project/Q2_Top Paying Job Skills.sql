/*
Question: What skills are required for the top-paying data analyst jobs?
– Use the top 10 highest-paying Data Analyst jobs from first query
– Add the specific skills required for these roles
– Why? It provides a detailed look at which high-paying jobs demand certain skills,
   helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs 
    AS (

SELECT
    jp.job_id,
    jp.job_title,
    cd.name as company_name,
    jp.salary_year_avg
FROM
    job_postings_fact as jp
INNER JOIN
    company_dim as cd ON
    jp.company_id  = cd.company_id
WHERE
    jp.job_title_short ilike '%data analyst%' and 
    jp.job_location ilike '%anywhere%' and
    jp.salary_year_avg is not null
ORDER BY
    jp.salary_year_avg DESC
limit 10
    
    )

SELECT 
    top_paying_jobs.*,
    skills_dim.skills
FROM
    top_paying_jobs 
INNER JOIN
    skills_job_dim
ON
    top_paying_jobs.job_id = skills_job_dim.job_id

INNER JOIN
    skills_dim
ON
    skills_job_dim.skill_id = skills_dim.skill_id

ORDER BY
    salary_year_avg DESC


    -- Insights:
-- SQL, Python, and Tableau are the top skills in high-paying data analyst roles.
-- The most frequent skill pair is SQL + Python, followed by SQL + Tableau.
-- These skills together cover data extraction, analysis, and visualization.
-- Cloud tools like AWS and Azure also appear in top roles, showing growing demand.
-- Skills cluster into: Programming (Python, R), Querying (SQL), Visualization (Tableau), and Cloud.
-- Learning in clusters (e.g., SQL + Python + Tableau) increases salary potential.
-- Mastering this combination can position analysts for top-paying jobs.
