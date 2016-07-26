#!/bin/bash

#si nunca nadie la vio:
#SQL="select schemaname||'.'||relname from pg_stat_user_tables where last_vacuum is null AND last_autovacuum is null AND last_analyze is null AND last_autoanalyze is null limit 1;"
DATABASE=$1

SQL="select schemaname||'.'||relname from pg_stat_user_tables where 
(last_vacuum is null or last_vacuum < now() -interval '7 day') 
AND 
(last_autovacuum is null or last_autovacuum < now() -interval '7 day')
AND 
(last_analyze is null or last_analyze < now() -interval '7 day')
AND 
(last_autoanalyze is null or last_autoanalyze < now() -interval '7 day')
limit 1;"

TABLE=`psql $DATABASE -t -c "$SQL"`

echo $TABLE
if [ "X${TABLE}" == "X" ]; then
	echo 'nothing to do'
else
	echo "ready to vacuum ${TABLE}? (S/N)"
	read a
	if [ $a -eq "S" ]; then
		vacuumdb -d $DATABASE -t $TABLE -z
	else
		if [ $a -eq "s" ]; then
			vacuumdb -d $DATABASE -t $TABLE -z
		fi
	fi
fi

