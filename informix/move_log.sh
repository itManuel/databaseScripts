#!/bin/ksh
: '
Copyright (c) Manuel Fernando Aller 2013 All Rights Reserved.
move_log.sh
Move the given DB server message log

'

# Set timestamp
DAY="`date '+%a'`"
DATESTAMP="`date '+%Y%m%d'`"

# Check parameters
PROG="`basename $0`"
if [ $# -gt 1 ]
then
	echo "Usage: $PROG [dbserver]"
	exit 2
fi

# Set environment
. /usr/dba/environ/common_env
DBSERV="$1"
if [ "X$DBSERV" = "X" ]
then
	DBSERV="$INFORMIXSERVER"
else
	. /usr/dba/environ/$DBSERV.env
fi

# Get config file name
CONFIG="${INFORMIXDIR:-/usr/informix}/etc/${ONCONFIG:-onconfig}"
if [ ! -r ${CONFIG} ]
then
	echo "$PROG: Cannot locate onconfig file '$CONFIG'!"
	exit 1
fi

# Set file name details
set X `grep ^MSGPATH ${CONFIG}`
shift
MSGDIR="`dirname $2`"
MSGLOG="`basename $2`"
ARCDIR="$MSGDIR/OLDLOGS"

# Check directory exists
if [ ! -d ${ARCDIR} ]
then
	if mkdir ${ARCDIR}
	then
		ln -s ${MSGDIR}/${MSGLOG} ${ARCDIR}/${MSGLOG}.current
	else
		echo "$PROG: Cannot create directory ${ARCDIR}!"
		exit 1
	fi
fi

# Archive message log
mv ${MSGDIR}/${MSGLOG} ${ARCDIR}/${MSGLOG}.${DATESTAMP}.${DAY}
touch ${MSGDIR}/${MSGLOG}

# Check message log for events
/usr/dba/cronscripts/check_msglog.sh -d ${DBSERV} -l ${ARCDIR}/${MSGLOG}.${DATESTAMP}.${DAY}

# Compress message log archive
gzip ${ARCDIR}/${MSGLOG}.${DATESTAMP}.${DAY}
