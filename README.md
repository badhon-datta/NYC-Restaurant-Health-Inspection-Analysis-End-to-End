# **New York City Restaurant Health Inspection Analysis**

---

## 📌 Project Overview

NYC restaurant health inspections are designed to protect public health by ensuring food safety, sanitation, and regulatory compliance across all food service establishments. Inspectors check for compliance with New York City Health Code and New York State Sanitary Code, which set standards for cleanliness, food storage, pest control, and employee hygiene. The dataset includes restaurant details, location, cuisine descriptions, inspection results, grades, and violation types.

### 🙏 Credit

- **[Analyst Builder](https://www.analystbuilder.com/projects/restaurant-health-inspection-analysis-nyc-FhAOm)** for the datasets and the directions for the analysis.

- **[NYC Environmental Health Services team at DOHMH](https://github.com/nycehs/NYC_geography)** for the topo-json of NYC.


## 🎯 Objectives

- To identify common health violations
- To analyze trends by cuisine and geography
- To find variations in grades and violations across boroughs and over time.
- To provide actionable recommendations.

## 🛠️ Tools Used

- Python: Pandas, SQLAlchemy, pymysql
- MySQL Workbench  
- Microsoft Power BI (Desktop)

## 🧠 Skills Demonstrated

- Data cleaning and transformation with Python  
- SQL analysis using CTEs, subqueries, joins, and aggregations  
- Interactive dashboards with Power BI  

---

## ⚙️ Methodology  

### 📥 Data Loading  
Raw data was imported into a Jupyter notebook using `pandas`, cleaned and transformed, then exported to MySQL Workbench via `SQLAlchemy` and `pymysql`.


### 🧹 Data Cleaning  

1. **Initial Inspection**  
   Reviewed structure and content of the raw dataset.

2. **Column Standardization**  
   Renamed all columns to lowercase and replaced spaces with underscores for consistency.

3. **Duplicate Removal**  
   Dropped rows with identical `camis`, `inspection_date`, and `violation_code`.

4. **Type Conversion**  
   Converted date fields (`inspection_date`, `grade_date`, `record_date`) to datetime format.

5. **String Cleanup**  
   Trimmed whitespace and converted `dba` names to title case.

6. **Inspection Type Parsing**  
   Split `inspection_type` into two new columns: `inspection_program` and `inspection_phase`.

7. **Cuisine Categorization**  
   Standardized `cuisine_description` by:  
   - **Geographic origin** (e.g., African, European, American)  
   - **Thematic grouping** (e.g., ethnic, fast food, beverage)

8. **Violation Grouping**  
   Mapped 148 violation codes into broader categories using [NYC Health Code](https://codelibrary.amlegal.com/codes/newyorkcity/latest/NYCrules/0-0-0-43593).

9. **Missing Value Imputation**  
   Filled gaps in `inspection_program`, `inspection_phase`, and `grade`.

10. **Column Pruning**  
    Dropped fields which were irrelevant for the analysis: `inspection_type`, `cuisine_description`, `action`, `violation_description`, `building`, `latitude`,`longitude`, `street`, `phone`, `community_board`, `council_district`, `bin`, `bbl`, `nta`, and `census_tract`.


### 📊 Exploratory Data Analysis (EDA)

The cleaned data was exported to MySQL workbench and then connected to Power BI for the analysis. Several techniques like aggregations, CTEs, and joins were used to glean insights using SQL. I then used Power BI to visualise the data and mapped NYC using zipcodes to identify violation hotspots across the city.

---

## 🔍 Key Findings  

### 📌 Overall Insights  
- There were **288867 total inspections** in over **30,360 different restaurants** across the city. **Manhattan** leads with 106,783 inspections, followed by Brooklyn and Queens with 74888 and 70693 inspections respectively.

- **Cycle inspections** (215866, 75.7%) and **Pre-permit inspections** (56233, 19.7%) were the top inspection programmes with **initial inspection** (205252) and **re-inspection** (72471) being the top inspection phases.

<br>
<p align="center">
  <img src="images/Overview.png" width="1200"/>
</p>

*A screenshot of the overview of the insights*

<br>


### 🚨 Violation Analysis 

- The top 5 violations were **Facility Maintenance** (73430), **Food Protection & Pest Control** (54678), **Food Worker Hygiene and Other Food Protection** (52022), **Time and Temperature Control for Safety** (36742) and **Garbage, Waste Disposal and Pest Management** (33802).

- Most of the violations 153133 (54.4%) were found to be **Critical** and so pose significant public health risk.

- Manhattan led the boroughs with the highest number of critical violations. The proportion of critical and non-critical violations were found to be similar across all  the boroughs. This means that in the broad sense, majority of the inspections across all the boroughs revealed critical violations. This finding is alarming.

<br>

 *The table below shows the critical violation hotspots areas in each borough when mapped using zipcodes.*



| Borough | Critical Hotspots (zipcode areas) |
|--------------|-----------------------|
|Manhattan | `10003`, `10019`, `10012` and `10013`|
| Brooklyn | `11220`, `11201` and `11211` |
| Bronx | `10458`, `10461`, and `10467` |
| Queens |  `11354 `, `11101`, `11372` |
|Staten Island | `10314`, `10306` and `10301` |

<br>
<p align="center">
  <img src="images/Violation mapping.png" width="1200"/>
</p>

*A screenshot of the violation mapping of NYC using zipcodes.*

<br>

### 🍽️ Cuisine Analysis  

- The top cuisines were **American**, **Asian** and **Neutral cuisines**. Restaurants serving American cuisines had the highest number of critical violations with the hotspots being zipcode areas **`10001`**, **`10019`** and **`10036`** all in Manhattan.

- Area **`11365`** in Queens was the hotspot for critical violations for restaurants that serve **Asian Cuisines**.

- For European cuisines, the critcal hotspots were found in areas in Manhattan.

- Restaurants serving American cuisines had the highest number of grade A ratings.


### 🗺️ Geographic and Temporal Trends

- There has been a general increase in scores over the years for all the boroughs.

<br>
<p align="left">
  <img src="images/annual_average_score.png" width="600"/>
</p>

*A screenshot of the annual average scores.*

<br>


- Manhattan having the highest number of restaurants leads in all the violations.

- Manhattan also had the highest number of grade A restaurants.

- The impact of COVID 19 pandemic exposes a gap in the inpections from 2020 to 2021. This is seen by drilling down the data in Power BI.

---

## 💡 Recommendations 

1. Improve re-inspection frequency in high-risk areas and restaurants
2. Targeted education for cuisines with frequent violations.
3. A city campaign to train food workers on hygiene and safety.
4. Restaurants should adhere to temperature control guidelines.
5. Pass legislation for restaurants to have internal quality assurance managers to ensure compliance to the health codes.

---

## 🏁 Conclusion

Common critical violations found were food protection and self control as well as food worker hygiene. These critcal violations were prevalent accross all boroughs even though certian areas seem to be hotspots.
City authorities must come out with revised policies to protect the general public from the dire consequences of these critical violations.

---

## 🔍 Further Analysis Opportunities

- Predictive modeling for future violations  
- Sentiment analysis from customer reviews  
- Comparison with other cities

-------------

📬 Contact
If you'd like to connect, collaborate, or discuss this project further:

📧 **Email:** mathiasofosu2@gmail.com

💼 **LinkedIn:** [Mathias Ofosu](https://linkedin.com/in/mathias-ofosu)

🧠 **GitHub Profile:** [Mathias Ofosu](https://github.com/MKOfosu)

🌟**Twitter/X:** [Mathias Ofosu](https://x.com/MKOfosu)

Feel free to reach out. I’m always open to data-driven conversations on how to unlock actionable insights from your data.
