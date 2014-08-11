#!/bin/ksh

# Display usage message
usage()
{
echo "Usage: `basename $0` -d dbserver_name [-l logfile]"
if [ "X$1" = "X-?" -o "X$1" = "X--" ]
then
	echo "-d Display message log events for dbserver_name"
	echo "-l Display events from logfile (default=$MSGLOG)"
fi
}

# Set environment
. /usr/dba/environ/common_env
DBS="$INFORMIXSERVER"
if [ -r /usr/dba/environ/$DBS.env ]
then
	. /usr/dba/environ/$DBS.env
fi

# Set up defaults
PROG="`basename $0 .sh`"
LOG="/tmp/${PROG}.$$"
HOST="`hostname`"
MAILLIST="you@yourdomain.com"
#DBSERVERNAME="`onstat -c 2>/dev/null |grep ^DBSERVERNAME |awk '{print $2}'`"
MSGLOG="`onstat -c 2>/dev/null |grep '^MSGPATH' |awk '{print $2}'`"

# Check parameters
while [ $# -gt 0 ]
do
	case $1 in
		-d*)    # DBserver name
		if [ "X$1" = "X-d" ]
		then
			case $2 in
				-*|'')
				echo "Please supply a DBserver name!"
				exit 2
				;;

				*)
				DBS="$2"
				shift
				;;
			esac
		else
			DBS="`echo $1 |sed -e 's,-d,,'`"
		fi
		;;

		-l*)    # Log file name
		if [ "X$1" = "X-l" ]
		then
			case $2 in
				-*|'')
				echo "Please supply a database message log file name!"
				exit 2
				;;

				*)
				MSGLOG="$2"
				shift
				;;
			esac
		else
			MSGLOG="`echo $1 |sed -e 's,-l,,'`"
		fi
		;;

		*)
		usage $1
		exit 2
		;;
	esac
	shift
done

# Check dbserver name
if [ "X$DBS" = "X" ]
then
	echo "Please supply a DBServer name!" >&2
	exit 2
fi

# Set environment
if [ -r /usr/dba/environ/$DBS.env ]
then
	. /usr/dba/environ/$DBS.env
fi

# Check message log file name
if [ "X$MSGLOG" = "X" ]
then
	MSGLOG="`onstat -c 2>/dev/null |grep '^MSGPATH' |awk '{print $2}'`"
	if [ "X$MSGLOG" = "X" ]
	then
		echo "Please supply a message log file name!" >&2
		exit 2
	fi
fi

# Check we are running on the Primary
onstat - >/dev/null 2>&1
if [ $? -eq 5 ]
then
	TYPE="Primary"
else
	TYPE="Secondary"
fi
								
# Set known events to ignore
IGNORE="^$"
IGNORE="$IGNORE|Archive started"
IGNORE="$IGNORE|Archive .* Completed."
IGNORE="$IGNORE|Logical Log .* Complete"
IGNORE="$IGNORE|Logical Log .* Backup"
IGNORE="$IGNORE|Checkpoint Completed:"
IGNORE="$IGNORE|Checkpoint Statistics"
IGNORE="$IGNORE|loguniq .* logpos .* timestamp"
IGNORE="$IGNORE|Maximum server connections"
IGNORE="$IGNORE|Booting Language"
IGNORE="$IGNORE|Loading Module"
IGNORE="$IGNORE|DR: Sending index"

LEVEL=0
if [ $LEVEL -ge 2 ]
then
	IGNORE="$IGNORE|password .* the database server"
	IGNORE="$IGNORE|Password Validation .* failed"
	IGNORE="$IGNORE|Check for password aging/account lock-out"
fi

# Set viewer command
case $MSGLOG in
	*.gz)
	CMD="gzcat"
	;;

	*.Z)
	CMD="zcat"
	;;

	*)
	CMD="cat"
	;;
esac

# Extract message log events
$CMD ${MSGLOG} |egrep -v "${IGNORE}" >$LOG
EVENTS="`grep -v '^[A-Z].. .* [0-9][0-9][0-9][0-9]$' $LOG |wc -l`"
EVENTS="`echo $EVENTS`"		# Remove leading spaces

# Set subject
DATE="`date '+%d/%m/%Y'`"
SUBJECT="${DBS} - $TYPE Message Log events for $DATE"
if [ 0$EVENTS -gt 0 ]
then
	BODY="Please review the following events found in the database message log for ${DBS}:"
	SUBJECT="${SUBJECT}*"
else
	BODY="There were no events found in the database message log for ${DBS}:"
fi

# Mail events report
(echo "${BODY}"
echo ""

cat $LOG
echo "") |mailx -s "Events: ${SUBJECT}" $MAILLIST <${MAILLOG}

# Remoce log file
rm -f $LOG
