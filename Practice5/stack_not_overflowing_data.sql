use stack_definitively_not_overFlowing;
delimiter $$
drop procedure if exists Create_User$$
create procedure Create_User(j_data json)
begin
end$$

drop procedure if exists Create_Topic$$
create procedure Create_Topic(j_data json)
begin
    INSERT INTO  topics ( TopicID,Topic ) VALUES(
         j_data->>"topic_id",
         j_data->>"topic_name"
    );
end$$

drop procedure if exists Create_Answer$$
create procedure Create_Answer(j_data json)
begin
end$$

drop procedure if exists Create_Access$$
create procedure Create_Access(j_data json)
begin
   INSERT INTO  accessLevel ( AccessID,Access ) VALUES(
        j_data->>"access_id",
        j_data->>"access_level"
   );
end$$

drop procedure if exists Create_Question$$
create procedure Create_Question(j_data json)
begin
end$$

drop procedure if exists Create_Rating$$
create procedure Create_Ratings(j_data json)
begin
    /*Getting the right AnswerID and UserID will be left up to the app developer
      the only check is for weather or not this user is trying to rate their own answer*/
    IF j_data->>"user_id" not in (SELECT UserID FROM answers where AnswerID = j_data->>"answer_id")
    Then INSERT INTO ratings ( UserID,AnswerID,Rating ) VALUES(
        j_data->>"user_id",
        j_data->>"answer_id",
        j_data->>"rating"
    );
    end if;
end$$

drop procedure if exists Create_Status$$
create procedure Create_Status(j_data json)
begin
   INSERT INTO userstatuses ( StatusID,UserStatus ) VALUES(
        j_data->>"status_id",
        j_data->>"user_status"
   );
end$$

drop procedure if exists Get_User$$
create procedure Get_User(j_data json)
begin
end$$
drop procedure if exists Get_Topic$$
create procedure Get_Topic(j_data json)
begin
end$$
drop procedure if exists Get_Answer$$
create procedure Get_Answer(j_data json)
begin
end$$
drop procedure if exists Get_Access$$
create procedure Get_Access(j_data json)
begin
end$$
drop procedure if exists Get_Question$$
create procedure Get_Question(j_data json)
begin
end$$
drop procedure if exists Get_Rating$$
create procedure Get_Ratings(j_data json)
begin
end$$
drop procedure if exists Get_Status$$
create procedure Get_Status(j_data json)
begin
end$$

drop procedure if exists Update_User$$
create procedure Update_User(j_data json)
begin
end$$
drop procedure if exists Update_Topic$$
create procedure Update_Topic(j_data json)
begin
end$$
drop procedure if exists Update_Answer$$
create procedure Update_Answer(j_data json)
begin
end$$
drop procedure if exists Update_Access$$
create procedure Update_Access(j_data json)
begin
end$$
drop procedure if exists Update_Question$$
create procedure Update_Question(j_data json)
begin
end$$
drop procedure if exists Update_Rating$$
create procedure Update_Ratings(j_data json)
begin
end$$
drop procedure if exists Update_Status$$
create procedure Update_Status(j_data json)
begin
end$$

drop procedure if exists Delete_User$$
create procedure Delete_User(j_data json)
begin
end$$
drop procedure if exists Delete_Topic$$
create procedure Delete_Topic(j_data json)
begin
end$$
drop procedure if exists Delete_Answer$$
create procedure Delete_Answer(j_data json)
begin
end$$
drop procedure if exists Delete_Access$$
create procedure Delete_Access(j_data json)
begin
end$$
drop procedure if exists Delete_Question$$
create procedure Delete_Question(j_data json)
begin
end$$
drop procedure if exists Delete_Rating$$
create procedure Delete_Ratings(j_data json)
begin
end$$
drop procedure if exists Delete_Status$$
create procedure Delete_Status(j_data json)
begin
end$$