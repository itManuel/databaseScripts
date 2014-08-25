#!/bin/bash
# script to do a full basebackup in old pg versions
BACKUPDIR=/var/lib/pgsql
SERVER=192.168.210.50
BKPUSER=postgres
DATE=`date +%Y%m%d`

echo "SELECT pg_start_backup('bkp$(date +%Y%m%d)');"  | psql -h $SERVER -U $BKPUSER
if [ $? != 0 ]; then
	echo 'error backing up'
	exit 1
fi
sleep 1
(cd $BACKUPDIR ; rm data ; rsync -av $SERVER:/var/lib/pgsql/data $DATE ; ln -s ${DATE}/data data )
if [ $? != 0 ]; then
	echo 'error backing up'
	exit 1
fi

sleep 1

echo "SELECT pg_stop_backup();"  | psql -h $SERVER -U $BKPUSER
if [ $? != 0 ]; then
	echo 'error backing up'
	exit 1
fi
