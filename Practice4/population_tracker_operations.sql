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
/*	This Procedure Is Both Number 4 and 5 In The Project.
	It returns either an overview of growth of all cities or just one
    depending on wether the city_id field is null or not
*/
drop procedure if exists percentage_growth$$
create procedure percentage_growth(date_from date,date_to date,c_id char(4),r_name varchar(75))
get_percentage:begin
    declare sum_pop_second int;
	if datediff(date_to,date_from) < 0
    then leave get_percentage;
    end if;
    if c_id = '' and r_name = ''
		then select c.CityID,CityName,RecordDate,Population,(select RecordDate from population where recorddate = date_to and cityID = c.cityID)as RecordDate,(select population from population where recorddate = date_to and cityID = c.cityID) as Population,(select population from population where cityid = c.cityid and recorddate = date_to)-population as NumberDiff,1 - (population/(select population from population where cityid = c.cityid and recorddate = date_to)) as PercentageGrowth from cities c
		join population p on p.cityid = c.cityid
		where recorddate = date_from;
    else if r_name = ''
		then select c.CityID,CityName,RecordDate,Population,(select RecordDate from population where recorddate = date_to and cityID = c.cityID)as RecordDate,(select population from population where recorddate = date_to and cityID = c.cityID) as Population,(select population from population where cityid = c.cityid and recorddate = date_to)-population as NumberDiff,1 - (population/(select population from population where cityid = c.cityid and recorddate = date_to)) as PercentageGrowth from cities c
		join population p on p.cityid = c.cityid
		where recorddate = date_from and c.CityID = c_id;
	else
		Set sum_pop_second = (select sum(population) from regions r
			join cities c on r.RegionID = c.RegionID
			join population p on p.CityID = c.CityID
			where RegionName = r_name and recorddate = date_to);
            
		select RegionName,RecordDate,sum(population) as Population,
		(select RecordDate from population where recorddate = date_to and cityID = c.cityID)as RecordDate,(select sum_pop_second) as Population,(select sum_pop_second)-sum(population) as NumberDiff,1 - (sum(population)/(select sum_pop_second)) as PercentageGrowth from regions r
        join cities c on r.RegionID = c.RegionID
		join population p on p.cityid = c.cityid
		where recorddate = date_from and RegionName = r_name;
        end if;
    end if;
end$$
drop procedure if exists get_region_pop$$
create procedure get_region_pop(region_name varchar(75))
begin
	select RegionName,RecordDate,sum(population) from regions r
    join cities c on r.RegionID = c.RegionID
    join population p on p.CityID = c.CityID
    where RegionName = region_name
    group by RecordDate;
end$$

call percentage_growth("2017-12-01","2018-04-15","","Höfuðborgarsvæðið");
#call get_region_pop((select RegionName from regions where regionid = 3));