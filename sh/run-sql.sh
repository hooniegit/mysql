#!/bin/bash

# run 'chmod +x run-sql.sh'
# ./run-sql.sh <username> <database> </path/to/sql/file>/<filename>.sql

username=$1
database=$2
sql_file=$3

mysql -u $username -p $database < $sql_file