use stack_definitively_not_overFlowing;
delimiter $$
/*CREATE STATEMENTS*/
drop procedure if exists Create_User$$
create procedure Create_User(j_data json)
begin
   INSERT INTO users ( UserID,StatusID,AccessID,UserName,UserPassword,email,LastLogon ) VALUES(
        j_data->>"$.user_id",
        (select StatusID from userstatuses where UserStatus = j_data->>"$.status"),
        (select AccessID from accessLevel where Access = j_data->>"$.user_type"),
        j_data->>"$.username",
        SHA2(j_data->>"$.password",256),
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
    declare user_status varchar(50);
    select UserStatus into user_status from userstatuses where StatusID=(select StatusID from users where UserID = (select UserID from users where UserName = j_data->>"$.poster"));
    if strcmp(user_status,"Active")
    then INSERT INTO answers ( AnswerID,QuestionID,UserID,Content,DatePosted ) VALUES(
         j_data->>"$.answer_id",
         j_data->>"$.question_id",
         (select UserID from users where UserName = j_data->>"$.poster"),
         j_data->>"$.contents",
         now()
    );
    end if;
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
    declare user_status varchar(50);
    select UserStatus into user_status from userstatuses where StatusID=(select StatusID from users where UserID = (select UserID from users where UserName = j_data->>"$.poster"));
    if strcmp(user_status,"Active")
    then INSERT INTO questions ( QuestionID,TopicID,UserID,Title,Content,DatePosted ) VALUES(
         j_data->>"$.question_id",
         (select TopicID from topics where Topic = j_data->>"$.topic"),
         (select UserID from users where UserName = j_data->>"$.poster"),
         j_data->>"$.title",
         j_data->>"$.description",
         now()
    );
    end if;
end$$

drop procedure if exists Create_Ratings$$
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

/*READ STATEMENTS*/
drop procedure if exists Get_User$$
create procedure Get_User(user_name varchar(75))
begin
    select json_object(
        "user_id",(select UserID from users where UserName = user_name),
        "username",user_name,
        "status",(select UserStatus from userstatuses where StatusID = (select StatusID from users where UserName = user_name)),
        "user_type",(select Access from accessLevel where AccessID = (select AccessID from users where UserName = user_name)),
        "hashed_password",(select userPassword from users where UserName = user_name),
        "email",(select email from users where UserName = user_name),
        "last_logon_date",(select LastLogon from users where UserName = user_name)
        );
end$$

drop procedure if exists Get_Users$$
create procedure Get_Users()
begin
    select json_arrayagg(json_object(
        "user_id",UserID,
        "username",UserName,
        "status",UserStatus,
        "user_type",Access,
        "hashed_password",userPassword,
        "email",email,
        "last_logon_date", LastLogon
        ))from users u
          join userstatuses us
          on u.StatusID = us.StatusID
          join accessLevel acl
          on u.AccessID = acl.AccessID;
end$$

drop procedure if exists Get_Topic$$
create procedure Get_Topic(topic_id int)
begin
    select json_object(
        "topic_id",topic_id,
        "topic",(select Topic from topics where TopicID = topic_id)
        );
end$$

drop procedure if exists Get_Topics$$
create procedure Get_Topics()
begin
    select json_arrayagg(json_object(
        "topic_id",TopicID,
        "topic",Topic
        )) from topics;
end$$

drop procedure if exists Get_Question_Answers$$
create procedure Get_Question_Answers(question_id int)
begin
    select json_arrayagg(json_object(
        "answer_id",AnswerID,
        "question_id",QuestionID,
        "contents",Content,
        "date_posted",DatePosted
        )) from answers where QuestionID = question_id;
end$$

drop procedure if exists Get_Access$$
create procedure Get_Access(access_id int)
begin
    select json_object(
        "access_id",access_id,
        "access_level",(select Access from accessLevel where AccessID = access_id)
    );
end$$

drop procedure if exists Get_Access_All$$
create procedure Get_Access_All(access_id int)
begin
    select json_arrayagg(json_object(
        "access_id",AccessID,
        "access_level",Access
    ))from accessLevel;
end$$

drop procedure if exists Get_Questions$$
create procedure Get_Questions()
begin
    select json_arrayagg(json_object(
        "question_id",QuestionID,
        "topic",(select Topic from topics where topics.TopicID = questions.TopicID),
        "poster",(select UserName from users where users.UserID = questions.UserID),
        "question",Title,
        "description",Content,
        "date_posted",DatePosted
    )) from questions;
end$$

drop procedure if exists Get_Ratings$$
create procedure Get_Ratings(answer_id int)
begin
    select json_arrayagg(json_object(
        "rater_id",UserID,
        "answer_id",AnswerID,
        "rating",Rating
    )) from ratings where AnswerID = answer_id;
end$$

drop procedure if exists Get_Status$$
create procedure Get_Status(status_id int)
begin
    select json_object(
        "status_id",status_id,
        "user_status",(select UserStatus from userstatuses where StatusID = status_id)
    );
end$$

drop procedure if exists Get_Statuses$$
create procedure Get_Statuses(status_id int)
begin
    select json_arrayagg(json_object(
        "status_id",StatusID,
        "user_status",UserStatus
    ))from userstatuses;
end$$

/*UPDATE STATEMENTS*/
drop procedure if exists Update_User_All$$
create procedure Update_User_All(j_data json)
begin
    update users
    set StatusID = (select StatusID from userstatuses where UserStatus = j_data->>"$.status"),
        AccessID = (select AccessID from accessLevel where Access = j_data->>"$.access_level"),
        UserName = j_data->>"$.username",
        userPassword = j_data->>"$.password",
        email = j_data->>"$.email"
    where UserID = j_data->>"$.user_id";
end$$

drop procedure if exists Update_Topic_All$$
create procedure Update_Topic_All(j_data json)
begin
    update topics
    set Topic = j_data->>"$.topic"
    where TopicID = j_data->>"$.topic_id";
end$$

drop procedure if exists Update_Answer_All$$
create procedure Update_Answer_All(j_data json)
begin
    update answers
    set Content = j_data->>"$.contents"
    where AnswerID = j_data->>"$.answer_id";
end$$

drop procedure if exists Update_Access_All$$
create procedure Update_Access_All(j_data json)
begin
    update accessLevel
    set Access = j_data->>"$.access_level"
    where AccessID = j_data->>"$.access_id";
end$$

drop procedure if exists Update_Question_All$$
create procedure Update_Question_All(j_data json)
begin
    update questions
    set TopicID = (select TopicID from topics where Topic = j_data->>"$.topic"),
        Title = j_data->>"$.question",
        Content = j_data->>"$.desription"
    where QuestionID = j_data->>"$.question_id";
end$$

drop procedure if exists Update_Rating_All$$
create procedure Update_Rating_All(j_data json)
begin
    update ratings
    set Rating = j_data->>"$.rating"
    where UserID = j_data->>"$.user_id" and AnswerID = j_data->>"$.answer_id";
end$$

drop procedure if exists Update_Status_All$$
create procedure Update_Status_All(j_data json)
begin
    update userstatuses
    set UserStatus = j_data->>"$.status"
    where StatusID = j_data->>"$.status_id";
end$$

/*DELETE STATEMENTS*/
drop procedure if exists Delete_User$$
create procedure Delete_User(user_id int)
begin
    if !HasPosted(user_id)
    then delete from users where UserID = user_id;
    else
        update users
        set status_id = (select StatusID from userstatuses where UserStatus = "Terminated"),
        email = Null,
        userPassword = Null
        where UserID = user_id;
    end if;
end$$

drop procedure if exists Delete_Topic$$
create procedure Delete_Topic(topic_id int)
begin
    delete from topics where TopicID = topic_id;
end$$

drop procedure if exists Delete_Answer$$
create procedure Delete_Answer(answer_id int)
begin
    delete from answers where AnswerID = answer_id;
end$$

drop procedure if exists Delete_Access$$
create procedure Delete_Access(access_id int)
begin
    delete from accessLevel where AccessID = access_id;
end$$

drop procedure if exists Delete_Question$$
create procedure Delete_Question(question_id int)
begin
    delete from questions where QuestionID = question_id;
end$$

drop procedure if exists Delete_Status$$
create procedure Delete_Status(status_id int)
begin
    delete from userstatuses where StatusID = status_id;
end$$