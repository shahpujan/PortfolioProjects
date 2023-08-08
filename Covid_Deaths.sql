select *
from PortfolioProject..CovidDeaths
order by 3,4;


--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4;

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid 
select  location,date,total_cases,total_deaths,round(((total_deaths/total_cases)*100),2) as Death_perc
from PortfolioProject..CovidDeaths
where location like '%Australia%'
order by 1,2

----Shows what Percentage of population who got covid
select  location,date,total_cases,population,round(((total_cases/population)*100),2) as Population_perc
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

--- Looking at countries with highest infection rate compared to population
select  location,population,MAX(total_cases) as HighestInfectioncount,MAX(round(((total_cases/population)*100),2)) as HighestPercPopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
--where location like '%states%'
group by location,population
order by 4 desc

--Showing the countries with the highest Death count for population
select  location, MAX(total_deaths) as HighestDeathcount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by 2 desc

--Check the totaldeath count by continet
select  location, MAX(total_deaths) as TotalDeathcount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by 2 desc

--Showing the countries with the highest Death count and highest death percent for population

select  location,population,MAX(total_deaths) as HighestDeathcount,MAX(round(((total_deaths/population)*100),2)) as HighestPercdeaths
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by location,population
order by 4 desc