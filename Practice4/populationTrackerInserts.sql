use population_tracker;
delimiter $$

drop procedure if exists insert_region$$
create procedure insert_region(json_data json)
begin
	insert into regions(RegionName) value(json_data->>"$.region_name");
    select json_object('table', 'Regions', 'rows_inserted', row_count()) as result;
end$$

drop procedure if exists insert_cities$$
create procedure insert_cities(json_data json)
begin
	declare region_id int;
    select RegionID into region_id from regions where regions.RegionName = json_data->>"$.region_name";
	insert into cities(CityID,RegionID,CityName)
    values(json_data->>"$.city_id",region_id,json_data->>"$.city_name");
    select json_object('table', 'Cities', 'rows_inserted', row_count()) as result;
end$$

drop procedure if exists insert_population$$
create procedure insert_population(json_data json)
begin
	insert into population(RecordDate,CityID,population,JsonData)
    values(json_data->>"$.record_date",json_data->>"$.city_id",json_data->>"$.population",json_data);
    select json_object('table', 'Population', 'rows_inserted', row_count()) as result;
end$$
call insert_region(json_object('region_name', 'Suðurland', 'city_id', '9999', 'city_name', 'aodhspgjl', 'record_date', '1/12/2022', 'population','640'));
call insert_cities(json_object('region_name', 'Suðurland', 'city_id', '9999', 'city_name', 'aodhspgjl', 'record_date', '1/12/2022', 'population','640'));
call insert_population(json_object('region_name', 'Suðurland', 'city_id', '9999', 'city_name', 'aodhspgjl', 'record_date', '1/12/2022', 'population','640'));