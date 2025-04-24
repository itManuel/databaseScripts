-----------------------------------------------------------------------------
-- dbscpace_free.sh script to run by cron
-- Based on previous work from: Lester Knutsen  Email: lester@advancedatatools.com
-- Discription:	check free space for a given dbspace, and warns if is less than given percentage
-----------------------------------------------------------------------------

MAILLIST='name@domain.com'
LIMITE=3

DBSPACE=$1
until [ $DBSPACE ]
do
	echo -n "Base de Datos: "
	read DBSPACE
done

#environment load:
. /path/to/env_file

PORCENTAJE=`dbaccess sysmaster 2> /dev/null << EOF
select round ((sum(nfree)) / (sum(chksize)) * 100, 2) -- percent_free
from  sysdbspaces d, syschunks c
where name='${DBSPACE}' and d.dbsnum = c.dbsnum
EOF`
PORCENTAJE=`echo $PORCENTAJE|awk '{print $2}'|sed 's/,/\./'`

ALARM=`awk "BEGIN {return_code=( ${PORCENTAJE} >= ${LIMITE} ) ? 0 : 1; exit} END {print return_code}"`
if [ $ALARM -eq 1 ]; then
        echo 'hay problemita'
else
        echo 'todo bien, ' $PORCENTAJE ' es mayor que '$LIMITE
fi

