WITH CategoryRevenue AS (
 SELECT Year,category_group,
ROUND(SUM(ad_revenue), 2) AS Category_Revenue
FROM code_bsacis_project.fact_ad_revenue AS REV
JOIN code_bsacis_project.dim_ad_category AS Cat
ON REV.ad_category = Cat.ad_category_id
Group By Year,category_group
Order By Year Asc
),
YearlyTotal AS (
SELECT Year,
        SUM(ad_revenue) AS total_revenue_year
    FROM code_bsacis_project.fact_ad_revenue
    GROUP BY Year
    order by Year asc
)
SELECT
    CR.year,
    CR.category_group,
    CR.Category_Revenue,
    ROUND(YT.total_revenue_year,2) As Total_revenue_Year,
    ROUND((CR.Category_Revenue* 100.0) / YT.total_revenue_year, 2) AS percentage_of_year_total
FROM CategoryRevenue CR
JOIN YearlyTotal YT ON CR.year = YT.year
# WHERE (CR.category_revenue * 100.0) / YT.total_revenue_year > 40
ORDER BY CR.year, percentage_of_year_total DESC;

