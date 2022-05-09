use stack_definitively_not_overFlowing;
delimiter $$
drop procedure if exists Create_User$$
create procedure Create_User(j_data json)
begin
   INSERT INTO users ( UserID,StatusID,AccessID,UserName,UserPassword,email,LastLogon ) VALUES(
        j_data->>"$.user_id",
        (select StatusID from userstatuses where UserStatus = j_data->>"$.status"),
        (select AccessID from accessLevel where Access = j_data->>"$.user_type"),
        j_data->>"$.username",
        j_data->>"$.password",
        j_data->>"$.email",
        now()
   );
end$$

drop procedure if exists Create_Topic$$
create procedure Create_Topic(j_data json)
begin
    INSERT INTO  topics ( TopicID,Topic ) VALUES(
         j_data->>"$.topic_id",
         j_data->>"$.topic_name"
    );
end$$

drop procedure if exists Create_Answer$$
create procedure Create_Answer(j_data json)
begin
   INSERT INTO answers ( AnswerID,QuestionID,UserID,Content,DatePosted ) VALUES(
        j_data->>"$.answer_id",
        j_data->>"$.question_id",
        (select UserID from users where UserName = j_data->>"$.poster"),
        j_data->>"$.Contents",
        now()
   );
end$$

drop procedure if exists Create_Access$$
create procedure Create_Access(j_data json)
begin
   INSERT INTO  accessLevel ( AccessID,Access ) VALUES(
        j_data->>"$.access_id",
        j_data->>"$.access_level"
   );
end$$

drop procedure if exists Create_Question$$
create procedure Create_Question(j_data json)
begin
   INSERT INTO questions ( QuestionID,TopicID,UserID,Title,Content,DatePosted ) VALUES(
        j_data->>"$.question_id",
        (select TopicID from topics where Topic = j_data->>"$.topic"),
        (select UserID from users where UserName = j_data->>"$.poster"),
        j_data->>"$.title",
        j_data->>"$.description",
        now()
   );
end$$

drop procedure if exists Create_Rating$$
create procedure Create_Ratings(j_data json)
begin
    /*Getting the right AnswerID and UserID will be left up to the app developer
      the only check is for weather or not this user is trying to rate their own answer*/
    IF j_data->>"$.user_id" not in (SELECT UserID FROM answers where AnswerID = j_data->>"$.answer_id")
    Then INSERT INTO ratings ( UserID,AnswerID,Rating ) VALUES(
        j_data->>"$.user_id",
        j_data->>"$.answer_id",
        j_data->>"$.rating"
    );
    end if;
end$$

drop procedure if exists Create_Status$$
create procedure Create_Status(j_data json)
begin
   INSERT INTO userstatuses ( StatusID,UserStatus ) VALUES(
        j_data->>"$.status_id",
        j_data->>"$.user_status"
   );
end$$


drop procedure if exists Get_User$$
create procedure Get_User(user_name varchar(75))
begin
    select json_object(
        "user_id",
        (select UserID from users where UserName = user_name),
        "username",
        user_name,
        "status",
        (select UserStatus from userstatuses where StatusID = (select StatusID from users where UserName = user_name)),
        "user_level",
        (select Access from accessLevel where AccessID = (select AccessID from users where UserName = user_name)),
        "hashed_password",
        (select userPassword from users where UserName = user_name),
        "email",
        (select email from users where UserName = user_name),
        "last_logon_date",
        (select LastLogon from users where UserName = user_name)
        );
end$$

drop procedure if exists Get_Topic$$
create procedure Get_Topic(topic_id int)
begin
    select json_object(
        "topic_id",
        topic_id,
        "topic",
        (select Topic from topics where TopicID = topic_id)
        );
end$$

drop procedure if exists Get_Question_Answer$$
create procedure Get_Question_Answer(question_id int)
begin
    declare querry_length int;
    
    declare result json;
    select COUNT(*) from answers into querry_length where QuestionID = question_id;
    set result = json_array();
    answer_loop:loop
        
        set result = json_append(result,json_object(
            "question_id",
            question_id,
            "answer_id",
            (select AnswerID from answers where QuestionID = question_id limit 1)
        ));
    end loop anwer_loop;
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