use studytracker
delimiter $$
drop trigger if exists check_student_status$$
create trigger check_student_status 
before insert on registration
for each row
begin
	declare msg varchar(128);
	if !(select StudentStatus(new.studentID) in (select 1,8,7))
		then set msg = 'Student is not registered as an attendee in the studentstatus table';
		signal sqlstate '45000' set message_text = msg;
	end if;
end

