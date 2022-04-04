use studytracker;
delimiter $$
drop trigger if exists check_student_status_insert$$
create trigger check_student_status_insert
before insert on registration
for each row
begin
	declare msg varchar(128);
	if !(select StudentStatus(new.studentID) in (select 1,8,7))
		then set msg = 'Student is not registered as an attendee in the studentstatus table';
		signal sqlstate '45000' set message_text = msg;
	end if;
end$$

drop trigger if exists check_student_status_update$$
create trigger check_student_status_update
before update on registration
for each row
begin
	declare msg varchar(128);
	if !(select StudentStatus(new.studentID) in (select 1,8,7))
		then set msg = 'Student is not registered as an attendee in the studentstatus table';
		signal sqlstate '45000' set message_text = msg;
	end if;
end$$

drop procedure if exists get_finished_course_credits$$
create procedure get_finished_course_credits(student_id int)
begin
select concat(stud.firstName,stud.lastName) as FullName,tra.trackName,sum(cou.courseCredits) as FinishedCredits
from students stud
join registration reg on stud.studentID = reg.StudentID
join tracks tra on stud.trackID = tra.trackID
join courses cou on reg.courseNumber = cou.courseNumber
where stud.studentID = student_id and reg.grade >= 5.0;
end$$

drop procedure if exists get_finished_course_creditsAll$$
create procedure get_finished_course_creditsAll()
begin
select concat(stud.firstName,stud.lastName) as FullName,tra.trackName,round(avg(reg.grade),2) as AverageGrade,sum(cou.courseCredits) as FinishedCredits
from students stud
join registration reg on stud.studentID = reg.StudentID
join tracks tra on stud.trackID = tra.trackID
join courses cou on reg.courseNumber = cou.courseNumber
where reg.grade >= 5.0
group by stud.studentID;
end$$

drop procedure if exists add_manditory_courses$$
create procedure add_manditory_courses(student_id int,track_id int,semester_id int)
begin
declare adj_semester_id int;
set adj_semester_id = semester_id - 1;
insert into registration(studentID,courseNumber,registrationDate,semesterID)
select student_id,courseNumber,date(now()),adj_semester_id + semester
from trackcourses where trackID = track_id and mandatory = true;
end$$

drop procedure if exists add_new_student$$
create procedure add_new_student(first_name varchar(55),last_name varchar(55),birth_date date,track_id int,semester int)
begin
declare inserted_id int;
insert into students(firstName,lastName,dob,trackID,registerDate,studentStatus)
values(first_name,last_name,birth_date,track_id,now(),1);
select last_insert_id() into inserted_id;
call add_manditory_courses(inserted_id,track_id,semester);
end$$

