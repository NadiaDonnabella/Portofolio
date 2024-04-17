select location, date, population, total_cases, new_cases, total_deaths
from covid_deaths
where continent != ""
order by 1, 2;

-- deaths percentage
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deaths_percentage
from covid_deaths
where location = 'indonesia'
and continent != ""
order by 1, 2;

-- percent population infected
select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from covid_deaths
order by 1, 2;

-- countries with highest infection compared to population
select location, population, max(total_cases) as HighestInfection, max((total_cases/population))*100 as PercentPopulationInfected
from covid_deaths
group by location, population
order by PercentPopulationInfected desc;

-- countries with highest death count per population by location
select location, max(total_deaths) as TotalDeathsCount
from covid_deaths
where continent != ""
group by location
order by TotalDeathsCount desc;

-- breaking things down by continent
-- showing continent with the highest death count per population
select continent, max(total_deaths) as TotalDeathsCount
from covid_deaths
where continent != ""
group by continent
order by TotalDeathsCount desc;

-- global number
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_cases)/sum(new_deaths)*100 as DeathsPercentage
from covid_deaths
where continent != ""
order by 1, 2;

-- total populations vs vaccinations
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(v.new_vaccinations) over(partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from covid_deaths d
join covid_vaccinations v
	on d.location = v.location
    and d.date = v.date
where d.continent != ""
order by 2, 3;

-- using CTE to perform calculation on partition by in previous query
with popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(v.new_vaccinations) over(partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from covid_deaths d
join covid_vaccinations v
	on d.location = v.location
    and d.date = v.date
where d.continent != ""
)
select *, (RollingPeopleVaccinated/population)*100 as percentPopulationsVaccinated
from popvsvac;

-- creating view to store data for later visualizations

create view percentPopulationsVaccinated as
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(v.new_vaccinations) over(partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from covid_deaths d
join covid_vaccinations v
	on d.location = v.location
    and d.date = v.date
where d.continent != "";

select * from percentPopulationsVaccinated;