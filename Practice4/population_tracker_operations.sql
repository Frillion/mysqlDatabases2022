use population_tracker;
delimiter $$
drop procedure if exists get_city_details$$
create procedure get_city_details(city_name varchar(75))
begin
	select RegionName,c.CityID,c.CityName,p.RecordDate,p.population from population p join
    cities c on c.CityID = p.CityID
    join regions r on c.RegionID = r.RegionID
    where CityName = city_name;
end;
