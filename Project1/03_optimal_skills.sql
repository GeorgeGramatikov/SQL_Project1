/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)),1) AS ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1_000_000,1) AS optimal_score
FROM 
    job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True 
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY 
      sd.skills
HAVING 
      COUNT(jpf.*) > 100
ORDER BY 
      optimal_score DESC
LIMIT 20;

/*
The results show that skills like Terraform, AWS, SQL, and Python are the most optimal skills 
for data engineers, balancing both high median salaries and strong demand in the remote job market.
┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │          193 │             5.3 │           1.0 │
│ aws        │      137320.0 │          783 │             6.7 │           0.9 │
│ sql        │      130000.0 │         1128 │             7.0 │           0.9 │
│ python     │      135000.0 │         1133 │             7.0 │           0.9 │
│ airflow    │      150000.0 │          386 │             6.0 │           0.9 │
│ spark      │      140000.0 │          503 │             6.2 │           0.9 │
│ azure      │      128000.0 │          475 │             6.2 │           0.8 │
│ java       │      135000.0 │          303 │             5.7 │           0.8 │
│ scala      │      137290.0 │          247 │             5.5 │           0.8 │
│ kubernetes │      150500.0 │          147 │             5.0 │           0.8 │
│ kafka      │      145000.0 │          292 │             5.7 │           0.8 │
│ snowflake  │      135500.0 │          438 │             6.1 │           0.8 │
│ pyspark    │      140000.0 │          152 │             5.0 │           0.7 │
│ github     │      135000.0 │          127 │             4.8 │           0.7 │
│ go         │      140000.0 │          113 │             4.7 │           0.7 │
│ git        │      140000.0 │          208 │             5.3 │           0.7 │
│ hadoop     │      135000.0 │          198 │             5.3 │           0.7 │
│ redshift   │      130000.0 │          274 │             5.6 │           0.7 │
│ docker     │      135000.0 │          144 │             5.0 │           0.7 │
│ nosql      │      134415.0 │          193 │             5.3 │           0.7 │
└────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘
  20 rows                                                           5 columns
  */