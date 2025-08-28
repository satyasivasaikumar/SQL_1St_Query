SELECT 
T2.city As city_name,
T1.Copies_Sold_1 AS copies_printed_2024,
T1.Net_Circulation,
ROUND(T1.Net_Circulation / T1.Copies_Sold_1, 4) AS efficiency_ratio,
T1.Year,
RANK() Over (order by T1.Net_Circulation / T1.Copies_Sold_1 DESC)AS efficiency_rank_2024
FROM
  code_bsacis_project.fact_print_sales AS T1
JOIN
  code_bsacis_project.dim_city AS T2
  ON T1.city_id = T2.city_id
WHERE T1.year = 2024;