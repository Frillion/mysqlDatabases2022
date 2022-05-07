# Database Class 2022
## Practice 4 Notes
<b>Mann\_Fjöldi\_a\_islandi.csv Has Been modified slightly to make it easier to read from python and construct the json object that is shown below</b>

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
The [CSV-Test](https://github.com/Frillion/mysqlDatabases2022/blob/main/Practice4/APIS/CSV-Test.py) file is the script that takes a file path to the csv file and imports that to the database **Requires:**[CSV\_Import](https://github.com/Frillion/mysqlDatabases2022/blob/main/Practice4/APIS/CSV_Import.py)

---
### Database Diagram

![Practice4 database diagram](https://github.com/Frillion/mysqlDatabases2022/tree/main/Practice4/database_diagram.png)

---
### Mysql Files

populationTracker creates the database and all its tables<br>
populationtracker inserts holds all the stored procedures that are required to insert the json data it gets from csv-test/csv\_Import<br>
population\_tracker\_operations holds the stored procedures for all data that the database should return

## Practice 5
### Relational Diagram
![Database Relationship Diagram](https://github.com/Frillion/mysqlDatabases2022/blob/main/Practice5/DatabaseRelationalDiagram.png)
This is the relationship diagram for a database meant to be a question and answer site akin to stack overflow.
