#CREATING "coviddeath" TABLE TO INSERT DATA FROM CSV FILE
CREATE TABLE coviddeaths (
    id INT NOT NULL AUTO_INCREMENT,
    iso_code VARCHAR(255) NOT NULL,
    continent VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    date VARCHAR(255) NOT NULL,
    population VARCHAR(255) NOT NULL,
    total_cases VARCHAR(255) NOT NULL,
    new_cases VARCHAR(255) NOT NULL,
    new_cases_smoothed VARCHAR(255) NOT NULL,
    total_deaths VARCHAR(255) NOT NULL,
    new_deaths VARCHAR(255) NOT NULL,
    new_deaths_smoothed VARCHAR(255) NOT NULL,
    total_cases_per_million VARCHAR(255) NOT NULL,
    new_cases_per_million VARCHAR(255) NOT NULL,
    new_cases_smoothed_per_million VARCHAR(255) NOT NULL,
    total_deaths_per_million VARCHAR(255) NOT NULL,
    new_deaths_per_million VARCHAR(255) NOT NULL,
    new_deaths_smoothed_per_million VARCHAR(255) NOT NULL,
    reproduction_rate VARCHAR(255) NOT NULL,
    icu_patients VARCHAR(255) NOT NULL,
    icu_patients_per_million VARCHAR(255) NOT NULL,
    hosp_patients VARCHAR(255) NOT NULL,
    hosp_patients_per_million VARCHAR(255) NOT NULL,
    weekly_icu_admissions VARCHAR(255) NOT NULL,
    weekly_icu_admissions_per_million VARCHAR(255) NOT NULL,
	weekly_hosp_admissions VARCHAR(255) NOT NULL,
	weekly_hosp_admissions_per_million VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

#CREATING "covidvaccinated" TABLE TO INSERT DATA FROM CSV FILE
CREATE TABLE covidvaccinated (
    ID INT NOT NULL AUTO_INCREMENT,
    iso_code VARCHAR(255) NOT NULL,
    continent VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    date VARCHAR(255) NOT NULL,
    new_tests VARCHAR(255) NOT NULL	,
    total_tests	VARCHAR(255) NOT NULL,
    total_tests_per_thousand VARCHAR(255) NOT NULL,
    new_tests_per_thousand VARCHAR(255) NOT NULL,
    new_tests_smoothed VARCHAR(255) NOT NULL,
    new_tests_smoothed_per_thousand	VARCHAR(255) NOT NULL,
    positive_rate VARCHAR(255) NOT NULL,
    tests_per_case VARCHAR(255) NOT NULL,	
    tests_units	VARCHAR(255) NOT NULL,
    total_vaccinations VARCHAR(255) NOT NULL,
	people_vaccinated VARCHAR(255) NOT NULL,
    people_fully_vaccinated	VARCHAR(255) NOT NULL,
    total_boosters VARCHAR(255) NOT NULL,
    new_vaccinations VARCHAR(255) NOT NULL,
	new_vaccinations_smoothed VARCHAR(255) NOT NULL,
    total_vaccinations_per_hundred VARCHAR(255) NOT NULL,
    people_vaccinated_per_hundred VARCHAR(255) NOT NULL,
    people_fully_vaccinated_per_hundred VARCHAR(255) NOT NULL,
    total_boosters_per_hundred VARCHAR(255) NOT NULL,
    new_vaccinations_smoothed_per_million VARCHAR(255) NOT NULL,
    stringency_index VARCHAR(255) NOT NULL,
    population_density VARCHAR(255) NOT NULL,
    median_age VARCHAR(255) NOT NULL,
    aged_65_older VARCHAR(255) NOT NULL,
    aged_70_older VARCHAR(255) NOT NULL,
    gdp_per_capita VARCHAR(255) NOT NULL,
    extreme_poverty	VARCHAR(255) NOT NULL,
    cardiovasc_death_rate VARCHAR(255) NOT NULL,
	diabetes_prevalence VARCHAR(255) NOT NULL,	
    female_smokers VARCHAR(255) NOT NULL,
    male_smokers VARCHAR(255) NOT NULL,
    handwashing_facilities VARCHAR(255) NOT NULL,
    hospital_beds_per_thousand VARCHAR(255) NOT NULL,
    life_expectancy	VARCHAR(255) NOT NULL,
    human_development_index	 VARCHAR(255) NOT NULL,
    excess_mortality_cumulative_absolute VARCHAR(255) NOT NULL,
    excess_mortality_cumulative	VARCHAR(255) NOT NULL,
    excess_mortality VARCHAR(255) NOT NULL,
    excess_mortality_cumulative_per_million VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID)
);

#Looking at Covid Death data
select location AS "Country",date AS "Date",total_cases AS "Total Cases",new_cases AS "New Cases",total_deaths AS "Total Deaths"
,population AS "Population"
from coviddeaths
order by location,date;

#Percentage of people got infected by COVID-19 in each country by Date
select location AS "Country",date AS "Date",population AS "Population",total_cases AS "Total Cases"
,(total_cases/population)*100 AS "Percentage_of_Population_Infected"
from coviddeaths
order by location,date;

#Percentage of death due to COVID-19 in each country by Date
select location AS "Country",date AS "Date",total_cases AS "Total Cases",total_deaths AS "Total Deaths",population AS "Population",
(total_deaths/total_cases)*100 AS "Death_Percentage(%)"
from coviddeaths
order by location,date;

#Total COVID-19 cases by Countries 
select location AS "Country",SUM(total_cases) AS "Overall Total Cases"
from coviddeaths
group by location;

#Total Death Count by Countries
select location AS "Country",SUM(total_deaths) AS "Overall Total Deaths"
from coviddeaths
group by location;

#Total Death Count by continents
select continent AS "Continent",SUM(total_deaths) AS "Overall_Total_Deaths_Continent"
from coviddeaths
where continent is NOT NULL
group by continent
order by Overall_Total_Deaths_Continent desc;

#Highest Death Count in a Single day by Countries 
select location AS "Country",MAX(CAST(total_deaths AS SIGNED)) AS "Highest_Death" 
from coviddeaths
Where location NOT IN('World','Upper middle income','High income','Europe','Asia','South America','North America',
'Lower middle income','European Union')
group by location
order by Highest_Death desc;

#Highest Death Count in a Single day by Continents
select continent AS "Continent",MAX(CAST(total_deaths AS SIGNED)) AS "Highest_Death_Continent"
from coviddeaths
where continent is NOT NULL
group by continent
order by Highest_Death_Continent desc;

#Highest Infection Rate in a single day by Countries 
select location AS "Country",population AS "Population",MAX(total_cases) AS "Max Cases in a Day",((MAX(total_cases)/population)*100)AS "Highest_Infection_Rate"
from coviddeaths
group by location,population
order by Highest_Infection_Rate desc;

#Total New Cases and Total New Deaths by countries
select location AS "Country", SUM(new_cases) AS "Total_New_Cases_By_Countries", SUM(new_deaths) AS "Total_New_Deaths_By_Countries"
,((SUM(new_deaths)/SUM(new_cases))*100) AS "New_Deaths(%)"
from coviddeaths
group by location; 

#Joining coviddeaths and covidvaccinated Tables
#Method 1
select *
from covidvaccinated JOIN coviddeaths ON
covidvaccinated.location = coviddeaths.location and
covidvaccinated.date = coviddeaths.date;

#Method 2 
select * 
from covidvaccinated JOIN coviddeaths ON
covidvaccinated.ID = coviddeaths.id;

#Total number of vaccinated people in each Country
select coviddeaths.location AS "Country",SUM(covidvaccinated.new_vaccinations) AS "Total_Vaccinations_By_Countries"
from covidvaccinated JOIN coviddeaths ON 
covidvaccinated.location = coviddeaths.location AND 
covidvaccinated.date = coviddeaths.date
group by coviddeaths.location;

#Total Number of vaccinated people in each country on each date
select coviddeaths.location AS "Country",coviddeaths.date AS "Date",coviddeaths.population AS "Population",
covidvaccinated.new_vaccinations AS "New Vaccinations",SUM(covidvaccinated.new_vaccinations) OVER 
(PARTITION BY coviddeaths.location ORDER BY coviddeaths.location,coviddeaths.date) AS "Total_No_Of_Vaccinated_People_on_Each_Date"
from covidvaccinated JOIN coviddeaths ON
covidvaccinated.location = coviddeaths.location AND
covidvaccinated.date = coviddeaths.date;

#Percentage of Total Number of vaccinated people in each country on each date
WITH VaccinationPercent (Location,Date,Population,New_Vaccinations,Total_No_Of_Vaccinated_People_on_Each_Date) 
AS
(
select coviddeaths.location AS "Country",coviddeaths.date AS "Date",coviddeaths.population AS "Population",
covidvaccinated.new_vaccinations AS "New Vaccinations",SUM(covidvaccinated.new_vaccinations) OVER 
(PARTITION BY coviddeaths.location ORDER BY coviddeaths.location,coviddeaths.date) AS "Total_No_Of_Vaccinated_People_on_Each_Date"
from covidvaccinated JOIN coviddeaths ON
covidvaccinated.location = coviddeaths.location AND
covidvaccinated.date = coviddeaths.date
)

select *,(Total_No_Of_Vaccinated_People_on_Each_Date/Population)*100
from VaccinationPercent


