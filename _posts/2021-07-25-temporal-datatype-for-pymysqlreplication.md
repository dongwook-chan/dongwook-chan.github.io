---
title: temporal datatype for pymysqlreplication
key: dong-temporal-datatype-for-pymysqlreplication
tags: pymysqlreplication python-mysql-replication pymysql
---

## create table
```sql
CREATE TABLE `temporal_datatype` (
  `classification` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `date` date DEFAULT NULL,
  `datetime` datetime(6) DEFAULT NULL,
  `timestamp` timestamp(6) NULL DEFAULT NULL,
  `time` time(6) DEFAULT NULL,
  `year` year DEFAULT NULL
)
```
## insert values
### zero, min, max values for `temporal` datatype
[MySQL Doc: Temporal Types](https://dev.mysql.com/doc/refman/8.0/en/date-and-time-types.html)

| class | date          | datetime                      | timestamp                     | time                  | year  |
| :-:   | :-:           | :-:                           | :-:                           | :-:                   | :-:   |
| zero | '0000-00-00'  | '0000-00-00 00:00:00.000000'  | '0000-00-00 00:00:00.000000'  | '000:00:00.000000'    | '0000'|
| min   | '1000-01-01'  | '1000-01-01 00:00:00.000000'  | '1970-01-01 00:00:01.000000'  | '-838:59:59.000000'   | '1901'|
| max   | '9999-12-31'  | '9999-12-31 23:59:59.999999'  | '2038-01-19 03:14:07.999999'  | '838:59:59.000000'    | '2155'|

### check before insert
#### sql_mode for zero value
[MySQL Doc: no_zero_date, no_zero_in_date](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#sqlmode_no_zero_date)  
Inserting zero values is possible only if `no_zero_date` and `no_zero_in_date` disabled in `sql_mode`.  
Set `sql_mode` to exclude above two values.  
```sql
SET GLOBAL `sql_mode` = '';
```
#### time_zone for min, max value
Datatype range is applies only to UTC.  
Set `time_zone` to UTC or apply time difference to get the correct min/max value for the current `time_zone`.   
```sql
SET GLOBAL `time_zone` = 'UTC';
```
### insert
Insert zero, min, max values for each temporal datatype.
```sql
INSERT INTO `temporal` VALUES('zero', '0000-00-00', '0000-00-00 00:00:00.000000', '0000-00-00 00:00:00.000000', '000:00:00.000000', '0000');
INSERT INTO `temporal` VALUES('min', '1000-01-01', '1000-01-01 00:00:00.000000', '1970-01-01 00:00:01.000000', '-838:59:59.000000', '1901');
INSERT INTO `temporal` VALUES('max', '9999-12-31', '9999-12-31 23:59:59.999999', '2038-01-19 03:14:07.999999', '838:59:59.000000', '2155');
```
## get values using Python library
### [pymysql](https://github.com/PyMySQL/PyMySQL)

| class | DATE                                  | DATETIME                                              | TIMESTAMP                                                 | TIME                                              | YEAR                  |
| :-:   | :-:                                   | :-:                                                   | :-:                                                       | :-:                                               | :-:                   |
| zero | **<class 'str'> 0000-00-00**          | **<class 'str'> 0000-00-00 00:00:00.000000**          | **<class 'str'> 0000-00-00 00:00:00.000000**              | <class 'datetime.timedelta'> 0:00:00              | **<class 'int'> 0**   |
| min   | <class 'datetime.date'> 1000-01-01    | <class 'datetime.datetime'> 1000-01-01 00:00:00       | <class 'datetime.datetime'> 1970-01-01 **00:00:01**       | <class 'datetime.timedelta'> -35 days, **1:00:01**| <class 'int'> 1901    |
| max   | <class 'datetime.date'> 9999-12-31    | <class 'datetime.datetime'> 9999-12-31 23:59:59.999999| <class 'datetime.datetime'> 2038-01-19 **03:14:07.999999**| <class 'datetime.timedelta'> 34 days, 22:59:59    | <class 'int'> 2155    |

### [pymysqlreplication](https://github.com/noplay/python-mysql-replication)

| class | DATE                                  | DATETIME                                              | TIMESTAMP                                                 | TIME                                              | YEAR                  |
| :-:   | :-:                                   | :-:                                                   | :-:                                                       | :-:                                               | :-:                   |
| zero | **<class 'NoneType'> None**           | **<class 'NoneType'> None**                           | **<class 'datetime.datetime'> 1970-01-01 09:00:00**       | <class 'datetime.timedelta'> 0:00:00              | **<class 'int'> 1900**|
| min   | <class 'datetime.date'> 1000-01-01    | <class 'datetime.datetime'> 1000-01-01 00:00:00       | <class 'datetime.datetime'> 1970-01-01 **09:00:01**       | <class 'datetime.timedelta'> -35 days, **2:59:59**| <class 'int'> 1901    | 
| max   | <class 'datetime.date'> 9999-12-31    | <class 'datetime.datetime'> 9999-12-31 23:59:59.999999| <class 'datetime.datetime'> 2038-01-19 **12:14:07.999999**| <class 'datetime.timedelta'> 34 days, 22:59:59    | <class 'int'> 2155    |


### difference analysis
#### zero DATE & DATETIME

| library           | class                                 | exception | return value                  |
| :-:               | :-:                                   | :-:       | :-:                           |
| [pymysql](https://github.com/PyMySQL/PyMySQL/blob/fb10477caf21122a89d7f216a0670d49dd2aa5d2/pymysql/converters.py#L155-L183)| datetime.date(), datetime() | ValueError | returns obj as it is (string) |
| [pymysqlreplication](https://github.com/noplay/python-mysql-replication/blob/3de6ff499f7695a800409341f4f859cac5b724d0/pymysqlreplication/row_event.py#L295-L361) | datetime.date(), datetime() | ValueError | returns None |
  
#### zero TIMESTAMP

| library             | class                             | exception | return value                  | timedelta applied     |
| :-:                 | :-:                               | :-:       | :-:                           | :-:                   |
| [pymysql](https://github.com/PyMySQL/PyMySQL/blob/fb10477caf21122a89d7f216a0670d49dd2aa5d2/pymysql/converters.py#L155-L183) | datetime.datetime() | ValueError| returns obj as it is (string) | N/A                   |
| [pymysqlreplication](https://github.com/noplay/python-mysql-replication/blob/3de6ff499f7695a800409341f4f859cac5b724d0/pymysqlreplication/row_event.py#L160-L163) | datetime.datetime.fromtimestamp() | N/A       | '1970-01-01 09:00:00'         | +09:00 ('Asia/Seoul') |
 
#### min TIME

| library | return value|
| :-:     | :-:         |
| [pymysql](https://github.com/PyMySQL/PyMySQL/blob/fb10477caf21122a89d7f216a0670d49dd2aa5d2/pymysql/converters.py#L189-L230) | -838 hours, -59 minutes, -59 seconds **(correct)** |
| [pymysqlreplication](https://github.com/noplay/python-mysql-replication/blob/3de6ff499f7695a800409341f4f859cac5b724d0/pymysqlreplication/row_event.py#L268-L293) | -838 hours, +59 minutes, +59 seconds **(wrong)** |

Created [pull request](https://github.com/noplay/python-mysql-replication/pull/352) to correct TIME values for pymysqlreplication