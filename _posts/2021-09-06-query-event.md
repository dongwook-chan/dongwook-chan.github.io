---
title: query-event
key: dong-query-event
tags: 
---

# dump & analysis
## dump dump

    === QueryEvent ===
    Date: 2021-08-24T22:57:09
    Log position: 401
    Event size: 145
    Read bytes: 145
    Schema: b'pymysqlreplication_test'
    Execution time: 0
    Query: CREATE TABLE test (test DATETIME NOT NULL)

    None
    2

## dump packet

    packet length: 169
    call[1]: dump (line 224)
    call[2]: <module> (line 1)
    call[3]: _getval (line 1155)
    call[4]: do_p (line 1177)
    call[5]: onecmd (line 217)
    call[6]: onecmd (line 418)
    ------------------------------------------------------------------
    00 B5 FA 24 61 02 01 00 00 00 A8 00 00 00 91 01  ...$a...........
    00 00 00 00 ED 09 00 00 00 00 00 00 17 00 00 42  ...............B
    00|00 00 00 00 00 01 20 00 A0 45 00 00 00 00 06  ....... ..E.....
    03 73 74 64/04 21 00 21 00 2D 00/0C 01 70 79 6D  .std.!.!.-...pym
    79 73 71 6C 72 65 70 6C 69 63 61 74 69 6F 6E 5F  ysqlreplication_
    74 65 73 74 00/11 1B 68 01 00 00 00 00 00/12 FF  test...h........
    00 13 00|70 79 6D 79 73 71 6C 72 65 70 6C 69 63  ...pymysqlreplic
    61 74 69 6F 6E 5F 74 65 73 74 00 43 52 45 41 54  ation_test.CREAT
    45 20 54 41 42 4C 45 20 74 65 73 74 20 28 74 65  E TABLE test (te
    73 74 20 44 41 54 45 54 49 4D 45 20 4E 4F 54 20  st DATETIME NOT
    4E 55 4C 4C 29 F9 CB 9B F2                       NULL)....
    ------------------------------------------------------------------

## print event.status_vars
    b'\x00\x00\x00\x00\x00\x01 \x00\xa0E\x00\x00\x00\x00\x06\x03std\x04!\x00!\x00-\x00\x0c\x01pymysqlreplication_test\x00\x11\x1bh\x01\x00\x00\x00\x00\x00\x12\xff\x00\x13\x00'

## parse status_vars
self.packet.read_bytes = 13
self.status_vars_length = 66
status_vars_end_pos = 79

| key | value | meaning | read_bytes |
| --- | ----- | ------- | ---------- |
| 00 | 00 00 00 00 | | 18 |
| 01 | 20 00 A0 45 00 00 00 00 | MODE_NO_ENGINE_SUBSTITUTION, MODE_ERROR_FOR_DIVISION_BY_ZERO, MODE_NO_ZERO_DATE, MODE_NO_ZERO_IN_DATE, MODE_STRICT_TRANS_TABLES, MODE_ONLY_FULL_GROUP_BY | 27 |
| 06 | 03 std | std | 32 |
| 04 | 21 00 21 | utf8_general_ci, utf8_general_ci, utf8mb4_general_ci | 39 | 
| 0C | 01 70 79 6D 79 73 71 6C 72 65 70 6C 69 63 61 74 69 6F 6E 5F 74 65 73 74 00 | updated db 목록: 크기 1, pymysqlreplication_test | 65 |
| 11 | 1B 68 01 00 00 00 00 00 | Q_DDL_LOGGED_WITH_XID | 74 |
| 12 | FF 00 | Q_DEFAULT_COLLATION_FOR_UTF8MB4 |
| 13 | 00 | Q_SQL_REQUIRE_PRIMARY_KEY: False | 


# reference study

            Binary_log_event
                   ^
                   |
                   |
            Query_event  Log_event
                   \       /
         <<virtual>>\     /
                     \   /
                Query_log_event

## define query_event status_vars
libbinlogevents/include/statement_events.h > Query_event
    /**
      @addtogroup Replication
      @{
    
      @file statement_events.h
    
      @brief Contains the classes representing statement events occurring in the
      replication stream. Each event is represented as a byte sequence with logical
      divisions as event header, event specific data and event footer. The header
      and footer are common to all the events and are represented as two different
      subclasses.
    */
[definition of Query_event_status_vars](https://github.com/mysql/mysql-server/blob/beb865a960b9a8a16cf999c323e46c5b0c67f21f/libbinlogevents/include/statement_events.h#L463-L532)
[comment on status_vars](https://github.com/mysql/mysql-server/blob/beb865a960b9a8a16cf999c323e46c5b0c67f21f/libbinlogevents/include/statement_events.h#L153-L446)

## construct query_event
libbinlogevents/include/statement_events.cpp > Query_event
[constructor of Query_event](https://github.com/mysql/mysql-server/blob/beb865a960b9a8a16cf999c323e46c5b0c67f21f/libbinlogevents/src/statement_events.cpp#L109-L336)

### event_reader 
libbinlogevents/include/event_reader.h
/**
  @addtogroup Replication
  @{

  @file event_reader.h

  @brief Contains the class responsible for deserializing fields of an event
         previously stored in a buffer.
*/

## write Query_log_event
sql/log_event.h
    /**
      @file sql/log_event.h
    
      @brief Binary log event definitions.  This includes generic code
      common to all types of log events, as well as specific code for each
      type of log event.
    
      @addtogroup Replication
      @{
    */

    /*
        One class for each type of event.
        Two constructors for each class:
        - one to create the event for logging (when the server acts as a master),
        called after an update to the database is done,
        which accepts parameters like the query, the database, the options for LOAD
        DATA INFILE...
        - one to create the event from a packet (when the server acts as a slave),
        called before reproducing the update, which accepts parameters (like a
        buffer). Used to read from the master, from the relay log, and in
        mysqlbinlog. This constructor must be format-tolerant.
    */

    /**
        Query_log_event::write().
    
        @note
            In this event we have to modify the header to have the correct
            EVENT_LEN_OFFSET as we don't yet know how many status variables we
            will print!
    */










## reference to parse query_event.status_vars
[MySQL Documentaition](https://dev.mysql.com/doc/internals/en/query-event.html)
[mysql-server/client](https://github.com/mysql/mysql-server/blob/beb865a960b9a8a16cf999c323e46c5b0c67f21f/client/mysqlbinlog.cc#L371-L395)
[mysql-server/statement-events](https://github.com/mysql/mysql-server/blob/beb865a960b9a8a16cf999c323e46c5b0c67f21f/libbinlogevents/include/statement_events.h#L153-L446) -> latest