use population_tracker;
delimiter $$
drop procedure if exists get_city_details$$
create procedure get_city_details(city_name varchar(75))
begin
	select c.CityID,c.CityName,p.RecordDate,p.population from population p join
    cities c on c.CityID = p.CityID
    join regions r on c.RegionID = r.RegionID
    where CityName = city_name;
end$$

drop procedure if exists get_region_details$$
create procedure get_region_details(region_name varchar(75))
begin
	select r.RegionID,RegionName,c.cityid,cityname,population,RecordDate from regions r 
    join cities c on c.RegionID = r.RegionID
    join population p on c.cityid = p.cityid
    where RegionName = region_name;
end$$

drop procedure if exists get_total_pop$$
create procedure get_total_pop(record_date date)
begin
	select sum(population) as TotalPopulation from population
    where recordDate = record_date
	order by cityid;
end$$
drop procedure if exists percentage_growth$$
create procedure percentage_growth(date_from date,date_to date)
get_percentage:begin
	if datediff(date_to,date_from) < 0
    then leave get_percentage;
    end if;
    select c.cityid,cityname,(select population from population where cityid = c.cityid and recorddate = date_to)-population as NumberDiff,1 - (population/(select population from population where cityid = c.cityid and recorddate = date_to)) as PercentageGrowth from cities c
    join population p on p.cityid = c.cityid
    where recorddate = date_from;
end$$