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

![Practice4 database diagram](Practice4/database_diagram.png)

---
### Mysql Files

populationTracker creates the database and all its tables<br>
populationtracker inserts holds all the stored procedures that are required to insert the json data it gets from csv-test/csv\_Import<br>
population\_tracker\_operations holds the stored procedures for all data that the database should return

## Practice 5
### Relational Diagram
![Database Relationship Diagram](https://github.com/Frillion/mysqlDatabases2022/blob/main/Practice5/DatabaseRelationalDiagram.png)
This is the relationship diagram for a database meant to be a question and answer site akin to stack overflow.

### MySQL Files
The name that i have decided on for the database is stack_definitively_not_overflowing cause as you might know i am very original \*cough\*\*cough\*<br>
Therefore the file containing the creation of the database is named as such.<br>
The file containing all the CRUD operations is called stack_not_overflowing_data.sql(**This Includes "Posting" Questions And Answers**)<br>
stack_not_overflowing_special_operations.sql has all other procedures needed by the database

### Json Objects
**CREATE**
**Create User Input**
```json
{
	"user_id":"hDap6dc=",
	"status":"Active",
	"user_type":"Beginner",
	"username":"Julian Oliver",
	"password":"hoover",
	"email":"julian.oliver@example.com"
}
```
*note: the password would be encrypted*

**Create Topic Input**
```json
{
	"topic_id":0,
	"topic_name":"Programming"
}
```
**Create Answer Input**
```json
{
	"poster":"Julian Oliver",
	"answer_id":"y1Geya4=",
	"question_id":"tY9Gyio=",
	"contents":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus vitae aliquet sem. Quisque porta eleifend metus, non convallis turpis volutpat sit amet.Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
}
```
**Create Access Input**
```json
{
	"access_id":0,
	"access_level":"Admin"
}
```
**Create Question Input**
```json
{
	"poster":"Julian Oliver",
	"question_id":"gfVyuyw=",
	"topic":"Programming",
	"title":"Aliquam erat volutpat. Suspendisse lorem arcu, blandit non diam eget, eleifend aliquam purus. Quisque nec leo a dolor auctor auctor quis vehicula massa.",
	"description":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed turpis felis, luctus quis odio sed, rhoncus egestas nibh.Quisque tempus, ante ut egestas finibus, ante risus ullamcorper metus, porttitor congue ipsum purus eu neque. Ut massa metus, suscipit et tincidunt non, gravida ac lacus. Fusce in fringilla mi, ut tincidunt nunc. Praesent ornare semper ipsum a luctus.Suspendisse potenti.Quisque laoreet pretium semper. Curabitur convallis in mi vel sodales. Nam massa turpis, porta sit amet sem nec, iaculis ultricies nulla. Nam et varius enim. Praesent volutpat malesuada nisi, a ultricies risus aliquet non."
}
```
**Create Rating Input**
```json
{
	"user_id":"hDap6dc=",
	"answer_id":"y1Geya4=",
	"rating":8
}
```
*note: inputing a rating of the users own answer will not work*

**Create Status Input**
```json
{
	"status_id":0,
	"user_status":"Active"
}
```
**READ**
*note: getting all rows just returns an array of these objects*
**Get User Output**
```json
{
	"user_id":"hDap6dc=",
	"username":"Julian Oliver",
	"status":"Active",
	"user_type":"Admin",
	"hased_password":"SHA2(hoover)",
	"email":"julian.oliver@example.com",
	"last_logon_date":"2022/05/01"
}
```
**Get Topic Output**
```json
{
	"topic_id":0,
	"topic":"Programming"
}
```
**Get Question Answers Output**
*note:  Gets all answers of a given question so its an array of this object*
```json
{
	"answer_id":"y1Geya4=",
	"question_id":"gfVyuyw=",
	"contents":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sed tempus metus. Nunc tempus condimentum euismod. Fusce blandit vel eros in ultricies. Aliquam placerat dapibus lorem nec vulputate.Praesent fermentum elit arcu, quis tincidunt velit sodales at. Cras ac convallis justo.Fusce rhoncus libero quis accumsan ornare. Mauris eget facilisis nisl."
	"date_posted":"2022/03/01"
}
```
**Get Access Output**
```json
{
	"access_id":0,
	"access_id":"Admin"
}
```
**Get Questions Output**
```json
{
	"question_id":"gfVyuyw=",
	"topic":"Programming",
	"poster":"Julian Oliver",
	"question":"Nunc accumsan ligula ac luctus tempus. Sed euismod accumsan gravida. Sed convallis ipsum eget nibh euismod commodo.Ut bibendum, risus tempus mattis accumsan, massa leo tincidunt velit, quis euismod nulla ligula ac lectus.",
	"description":"Mauris hendrerit ac velit ac porta. Cras ultricies, urna ut luctus porta, massa metus feugiat ante, consectetur lacinia ante libero sit amet tortor. Pellentesque ut nisi lacus. Mauris pellentesque nisi massa,ut volutpat justo dignissim vitae. In hac habitasse platea dictumst. Duis efficitur sapien sed rutrum condimentum.Morbi imperdiet hendrerit rutrum. Vivamus elit velit, mollis eu mattis eu, blandit et diam",
	"date_posted":"2022/01/15"
}
```
**Get Ratings Output**
*note: Gets all ratings for a given answer*
```json
{
	"rater_id":"hDap6dc=",
	"answer_id":"y1Geya4=",
	"rating":8
}
```
**Get Status Output**
```json
{
	"status_id":0,
	"user_status":"Active"
}
```
**Update User Input**
```json
{
	"user_id":"y1Geya4=",
	"username":"(new_username)",
	"password":"(new_password)",
	"email":"(new_email)"
}
```



