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


