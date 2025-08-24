With MonthlyChange AS (
SELECT 
    T2.city AS City_name,
    T1.Month,
    T1.Year,
    T1.Net_Circulation,
    LAG(T1.Net_Circulation) OVER (
        PARTITION BY T2.city 
        ORDER BY T1.Month
    ) AS Previous_Month_Circulation,
		T1.Net_Circulation - LAG(T1.Net_Circulation) OVER (
        PARTITION BY T2.city 
        ORDER BY T1.Month
        ) AS differnce
FROM 
    code_bsacis_project.fact_print_sales AS T1
JOIN 
    code_bsacis_project.dim_city AS T2
    ON T1.City_ID = T2.city_id
    order by T1.Year)
    
    Select City_name,Month,Net_Circulation,Previous_Month_Circulation,differnce FROM MonthlyChange
    WHERE differnce < 0
ORDER BY ABS(differnce) DESC
LIMIT 3;

