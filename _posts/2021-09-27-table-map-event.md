---
title: table map event
key: dong-table-map-event
tags: 
---

# dump & analysis
## description
    /**
        <pre>
        The buffer layout for fixed data part is as follows:
        +-----------------------------------+
        | table_id | Reserved for future use|
        +-----------------------------------+
        </pre>

        <pre>
        The buffer layout for variable data part is as follows:
        +--------------------------------------------------------------------------+
        | db len| db name | table len| table name | no of cols | array of col types|
        +--------------------------------------------------------------------------+
        +---------------------------------------------+
        | metadata len | metadata block | m_null_bits |
        +---------------------------------------------+
        </pre>

        @param buf  Contains the serialized event.
        @param fde  An FDE event (see Rotate_event constructor for more info).
    */

## dump dump

    === TableMapEvent ===
    Date: 2021-09-26T17:04:42
    Log position: 1049
    Event size: 56
    Read bytes: 47
    Table id: 43256
    Schema: will
    Table: test_table_map_ev
    Columns: 6

    === TableMapEvent ===
    Date: 2021-09-27T14:59:13
    Log position: 1597
    Event size: 35
    Read bytes: 28
    Table id: 43257
    Schema: will
    Table: bin
    Columns: 3

## dump packet

    packet length: 80
    call[1]: dump (line 224)
    call[2]: <module> (line 1)
    call[3]: _getval (line 1155)
    call[4]: do_p (line 1177)
    call[5]: onecmd (line 217)
    call[6]: onecmd (line 418)
    ------------------------------------------------------------------
    00 9A 29 50 61 13 01 00 00 00 4F 00 00 00 19 04  ..)Pa.....O.....
    00 00 00 00|F8 A8 00 00 00 00|01 00|04|77 69 6C  .............wil
    6C|00|11|74 65 73 74 5F 74 61 62 6C 65 5F 6D 61  l..test_table_ma
    70 5F 65 76|00|06|08 0F FC FC 11 04|06:28 00-02- p_ev.........(..
    02-00-04|3E|01 01 00 02 03 2D 02 3F D2 6C 87 D5  ...>.....-.?.l..
    ------------------------------------------------------------------

    packet length: 59
    call[1]: dump (line 224)
    call[2]: <module> (line 1)
    call[3]: _getval (line 1155)
    call[4]: do_p (line 1177)
    call[5]: onecmd (line 217)
    call[6]: onecmd (line 418)
    ------------------------------------------------------------------
    00 B1 5D 51 61 13 01 00 00 00 3A 00 00 00 3D 06  ..]Qa.....:...=.
    00 00 00 00 F9 A8 00 00 00 00 01 00 04|77 69 6C  .............wil
    6C|00|03|62 69 6E|00|03|08 FE 0F|04:FE 01-0A 00| l..bin..........
    06|01 01 00 02 01 3F 2B A6 38 A2                 ......?+.8.
    ------------------------------------------------------------------

## parse packet

https://dev.mysql.com/doc/internals/en/com-query-response.html#packet-Protocol::MYSQL_TYPE_STRING 보고 pymysql / pymysqlreplication에 추가

| field length  | field name        | field value |
| ------------- | ----------------- | ----------- |
| 6             | table id          | 43224 |
| 2             | flags             | 1 |
| string(4)     | schema            | will |
| string(17)    | table name        | test_table_map_ev |
| lenencint     | column count      | 06 |
| column count  | column-def        | LONGLONG, VARCHAR, BLOB, BLOB, TIMESTAMP2, FLOAT |
| lenenc-str(6: 0, 2, 1, 1, 1, 1)| column-meta-def   |  |
| 1             | NULL-bitmask      | 3E = 111110 역순 |

| field length  | field name        | field value |
| ------------- | ----------------- | ----------- |
| 6             | table id          | 43224 |
| 2             | flags             | 1 |
| string(4)     | schema            | will |
| string(3)     | table name        | bin |
| lenencint     | column count      | 03 |
| column count  | column-def        | LONGLONG, STRING, VARCHAR |
| lenenc-str(4: 0, 2, 2)| column-meta-def   |  |
| 1             | NULL-bitmask      | 6 = 110 역순 |

### parse reference
rows_event.cpp:Table_map_event::Table_map_event()
log_event.cc:Table_map_log_event::Table_map_log_event()

### meta length for each column type
https://dev.mysql.com/doc/internals/en/table-map-event.html (outdated)
https://github.com/mysql/mysql-server/blob/beb865a960b9a8a16cf999c323e46c5b0c67f21f/sql/log_event.cc#L11305-L11453

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




# information on columns
## TableMapEvent
[..., 'column_count', 'column_schemas', 'columns', ...]

### column_schemas: List[Dict]
COLUMN_NAME
COLLATION_NAME
CHARACTER_SET_NAME
COLUMN_COMMENT
COLUMN_TYPE
COLUMN_KEY
ORDINAL_POSITION

### columns: List[Column]
[..., 'character_set_name', 'collation_name', 'comment', 'data', 'is_primary', 'name', 'serializable_data', 'type', 'type_is_bool', 'unsigned', 'zerofill'], ...]

## WriteRowsEvent
[..., 'columns', 'columns_present_bitmap', 'number_of_columns', ...]

## 