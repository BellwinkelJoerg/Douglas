# Douglas

Files:
README.md 
RunHTTPLog.pl 
createIndex.sh 
search.sh  

Vorraussetzungen:

Um die Scripte zu nutzen, ist es notwendig das sowohl ein Apache Webserver als auch ein ElasticSearch auf einem Linuxserver installiert sind. Dieser Server muss durch eine IP-Adresse erreichbar sein. 


How To:

1. Index in ElasticSearch erstellen

Um einen entsprechenden Index in ElasticSearch zu erstellen ist das Script createIndex.sh notwendig. Als einziges Argument ist die IP-Adresse 

./createIndex.sh 192.168.1.XXX

2. 

To initialize the ElasticSearch database you can use the shell script: createIndex.sh XXX.XXX.XXX.XXX
The argument is the target IP Adress of the Server which runs the ElasticSearch database with port 9200.

If you are running an apache webserver and also get logfiles from this service, you can run the perl script RunHTTPLog.pl with some arguments to get the percentage of HTTP 200 responses written into the ElasticSearch database. If you did not use any arguments, the script will give an output with an example usage.

With the script search.sh you can search in the ElasticSearch database for the written entries.



How to
======

1. ./createIndex.sh http://192.168.99.100:32806 # pass whole url and port in
2. ES_SERVER=http://192.168.99.100:32806 perl RunHTTPLog.pl '09/Apr/2017:20:21:22' '12/Apr/2017:20:28:29' access.log 10  # Use environment variable instead of hardcoding (or use script arg but this is more descriptive)
3. ./search.sh http://192.168.99.100:32806 _search   # Lacked documentation on how to use this but added this