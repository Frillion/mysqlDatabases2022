use stack_definitively_not_overflowing;
delimiter $$

/*POSTER WILL SIGNIFY THE USER BEING ACTED UPPON 
  AND USER SIGNIFIES THE ADMIN ACTING UPPON THE POSTER*/
drop function if exists IsAdmin$$
create function IsAdmin(user_id varchar(20)) 
returns boolean deterministic
begin
  declare admin_level char(5);
  set admin_level = "Admin";
  if admin_level in (select UserStatus from userstatuses us 
              join users u on us.StatusID = u.StatusID
              where u.UserID = j_data->>"$.user_id")
  then return True;
  end if;
  return False;
end$$

drop function if exists Number_OF_Answers_Posted$$
create function Number_OF_Answers_Posted(user_id varchar(20)) 
returns int deterministic
begin
  declare answer_count int;
  select count(*) into answer_count from answers 
  where UserID = user_id;
  return answer_count;
end$$

drop function if exists Number_OF_Questions_Posted$$
create function Number_OF_Questions_Posted(user_id varchar(20)) 
returns int deterministic
begin
  declare question_count int;
  select count(*) into question_count from questions 
  where UserID = user_id;
  return question_count;
end$$

drop function if exists Avg_Rating$$
create function Avg_Rating(answer_id varchar(20)) 
returns float deterministic
begin
  declare avg_rating int;
  declare row_count int;
  select count(*) into row_count from ratings where AnswerID = answer_id;
  select sum(Rating) into avg_rating from ratings where AnswerID = answer_id;
  select avg_rating/row_count into avg_rating;
  return avg_rating;
end$$

drop function if exists HasPosted$$
create function HasPosted(user_id varchar(20)) 
returns boolean deterministic
begin
  if Number_OF_Answers_Posted(user_id) <= 0 or Number_OF_Questions_Posted(user_id) <= 0
  then return False;
  end if;
  return True;
end$$

drop Procedure if exists Update_User_Status$$
create procedure Update_User_Status(j_data json)
begin
  if IsAdmin(j_data->>"$.user_id")
      then update users
      set StatusID = (select StatusID from userstatuses where UserStatus = j_data->>"$.status")
      where UserID = j_data->>"$.poster_id";
  end if;
end$$

drop procedure if exists Get_Users_OF_Type$$
create procedure Get_Users_OF_Type(j_data json)
begin
  if IsAdmin(j_data->>"$.user_id")
  then select UserID,StatusID,AccessID,UserName,userPassword,email,LastLogon
       from users u join accessLevel acl
       on u.AccessID = acl.AccessID
       where Access = j_data->>"$.user_type";
  end if;
end$$

drop trigger if exists rank_update$$
create trigger rank_update
after insert on answers for each row
begin
  if strcmp("Beginner",(select UserStatus from userstatuses us
                        join users u on u.StatusID = us.StatusID
                        where UserID = new.UserID)) = 0
  and Number_OF_Answers_Posted(new.UserID)+Number_OF_Questions_Posted(new.UserID) >= 20
  then update users
       set StatusID = (select StatusID from userstatuses where UserStatus = "Intermediate")
       where UserID = new.UserID;
  end if;
end;