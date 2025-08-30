WITH City_trends AS (
  SELECT 
    C.city AS city_name,
    R.Year,
    S.Net_Circulation AS yearly_net_circulation,
    LEAD(S.Net_Circulation) OVER (PARTITION BY C.city ORDER BY R.Year) AS next_net_circulation,
    R.ad_revenue AS yearly_ad_revenue,
    LEAD(R.ad_revenue) OVER (PARTITION BY C.city ORDER BY R.Year) AS next_ad_revenue
  FROM code_bsacis_project.fact_ad_revenue R
  JOIN code_bsacis_project.fact_print_sales S
    ON R.edition_id = S.edition_ID
  JOIN code_bsacis_project.dim_city C
    ON S.city_id = C.city_id
  WHERE R.Year BETWEEN 2019 AND 2024
),
decline_flags AS (
  SELECT 
    city_name,
    COUNT(*) AS years_checked,
    COUNT(CASE WHEN yearly_net_circulation > next_net_circulation THEN 1 END) AS declining_net_circulation_years,
    COUNT(CASE WHEN yearly_ad_revenue > next_ad_revenue THEN 1 END) AS declining_ad_revenue_years
  FROM City_trends
  WHERE next_net_circulation IS NOT NULL AND next_ad_revenue IS NOT NULL
  GROUP BY city_name
)
SELECT 
  CT.city_name,
  CT.Year,
  CT.yearly_net_circulation,
  CT.yearly_ad_revenue,
  CASE WHEN DF.declining_net_circulation_years = 5 THEN 'Yes' ELSE 'No' END AS is_declining_print,
  CASE WHEN DF.declining_ad_revenue_years = 5 THEN 'Yes' ELSE 'No' END AS is_declining_ad_revenue,
  CASE WHEN DF.declining_net_circulation_years = 5 AND DF.declining_ad_revenue_years = 5 THEN 'Yes' ELSE 'No' END AS is_declining_both
FROM City_trends CT
JOIN decline_flags DF ON CT.city_name = DF.city_name
WHERE CT.Year BETWEEN 2019 AND 2024;