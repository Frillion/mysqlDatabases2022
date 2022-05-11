drop database if exists stack_definitively_not_overFlowing;
create database stack_definitively_not_overFlowing;

use stack_definitively_not_overFlowing;

create table accessLevel(
	AccessID int,
    Access varchar(50) UNIQUE,
    constraint access_pk primary key(accessID)
);

create table userStatuses(
	StatusID int,
    UserStatus varchar(50) UNIQUE,
    constraint status_pk primary key(StatusID)
);

create table topics(
	TopicID int,
    Topic varchar(75) UNIQUE,
    constraint topic_pk primary key(TopicID)
);

create table users(
	UserID varchar(20),
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
	QuestionID varchar(20),
    TopicID int,
    UserID varchar(20),
	Title varchar(100),
    Content text,
    DatePosted date,
    constraint question_pk primary key(QuestionID),
    constraint question_topic foreign key(TopicID) references topics(TopicID),
    constraint question_poster foreign key(UserID) references users(UserID)
);

create table answers(
	AnswerID varchar(20),
    QuestionID varchar(20),
    UserID varchar(20),
    Content text,
    DatePosted date,
    constraint Answer_pk primary key(AnswerID),
    constraint question foreign key(QuestionID) references questions(QuestionID),
    constraint poster foreign key(UserID) references users(UserID)
);


create table ratings(
	UserID varchar(20),
    AnswerID varchar(20),
    Rating int,
    constraint rating_pk primary key(UserID,AnswerID),
    constraint rater foreign key(UserID) references users(UserID),
    constraint ratie foreign key(AnswerID) references answers(AnswerID)
);