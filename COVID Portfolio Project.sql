--Data validation
SELECT *
FROM PortfolioProject..CovidDeaths
Where continent is not null
ORDER BY 3,4

SELECT *
FROM PortfolioProject..CovidVaccinations
Where continent is not null
ORDER BY 3,4

--Select Data that I am going to use
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
Where continent is not null
ORDER BY 1,2

--Looking at the Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where location like '%Poland%'
AND continent is not null
ORDER BY 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got COVID

SELECT Location, date, population, total_cases, (total_cases/population) * 100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
Where location like '%Poland%'
AND continent is not null
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) * 100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY Location, population
ORDER BY PercentPopulationInfected DESC


--Showing countries with highest death count per populaiton

SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Showing continents with the highest death count

SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC


--- Global numbers

SELECT date, SUM(new_cases) as NewCasesGlobal, SUM(CAST(new_deaths as int)) as NewDeathsGlobal, CAST(ROUND(SUM(CAST(new_deaths as int))/SUM(new_cases),4) as float) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
HAVING SUM(new_cases) is not null
ORDER BY 1,2 

-- Global in total numbers

SELECT SUM(new_cases) as NewCasesGlobal, SUM(CAST(new_deaths as int)) as NewDeathsGlobal, CAST(ROUND(SUM(CAST(new_deaths as int))/SUM(new_cases),4) as float) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
HAVING SUM(new_cases) is not null
ORDER BY 1,2 


-- Looking at total population vs vaccinations
-- USE CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) 
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) * 100
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidVaccinations AS vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *, CONCAT(ROUND(((RollingPeopleVaccinated/population) * 100),2),'%') AS RollingPeopleVaccinatedPercent
FROM PopvsVac



-- Creating Temporary table

DROP Table if exists #PercentPopulationVaccinated 
CREATE TABLE #PercentPopulationVaccinated 
(
Continent nvarchar(255), 
Location nvarchar(255), 
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) * 100
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidVaccinations AS vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, CONCAT(ROUND(((RollingPeopleVaccinated/population) * 100),2),'%') AS RollingPeopleVaccinatedPercent
FROM #PercentPopulationVaccinated 

-- Creating view to store data for later visualization

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidVaccinations AS vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
