#!/bin/bash

curl -XPUT $1:9200/mydouglas -d '
{
    "settings" : {
        "index" : {
            "number_of_shards" : 10,
            "number_of_replicas" : 1
        }
    }
}
'


curl -XPUT $1:9200/mystackoverflow/_mapping/logs -d '
{
    "properties": {
        "start_date": {
            "type": "string",
            "analyzer": "standard"
        },
        "end_date": {
            "type": "string",
            "analyzer": "standard"
        },
        "count_total": {
            "type": "string",
            "analyzer": "standard"
        },
        "count_200": {
            "type": "string",
            "analyzer": "english"
        },
        "percentage" : {
            "type" : "string",
            "index":    "not_analyzed"
        },
        "created_at": {
            "type": "date",
            "format": "date_hour_minute_second_millis"
        }
    }
}
'
