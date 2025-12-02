
/*==============================================================
  NYC RESTAURANT INSPECTIONS — FULL ANALYSIS SCRIPT
  Author: Mathias Ofosu
  Date: 2025-11-05
  Description:
      End-to-end analysis of restaurant inspections.
      Data already cleaned and transformed with Python
      This script contains the analytical queries.
================================================================*/

CREATE DATABASE restaurant_health_inspection;
USE restaurant_health_inspection;


/* SECTION 1: Overall Insights
==================================================
	Count the total number of inspections by borough.

	Calculate the distribution of grades (A, B, C, etc.) across NYC.

	Identify the most common inspection types (Initial, Re-inspection, Pre-permit).
*/

-- Count the total number of inspections
SELECT
	COUNT(*) AS number_of_inspections
FROM
	cleaned_inspection_data;
    
-- Count number of unique restaurants
SELECT
	COUNT(DISTINCT camis) AS number_of_restaurants
FROM
	cleaned_inspection_data;
    
-- There are 30361 unique restaurants inspected in NYC.
    
-- Count the total number of inspections by borough.
SELECT
	boro,
    COUNT(*) AS number_of_inspections
FROM
	cleaned_inspection_data
GROUP BY
	boro
ORDER BY 
	number_of_inspections DESC;
/*
Manhattan leads with 106,783 inspections, followed by Brooklyn and Queens with 74888 and 70693 inspections
respectively
*/

/*
Calculate the distribution of grades (A, B, C, etc.) across NYC.
*/

SELECT
	boro,
    grade,
    COUNT(*) AS number_of_restaurants
FROM
	cleaned_inspection_data
WHERE 
	grade != "Not graded"
GROUP BY
	boro, grade
ORDER BY
	grade, number_of_restaurants DESC;
    
-- Manhattan leads with the highest number of restaurants with grade A restaurants

/* 
Identify the most common inspection types (Initial, Re-inspection, Pre-permit).
*/

SELECT
	inspection_program,
    COUNT(*) AS num_records
FROM
	cleaned_inspection_data
GROUP BY
	inspection_program
ORDER BY
	num_records DESC;
    
-- Count the inspection phases
SELECT
	inspection_phase,
    COUNT(*) AS num_records
FROM
	cleaned_inspection_data
GROUP BY
	inspection_phase
ORDER BY
	num_records DESC;
    
/*
The commonest inspection programs are Cycle inspection, pre-permit and adminstrative Miscellaneous inspections.
Initial inspections was the highest number of inspection phases with 2025252 inspections. 
Re-inspection and Reopening inspection followed with 72471 and 3607 respectively
*/

/* SECTION 2: Violation Analysis
========================================
	Find the top 10 most frequent violations (e.g., “Evidence of mice,” “Improper food temperature”).

	Compare critical vs. non-critical violations.

	See which boroughs or neighborhoods have the highest rate of critical violations.
*/

-- Find the top 10 most frequent violations (e.g., “Evidence of mice,” “Improper food temperature”).
SELECT
	violation_category,
    COUNT(*) AS number_of_violations
FROM
	cleaned_inspection_data
GROUP BY
	violation_category
ORDER BY
	number_of_violations DESC
LIMIT 10;

/*
The top 3 number of violations were issues related to facility maintenance (73430), 
food protection and pest control (54678) and food worker hygiene and other food protection (52022)
*/
    
-- Compare critical vs. non-critical violations.
SELECT
	critical_flag,
    COUNT(*) AS number_of_violations,
    ROUND(COUNT(*) / (SELECT COUNT(*) FROM cleaned_inspection_data WHERE critical_flag != "Not Applicable") * 100, 1) AS pct_violations
FROM
	cleaned_inspection_data
WHERE
	critical_flag != "Not Applicable"
GROUP BY
	critical_flag
ORDER BY
	number_of_violations DESC;
    
/*
There were 153133 critical violations (54.4%) as compared to 128152 non-critical violations (45.6%).
*/

-- See which boroughs or neighborhoods have the highest rate of critical violations.
WITH number_of_restaurants AS ( -- To get the total number of restaurants from each boro
	SELECT
		boro,
		COUNT(*) AS number_of_inspections
	FROM
		cleaned_inspection_data
	WHERE
		critical_flag != "Not Applicable"
	GROUP BY
		boro
)
, number_critically_flagged AS( -- to get the number of critically_flagged restaurants in each boro
	SELECT
		boro,
		COUNT(*) AS number_of_critical_violations
	FROM
		cleaned_inspection_data
	WHERE
		critical_flag = "Critical"
	GROUP BY
		boro
)

SELECT -- finally to show the number and proportion of critical violations
	ns.boro,
    ns.number_of_inspections,
    ncf.number_of_critical_violations,
	ROUND(ncf.number_of_critical_violations / ns.number_of_inspections * 100, 1) AS proportion_of_critical_violations
FROM
	number_of_restaurants AS ns
JOIN
	number_critically_flagged AS ncf
    ON ns.boro = ncf.boro
ORDER BY 
	proportion_of_critical_violations DESC;
/*
All the boroughs had more than 50% of the restaurants flagged for critical violations.

The analysis reveals that 55.7% of inspections in Staten Island had critical violations.
Queens borough has 55% of inspections flagged with critical violations
Brooklyn had 54.9% of inspections flagged with critical violations.
*/

/* SECTION 3: Cuisine Analysis
========================================
	Compare grades by cuisine type (e.g., Chinese vs American vs Italian).

	Find the top 5 cuisines with the lowest average scores.

	Identify cuisines with the highest proportion of “Critical” violations.
*/

-- Compare grades by cuisine type (e.g., Chinese vs American vs Italian).
-- Compare by geographic groupings
SELECT
	cuisine_geographic_category,
    grade,
    COUNT(*) AS number_graded
FROM
	cleaned_inspection_data
WHERE
	grade != "Not graded"
GROUP BY
	cuisine_geographic_category, grade
ORDER BY
	grade, number_graded DESC;

-- Compare by thematic cuisine groupings
SELECT
	thematic_cuisine_category,
    grade,
    COUNT(*) AS number_graded
FROM
	cleaned_inspection_data
WHERE
	grade != "Not graded"
GROUP BY
	thematic_cuisine_category, grade
ORDER BY
	grade, number_graded DESC;
    
/*
American cuisines led the grade A rated cuisines with a number of 25882, European and Asian cuisines recorded
15908 and 15038 respectively.alter

Based on thematic grouping, Ethnic cuisines dominated all the grades, followed by quick service cuisines. 
This is because they have the highest number of restaurants under them.
*/


-- Find the top 5 cuisines with the lowest average scores.
-- geographic categories
SELECT
	cuisine_geographic_category,
    ROUND(AVG(score), 2) AS average_score
FROM
	cleaned_inspection_data
WHERE
	cuisine_geographic_category != "Not listed"
GROUP BY
	cuisine_geographic_category
ORDER BY
	average_score ASC
LIMIT 5;

-- thematic categories
SELECT
	thematic_cuisine_category,
    ROUND(AVG(score), 2) AS average_score
FROM
	cleaned_inspection_data
WHERE
	 thematic_cuisine_category != "Not listed"
GROUP BY
	thematic_cuisine_category
ORDER BY
	average_score ASC
LIMIT 5;

/*
In terms of geographic categories, Neutral cuisines, American and European cuisines had the lowest average scores of
21.93, 22.3, 24.48 respectively.alter

In terms of thematic groupings, beverage-centric (21.65), quick service (21.79) 
and health/plant-based cuisines (23.1) had the lowest average scores.
*/

-- Identify cuisines with the highest proportion of “Critical” violations.
-- geographic groupings
WITH number_of_cuisines AS ( -- To get the total number of restaurants from each boro
	SELECT
		cuisine_geographic_category,
		COUNT(*) AS number_of_cuisines
	FROM
		cleaned_inspection_data
	WHERE
		critical_flag != "Not Applicable"
	GROUP BY
		cuisine_geographic_category
)
, number_critically_flagged AS( -- to get the number of critically_flagged restaurants in each boro
	SELECT
		cuisine_geographic_category,
		COUNT(*) AS number_of_critical_violations
	FROM
		cleaned_inspection_data
	WHERE
		critical_flag = "Critical"
	GROUP BY
		cuisine_geographic_category
)

SELECT -- finally to show the number and proportion of critical violations
	nc.cuisine_geographic_category,
    nc.number_of_cuisines,
    ncf.number_of_critical_violations,
	ROUND(ncf.number_of_critical_violations / nc.number_of_cuisines * 100, 1) AS proportion_of_critical_violations
FROM
	number_of_cuisines AS nc
JOIN
	number_critically_flagged AS ncf
    ON nc.cuisine_geographic_category = ncf.cuisine_geographic_category
ORDER BY 
	proportion_of_critical_violations DESC;
    
-- thematic groupings
WITH number_of_cuisines AS ( -- To get the total number of restaurants from each boro
	SELECT
		thematic_cuisine_category,
		COUNT(*) AS number_of_cuisines
	FROM
		cleaned_inspection_data
	WHERE
		critical_flag != "Not Applicable"
	GROUP BY
		thematic_cuisine_category
)
, number_critically_flagged AS( -- to get the number of critically_flagged restaurants in each boro
	SELECT
		thematic_cuisine_category,
		COUNT(*) AS number_of_critical_violations
	FROM
		cleaned_inspection_data
	WHERE
		critical_flag = "Critical"
	GROUP BY
		thematic_cuisine_category
)

SELECT -- finally to show the number and proportion of critical violations
	nc.thematic_cuisine_category,
    nc.number_of_cuisines,
    ncf.number_of_critical_violations,
	ROUND(ncf.number_of_critical_violations / nc.number_of_cuisines * 100, 1) AS proportion_of_critical_violations
FROM
	number_of_cuisines AS nc
JOIN
	number_critically_flagged AS ncf
    ON nc.thematic_cuisine_category = ncf.thematic_cuisine_category
ORDER BY 
	proportion_of_critical_violations DESC;
    
/*
Asian (57.9), African (57.3) and European (55.2) had the highest proportion of critical violation

On thematic groupings, ethnic cuisines (55.7), fine dinning (55.4) and desserts/bakery (53.2) had
the highest number of critical violations
*/


-- The next sections of the analysis was carried out with Microsoft PowerBi for the visualisations
/*
SECTION 4: Geographic & Time Trends
=======================================
	Visualize restaurant grades across boroughs (map or bar chart).

	Check if violations or scores have improved or worsened over time.

	Highlight if certain neighborhoods consistently perform worse.
*/

/*
Recommendations
=======================

	Suggest where targeted inspections or public health campaigns should focus.

	Identify cuisines/areas where more food safety training could reduce risks.

	Highlight policy opportunities (e.g., stricter enforcement in high-violation zones).
*/
