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

call Create_User(json_object("user_id","hDap6dc=","status","Active","user_type","Beginner","username","Julian Oliver","password","hoover","email","julian.oliver@example.com"));
call Create_User(json_object("user_id","TpgrPUc=","status","Active","user_type","Intermediate","username","Marshall Coleman","password","jessie","email","marshall.coleman@example.com"));

call Create_Question(json_object("poster","Julian Oliver","question_id","gfVyuyw=","topic","Programming","title","Aliquam erat volutpat. Suspendisse lorem arcu, blandit non diam eget, eleifend aliquam purus. Quisque nec leo a dolor auctor auctor quis vehicula massa.","description","Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed turpis felis, luctus quis odio sed, rhoncus egestas nibh.Quisque tempus, ante ut egestas finibus, ante risus ullamcorper metus, porttitor congue ipsum purus eu neque. Ut massa metus, suscipit et tincidunt non, gravida ac lacus. Fusce in fringilla mi, ut tincidunt nunc. Praesent ornare semper ipsum a luctus.Suspendisse potenti.Quisque laoreet pretium semper. Curabitur convallis in mi vel sodales. Nam massa turpis, porta sit amet sem nec, iaculis ultricies nulla. Nam et varius enim. Praesent volutpat malesuada nisi, a ultricies risus aliquet non."));

call Create_Answer(json_object("poster","Marshall Coleman","answer_id","vv7yaAE=","question_id","gfVyuyw=","contents","Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus vitae aliquet sem. Quisque porta eleifend metus, non convallis turpis volutpat sit amet.Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."));

call Create_Ratings(json_object("user_id","hDap6dc=","answer_id","vv7yaAE=","rating",8));
