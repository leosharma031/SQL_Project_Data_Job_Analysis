-- What are the top skills based on salary?

-- Look at the average salary associated with each skill for Data Analyst positions

-- Focuses on roles with specified salaries, regardless of location

-- Why? It reveals how different skills impact salary levels for Data Analysts and helps 
-- identify the most financially rewarding skills to acquire or improve


---------------------------------------------------------------------------------------------------------------------------------------

SELECT 
    skills_dim.skills,
    round(avg(job.salary_year_avg) ,2) as avg_salary
FROM
    job_postings_fact as job
INNER JOIN
    skills_job_dim as skill_job ON
job.job_id = skill_job.job_id

INNER JOIN
    skills_dim ON
skills_dim.skill_id = skill_job.skill_id

WHERE
    job.salary_year_avg is not null 
    AND
    job.job_title_short ilike 'data analyst'
GROUP BY
    skills_dim.skills

ORDER BY
    avg_salary desc
limit 5




-----------------------------------------------
-- Checking specficailly for these roles

SELECT 
    skills_dim.skills,
    round(avg(job.salary_year_avg) ,2) as avg_salary
FROM
    job_postings_fact as job
INNER JOIN
    skills_job_dim as skill_job ON
job.job_id = skill_job.job_id

INNER JOIN
    skills_dim ON
skills_dim.skill_id = skill_job.skill_id

WHERE
    job.salary_year_avg is not null 
    AND
    job.job_title_short ilike 'data analyst'
    and(
    skills_dim.skills ilike 'sql' or
    skills_dim.skills ilike 'python' or
    skills_dim.skills ilike '%power bi%' or 
    skills_dim.skills ilike 'excel' )
GROUP BY
    skills_dim.skills

ORDER BY
    avg_salary desc