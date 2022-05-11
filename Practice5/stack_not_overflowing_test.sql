call Create_Topic(json_object("topic_id",0,"topic_name","Programming"));
call Create_Topic(json_object("topic_id",1,"topic_name","Databases"));
call Create_Topic(json_object("topic_id",2,"topic_name","Game Programming"));
call Create_Topic(json_object("topic_id",3,"topic_name","Linux-Administration"));
call Create_Topic(json_object("topic_id",4,"topic_name","Windows-Administration"));
call Create_Topic(json_object("topic_id",5,"topic_name","Robotics"));
call Create_Topic(json_object("topic_id",6,"topic_name","Web Development"));

call Create_Access(json_object("access_id",0,"access_level","Beginner"));
call Create_Access(json_object("access_id",1,"access_level","Intermediate"));
call Create_Access(json_object("access_id",2,"access_level","Advanced"));
call Create_Access(json_object("access_id",3,"access_level","Super User"));
call Create_Access(json_object("access_id",4,"access_level","Admin"));

call Create_Status(json_object("status_id",0,"user_status","Active"));
call Create_Status(json_object("status_id",1,"user_status","Terminated"));
call Create_Status(json_object("status_id",2,"user_status","Temporary Ban"));
call Create_Status(json_object("status_id",3,"user_status","Prema Ban"));