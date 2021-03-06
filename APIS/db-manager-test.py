import db_manager
import types
from inspect import signature
import time

def replace(re,wit,lst):
    for i in range(len(lst)):
        if lst[i] == re:
            lst[i] = wit

def reset_mode():
    global mode
    mode = ''
def print_json_result(result):
    if len(result) == 0:
        for i in result:
            print(i)
            time.sleep(1)
        return
    for key in result.keys():
        print(key,' : ',result[key])
        time.sleep(1)
    print()

def print_menu(menu):
    print("Command List:")
    for key in menu.keys():
        if not callable(menu.get(key)[1]):
            for internal_key in menu[key][1].keys():
                print(menu[key][0]+' '+internal_key+' '+menu[key][1][internal_key][0])
        else:
            print(menu[key][0])

def check_status():
    print(manager.status)

def not_valid():
    print('That is not a recognized command')

def abort():
    raise SystemExit

if __name__ == '__main__':

    manager = db_manager.DbManager()
    command = ''
    mode = ''
    main_menu = {
        "Create":("Create",{
            "Courses":('[course_number][course_name][course_credits]',manager.add_course),
            "TrackCourses":('[track_id][course_number][semester_id][is_mandatory]',manager.add_track_course),
            "Semesters":('[semester_name][semester_start][semester_end][academic_year]',manager.add_semester)
        }),
        "Fetch":("Fetch",{
            "Courses":('[course_number]',manager.single_course),
            "TrackCourses":('[track_id][course_number]',manager.single_track_course),
            "Semesters":('[semester_id]',manager.single_semester)
        }),
        "Update":("Update",{
            "Courses":('[course_number][course_name "can be None"][course_credits "can be None"]',manager.update_course),
            "TrackCourses":('[track_id][course_number][semester_number "can be None][is_mandatory "can be None"]',manager.update_track_course),
            "Semesters":('[semester_id][semester_name "can be None"][semester_start "can be None"][semester_end "can be None"][academic_year "can be None"]',manager.update_semester)
        }),
        "Delete":("Delete",{
            "Courses":('[course_number]',manager.delete_course),
            "TrackCourses":('[track_id][course_number]',manager.delete_track_course),
            "Semesters":('[semester_id]',manager.delete_semester)
        }),
        "Status":("Status",check_status),
        "Exit":("Exit",abort)
    }

    while True:
        print('Type A Command Into The Prompt, Commands Are Separated By Spaces One Primary, One Secondary And Parameters\n'
              'Parameters That Have "Can Be None" Are Optional To Leave Those Unchanged Type None Into That Field\n')
        time.sleep(2)
        print_menu(main_menu)
        command = input('Selection>: ')
        command = command.split()
        replace('None',None,command)
        mode = main_menu.get(command[0],[None,not_valid])[1]
        if not isinstance(mode,types.FunctionType):
            try:
                if len(signature(mode.get(command[1])[1]).parameters) == 1:
                    mode = mode.get(command[1])[1](command[2])
                    print_json_result(mode)
                elif len(signature(mode.get(command[1])[1]).parameters) == 2:
                    mode = mode.get(command[1])[1](command[2],command[3])
                    print_json_result(mode)
                elif len(signature(mode[command[1]][1]).parameters) == 3:
                    mode = mode.get(command[1])[1](command[2],command[3],command[4])
                    print_json_result(mode)
                elif len(signature(mode[command[1]][1]).parameters) == 4:
                    mode = mode.get(command[1])[1](command[2],command[3],command[4],command[5])
                    print_json_result(mode)
                else:
                    mode = mode.get(command[1])[1](command[2], command[3], command[4],command[5],command[6])
                    print_json_result(mode)
            except SyntaxError as e:
                print("Unexpected Error Has Occurred With The Command Syntax:",e)
            except KeyError as e:
                print("No Command Was Found Of That Name:",e)
            except TypeError as e:
                print("Whoops seems like something went wrong please try again:",e)
            except IndexError as e:
                print("No Results Where Returned:",e)
        else:
            mode = main_menu.get(command[0], [None, not_valid])[1]()