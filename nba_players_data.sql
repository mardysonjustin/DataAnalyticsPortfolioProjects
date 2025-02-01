SELECT * FROM all_seasons;

/* Average Height from all seasons */
SELECT AVG(player_height) / 100 AS average_height_meters
FROM all_seasons;

/* Average Longevity of a Player */
SELECT AVG(longevity) AS avg_longevity_years
FROM (
    SELECT 
        player_name, 
        MIN(LEFT(season, 4)) AS first_season,  
        MAX(LEFT(season, 4)) AS last_season,
        (MAX(LEFT(season, 4)) - MIN(LEFT(season, 4)) + 1) AS longevity
    FROM all_seasons
    GROUP BY player_name
) AS player_longevity;

/* Average Height per Decade */
SELECT CONCAT(LEFT(season, 3), '0s') AS decade,
       AVG(player_height) / 100 AS avg_height_meters
FROM all_seasons
GROUP BY decade
ORDER BY decade;

/* Average Weight per Decade */
SELECT CONCAT(LEFT(season, 3), '0s') AS decade,
       AVG(player_weight) AS avg_weight_kilograms
FROM all_seasons
GROUP BY decade
ORDER BY decade;			


/* Frequency of American players to World players */
SELECT CONCAT(LEFT(season, 3), '0s') AS decade,
       SUM(CASE WHEN country = 'USA' THEN 1 ELSE 0 END) AS usa_players,
       SUM(CASE WHEN country <> 'USA' THEN 1 ELSE 0 END) AS world_players,
       ROUND(
			SUM(CASE WHEN country = 'USA' THEN 1 ELSE 0 END) /
            NULLIF(SUM(CASE WHEN country <> 'USA' THEN 1 ELSE 0 END), 0), 2 
            ) AS usa_to_world_ratio
FROM all_seasons
GROUP BY decade
ORDER BY decade;


/* Average games played per season in each decade */
SELECT CONCAT(LEFT(season, 3), '0s') AS decade,
       AVG(gp) AS games_played
FROM all_seasons
GROUP BY decade
ORDER BY decade;


/* Points inflation */
SELECT CONCAT(LEFT(season, 3), '0s') AS decade,
       AVG(pts) AS avg_ppg
FROM all_seasons
GROUP BY decade
ORDER BY decade;

/* Stats inflation */
SELECT CONCAT(LEFT(season, 3), '0s') AS decade,
       AVG(pts) AS avg_ppg,
       AVG(ast) AS avg_ast,
       AVG(reb) AS avg_reb
FROM all_seasons
GROUP BY decade
ORDER BY decade;


/* True Shooting Percentage Analysis */
SELECT CONCAT(LEFT(season, 3), '0s') AS decade,
       AVG(ts_pct) AS avg_ts_pct
FROM all_seasons
GROUP BY decade
ORDER BY decade;



SELECT DISTINCT college
FROM all_seasons
ORDER BY college;

/* College Schools Frequency */
SELECT 
    college, 
    COUNT(*) AS player_count
FROM all_seasons
GROUP BY college
ORDER BY player_count DESC;

