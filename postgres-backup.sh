#!/bin/sh

# set database password so that pg_dump util can connect to your server
export PGPASSWORD='password'

# create timestamped dumps of your database
pg_dump --host localhost --port 5432 --username postgres --dbname databasename  --verbose --format=c > "/home/backups/databasename-"`date +"%d-%m-%Y"`".dump"

# remove backups older than 7 days
find /home/backups -type f -mtime +7 -name '*.dump' -delete
