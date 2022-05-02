import json
import csv
from mysql.connector import connect
from mysql.connector import Error

class DbManager:
    def __init__(self):
        self.status = ' '
        try:
            self.conn = connect(user='root',
                                password='Frill_ionLegate1_4',
                                host='127.0.0.1',
                                database='population_tracker',
                                auth_plugin='mysql_native_password')
            if self.conn.is_connected():
                self.status = 'connected'
            else:
                self.status = 'connection failed.'
        except Error as error:
            self.status = error

    def insert_entry_from_csv(self,file_path,first_year=True):
        json_object = {}
        with open(file_path,'r',encoding='UTF-8') as csvfile:
            prev_region_id = ''
            index = 0
            csv_reader = csv.DictReader(csvfile)
            for row in csv_reader:
                try:
                    int_test = int(row['Sveitarfélagsnúmer'])
                    json_object[prev_region_id].append({'city_id':str(row['Sveitarfélagsnúmer']),'city_name':row['Sveitarfélag'],'city_population':[]})
                    if first_year:
                        json_object[prev_region_id][index]['city_population'].append({'record_date':list(row.keys())[2].split('-')[1],'population':row[list(row.keys())[2]]})
                    else:
                        json_object[prev_region_id][index]['city_population'].append({'record_date':list(row.keys())[3].split('-')[1],'population':row[list(row.keys())[3]]})
                    index +=1
                except ValueError:
                    if index > 0:
                        params = json.dumps(json_object,ensure_ascii=False)
                        self.execute_sql_procedure("insert_region",params)
                        self.execute_sql_procedure("insert_cities",params)
                        self.execute_sql_procedure("insert_json",params)
                        self.execute_sql_procedure("insert_population",params)
                        print(json_object)
                        print(self.status)
                        json_object.clear()
                    json_object[row['Sveitarfélagsnúmer']] = []
                    prev_region_id = row['Sveitarfélagsnúmer']
                    index = 0


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