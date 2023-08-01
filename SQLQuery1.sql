select * From PortofolioProject ..CovidDeaths
order by 3,4
--select * From PortofolioProject ..CovidVaccinations
--order by 3,4
select * From PortofolioProject ..CovidDeaths
order by 3,4

select Location,date,total_cases,new_cases,total_deaths,population
From PortofolioProject ..CovidDeaths
where continent is not NULL

order by 1,2


-- Total cases vs Total Death
select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
From PortofolioProject ..CovidDeaths
order by 1,2 


-- Likelihood you die from covid in egypt
select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
From PortofolioProject ..CovidDeaths
where location ='Egypt' and continent is not NULL
order by 1,2 

---Total cases vs population

select Location,date,total_cases,total_deaths,population,(total_cases/population)*100 as case_percentage
From PortofolioProject ..CovidDeaths
where location ='Egypt' and continent is not NULL
order by 1,2 

--Countries with highest infection Rate compared to population
select Location,population,Max(total_cases)as HighestInfectionRate,Max((total_cases/population))*100 as PercentPopulationInfected
From PortofolioProject ..CovidDeaths
where continent is not NULL
group by location,population
order by PercentPopulationInfected desc

--countries with highest death count per population
select Location,population,Max(total_deaths)as HighestdeathRate,Max((total_deaths/population))*100 as PercentPopulationDead
From PortofolioProject ..CovidDeaths
where continent is not NULL
group by location,population
order by PercentPopulationDead desc

--Continent with highest death count
select continent ,Max(cast(total_deaths as int))as HighestdeathRate
From PortofolioProject ..CovidDeaths
where continent is not NULL
group by continent
order by  HighestdeathRate desc

--Global numbers
--new cases per day/New death 

select date,sum(new_cases) CasesThisDay ,sum(cast(new_deaths as int) ) DeathThisDay,(sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage
From PortofolioProject ..CovidDeaths
where continent is not null 
Group by date
order by 1,2 


select *
From PortofolioProject ..CovidVaccinations



---Total population Vs vaccinations
select dea.date,dea.continent,dea.location,dea.Population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as int )) OVER (Partition by dea.location Order BY dea.location,dea.date)RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortofolioProject ..CovidDeaths dea
join PortofolioProject ..CovidVaccinations  vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null 
order by dea.location,dea.date

--CTE to use columns we created

with PopvsVac (date,continent,location,Population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.date,dea.continent,dea.location,dea.Population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as int )) OVER (Partition by dea.location Order BY dea.location,dea.date)RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortofolioProject ..CovidDeaths dea
join PortofolioProject ..CovidVaccinations  vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null 
--order by dea.location,dea.date
)

Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac


--Temp Table 
Drop Table if exists #PopvsVac
Create Table #PopvsVac(
date datetime,
continent nvarchar(255),
location nvarchar(255),
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PopvsVac
select dea.date,dea.continent,dea.location,dea.Population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as int )) OVER (Partition by dea.location Order BY dea.location,dea.date)RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortofolioProject ..CovidDeaths dea
join PortofolioProject ..CovidVaccinations  vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null 
--order by dea.date,dea.location

Select*,(RollingPeopleVaccinated/population)*100
from #PopvsVac



---Create view to store date for visualizing later
create view PercentPopulationVaccinated as
select dea.date,dea.continent,dea.location,dea.Population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as int )) OVER (Partition by dea.location Order BY dea.location,dea.date)RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortofolioProject ..CovidDeaths dea
join PortofolioProject ..CovidVaccinations  vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null 
--order by dea.date,dea.location


Select * From PercentPopulationVaccinated






