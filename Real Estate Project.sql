-- MUNICIPALITY SCREENER FOR RESIDENTIAL REAL ESTATE
-- Purpose: Help identify municipalities in Finland that show investment potential in residential real estate
-- Tables: prices.csv, demographic2015.csv, demographic2020.csv, postcodes.csv


-- 1. RESTRUCTURE "PRICES" TABLE
-- The "prices" table is grouped by year [year, municipality, house type, m2 price]
-- We need it grouped by municipality and house type, with 2015 and 2020 prices in individual columns and a new column for 2015-2020 price growth 
-- Format: [municipality, house type, 2015 price, 2020 price, price growth]

SELECT
	municipality,
	house_type,
	price_2015,
	price_2020,
	price_2020 / price_2015 -1 AS price_growth
FROM 
(
	SELECT municipality, house_type, m2_price AS price_2015
	FROM prices
	WHERE year = 2015
) a
JOIN
(
	SELECT municipality, house_type, m2_price AS price_2020
	FROM prices
	WHERE year = 2020
) b
USING (municipality, house_type)



-- 2. JOIN DEMOGRAPHICS TABLES WITH "POSTCODES" TABLE, ADD RANKINGS FOR GROWTH IN POPULATION, INCOME AND JOBS
-- The "demographic2015" and "demographic2020" tables are grouped by a string that begins with a postal code, need to extract that and join with "postcodes" table to get municipality name
-- Add columns for 2015 and 2020 total incomes per postal code (avg income * number of adults), to get an accurate average income when grouping all postcodes by their shared municipality
-- Drop the postcode column, save as a temp table

CREATE TEMPORARY TABLE demographics_ungrouped
SELECT 
	municipality,
	population_2015,
	adults_2015,
	avg_income_2015,
	jobs_2015,
	population_2020,
	adults_2020,
	avg_income_2020,
	jobs_2020,
	adults_2015 * avg_income_2015 AS total_income2015, 
	adults_2020 * avg_income_2020 AS total_income2020
FROM 
(
	SELECT 
		municipality,
		postcode
	FROM postcodes
) a
JOIN
(
	SELECT
		LEFT(postcode, 5) AS postcode,
		population_2015,
		adults_2015,
		avg_income_2015,
		jobs_2015
	FROM demographic2015
) b
USING (postcode)
JOIN 
(
	SELECT 
		LEFT(postcode, 5) AS postcode,
		population_2020,
		adults_2020,
		avg_income_2020,
		jobs_2020
	FROM demographic2020
) c
USING (postcode)

-- Check temp table

SELECT *
FROM demographics_ungrouped


-- Group by municipality, add new average income column and growth columns for population, income and jobs
-- Saving as a temp table for next step

CREATE TEMPORARY TABLE demographics
SELECT 
	*, 
	population_2020 / population_2015 -1 AS population_growth,
	avg_income_2020 / avg_income_2015 -1 AS income_growth,
	jobs_2020 / jobs_2015 -1 AS jobs_growth
FROM (
	SELECT
		municipality,
		SUM(population_2015) AS population_2015,
		SUM(total_income2015) / SUM(adults_2015) AS avg_income_2015,
		SUM(jobs_2015) AS jobs_2015,
		SUM(population_2020) AS population_2020,
		SUM(total_income2020) / SUM(adults_2020) AS avg_income_2020,
		SUM(jobs_2020) AS jobs_2020
	FROM demographics_ungrouped
	GROUP BY municipality ) a

-- Check temp table

SELECT *
FROM demographics


-- Creating rankings for all 3 growth categories (1 = best growth)

SELECT
	*,
	RANK() OVER (ORDER BY (population_rank + income_rank + jobs_rank) / 3) AS overall_rank
FROM (
	SELECT *,
		RANK() OVER (ORDER BY population_growth DESC) AS population_rank,
		RANK() OVER (ORDER BY income_growth DESC) AS income_rank,
		RANK() OVER (ORDER BY jobs_growth DESC) AS jobs_rank
	FROM demographics ) a




