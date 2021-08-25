---
title: pymysqlreplication-test-broken-datetime
key: dong-pymysqlreplication-test-broken-datetime
tags: 
---
/usr/local/lib64/python3.6/site-packages/pymysql/err.py(143)  
raise errorclass(errno, errval)

/usr/local/lib64/python3.6/site-packages/pymysql/protocol.py(221)raise_for_error()  
-> err.raise_mysql_exception(self._data)

/usr/local/lib64/python3.6/site-packages/pymysql/connections.py(725)_read_packet()  
-> packet.raise_for_error()

/usr/local/lib64/python3.6/site-packages/pymysql/connections.py(1156)read()  
-> first_packet = self.connection._read_packet()

/usr/local/lib64/python3.6/site-packages/pymysql/connections.py(775)_read_query_result()  
-> result.read()

/usr/local/lib64/python3.6/site-packages/pymysql/connections.py(548)query()  
-> self._affected_rows = self._read_query_result(unbuffered=unbuffered)

/usr/local/lib64/python3.6/site-packages/pymysql/cursors.py(310)_query()  
-> conn.query(q)  
"INSERT INTO test VALUES('2013-00-00 00:00:00')"  

/usr/local/lib64/python3.6/site-packages/pymysql/cursors.py(148)execute()
-> result = self._query(query)
"INSERT INTO test VALUES('2013-00-00 00:00:00')"

/home/deploy/python-mysql-replication/pymysqlreplication/tests/base.py(84)execute()
-> c.execute(query)
"INSERT INTO test VALUES('2013-00-00 00:00:00')"