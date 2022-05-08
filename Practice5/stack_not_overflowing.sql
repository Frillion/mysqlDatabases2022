drop database if exists stack_definitively_not_overFlowing;
create database stack_definitively_not_overFlowing;

use stack_definitively_not_overFlowing;

create table accessLevel(
	AccessID int,
    Access varchar(50),
    constraint access_pk primary key(accessID)
);

create table userStatuses(
	StatusID int,
    UserStatus varchar(50),
    constraint status_pk primary key(StatusID)
);

create table topics(
	TopicID int,
    Topic varchar(75),
    constraint topic_pk primary key(TopicID)
);

create table users(
	UserID int,
    StatusID int,
    AccessID int,
    UserName varchar(75) unique,
    userPassword varchar(64),
    email varchar(75),
    LastLogon date,
    constraint users_pk primary key(UserID),
    constraint status_fk foreign key(StatusID) references userStatuses(StatusID),
    constraint access_fk foreign key(AccessID) references accessLevel(accessID)
);

create table questions(
	QuestionID int,
    TopicID int,
    UserID int,
    Content text,
    DatePosted date,
    constraint question_pk primary key(QuestionID),
    constraint question_topic foreign key(TopicID) references topics(TopicID),
    constraint question_poster foreign key(UserID) references users(UserID)
);

create table answers(
	AnswerID int,
    QuestionID int,
    UserID int,
    Content text,
    DatePosted date,
    constraint Answer_pk primary key(AnswerID),
    constraint question foreign key(QuestionID) references questions(QuestionID),
    constraint poster foreign key(UserID) references users(UserID)
);


create table ratings(
	UserID int,
    AnswerID int,
    Rating int,
    constraint rating_pk primary key(UserID,AnswerID),
    constraint rater foreign key(UserID) references users(UserID),
    constraint ratie foreign key(AnswerID) references answers(AnswerID)
);