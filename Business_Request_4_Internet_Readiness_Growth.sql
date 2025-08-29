SELECT
  R1.city_id,
  C1.city,
  MAX(CASE WHEN quarter = '2021-Q4' THEN internet_penetration END) AS internet_rate_q4_2021,
  MAX(CASE WHEN quarter = '2021-Q1' THEN internet_penetration END) AS internet_rate_q4_2021,
  ROUND(MAX(CASE WHEN quarter = '2021-Q4' THEN internet_penetration END) -
  MAX(CASE WHEN quarter = '2021-Q1' THEN internet_penetration END),2) AS delta_internet_rate
FROM code_bsacis_project.fact_city_readiness R1
JOIN code_bsacis_project.dim_city C1
ON R1.city_id = C1.city_id
WHERE quarter IN ('2021-Q1', '2021-Q4')
GROUP BY R1.city_id,C1.city;
