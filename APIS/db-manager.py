import json
from mysql.connector import connect
from mysql.connector import Error
from config import *
import _mysql_connector

class DbManager:
    def __init__(self):
        self.status = ' '
        try:
            self.conn = connect(user='root',
                                password='Frill_ionLegate1_4',
                                host='127.0.0.1',
                                database='studytracker',
                                auth_plugin='mysql_native_password')
            if self.conn.is_connected():
                self.status = 'connected'
            else:
                self.status = 'connection failed.'
        except Error as error:
            self.status = error

    # ---------------------------------------------------------------------------------------
    def add_course(self, course_number, course_name, course_credits):
        course = {
            "course_number": course_number,
            "course_name": course_name,
            "course_credits": course_credits
        }
        params = [json.dumps(course, ensure_ascii=False)]

        response_json = self.execute_sql_procedure('add_course_json', params)
        return json.loads(response_json[0][0])


    def single_course(self, course_number):
        pass


    def update_course(self, course_number, course_name, course_credits):
        pass


    def delete_course(self, course_number):
        pass


    # ---------------------------------------------------------------------------------------
    def add_track_course(self, course_number, semester_id, is_mandatory):
        pass


    def single_track_course(self, track_id, course_number):
        pass


    def update_track_course(self, track_id, course_number, semester_id, is_mandatory):
        pass


    def delete_track_course(self, track_id, course_number):
        pass


    # ---------------------------------------------------------------------------------------
    def add_semester(self, semester_name, semester_starts, semester_ends, academic_year):
        pass


    def single_semester(self, semester_id):
        pass


    def update_semester(self, semester_id, semester_name, semester_starts, semester_ends, academic_year):
        pass


    def delete_semester(self, semester_id):
        pass


    # ---------------------------------------------------------------------------------------
    def execute_sql_function(self, function_name, parameters=None):
        returns = []
        try:
            cursor = self.conn.cursor(prepared=True)
            if parameters:
                cursor.execute(function_name, parameters)
            else:
                cursor.execute(function_name)

            returns = cursor.fetchone()
            cursor.close()
        except Error as error:
            self.status = error
            returns.append(None)
        finally:
            return returns[0]

    def execute_sql_procedure(self, procedure_name, parameters=None):
        results = []
        try:
            cursor = self.conn.cursor()
            if parameters:
                cursor.callproc(procedure_name, parameters)
            else:
                cursor.callproc(procedure_name)

            self.conn.commit()

            for result in cursor.stored_results():
                results = result.fetchall()

        except Error as error:
            self.status = error
        finally:
            return results