use population_tracker;
delimiter $$

drop procedure if exists insert_region$$
create procedure insert_region(j_data json)
begin
	insert into regions(RegionName)
    values((select json_extract(json_keys(j_data),'$[0]')));
    select json_object('table', 'Regions', 'rows_inserted', row_count()) as result;
end$$

drop procedure if exists insert_json$$
create procedure insert_json(j_data json)
begin
	declare region_id int;
    declare entire_object json;
    declare city_array json;
    declare population_array json;
    select RegionID into region_id from regions where regions.RegionName = (select json_extract(json_keys(j_data),'$[0]'));
    select JsonData into entire_object from jsonfiles where RegionID = region_id;
    select json_extract(entire_object->"$.%"%((select json_extract(json_keys(entire_object),'$[0]'))),'$[%]'%(i)) into city_array;
    if region_id not in (select RegionID from jsonfiles)
	then insert into jsonfiles(RegionID,JsonData)
		 values(region_id,j_data);
	else
		update jsonfiles
        set JsonData = (select json_set((entire_object,'$.%.%'%((select json_extract(json_keys(j_data),'$[0]')),))));
	end if;
end;

drop procedure if exists insert_cities$$
create procedure insert_cities(j_data json)
begin
declare data_length int;
declare region_id int;
declare city_array json;
declare i int;
set i = 0;
select json_length(j_data->"$.%"%((select json_extract(json_keys(j_data),'$[0]')))) into data_length;
select RegionID into region_id from regions where regions.RegionName = (select json_extract(json_keys(j_data),'$[0]'));
select json_extract(j_data->"$.%"%((select json_extract(json_keys(j_data),'$[0]'))),'$[%]'%(i)) into city_array;
    insert_loop: loop
		if i >= data_length
        then leave insert_loop;
        end if;
        insert into cities(CityID,RegionID,CityName)
		values(json_extract(city_array,'$.city_id'),region_id,json_extract(city_array,'$.city_name'));
		set i = i+1;
    end loop;
    select json_object('table', 'Cities', 'rows_inserted', row_count()) as result;
end$$

drop procedure if exists insert_population$$
create procedure insert_population(json_data json)
begin
	insert into population(RecordDate,CityID,population,JsonData)
	values(str_to_date(json_data->>"$.record_date","%d/%m/%Y"),json_data->>"$.city_id",json_data->>"$.population",json_data);
    select json_object('table', 'Population', 'rows_inserted', row_count()) as result;
end$$

