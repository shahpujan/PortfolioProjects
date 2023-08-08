--select * 
--from PortfolioProject..CovidVaccinations
--------------------------------
--Use CTE to use rolling people vaccinated
With PopvsVac(continent,Location,Date,Population,new_vaccinations,RollingPplVaccinated)
as
-- Looking at total population vs vaccinations
(select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
SUM(convert(bigint,(cv.new_vaccinations))) over (partition by cd.location order by cd.location,cd.date) as RollingPplVaccinated
--(RollingPplVaccinated/population)*100
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
--order by 2,3
)
select * ,round(((RollingPplVaccinated/Population)*100),2)
from PopvsVac


-- Looking at total population vs vaccinations
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
SUM(convert(bigint,(cv.new_vaccinations))) over (partition by cd.location order by cd.location,cd.date) as RollingPplVaccinated
--(RollingPplVaccinated/population)*100
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
order by 2,3


---TEMP TABLE
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingpplVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
SUM(convert(bigint,(cv.new_vaccinations))) over (partition by cd.location order by cd.location,cd.date) as RollingPplVaccinated
--(RollingPplVaccinated/population)*100
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
--order by 2,3

select *,round((RollingPplVaccinated/100),2) as Perc_rollingpplvaccinated
from #PercentPopulationVaccinated

--Creating view for later visualisations

Create View PercentPopulationVaccinated as 
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
	SUM(convert(bigint,(cv.new_vaccinations))) over (partition by cd.location order by cd.location,cd.date) as RollingPplVaccinated
	--(RollingPplVaccinated/population)*100
	from PortfolioProject..CovidDeaths cd
	join PortfolioProject..CovidVaccinations cv
		on cd.location = cv.location
		and cd.date = cv.date
	where cd.continent is not null
	

select * from PercentPopulationVaccinated