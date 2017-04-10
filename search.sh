#!/bin/bash
curl -XGET $1:9200/mydouglas/logs/$2?pretty
