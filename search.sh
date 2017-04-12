#!/bin/bash
#
# Usage: ./search.sh http://192.168.99.100:32806 _search
#
echo $1/mydouglas/logs/$2?pretty
curl -XGET $1/mydouglas/logs/$2?pretty
