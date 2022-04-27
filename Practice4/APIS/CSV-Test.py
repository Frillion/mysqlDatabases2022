from CSV_Import import *

dbmanager = DbManager()
result = dbmanager.insert_entry_from_csv("D:\Database2022\Practice4\\Mannfjoldi_a_islandi.csv",False)
print(result)