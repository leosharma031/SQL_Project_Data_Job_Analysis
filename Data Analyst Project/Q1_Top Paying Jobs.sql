/*
Question: What are the top-paying data analyst jobs?
– Identify the top 10 highest-paying Data Analyst roles that are available remotely.
– Focuses on job postings with specified salaries (remove nulls).
– Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employeers
*/



SELECT
    jp.job_id,
    jp.job_title,
    cd.name,
    jp.job_location,
    jp.job_schedule_type,
    jp.salary_year_avg,
    jp.job_posted_date
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

-- SELECT *
-- FROM
-- job_postings_fact
-- WHERE
-- job_id = 547382