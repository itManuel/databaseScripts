#!/bin/bash

# guarda una fecha en el master, y en el slave la compara contra 'current_timestamp'
# muestra la cantidad de segundos de diferencia

# armo el sql de update:
if [ $0 -eq 'M' ]; then
DATE=`/bin/date +'%Y-%m-%d %H:%M:%S'`

echo "update replica_times set fecha_text='${DATE}';" |psql postgres

else
LOGFILE=/tmp/check_replica_$$
# armo el sql del slave:
echo "select date_part('seconds',age(current_timestamp,fecha_text))+60*date_part('minute',age(current_timestamp,fecha_text))+3600*date_part('hour',age(current_timestamp,fecha_text))+86400*date_part('days',age(current_timestamp,fecha_text)) as seconds from replica_times ;" |psql postgres |head -3 |tail -1 > $LOGFILE

sort $LOGFILE|bc
rm $LOGFILE

fi
