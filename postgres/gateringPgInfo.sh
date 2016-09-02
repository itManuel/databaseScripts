#!/bin/bash
# postgresql data collector(c) Manuel Fernando Aller
# script para analizar lo que pasó en pg y refrescar las estadísticas. Correr una vez por día.

DB_LIST='gps desptaxis'
MAIL='manuel.aller@gmail.com'
LOCK=/tmp/gathering_info_pg


if [ -e $LOCK ]; then
	/usr/bin/logger -t postgres "ERROR: gatering info script failed to run. Still running or another script died before done"
	exit 1;
else
	touch $LOCK
	/usr/bin/logger -t postgres "INFO: start gathering info about pg health"
fi

# lo que pasó en el día

for DB_NAME in $DB_LIST; do 
echo "SELECT numbackends as CONN, xact_commit as TX_COMM, xact_rollback as TX_RLBCK, blks_read + blks_hit as READ_TOTAL, 
blks_hit * 100 / (blks_read + blks_hit) as BUFFER
FROM pg_stat_database
WHERE datname = '$DB_NAME' ;" |psql > /tmp/${DB_NAME}_stats1; done


# TOP 5 índices sin uso (ordenados por tamaño de índice)
for DB_NAME in $DB_LIST; do 
echo "select 
  s.schemaname as sch, 
  s.relname as rel, 
  s.indexrelname as idx, 
  s.idx_scan as scans, 
  pg_size_pretty(pg_relation_size(s.relid)) as ts, 
  pg_size_pretty(pg_relation_size(s.indexrelid)) as "is" 
from 
  pg_stat_user_indexes s 
  join pg_index i on i.indexrelid=s.indexrelid 
  left join pg_constraint c on i.indrelid=c.conrelid 
  and array_to_string(i.indkey, ' ') = array_to_string(c.conkey, ' ') 
where 
  i.indisunique is false and 
  --pg_relation_size(s.relid) > 1000000 and 
  s.idx_scan < 100000 and c.confrelid is null 
order by 
  s.idx_scan asc, pg_relation_size(s.relid) desc
limit 5"|psql $DB_NAME > /tmp/${DB_NAME}_stats2; done

# buffer hit:
for DB_NAME in $DB_LIST; do 
echo "SELECT 
  sum(heap_blks_read) as heap_read,
  sum(heap_blks_hit)  as heap_hit,
  sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) as ratio
FROM 
  pg_statio_user_tables;"|psql $DB_NAME > /tmp/${DB_NAME}_stats3; done

# index cache hit:
for DB_NAME in $DB_LIST; do 
echo "SELECT 
  sum(idx_blks_read) as idx_read,
  sum(idx_blks_hit)  as idx_hit,
  (sum(idx_blks_hit) - sum(idx_blks_read)) / sum(idx_blks_hit) as ratio
FROM 
  pg_statio_user_indexes;"|psql $DB_NAME > /tmp/${DB_NAME}_stats4; done

# reset stats:
for DB_NAME in $DB_LIST; do 
echo "select * from pg_stat_reset();"|psql $DB_NAME > /tmp/${DB_NAME}_stats5; done

# armo el mail:
for DB_NAME in $DB_LIST; do 
echo ${DB_NAME} > /tmp/${DB_NAME}_REPORT
echo "---------------------------------" >> /tmp/${DB_NAME}_REPORT
cat /tmp/${DB_NAME}_stats1 >> /tmp/${DB_NAME}_REPORT && rm /tmp/${DB_NAME}_stats1
cat /tmp/${DB_NAME}_stats2 >> /tmp/${DB_NAME}_REPORT && rm /tmp/${DB_NAME}_stats2
cat /tmp/${DB_NAME}_stats3 >> /tmp/${DB_NAME}_REPORT && rm /tmp/${DB_NAME}_stats3
cat /tmp/${DB_NAME}_stats4 >> /tmp/${DB_NAME}_REPORT && rm /tmp/${DB_NAME}_stats4
cat /tmp/${DB_NAME}_stats5 >> /tmp/${DB_NAME}_REPORT && rm /tmp/${DB_NAME}_stats5
done

for DB_NAME in $DB_LIST; do
cat /tmp/${DB_NAME}_REPORT >> /tmp/pg_mailer_report && rm /tmp/${DB_NAME}_REPORT
done
cat /tmp/pg_mailer_report | mail -s 'reporte status' $MAIL

rm $LOCK
if [ $? -eq 0 ]; then
	/usr/bin/logger -t postgres "INFO: end gathering info about pg health"
fi
