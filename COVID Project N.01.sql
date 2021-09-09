select*
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select*
--from PortfolioProject..CovidVaccinations
--order by 3,4

select location,date, total_cases, new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths

select location,date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%State%'
order by 1,2 

-- Looking at Total cases vs Population
-- Shows what perecentage of  population got COVID

select location,date, total_cases,total_deaths, population, (total_deaths/population)*100 as CovidPopulationPercentage
from PortfolioProject..CovidDeaths
--where location in ('Slovakia')
order by 1,2

-- Looking at countries with highest infection rate compared of Population

select location, Max(total_cases) as HighesInfectionCount, Max((total_deaths/population))*100 as CovidPopulationPercentage
from PortfolioProject..CovidDeaths
--where location in ('Slovakia')
group by location,population
order by CovidPopulationPercentage desc

-- Showing countries with highest death count population
Select location,Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc



-- By continent

Select continent,Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

-- showing with continent highst death count per population

Select continent, Max(cast(total_deaths as int)) as HightDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group By continent
Order by HightDeathCount desc

-- Global Numbers

Select  SUM(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
--where location like '%State%'
Where continent is not null
--Group By date
order by 1,2 


-- Looking at total population vs Vaccination


select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, cast(dea.date as datetime)) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated)population*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location= vac.location
	and dea.date= vac.date
Where dea.continent is not null
order by 2,3



--CTE
with PopvsVac(continent,location,date, population,new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, cast(dea.date as datetime)) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated)population*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location= vac.location
	and dea.date= vac.date
Where dea.continent is not null
--order by 2,3
)
select*, (RollingPeopleVaccinated/population)*100
from PopvsVac


--Temp Table
drop table if exists #PercentPopulationVaccinated
create table  #PercentPopulationVaccinated(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, cast(dea.date as datetime)) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated)population*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location= vac.location
	and dea.date= vac.date
Where dea.continent is not null
--order by 2,3
select*, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

-- Creating view to store data for later visualizations

Create view PercentPopulationVaccinated as
select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, cast(dea.date as datetime)) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated)population*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location= vac.location
	and dea.date= vac.date
Where dea.continent is not null
--order by 2,3


select*
from PercentPopulationVaccinated
