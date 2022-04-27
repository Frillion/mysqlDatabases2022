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
        json_object = {
            "region_name":"",
            "city_id":"",
            "city_name":"",
            "record_date":"",
            "population":""
        }
        with open(file_path,'r',encoding='UTF-8') as csvfile:
            inserted_regions = 0
            inserted_cities = 0
            inserted_population = 0
            failed_rows = 0
            csv_reader = csv.DictReader(csvfile)
            for row in csv_reader:
                try:
                    int_test = int(row['Sveitarfélagsnúmer'])
                    json_object['city_id']= str(row['Sveitarfélagsnúmer'])
                    json_object['city_name'] = row['Sveitarfélag']
                    if first_year:
                        json_object['record_date'] = str(list(row.keys())[2]).split("-")[1]
                        json_object["population"] = row[list(row.keys())[2]]
                    else:
                        json_object['record_date'] = str(list(row.keys())[3]).split("-")[1]
                        json_object["population"] = row[list(row.keys())[3]]
                    params = json.dumps(json_object,ensure_ascii=False)
                    try:
                        response = self.execute_sql_procedure("insert_region", params)
                        inserted_regions+=json.loads(response[0][0])['rows_inserted']
                        response = self.execute_sql_procedure("insert_cities", params)
                        inserted_cities+=json.loads(response[0][0])['rows_inserted']
                        response = self.execute_sql_procedure("insert_population", params)
                        inserted_population+=json.loads(response[0][0])['rows_inserted']
                    except IndexError:
                        failed_rows += 1
                    print(json_object)
                except ValueError:
                    json_object['region_name'] = row['Sveitarfélagsnúmer']
            return{"Inserted_Pop":inserted_population,"Inserted_Reg":inserted_regions,"Inserted_city":inserted_cities,"Failed":failed_rows}


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