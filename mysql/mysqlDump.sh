#!/bin/sh
# script para full backup de mysql y guardar sólo N dias hacia atras

DB_HOST=yourDBhost
BACKUP_DIR=/path/to/db_backups
ARCHIVE_DAYS=60

# Backup the DB

/usr/bin/mysqldump -u root --all-databases --routines | gzip > $BACKUP_DIR/$(/bin/hostname)-$(date +%Y-%m-%d).mysqldump.gz
EXITVALUE=$?
# Eliminate old backup files
find $BACKUP_DIR -name "*mysqldump.gz" -mtime +$ARCHIVE_DAYS -exec rm {} \; >/dev/null 2>&1

exit 0

