---
title: extra-data
key: dong-extra-data
tags: MySQL 
---

# MySQL 서버 변경 사항 
## 요약
MySQL 8.0.16부터 rows_event에 파티션 정보 [추가](https://github.com/mysql/mysql-server/commit/e11a540fc559dfbed72ba4ec4677638ac917454f)
* rows_event: row 단위의 DML

## 세부 사항
### [rows_event 레이아웃](https://dev.mysql.com/doc/internals/en/rows-event.html)
1. header - body - row 구조 
2. header에 extra_data 필드 존재
<div class="mxgraph" style="max-width:100%;border:1px solid transparent;" data-mxgraph="{&quot;highlight&quot;:&quot;#0000ff&quot;,&quot;nav&quot;:true,&quot;zoom&quot;:1.5,&quot;resize&quot;:true,&quot;toolbar&quot;:&quot;zoom layers lightbox&quot;,&quot;edit&quot;:&quot;_blank&quot;,&quot;xml&quot;:&quot;&lt;mxfile host=\&quot;app.diagrams.net\&quot; modified=\&quot;2021-08-25T14:30:37.138Z\&quot; agent=\&quot;5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36\&quot; etag=\&quot;z0cjsk_M_8JAZ54fLbOn\&quot; version=\&quot;14.8.6\&quot; type=\&quot;github\&quot;&gt;&lt;diagram id=\&quot;M1M0mQ8qJxGyyTks0bcV\&quot; name=\&quot;Page-1\&quot;&gt;5Zhdb5swFIZ/DZeVAMckuWzTbtW07SbTeu2AA96MzYxJyH79DsGEUBM1kxpA6k1iv8efz7GPbRy0SsvPimTJNxlR7vhuVDro0fH9xRLDbyUcagHPjRArFtWS1wpr9pca0TVqwSKadwpqKblmWVcMpRA01B2NKCX33WJbybu9ZiSmlrAOCbfVFxbpxEwLu63+TFmcND17rrGkpClshDwhkdyfSejJQSslpa5TabmivGLXcKnrfbpgPQ1MUaGvqcB/7mYrFM+//CKL9fNL+f3H192daWVHeGEmbAarDw0BJQsR0aoR10EP+4Rpus5IWFn34HLQEp1yyHmQNM1RpWl5cZzeafawaqhMqVYHKFJ2PW8WjLc0+X2LHyGjJWfom3LEeDw+tdxCgYTh8h+McA+jgEOvD1sJUzqHFfwpZGO4y4+L+R4KeDgrWyOk4uo/oSSiqmkLhlY3VxstNwBQ3WWdayV/05XkUoEipKBVz4zzVxLhLBaQDcEB0B96qNzDYInfG0PKoqjqpte5XfcP49+gx73+rdwbWO7VZAM4jtXG3gx+F5bvYQuW5/fQwvhGtOYWrS0ncT46KA+/TWo2JKiFBQo2sCLNdt+oZqdHRPeonIoYxj02Vt+dGNblRawkraYvNnl2gjo2vCvW5GJIeE3ondJxj/Db58FJG+S89/ouRe9x4G8k3II/2nF/jX/7IsjNznvPt9wbSl6kwg7CmaI5PTrplWHDdAq4xt47s8kFmJnFVhTppr3ltgjl1tZqP4x/mUDB1Lj2vUFGhoSnF7jtq/z7BO7jZ4SPFriv8e+wgdt+e4iiqjWRaIwnFzXsN0id9N2+6EtJCA8Od8soH//hGwx3tEG2/Qp3tJ19ykRP/wA=&lt;/diagram&gt;&lt;/mxfile&gt;&quot;}"></div>
<script type="text/javascript" src="https://viewer.diagrams.net/js/viewer-static.min.js"></script>

### 변경 전 rows_event
extra data가 사용되고 있지 않는듯...

### 변경 후 rows_event
extra data에 [ndb info, partition id 추가](https://github.com/mysql/mysql-server/blob/beb865a960b9a8a16cf999c323e46c5b0c67f21f/libbinlogevents/include/rows_event.h#L772-L814)  
1. type이 NDB인 경우

        +----------+--------------------------------------+
        |type_code |        extra_row_ndb_info            |
        +--- ------+--------------------------------------+
        | NDB      |Len of ndb_info |Format |ndb_data     |
        | 1 byte   |1 byte          |1 byte |len - 2 byte |
        +----------+----------------+-------+-------------+

2. type이 partition인 경우

        INSERT/DELETE인 경우
        +-----------+----------------+
        | type_code | partition_info |
        +-----------+----------------+
        |   PART    |  partition_id  |
        | (1 byte)  |     2 byte     |
        +-----------+----------------+

        UPDATE인 경우
        +-----------+------------------------------------+
        | type_code |        partition_info              |
        +-----------+--------------+---------------------+
        |   PART    | partition_id | source_partition_id |
        | (1 byte)  |    2 byte    |       2 byte        |
        +-----------+--------------+---------------------+

# python-mysql-replication 이슈
## 요약
extra data가 존재함을 인지, 파싱 시도  
하지만 extra data의 길이를 잘못 계산하여 파싱 실패  

MySQL 8.0.15 이전에는 extra data 미사용으로 이슈 없었으나,  
MySQL 8.0.16 이후 partition table에 대해 파싱 이슈 발생  

## 세부 사항
### 잘못된 extra data 코드

        self.extra_data = self.packet.read(self.extra_data_length / 8) 

### 표준 extra data 코드 

        self.extra_data = self.packet.read(self.extra_data_length - 2)

## 라이브러리 수정 후 PR

        [Fix parsing of row events for MySQL8 partitioned table](https://github.com/noplay/python-mysql-replication/pull/355)