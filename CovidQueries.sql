-- Useful Data
SELECT location, date, population, total_cases, new_cases, total_deaths
FROM CovidDeathData1;

SELECT *
FROM CovidVaccinationData1;



-- Death Percentage
SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeathData1;

SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From CovidDeathData1
WHERE location = 'United States';



-- Infection Percentage
SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectionPercentage
FROM CovidDeathData1;

SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectionPercentage
FROM CovidDeathData1
WHERE location = 'United States';



-- Total Percentage of Population Infected by Country
SELECT location, population, MAX(total_cases) AS ReportedCases, MAX((total_cases/population))*100 AS CasePercentage
FROM CovidDeathData1
WHERE continent <> ""
GROUP BY location, population
ORDER BY CasePercentage DESC;



-- Highest Death Count by Country
SELECT location, MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM CovidDeathData1
WHERE continent <> ""
GROUP BY location
ORDER BY TotalDeathCount DESC;



-- Highest Death Count by Continent
SELECT location, MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
From CovidDeathData1
WHERE continent = ""
GROUP BY location
ORDER BY TotalDeathCount DESC;



-- Global Cases and Deaths
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS UNSIGNED)) AS total_deaths, SUM(CAST(new_deaths AS UNSIGNED))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeathData1
WHERE continent <> ""
GROUP BY date;



-- Population vs New Vaccinations
WITH PopulationVsVaccinations (continent, location, date, population, new_vaccinations, RollingVaccinations)
AS
(
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS RollingVaccinations
FROM CovidDeathData1 death
JOIN CovidVaccinationData1 vac
	ON death.location = vac.location
    and death.date = vac.date
WHERE death.continent <> ""
)

Select *, (RollingVaccinations/population)*100
FROM PopulationVsVaccinations;




-- Creating Views 
CREATE VIEW DeathPercentage AS
SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeathData1;

CREATE VIEW USDeathPercentage AS
SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From CovidDeathData1
WHERE location = 'United States';

CREATE VIEW InfectionPercentage AS
SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectionPercentage
FROM CovidDeathData1;

CREATE VIEW USInfectionPercentage AS
SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectionPercentage
FROM CovidDeathData1
WHERE location = 'United States';

CREATE VIEW CasePercentage AS
SELECT location, population, MAX(total_cases) AS ReportedCases, MAX((total_cases/population))*100 AS CasePercentage
FROM CovidDeathData1
WHERE continent <> ""
GROUP BY location, population
ORDER BY CasePercentage DESC;

CREATE VIEW TotalDeathCount AS
SELECT location, MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM CovidDeathData1
WHERE continent <> ""
GROUP BY location
ORDER BY TotalDeathCount DESC;

CREATE VIEW DailyDeathPercentage AS
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS UNSIGNED)) AS total_deaths, SUM(CAST(new_deaths AS UNSIGNED))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeathData1
WHERE continent <> ""
GROUP BY date;

CREATE VIEW RollingVaccinations AS
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS RollingVaccinations
FROM CovidDeathData1 death
JOIN CovidVaccinationData1 vac
	ON death.location = vac.location
    and death.date = vac.date
WHERE death.continent <> "";

CREATE VIEW PopulationVsVaccinations AS
WITH PopulationVsVaccinations (continent, location, date, population, new_vaccinations, RollingVaccinations)
AS
(
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS RollingVaccinations
FROM CovidDeathData1 death
JOIN CovidVaccinationData1 vac
	ON death.location = vac.location
    and death.date = vac.date
WHERE death.continent <> ""
)

Select *, (RollingVaccinations/population)*100
FROM PopulationVsVaccinations;











