SELECT * from athlete_events;
SELECT * from noc_regions;


-- No. of olympics games have been held
SELECT count(distinct games) as total_olympic_games
    from athlete_events ae;
    

-- All olympics games held so far    
SELECT DISTINCT ae.year, ae.season, ae.city
FROM athlete_events ae
ORDER BY year;


-- Total no of nations who participated in each olympics game
SELECT ae.games, COUNT(DISTINCT nr.Region) as total_countries
FROM athlete_events ae
JOIN noc_regions nr ON nr.noc= ae.noc
GROUP BY ae.games
ORDER BY ae.games;


-- Year with lowest and highest no. of countries participating
WITH country_count AS (
    SELECT ae.games, COUNT(DISTINCT nr.Region) AS total_countries
    FROM athlete_events ae
    JOIN noc_regions nr ON nr.noc = ae.noc
    GROUP BY ae.games
)
SELECT games, total_countries
FROM country_count
WHERE total_countries = (SELECT MAX(total_countries) FROM country_count)
   OR total_countries = (SELECT MIN(total_countries) FROM country_count)
ORDER BY total_countries;

-- Nations that participated in all olympics games x
with total_games as
              (select count(distinct games) as total_gms
              from athlete_events),
          countries as
              (select games, nr.region as country
              from athlete_events ae
              join noc_regions nr ON nr.noc=ae.noc
              group by games, nr.region),
          countries_participated as
              (select country, count(1) as total_participated_games
              from countries
              group by country)
				  select cp.*
				  from countries_participated cp
				  join total_games tg on tg.total_gms = cp.total_participated_games
				  order by 1;

SELECT country, COUNT(DISTINCT games) AS total_participated_games
FROM (
    SELECT games, nr.region AS country
    FROM athlete_events ae
    JOIN noc_regions nr ON nr.noc = ae.noc
    GROUP BY games, nr.region
) countries
GROUP BY country
ORDER BY total_participated_games DESC;

-- Sport played in all of summer olympics
WITH total_summer_games AS (
    SELECT COUNT(DISTINCT games) AS total_games
    FROM athlete_events
    WHERE season = "Summer"
),
sports_played_summer AS (
    SELECT sport, COUNT(DISTINCT games) AS no_of_games
    FROM athlete_events
    WHERE season = "Summer"
    GROUP BY sport
)
SELECT sp.sport, sp.no_of_games
FROM sports_played_summer sp
JOIN total_summer_games tg
    ON sp.no_of_games = tg.total_games
ORDER BY sp.sport;


-- Sport that was played only once in the olympics
WITH sports_played AS (
    SELECT sport, COUNT(DISTINCT games) AS no_of_games
    FROM athlete_events
    GROUP BY sport
),
when_played AS (
	SELECT DISTINCT sport, games
    FROM athlete_events
    )
SELECT sp.sport, sp.no_of_games, wp.games
FROM sports_played sp
JOIN when_played wp ON wp.sport = sp.sport
WHERE sp.no_of_games = 1
ORDER BY sp.sport;


-- No. of games played in each olympics
SELECT games, COUNT(DISTINCT sport) AS total_sports
FROM athlete_events
GROUP BY games
ORDER BY games;


-- Oldest athlete/s to participate (
SELECT *
FROM athlete_events
WHERE CAST(Age AS UNSIGNED) = (
	SELECT MAX(CAST(Age AS UNSIGNED)) 
	FROM athlete_events 
	WHERE Medal = 'Gold'
)
AND Medal = 'Gold';

-- Ratio of men to women athletes
WITH gender_counts AS (
    SELECT 
        SUM(CASE WHEN Sex = 'M' THEN 1 ELSE 0 END) AS male_count,
        SUM(CASE WHEN Sex = 'F' THEN 1 ELSE 0 END) AS female_count
    FROM athlete_events
)
SELECT 
    CONCAT('1:', ROUND(male_count * 1.0 / female_count, 2)) AS ratio
FROM gender_counts;

            
