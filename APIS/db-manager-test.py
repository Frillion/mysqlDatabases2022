import db_manager

manager = db_manager.DbManager()

print(manager.status)
course = manager.single_course()