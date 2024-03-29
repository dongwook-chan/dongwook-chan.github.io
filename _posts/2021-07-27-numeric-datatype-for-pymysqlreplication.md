---
title: numeric datatype for pymysqlreplication
key: dong-numeric-datatype-for-pymysqlreplication
tags: pymysqlreplication python-mysql-replication pymysql
---

## create table
### integer datatype

```sql
CREATE TABLE `integer` (
  `tinyint` tinyint DEFAULT NULL,
  `smallint` smallint DEFAULT NULL,
  `mediumint` mediumint DEFAULT NULL,
  `int` int DEFAULT NULL,
  `bigint` bigint DEFAULT NULL
);
```
### unsigned datatype

```sql
CREATE TABLE `unsinged_integer` (
  `tinyint` tinyint unsigned DEFAULT NULL,
  `smallint` smallint unsigned DEFAULT NULL,
  `mediumint` mediumint unsigned DEFAULT NULL,
  `int` int unsigned DEFAULT NULL,
  `bigint` bigint unsigned DEFAULT NULL
);
```

### attribute for integer datatype



### fixed-point, floating-point, bit datatype

```sql
CREATE TABLE `etc` (
  `decimal` decimal(65,30) DEFAULT NULL,
  `negative_float` float DEFAULT NULL,
  `positive_float` float DEFAULT NULL,
  `negative_double` double DEFAULT NULL,
  `positive_double` double DEFAULT NULL,
  `bit` bit(64) DEFAULT NULL
);
```


## insert values

[min, max value for integer types](https://dev.mysql.com/doc/refman/8.0/en/integer-types.html)

### min, max values for integer datatype
[min, max value for integer types](https://dev.mysql.com/doc/refman/8.0/en/integer-types.html)  

| classification | tinyint | smallint | int | mediumint | bigint |
| :-: | :- | :- | :- | :- | :- |
| min | -128 | -32768 | -8388608 | -2147483648 | -9223372036854775808 |
| max | 127 |  32767 |  8388607 |  2147483647 |  9223372036854775807 |

### min, max values for **unsigned** integer datatype
[min, max value for integer types](https://dev.mysql.com/doc/refman/8.0/en/integer-types.html)  

| classification | tinyint | smallint | int | mediumint | bigint |
| :-: | :- | :- | :- | :- | :- |
| min |   0 |     0 |        0 |          0 |                    0 |
| max | 255 | 65535 | 16777215 | 4294967295 | 18446744073709551615 |


### attribute for integer datatype
zerofill

### fixed-point, floating-point, bit datatype
[min, max value for decimal](https://dev.mysql.com/doc/refman/8.0/en/fixed-point-types.html)
[min, max value for floating-point](https://docs.oracle.com/cd/E17952_01/mysql-8.0-en/numeric-type-syntax.html)
[min, max value for bit](https://dev.mysql.com/doc/refman/8.0/en/bit-type.html)

| classification | decimal | negative float | positive float | negative double | positive double | bit | 
| :-: | :- | :- | :- | :- | :- |
| min | -99999999999999999999999999999999999.999999999999999999999999999999 | -3.40282e38 | 1.17549e-38 | -1.7976931348623157e308 | -2.2250738585072014e-308 | 0x0000000000000000 |
| max | 99999999999999999999999999999999999.999999999999999999999999999999 | -1.17549e-38 | 3.40282e38 | 2.2250738585072014e-308 | 1.7976931348623157e308 | 0xFFFFFFFFFFFFFFFF |

## get values using Python library
### [pymysql](https://github.com/PyMySQL/PyMySQL)

```python
classification: min
bit: <class 'str'> 0000000000000000000000000000000000000000000000000000000000000000
64
decimal: <class 'decimal.Decimal'> -99999999999999999999999999999999999.999999999999999999999999999999
negative_float: <class 'float'> -3.40282e+38
positive_float: <class 'float'> 1.17549e-38
negative_double: <class 'float'> -1.7976931348623157e+308
positive_double: <class 'float'> 2.2250738585072014e-308
```

```python
classification: max
bit: <class 'str'> 1111111111111111111111111111111111111111111111111111111111111111
64
decimal: <class 'decimal.Decimal'> 99999999999999999999999999999999999.999999999999999999999999999999
negative_float: <class 'float'> -1.17549e-38
positive_float: <class 'float'> 3.40282e+38
negative_double: <class 'float'> -2.2250738585072014e-308
positive_double: <class 'float'> 1.7976931348623157e+308
```


### [pymysqlreplication](https://github.com/noplay/python-mysql-replication)

```python
classification: min
b:<class 'bytes'> b'\x00\x00\x00\x00\x00\x00\x00\x00'
dcm:<class 'decimal.Decimal'> -99999999999999999999999999999999999.999999999999999999999999999999
negative_float: <class 'float'> -3.4028234663852886e+38
positive_float: <class 'float'> 1.1754943508222875e-38
negative_double: <class 'float'> 1.1754943508222875e-38
positive_double: <class 'float'> 2.2250738585072014e-308
```

```python
classification: max
b:<class 'bytes'> b'\xff\xff\xff\xff\xff\xff\xff\xff'
dcm:<class 'decimal.Decimal'> 99999999999999999999999999999999999.999999999999999999999999999999
negative_float: <class 'float'> -1.1754943508222875e-38
positive_float: <class 'float'> 3.4028234663852886e+38
negative_double: <class 'float'> -2.2250738585072014e-308
positive_double: <class 'float'> 1.7976931348623157e+308
```

precision, scale -> decimal  
12 -> float  
22 -> double  


TODO
decimal zerofill test  
floating point -> inaccurate value, correct referring to pymysql
floating point -> width specifier & pad zero

