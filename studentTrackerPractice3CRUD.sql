use studytracker;

#Start of all CRUD procedures for Courses
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

drop procedure if exists get_course_json €€
create procedure get_course_json(json_data json)
begin
	select json_object('course_number',courseNumber,'course_name',courseName,'course_credits',courseCredits) from courses where courseNumber = json_data->>'$.course_number';
end€€

drop procedure if exists update_course_json€€
create procedure update_course_json(json_data json)
begin
	case
		when json_data->>'$.course_credits' = null 
        then 
			update courses
            set courseName = json_data->>'$.course_name'
			where courseNumber = json_data ->>'$.course_number';
		when json_data->>'$.course_name' = null
        then
			update courses
			set courseCredits = json_data ->>'$.course_credits'
			where courseNumber = json_data ->>'$.course_number';
		else
			update courses
			set courseName = json_data->>'$.course_name',
				courseCredits = json_data ->>'$.course_credits'
			where courseNumber = json_data ->>'$.course_number';
    end case;
    
    select json_object('table', 'Courses', 'rows_updated', row_count()) as result;
end€€

drop procedure if exists delete_course_json€€
create procedure delete_course_json(json_data json)
begin
	delete from courses
	where courseNumber = json_data->>'$.courseNumber';
    select json_object('table', 'Courses', 'rows_deleted', row_count()) as result;
end€€

#End of all CRUD procedures for Courses
#Start of all CRUD procedures for TrackCourses
drop procedure if exists add_track_course_json€€
create procedure add_track_course_json(json_data json)
begin
	if exists(select courseNumber from courses where courseNumber = json_data->>'$.course_number')
    then
		insert into trackcourses(courseNumber,semester,mandatory)
        values (json_data->>'$.course_number',json_data->>'$.semester_id',json_data->>'$.is_mandatory');
	end if;
    select json_object('table', 'TrackCourses', 'rows_added', row_count()) as result;
end€€
delimiter ;

