Select *
From [Portfolio Project].dbo.CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From [Portfolio Project].dbo.CovidVaccination
--order by 3,4

--Select Data 


SELECT location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project].dbo.CovidDeaths
order by 1,2


-- TOtal cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From [Portfolio Project].dbo.CovidDeaths
Where location like '%Philippines%'
and continent is not null 
order by 1,2


-- Total Cases vs Population

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Project].dbo.CovidDeaths
Where location like '%Philippines%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project].dbo.CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project].dbo.CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc


-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project].dbo.CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(new_deaths)  as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From [Portfolio Project].dbo.CovidDeaths
where continent is not null 
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location,	
dea.Date) as RollingPeopleVaccinated
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccination vac
	 On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null 
order by 2, 3


-- CTE Population vs Vaccination

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location,	
dea.Date) as RollingPeopleVaccinated
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccination vac
	 On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null 
--order by 2, 3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location,	
dea.Date) as RollingPeopleVaccinated
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccination vac
	 On dea.location = vac.location
	 and dea.date = vac.date
--where dea.continent is not null 
--order by 2, 3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for visualization

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location,	
dea.Date) as RollingPeopleVaccinated
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccination vac
	 On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null 
--order by 2, 3


Select *
From PercentPopulationVaccinated