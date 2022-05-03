use population_tracker;
delimiter $$

drop procedure if exists insert_region$$
create procedure insert_region(j_data json)
begin
	insert into regions(RegionName)
    values(json_unquote((select json_extract(json_keys(j_data),'$[0]'))));
    select json_object('table', 'Regions', 'rows_inserted', row_count()) as result;
end$$

drop procedure if exists insert_json$$
create procedure insert_json(j_data json)
begin
	declare region_id int;
    declare entire_object json;
    select RegionID into region_id from regions where regions.RegionName = (select json_extract(json_keys(j_data),'$[0]'));
    select JsonData into entire_object from jsonfiles where RegionID = region_id;
    if region_id not in (select RegionID from jsonfiles)
	then insert into jsonfiles(RegionID,JsonData)
		 values(region_id,j_data);
	else
		update jsonfiles
        set JsonData = json_merge_patch(entire_object,j_data)
        where RegionID = rergion_id;
	end if;
end;

drop procedure if exists insert_cities$$
create procedure insert_cities(j_data json)
begin
declare data_length int;
declare region_id int;
declare city_array json;
declare json_syntax char(3);
declare json_array_syntax char(5);
declare i int;
set json_syntax = "$.?";
set json_array_syntax = "$[?]";
set i = 0;
select json_length(json_extract(j_data,replace(json_syntax,'?',(select json_extract(json_keys(j_data),'$[0]'))))) into data_length;
select RegionID into region_id from regions where regions.RegionName = json_unquote((select json_extract(json_keys(j_data),'$[0]')));
    insert_loop: loop
		if i >= data_length
        then leave insert_loop;
        end if;
        set city_array =  json_extract(json_extract(j_data,replace(json_syntax,'?',((select json_extract(json_keys(j_data),'$[0]'))))),replace(json_array_syntax,'?',i));
        insert into cities(CityID,RegionID,CityName)
		values(json_unquote((select json_extract(city_array,'$.city_id'))),region_id,json_unquote(json_extract(city_array,'$.city_name')));
		set i = i+1;
    end loop;
    select json_object('table', 'Cities', 'rows_inserted', row_count()) as result;
end$$

drop procedure if exists insert_population$$
create procedure insert_population(json_data json)
begin
	declare city_array_length int;
    declare city_array json;
    declare city_index int;
    declare record json;
    declare city_id char(4);
    set city_index = 0;
    select json_extract(json_data,replace('$.?','?',json_extract(json_keys(json_data),'$[0]'))) into city_array;

	select json_length(json_extract(json_data,replace('$.%','%',(select json_extract(json_keys(json_data),'$[0]'))))) into city_array_length;
    insert_loop:loop
		if city_index >= city_array_length
			then leave insert_loop;
		end if;
        select json_unquote(json_extract(city_array,replace('$[%].city_id','%',city_index))) into city_id;
        select json_extract(city_array,replace('$[%].city_population[0]','%',city_index)) into record;
        insert into population(RecordDate,CityID,population)
        values(str_to_date(json_unquote(json_extract(record,'$.record_date')),'%d/%m/%Y'),json_unquote(city_id),json_extract(record,'$.population'));
        set city_index = city_index + 1;
    end loop;
    select json_object('table', 'Population', 'rows_inserted', row_count()) as result;
end$$
/*call insert_population(json_object('ækfædasjfl',json_array(json_object('city_id','0004','city_name','hlahnsgv','city_population',json_array(json_object('record_date','20/8/2020','population',132))),json_object('city_id','0005','city_name','hlahnsgv','city_population',json_array(json_object('record_date','20/8/2020','population',132))))));*/