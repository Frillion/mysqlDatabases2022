use population_tracker;
delimiter $$
drop procedure if exists get_city_details$$
create procedure get_city_details(city_name varchar(75))
begin
	select RegionName,c.CityID,c.CityName,p.RecordDate,p.population from population p join
    cities c on c.CityID = p.CityID
    join regions r on c.RegionID = r.RegionID
    where CityName = city_name;
end$$

drop procedure if exists get_region_details$$
create procedure get_region_details(region_name varchar(75))
begin
	select r.RegionID,RegionName,sum(population) as TotalPopulation,RecordDate from regions r 
    join cities c on c.RegionID = r.RegionID
    join population p on c.cityid = p.cityid
    where RegionName = region_name
    group by RecordDate;
end$$
drop procedure if exists get_total_pop$$
create procedure get_total_pop(record_date date)
begin
	select sum(population) as TotalPopulation from population
    where recordDate = record_date;
end$$
