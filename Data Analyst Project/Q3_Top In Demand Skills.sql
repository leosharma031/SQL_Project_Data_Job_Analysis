   ---------

with remote_job_skills as(
SELECT
    skill_id,
    count(jp.job_id) as skill_demand
FROM
    skills_job_dim sjd
INNER JOIN
    job_postings_fact as jp
ON
sjd.job_id = jp.job_id
WHERE
    job_title_short ilike 'data analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skill_id
)

SELECT sd.skill_id ,sd.skills, skill_demand FROM
remote_job_skills

INNER JOIN
    skills_dim sd
on
    sd.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_demand desc
limit
5



--------------------------------------------------------------





SELECT 
    skills_dim.skills,
    -- count(skills_dim.skill_id) as skill_count
    count(job_postings_fact.job_id) as skill_count
FROM job_postings_fact

INNER JOIN skills_job_dim ON 
    job_postings_fact.job_id = skills_job_dim.job_id

INNER JOIN skills_dim ON 
    skills_job_dim.skill_id = skills_dim.skill_id

WHERE
    job_postings_fact.job_title_short ilike 'data analyst'

GROUP BY
    skills_dim.skills

ORDER BY
    skill_count desc
limit
5
-- LIMIT
--     1000
