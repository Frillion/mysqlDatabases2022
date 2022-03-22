use studytracker;

delimiter $$
drop procedure if exists get_course $$
create procedure get_course(course_nbr char(15))
gc:begin
	select * from courses
	where courseNumber = course_nbr;
end$$

drop procedure if exists insert_new_course$$
create procedure insert_new_course(course_nbr char(15),course_name varchar(75),course_cred tinyint)
inc:begin
	if course_nbr in (select courseNumber from courses) #If The Course Is Already Registered
	then select -1; #Return -1 to Let The User Know 
	Leave inc; #And Leave The Procedure
	end if;
	insert into courses(courseNumber,courseName,courseCredits) values(course_nbr,course_name,course_cred); #Insert The New Course If Above Statements Are False
end$$

drop procedure if exists update_course$$
create procedure update_course(course_nbr char(15),course_name varchar(75),course_cred tinyint)
uc:begin
	update courses
	set courseName = course_name,courseCredits = course_cred
	where course_nbr = courseNumber;
	select row_count();
end$$

drop procedure if exists delete_course$$
create procedure delete_course(course_nbr char(15))
dc:begin
	if course_nbr in (select courseNumber from trackcourses)
    then select -1; Leave dc;
    end if;
    delete from courses where courseNumber = course_nbr;
end$$

drop trigger if exists remove_restrictor$$
create trigger remove_restrictor 
after delete on courses 
for each row 
begin
delete from restrictors 
where restrictors.courseNumber = old.coursenumber;
end$$

drop function if exists course_count$$
create function course_count(first_semester bool) returns int deterministic
begin
	declare cour_count int;
    if first_semester
    then select count(courseNumber) into cour_count from trackcourses where semester = 1;  
    return cour_count;
    end if;
    select count(courseNumber) into cour_count from trackcourses;
    return cour_count;
end$$

drop function if exists credit_count$$
create function credit_count(track_id int) returns int deterministic
begin
	declare cred_count int;
    select sum(courseCredits) into cred_count from trackcourses inner join courses 
    on trackcourses.courseNumber = courses.courseNumber
    where trackID = track_id;
    return cred_count;
end$$

drop function if exists is_leap_year$$
create function is_leap_year(year_var date) returns bool deterministic
begin
	return if(year(year_var)%4 = 0 and year(year_var)%100 != 0 or year(year_var)%400 = 0,true,false);
end$$

drop function if exists get_age$$
create function get_age(birthday date) returns int deterministic
begin
	return if((round(DATEDIFF(curdate(), birthday)/365.2425)!=null),(round(DATEDIFF(curdate(), birthday)/365.2425)),-1);
end$$

#Gets Details About Students Based On What Semester Theyre on
drop procedure if exists get_student_details_semester$$
create procedure get_student_details_semester(semester_id int)
begin
	select distinct(s.studentID),concat(firstName,' ',lastName) as StudentName,dob as BirthDate,ss.statusName,t.trackName,d.divisionName,sc.schoolName
    from registration r
    inner join students s on r.studentID = s.studentID
    inner join studentstatus ss on ss.ID = s.studentStatus
    inner join tracks t on t.trackID = s.trackID
    inner join divisions d on d.divisionID = t.divisionID
    inner join schools sc on sc.schoolID = d.schoolID
    where r.semesterID = semester_id;
end$$

call get_student_details_semester(17)$$