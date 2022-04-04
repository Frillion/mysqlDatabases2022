delimiter €€
drop procedure if exists add_course_json €€

create procedure add_course_json(json_data json)
begin
	if not exists(select courseNumber from Courses where courseNumber = json_data->>'$.course_number') then
		insert into Courses(courseNumber,courseName,courseCredits)
		values(json_data->>'$.course_number',json_data->>'$.course_name',json_data->>'$.course_credits');
	end if;
    
    select json_object('table', 'Courses', 'rows_inserted', row_count()) as result;
end €€


delimiter ;
