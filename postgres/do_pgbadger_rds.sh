#!/bin/bash
INSTANCE=$1
BASE=`pwd`

if [ ! -d ${INSTANCE} ]; then
	mkdir ${INSTANCE}
fi

for i in `aws rds describe-db-log-files --db-instance-identifier ${INSTANCE} --output text|awk '{print $3}'`; do
FILE=`basename ${i}`
if [ ! -e ${INSTANCE}/${FILE} ]; then
	aws rds download-db-log-file-portion --db-instance-identifier ${INSTANCE} --log-file-name ${i} --output text > ${INSTANCE}/${FILE}
fi

done

pgbadger -I --outdir=${BASE}/${INSTANCE} -p '%t:%r:%u@%d:[%p]:' ${INSTANCE}/postgres*

