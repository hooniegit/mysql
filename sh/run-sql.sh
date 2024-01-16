#!/bin/bash

# run 'chmod +x run-sql.sh'
# ./run-sql.sh <host> <username> <database> </path/to/sql/file>/<filename>.sql

host=$1
username=$2
database=$3
sql_file=$4

mysql -h $host -u $username -p $database < $sql_file
