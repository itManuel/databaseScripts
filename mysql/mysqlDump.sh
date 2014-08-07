#!/bin/sh
# script para full backup de mysql y guardar sólo N dias hacia atras

DB_HOST=capstan-master-db.cg1e3xqngvlk.us-east-1.rds.amazonaws.com
BACKUP_DIR=/opt/capstan/backups
ARCHIVE_DAYS=60

# Backup the DB

/usr/bin/mysqldump -u root --all-databases --routines | gzip > $BACKUP_DIR/$(/bin/hostname)-$(date +%Y-%m-%d).mysqldump.gz
EXITVALUE=$?
# Eliminate old backup files
find $BACKUP_DIR -name "capstan*" -mtime +$ARCHIVE_DAYS -exec rm {} \; >/dev/null 2>&1

exit 0

