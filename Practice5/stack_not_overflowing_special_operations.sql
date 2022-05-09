use stack_definitively_not_overflowing;
delimiter $$
/*POSTER WILL SIGNIFY THE USER BEING ACTED UPPON 
  AND USER SIGNIFIES THE ADMIN ACTING UPPON THE POSTER*/
drop Procedure if exists Update_User_Status$$
create procedure Update_User_Status(j_data json)
begin
    if "Admin" = (select UserStatus from userstatuses us 
                join users u on us.StatusID = u.StatusID
                where u.UserID = j_data->>"$.user_id")
        then update users
        set StatusID = (select StatusID from userstatuses where UserStatus = j_data->>"$.status")
        where UserID = j_data->>"$.poster_id";
    end if;
end$$