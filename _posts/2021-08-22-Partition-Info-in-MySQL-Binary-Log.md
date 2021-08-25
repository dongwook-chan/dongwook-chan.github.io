---
title: Partition Info in MySQL Binary Log
key: dong-Partition-Info-in-MySQL-Binary-Log
tags: 
---

# Overview
Partition information was added into MySQL binary log since MySQL 8.0.16  
'Rows_event' class represents the information in source code.

# Documentation
[ROWS_EVENT](https://dev.mysql.com/doc/internals/en/rows-event.html) in MySQL Documentation  
[Rows_event class](https://github.com/mysql/mysql-server/blob/beb865a960b9a8a16cf999c323e46c5b0c67f21f/libbinlogevents/src/rows_event.cpp#L415) in source code   

# Event Layout
## bytes before ?  
## Log Event Header
[Binlog::EventHeader](https://dev.mysql.com/doc/internals/en/binlog-event-header.html) in MySQL Documentation  
[Log Event Header(common header)](https://github.com/mysql/mysql-server/blob/beb865a960b9a8a16cf999c323e46c5b0c67f21f/sql/log_event.cc#L1299) in source code  
[table description](https://github.com/mysql/mysql-server/blob/beb865a960b9a8a16cf999c323e46c5b0c67f21f/sql/log_event.h#L732-L749) in source code
## Rows Event
[ROWS_EVENT](https://dev.mysql.com/doc/internals/en/rows-event.html) in MySQL Documentation  
[Rows_event class](https://github.com/mysql/mysql-server/blob/beb865a960b9a8a16cf999c323e46c5b0c67f21f/libbinlogevents/src/rows_event.cpp#L385) in source code   
[table description](https://github.com/mysql/mysql-server/blob/beb865a960b9a8a16cf999c323e46c5b0c67f21f/libbinlogevents/include/rows_event.h#L772-L814) in source code



<!---
# Source Code Summary
## binlog.cc
interface to write rows to the binary log
### int THD::binlog_write_row
## rpl_injector.cc
insert new rows into binary log
### int injector::transaction::write_row
## log_event.cc
### bool Write_rows_log_event::binlog_row_logging_function





rows_event의 Rows_event, {DML}_rows_event 클래스에 의해 정의


log_event의 Rows_log_event, {DML}_rows_log_event 클래스에 의해 정의

binlog의 binlog_{DML}_row 메소드


ha_는 무엇?
ha_write_row

common_header
post_header








binlog_row_logging_function -> binlog_write_row 
write_row -> binlog_write_row 
-->