
   

   
   WITH converted_data AS (
    SELECT *,
        -- Cast the character column to a numeric type (e.g., DECIMAL or INT)
        CAST(IMD_score AS DECIMAL(10,2)) AS imd_numeric
    FROM [Client_BTP_RW].[DOH001_MPI]
    WHERE IMD_score IS NOT NULL 
      -- Optional: Filters out non-numeric text to prevent casting errors
     -- AND IMD_score SIMILAR TO '[0-9]+(\.[0-9]+)?' 
),
quintile_boundaries AS (
    -- Step 2: Find the exact Max boundary for each quintile group
    SELECT 
        quintile,
        MAX(imd_numeric) AS max_val
    FROM (
        SELECT imd_numeric, NTILE(5) OVER (ORDER BY imd_numeric) AS quintile
        FROM converted_data
    ) t
    GROUP BY quintile
),
ranges AS (
    -- Step 3: Flatten the boundaries into single row variables for easy comparison
    SELECT 
        (SELECT max_val FROM quintile_boundaries WHERE quintile = 1) AS q1_max,
        (SELECT max_val FROM quintile_boundaries WHERE quintile = 2) AS q2_max,
        (SELECT max_val FROM quintile_boundaries WHERE quintile = 3) AS q3_max,
        (SELECT max_val FROM quintile_boundaries WHERE quintile = 4) AS q4_max
)

-- Step 4: Tag every row in the original table with its specific section
SELECT 
    c.*,
    CASE 
        WHEN c.imd_numeric <= r.q1_max THEN 'Section 1 (Lowest 20%)'
        WHEN c.imd_numeric <= r.q2_max THEN 'Section 2'
        WHEN c.imd_numeric <= r.q3_max THEN 'Section 3'
        WHEN c.imd_numeric <= r.q4_max THEN 'Section 4'
        ELSE 'Section 5 (Highest 20%)'
    END AS quintile_section
    into [Client_BTP_RW].[DOH003_MPI]
FROM converted_data c
CROSS JOIN ranges r
ORDER BY c.imd_numeric;





/*ORDER BY quintile;


SELECT
    case
  when [IMD_score]
  end  As IMD_quintile,
   count(*) as total_count,
  [Sex]
    
  FROM [Client_BTP_RW].[DOH002_MPI] 
  
 where [deceased] = 'N'

  group by 
  case
  
  end  ,
  
  Sex
  order by 1*/

