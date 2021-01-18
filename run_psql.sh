#!/bin/bash

PG_USER=postgres
PG_DATABASE=postgres
GUEST_SQL_DIR=/var/sql

CID=`docker ps -a | grep postgres | awk '{print $1}'`
echo CID: $CID

ARG1=$1

docker exec -it $CID \
	psql -U $PG_USER -f $GUEST_SQL_DIR/$ARG1.sql
