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
        course = {
            "course_number": course_number
        }
        param = [json.dumps(course,ensure_ascii=False)]
        response = self.execute_sql_procedure('get_course_json',param)
        try:
            return json.loads(response[0][0])
        except IndexError:
            return response
        pass


    def update_course(self, course_number, course_name = None, course_credits=None):
        course={
            "course_number":course_number,
            "course_name":course_name,
            "course_credits":course_credits
        }
        params = [json.dumps(course,ensure_ascii=False)]
        response = self.execute_sql_procedure('update_course_json',params)
        return json.loads(response[0][0])
        pass


    def delete_course(self, course_number):
        course={
            'course_number':course_number
        }
        param = [json.dumps(course, ensure_ascii=False)]
        response = self.execute_sql_procedure('delete_course_json', param)
        return json.loads(response[0][0])
        pass


    # ---------------------------------------------------------------------------------------
    def add_track_course(self, track_id, course_number, semester_id, is_mandatory):
        track_course = {
            "track_id":track_id,
            "course_number":course_number,
            "semester_id":semester_id,
            "is_mandatory":is_mandatory
        }
        param = [json.dumps(track_course, ensure_ascii=False)]
        response = self.execute_sql_procedure('add_track_course_json', param)
        return json.loads(response[0][0])
        pass


    def single_track_course(self, track_id, course_number):
        track_course = {
            "track_id":track_id,
            "course_number":course_number
        }
        param = [json.dumps(track_course, ensure_ascii=False)]
        response = self.execute_sql_procedure('get_track_course_json', param)
        try:
            return json.loads(response[0][0])
        except IndexError:
            return response
        pass


    def update_track_course(self, track_id, course_number, semester_id=None, is_mandatory=None):
        track_course = {
            "track_id":track_id,
            "course_number":course_number,
            "semester_id":semester_id,
            "is_mandatory":is_mandatory
        }
        param = [json.dumps(track_course, ensure_ascii=False)]
        response = self.execute_sql_procedure('update_track_course_json', param)
        return json.loads(response[0][0])
        pass


    def delete_track_course(self, track_id, course_number):
        track_course = {
            "track_id":track_id,
            "course_number":course_number
        }
        param = [json.dumps(track_course, ensure_ascii=False)]
        response = self.execute_sql_procedure('delete_track_course_json',param)
        return json.loads(response[0][0])
        pass


    # ---------------------------------------------------------------------------------------
    def add_semester(self, semester_name, semester_starts, semester_ends, academic_year):
        semester={
            "semester_name":semester_name,
            "semester_start":semester_starts,
            "semester_end":semester_ends,
            "academic_year":academic_year
        }
        param = [json.dumps(semester, ensure_ascii=False)]
        response = self.execute_sql_procedure('add_semester_json',param)
        return json.loads(response[0][0])
        pass


    def single_semester(self, semester_id):
        semester={
            "semester_id":semester_id
        }
        param = [json.dumps(semester, ensure_ascii=False)]
        response = self.execute_sql_procedure('get_semester_json',param)
        try:
            return json.loads(response[0][0])
        except IndexError:
            return response
        pass


    def update_semester(self, semester_id, semester_name=None, semester_starts=None, semester_ends=None, academic_year=None):
        semester = {
            "semester_id":semester_id,
            "semester_name":semester_name,
            "semester_start":semester_starts,
            "semester_end":semester_ends,
            "academic_year":academic_year
        }
        param = [json.dumps(semester, ensure_ascii=False)]
        response = self.execute_sql_procedure('update_semester_json', param)
        return json.loads(response[0][0])
        pass


    def delete_semester(self, semester_id):
        semester={
            "semester_id":semester_id
        }
        param = [json.dumps(semester, ensure_ascii=False)]
        response = self.execute_sql_procedure('delete_semester_json', param)
        return json.loads(response[0][0])
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