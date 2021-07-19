select*
from [portfolio project]..coviddeaths
where continent is not null
order by 3,4;

--select*
--from [portfolio project]..covidvaccination
--order by 3,4;

--select the data that we are using 


select location ,date, total_cases, total_deaths, new_cases, population
from [portfolio project]..coviddeaths
where continent is not null
order by 1,2;

--looking at total_cases vs total_deaths
select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from [portfolio project]..coviddeaths
where location like '%states%'
and continent is not null
order by 1,2;

--looking at total casesvs population
--show what percentage of popultaion got covid

select location, date, population,(total_cases/population)*100 as percentagepopulationinfected
from [portfolio project]..coviddeaths
--where location like '%india%'
and continent is not null
order by 1,2;

--looking at countries with highest infection rate compared to population

select location, population,max(total_cases) as higjhestinfectioncount, max(total_cases/population)*100 as percentagepopulationinfected
from [portfolio project]..coviddeaths
--where location like '%india%'
and continent is not null
group by location, population
order by  percentagepopulationinfected desc

--showing countries with highestndeath count per population

select location, max(cast (total_deaths as int)) as totaldeathcount
from [portfolio project]..coviddeaths
--where location like '%states%'
where continent is not null
group by location
order by totaldeathcount desc


--lets break things  down by continent


select continent, max(cast (total_deaths as int)) as totaldeathcount
from [portfolio project]..coviddeaths
--where location like '%states%'
where continent is not null
group by continent
order by totaldeathcount desc


--lets break things  down by continent

-- showing the continent with the highest death count per population

select continent, max(cast (total_deaths as int)) as totaldeathcount
from [portfolio project]..coviddeaths
--where location like '%states%'
where continent is not null
group by continent
order by totaldeathcount desc



--global numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from [portfolio project]..coviddeaths
--where location like '%states%'
where continent is not null
--group by date
order by 1,2;


--looking at total population vs vaccinatins

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
from [portfolio project]..coviddeaths dea
join [portfolio project]..covidvaccination vac
  on dea.location = vac.location
     and dea.date =vac.date
	 where dea.continent is not null
	 order by 2,3;


--use cte

with popvsvac (continent,location, date, population,new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
from [portfolio project]..coviddeaths dea
join [portfolio project]..covidvaccination vac
  on dea.location = vac.location
     and dea.date =vac.date
	 where dea.continent is not null
	-- order by 2,3;
)
	 select* ,(rollingpeoplevaccinated/population)*100
	 from popvsvac


-- temp table
drop table if exists  #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

Insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
from [portfolio project]..coviddeaths dea
join [portfolio project]..covidvaccination vac
  on dea.location = vac.location
     and dea.date =vac.date
	  where dea.continent is not null
	-- order by 2,3;

	select* ,(rollingpeoplevaccinated/population)*100
	 from #percentpopulationvaccinated

--creating view to store data for later visualizations


create view percentpopulationvaccinateds as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
from [portfolio project]..coviddeaths dea
join [portfolio project]..covidvaccination vac
  on dea.location = vac.location
     and dea.date =vac.date
	  where dea.continent is not null
	-- order by 2,3;



 select*
 from percentpopulationvaccinateds



