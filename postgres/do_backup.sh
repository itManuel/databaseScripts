#!/bin/sh
#
# simple database script for backup a single database
#
DB_NAME=database
HOST_NAME=`uname -n`
BACKUP_DIR=/DATA/backups
ARCHIVE_DAYS=20

/usr/bin/logger -t postgres-backup "backup started"

/usr/bin/pg_dump -c -b $DB_NAME |gzip > ${BACKUP_DIR}/${HOST_NAME}-${DB_NAME}-$(date +%Y-%m-%d).psql.gz
EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
	/usr/bin/logger -t postgres-backup-alert "ALERT exited abnormally with [$EXITVALUE]"
fi
/usr/bin/logger -t postgres-backup "backup ended"

find $BACKUP_DIR -name "*${DB_NAME}*" -mtime +$ARCHIVE_DAYS -exec rm {} \; > /dev/null 2>&1

