import db_manager

def menu_print(menu):
    if len(menu)!= 0:
        print('\n Type The Command You Wish To Preform E.g. Create')
        for i in menu:
            print(str(i))

if __name__ == '__main__':
    manager = db_manager.DbManager()
    is_connected = manager.status != 'connection failed.'
    main_menu = ["Create","Fetch","Update","Delete"]
    table_menu = ["Courses","TrackCourses","Semesters"]
    command = ''
    results = None

    print(manager.status + '\n')

    while is_connected:
        menu_print(main_menu)
        command = input('Selection>: ')
        while command == 'Create':
