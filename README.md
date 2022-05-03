# Database Class 2022
## Practice 4 Notes
**Mann\_Fjöldi\_a\_islandi.csv Has Been modified slightly to make it easier to read from python and construct the json object that is shown below**

```json
{
	"Region_id":[{
		"city_id":'',
		"city_name":'',
		"city_population":[{
			"record_date":'',
			"population":''
		}]
	}]
}
```
### Python Scripts
The [CSV-Test](https://github.com/Frillion/mysqlDatabases2022/blob/main/Practice4/APIS/CSV-Test.py) file is the script that takes a file path to the csv fileand imports that to the database **Requires:**[CSV\_Import](https://github.com/Frillion/mysqlDatabases2022/blob/main/Practice4/APIS/CSV_Import.py)

---
### Database Diagram

The diagram for the database is in database_diagram(1).drawio wich can be opened using this [website](https://app.diagrams.net)

---
### Mysql Files

populationTracker creates the database and all its tables
populationtracker inserts holds all the stored procedures that are required to insert the json data it gets from csv-test/csv\_Import
population\_tracker\_operations holds the stored procedures for all data that the database should return **Still Under Development**
