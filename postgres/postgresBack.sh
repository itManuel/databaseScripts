#!/bin/bash
LOCK=/tmp/backup_lock
MAIL=/tmp/$$_backup

ORIGEN=$1
DB_ORIGEN=$2
DESTINO=$3
DB_DESTINO=$4

until [ ${ORIGEN} ]; do
  echo "Servidor de origen: "
  read ORIGEN
done

until [ ${DB_ORIGEN} ]; do
  echo "BD de origen: "
  read DB_ORIGEN
done

until [ ${DESTINO} ]; do
  echo "Servidor destino: "
  read DESTINO
done

until [ ${DB_DESTINO} ]; do
  echo "BD destino: "
  read DB_DESTINO
done

USER=postgres
DIAS=7
SEMANAS=4
ARCHIVEDIR=/home/manuel/backups

############################################
SEMANAS=`echo $SEMANAS*7+1|bc`


if [ `date +%u` -eq 1 ]; then
	ARCHIVO=${ARCHIVEDIR}/LUN_${DB_ORIGEN}_`date +%Y%m%d_%H%M`.dump.sql
else
	ARCHIVO=${ARCHIVEDIR}/${DB_ORIGEN}_`date +%Y%m%d_%H%M`.dump.sql
fi

mandomail (){
	if [ -e $MAIL ]; then	
#		cat $MAIL |mailx -s 'Backup/restore script ${ORIGEN}:${DB_ORIGEN}' manuel.aller@infracoop.com.ar && \
#		rm $MAIL
		cat $MAIL && \
		rm $MAIL
	fi
}

if [ -e $LOCK ]; then
	echo "backup no puede comenzar, backup anterior no termino o se cancelo" >> $MAIL
	mandomail
	exit 1
else
	echo "backup started at `date`"> $LOCK
	cat $LOCK > $MAIL
fi

# dropear $DB_DESTINO_OLD y crear $DB_DESTINO vacia:
echo "DROP DATABASE IF EXISTS ${DB_DESTINO}_old" | psql -h $DESTINO -U $USER >> $MAIL 2>&1
echo "CREATE DATABASE ${DB_DESTINO}_2" |psql -h $DESTINO -U $USER >> $MAIL 2>&1

pg_dump -i -h $ORIGEN -p 5432 -U $USER -F c -b -v $DB_ORIGEN -f $ARCHIVO >> $MAIL 2>&1

if [ $? -eq 0 ]; then
	pg_restore -h $DESTINO -U $USER -d ${DB_DESTINO}_2 $ARCHIVO >> $MAIL 2>&1
else
	echo "problemas realizando el backup" >> $MAIL
	mandomail
	exit
fi

if [ $? -eq 0 ]; then
	echo "ALTER DATABASE ${DB_DESTINO} RENAME TO ${DB_DESTINO}_old" |psql -h $DESTINO -U $USER  >> $MAIL 2>&1
	echo "ALTER DATABASE ${DB_DESTINO}_2 RENAME TO ${DB_DESTINO}" |psql -h $DESTINO -U $USER  >> $MAIL 2>&1
else
	echo "backup fallo en dump o restore" >> $MAIL 2>&1
	mandomail
	exit 1
fi

if [ -e $LOCK ]; then
	rm $LOCK
fi
# borro dumps viejos
#find ${ARCHIVEDIR} -name '${DB_ORIGEN}_*dump.sql' -mtime +${DIAS} -exec rm {} \;
#find ${ARCHIVEDIR} -name 'LUN_${DB_ORIGEN}_*dump.sql' -mtime +${SEMANAS} -exec rm {} \;
find ${ARCHIVEDIR} -name '${DB_ORIGEN}_*dump.sql' -mtime +${DIAS} -exec ls -lh {} \;
find ${ARCHIVEDIR} -name 'LUN_${DB_ORIGEN}_*dump.sql' -mtime +${SEMANAS} -exec ls -lh {} \;
mandomail

