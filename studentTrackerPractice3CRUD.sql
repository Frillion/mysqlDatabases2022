use studytracker;

/*Start of all CRUD procedures for Courses*/
delimiter €€

drop function if exists json_null_to_sql_null€€
create function json_null_to_sql_null(a JSON) returns json deterministic
begin
    return if(JSON_TYPE(a) = 'NULL', NULL, a);
end€€

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
		update courses
		set courseName = ifnull((SELECT json_null_to_sql_null(JSON_EXTRACT(json_data, '$.course_name'))),courseName),
			courseCredits = ifnull((SELECT json_null_to_sql_null(JSON_EXTRACT(json_data, '$.course_credits'))),courseCredits)
		where courseNumber = json_data ->>'$.course_number';
    
    select json_object('table', 'Courses', 'rows_updated', row_count()) as result;
end€€

drop procedure if exists delete_course_json€€
create procedure delete_course_json(json_data json)
begin
	delete from courses
	where courseNumber = json_data->>'$.course_number';
    select json_object('table', 'Courses', 'rows_deleted', row_count()) as result;
end€€

#End of all CRUD procedures for Courses

/*Start of all CRUD procedures for TrackCourses*/
drop procedure if exists add_track_course_json€€
create procedure add_track_course_json(json_data json)
begin
	if not exists(select courseNumber from trackcourses where courseNumber = json_data->>'$.course_number' and trackID = json_data->>'$.track_id') then
		if exists(select courseNumber from courses where courseNumber = json_data->>'$.course_number')
		then
			insert into trackcourses(trackID,courseNumber,semester,mandatory)
			values (json_data->>'$.track_id',json_data->>'$.course_number',json_data->>'$.semester_id',json_data->>'$.is_mandatory');
		end if;
	end if;
    select json_object('table', 'TrackCourses', 'rows_added', row_count()) as result;
end€€

drop procedure if exists get_track_course_json€€
create procedure get_track_course_json(json_data json)
begin
	select json_object('track_id',trackID,'course_nubmer',courseNumber,'semester_id',semester,'is_mandatory',mandatory)
    as results
    from trackcourses 
    where trackID = json_data->>'$.track_id' and courseNumber = json_data->>'$.course_number';
end€€

drop procedure if exists update_track_course_json€€
create procedure update_track_course_json(json_data json)
begin
	if exists(select courseNumber from Courses where courseNumber = json_data->>'$.course_number')
    then
		update trackcourses
		set semester = ifnull((SELECT json_null_to_sql_null(JSON_EXTRACT(json_data, '$.semester_id'))),semester), 
			mandatory = ifnull((SELECT json_null_to_sql_null(JSON_EXTRACT(json_data, '$.is_mandatory'))),mandatory)
		where trackID = json_data->>'$.track_id' and courseNumber = json_data->>'$.course_number';
	end if;
    select json_object('table', 'TrackCourses', 'rows_updated', row_count()) as result;
end€€

drop procedure if exists delete_track_course_json€€
create procedure delete_track_course_json(json_data json)
begin
	delete from trackcourses
    where courseNumber = json_data->>'$.course_number' 
    and trackID = json_data->>'$.track_id';
    select json_object('table', 'TrackCourses', 'rows_deleted', row_count()) as result;
end€€

#End of the CRUD procedures for TrackCourses

/*Start of the CRUD procedures for Semesters*/
drop procedure if exists add_semester_json€€
create procedure add_semester_json(json_data json)
begin
	insert into semesters(semesterName,semesterStarts,semesterEnds,academicYear)
	values(json_data->>'$.semester_name',json_data->>'$.semester_start',json_data->>'$.semester_end',json_data->>'$.academic_year');
    
    select json_object('table', 'Semester', 'rows_added', row_count()) as result;
end€€

drop procedure if exists get_semester_json€€
create procedure get_semester_json(json_data json)
begin
	select json_object('semester_id',semesterID,'semester_name',semesterName,'semester_start',semesterStarts,'semester_end',semesterEnds,'academic_year',academicYear) as results
    from semesters
    where semsterID = json_data->>'$.semester_id';
end€€

drop procedure if exists update_semester_json€€
create procedure update_semester_json(json_data json)
begin
	update semesters
    set semesterName = ifnull((SELECT json_null_to_sql_null(JSON_EXTRACT(json_data, '$.semester_name'))),semesterName),
		semesterStarts = ifnull((SELECT json_null_to_sql_null(JSON_EXTRACT(json_data, '$.semester_start'))),semesterStarts),
		semesterEnds = ifnull((SELECT json_null_to_sql_null(JSON_EXTRACT(json_data, '$.semester_end'))),semesterEnds),
        academicYear = ifnull((SELECT json_null_to_sql_null(JSON_EXTRACT(json_data, '$.academic_year'))),academicYear)
	where semesterID = json_data->>'$.semester_id';
    select json_object('table', 'Semester', 'rows_updated', row_count()) as result;
end€€

drop procedure if exists delete_semester_json€€
create procedure delete_semester_json(json_data json)
begin
	delete from semesters
    where semesterID = json_data->>'$.semester_id';
end€€
delimiter ;

