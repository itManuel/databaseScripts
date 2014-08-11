#!/bin/ksh
: '
Copyright (c) Manuel Fernando Aller 2013 All Rights Reserved.
check_audit.sh

'

get_sec()
{
# Check for secondary
set X `${INFORMIXDIR:-/usr/informix}/bin/onstat -g dri |grep primary`
shift
if [ "X$2" = "Xon" ]
then
# Get the secondary dbserver
        SECDBS="$3"

# Check if we can use the HDR NIC
        set X `grep ^${SECDBS} /INFORMIX/BACKUP/backup_nic.lst 2>/dev/null`
        if [ "X$3" = "X" ]
        then
# Get HDR NIC hostname
                set X `grep ^${SECDBS} ${INFORMIXSQLHOSTS:-${INFORMIXDIR:-/usr/informix}/etc/sqlhosts}`
                shift
        fi
        HDRPAIR="$3"
else
        HDRPAIR=""
fi
}

# Check parameters
PROG="`basename $0`"
if [ $# -ne 1 ]
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
get_sec

# Set usage description
case $DBSERV in
	prddbs01v2)
	USAGE="Live Site Product/SKU/Customer data"
	;;

	prdebasket)
	USAGE="Live Site Ebasket, upl, ops data"
	;;

	*reporting)
	USAGE="Corporate reporting, Nastya data, Archive data"
	;;
esac

# Set DBSERVERNAME
DBSERVERNAME="`onstat -c 2>/dev/null |grep ^DBSERVERNAME |awk '{print $2}'`"
				
# Check we are running on the Primary
onstat - >/dev/null 2>&1
if [ $? -ne 5 ]
then
#	echo "Run Against Primary Only!"
	exit 3
fi
								
# Check auditing details
AUDITING="Y"
AUDITDIR="`onaudit -c 2>/dev/null |grep ADTPATH |awk '{print $3}'`"
ADTMODE="`onaudit -c 2>/dev/null |grep ADTMODE |awk '{print $3}'`"
case ${ADTMODE} in
	1|3|5|7)
	;;

	*)
	AUDITING="N"
	;;
esac

# Set defaults
HOSTNAME="`hostname`"
DBALIST="mstock|ptorking|arepossi|lrado"
MAILLIST="LMN-DBA-INFORMIX-ALERT@lastminute.com"
#H="24"		# Hours in a day (Doesnt work for 7 days)
H="239 / 10"	# Hours in a day
D="7"		# Days in a week
IGNORE="^$"
IGNORE="$IGNORE|Archive started"
IGNORE="$IGNORE|Archive .* Completed."
IGNORE="$IGNORE|Logical Log .* Complete"
IGNORE="$IGNORE|Logical Log .* Backup"
IGNORE="$IGNORE|Checkpoint Completed:"
IGNORE="$IGNORE|Checkpoint loguniq"
IGNORE="$IGNORE|Maximum server connections"
IGNORE="$IGNORE|Booting Language"
IGNORE="$IGNORE|Loading Module"
IGNORE="$IGNORE|DR: Sending index"

set X `onstat -c |grep "^MSGPATH"`
shift
MSGLOG="$2"
MSGDIR="`dirname $MSGLOG`"

# Set dates we need
TARFILE="check_audit.logs.`date '+%Y%m%d'`.tar"
SUFILE="check_su.logs.`date '+%Y%m%d'`"
DBSPACEFILE="check_dbspace.logs.`date '+%Y%m%d'`"
NO=1
DATE=""
DATE2=""
SUDATE=""
LOGDATE=""
DELIM=""
while [ $NO -le $D ]
do
# Build the grep string
	SHIFT=`expr $H \* $NO`
	TZ="GMT+$SHIFT"
	DATE="${DATE}${DELIM}`date '+%Y-%m-%d'`|`date '+%d\/%m\/%Y'`"
	SUDATE="${SUDATE}${DELIM}`date '+%m\/%d'`"
	LOGDATE="${LOGDATE} online.*`date '+%Y%m%d'`*"

# Set last date
	if [ "X$DATE2" = "X" ]
	then
		DATE2="`date '+%d/%m/%Y'`"
	fi

# Increment counter & set delimiter
	NO=`expr $NO + 1`
	DELIM="|"
done
# Set first date
DATE1="`date '+%d/%m/%Y'`"

# Set meeting date
TZ=GMT0
TZ=GMT-96
MEETDATE="`date '+%Y-%m-%d'`"
MINDATE="`date '+%Y%m%d'`"
# Put time back to normal :-)
TZ="GMT0"

SUBJECT="${DBSERV} - Log review & failed operations for $DATE1 - $DATE2"
MAILLOG="/INFORMIX/AUDIT/check_audit.email.`date '+%Y%m%d'`"

(echo "Please review the following access failures and events for ${DBSERV}."
echo ""
#echo "Cut&Paste the following details where shown, to the Service Delivery Meeting Minutes at:"
echo "Cut&Paste the following details where shown, to the Database Meeting Minutes at:"
echo ""
#echo "        http://twiki.lastminute.com/twiki/bin/view/SarbOx/ServiceDeliveryMinutes${MEETDATE}"
#echo "        http://twiki.lastminute.com/twiki/bin/view/SarbOx/DBALogsReview${MEETDATE}"
echo "        http://twiki.lastminute.com/twiki/bin/view/Database/DbMeetingMinutes${MINDATE}"
echo ""
echo "        1. Replace Name_of_DBA with your name."
echo "        2. Review the weeks message log events emails and note any exceptions."
echo "        3. Review the weeks audit log exceptions below and note any HD numbers raised."
echo "        4. Review the weeks SU log exceptions below and note any HD numbers raised."
echo "        5. Make comments about scheduled migrations, upgrades, etc."
echo "        6. Make comments about significant incidents/changes including HD/CHG numbers raised."

echo ""
echo ""
echo "-v-Cut Here-v-------------------------------------------------------------------"
echo "---+++Informix"
echo "---++++${DBSERV} - ${USAGE}"
echo "   * $HOSTNAME"
#dbdf -k -t |awk '{print substr($0,11)}' |sed -e 's,^,   * =,' -e 's,$,=,'
dbdf -k -t |awk '{print substr($0,11)}' >${AUDITDIR}/$DBSPACEFILE
sed -e 's,^,   * =,' -e 's,$,=,' ${AUDITDIR}/$DBSPACEFILE
#echo "   * =Usage                           ?               -?="
grep Total `ls ${AUDITDIR}/check_dbspace.logs.* |tail -2` |while read T S F P
do
	if [ 0$STOT -gt 0 ]
	then
		STOT=`expr $S - $STOT`
		FTOT=`expr $F - $FTOT`
		printf "   * =Usage                  %10d       %10d=\n" $STOT $FTOT
	else
		STOT=$S
		FTOT=$F
	fi
done

echo ""
echo "---+++++Logs"
echo "   * Reviewed on $MEETDATE"
echo "   * Reviewed by Name_of_DBA &AMP; Mark Stock"

if [ "X$AUDITING" = "XN" ]
then
	echo "   * Auditing is not enabled - due to performance issues caused by logging. "
	echo "   * Logged as an exception"
else
# Move to audit directory
	cd ${AUDITDIR}

# Get log file names for these dates
	LOGFILES=`egrep -l "$DATE" ${DBSERVERNAME}.*[0-9]`

# Get audited failures for these dates
	if [ -n "${LOGFILES}" ]
	then
		echo "   * Logs located at $HOSTNAME:${AUDITDIR}/${TARFILE}.gz"
		echo ""
		echo "   * Exceptions:"
		echo '   | *No.* |*Date*      |*Server*     |*DBServ* |*User*  | *Err*|*Code* |*DB* | *ID*|*Name* |'
		# Add "*Grantor* |*Grantee* |*Permission* |" for GR Codes

# Format audited failures for these dates
		egrep "$DATE" ${LOGFILES} |\
			grep -v "|0:[A-Z][A-Z][A-Z][A-Z]:" |\
			awk -F\| '{print $2,$3,$4,$5,$6,$7,$8}' |\
			sed -e 's,\(.*\)\/\(.*\)\/\(.*\) [0-9][0-9]:,\3-\2-\1 ,' |\
			awk '{print "|"$1"|"$3"|"$5"|"$6"|"$7"|"$8}' |\
			sed -e 's,:,|,g' |\
			sort |\
			uniq -c |\
			sed -e 's,^,   |,'

# Create a tar file of the relevant logs ready for email
		tar cf ${TARFILE} ${LOGFILES}
		gzip -f ${TARFILE}
	else
		echo "Could not find any audit logs for this date period!"
	fi
fi

# Format su exceptions for these dates
echo ""
echo "---+++++SU Logs"
echo "   * Reviewed on $MEETDATE"
echo "   * Reviewed by Name_of_DBA &AMP; Mark Stock"
echo "   * Logs located at $HOSTNAME:${AUDITDIR}/${SUFILE}P.gz"
if [ "X$HDRPAIR" != "X" ]
then
	echo "   * Logs located at $HOSTNAME:${AUDITDIR}/${SUFILE}S.gz"
fi

egrep "$SUDATE" /var/adm/sulog |\
	grep "\-informix" \
	>${AUDITDIR}/${SUFILE}P

NO=0
echo ""
echo "   * `hostname`:"
awk '{print $2,$6}' ${AUDITDIR}/${SUFILE}P |\
	egrep -v "$DBALIST" |\
	sort |\
	uniq -c |\
	awk '{print "|"$1"|"$2"|"$3"|"}' |\
	while read LINE
	do
		if [ $NO -eq 0 ]
		then
			NO=1
			echo "      * Exceptions:"
			echo "      |No.|Date|from-to|"
		fi
		echo "      $LINE"
	done

if [ $NO -eq 0 ]
then
	echo "      * No exceptions to report"
fi

if [ "X$HDRPAIR" != "X" ]
then
	NO=0
	echo ""
	echo "   * $HDRPAIR:"
	ssh $HDRPAIR "egrep '$SUDATE' /var/adm/sulog" |\
		grep "\-informix" \
		>${AUDITDIR}/${SUFILE}S

	awk '{print $2,$6}' ${AUDITDIR}/${SUFILE}S |\
		egrep -v "$DBALIST" |\
		sort |\
		uniq -c |\
		awk '{print "|"$1"|"$2"|"$3"|"}' |\
		while read LINE
		do
			if [ $NO -eq 0 ]
			then
				NO=1
				echo "      * Exceptions:"
				echo "      |No.|Date|from-to|"
			fi
			echo "      $LINE"
		done

	if [ $NO -eq 0 ]
	then
		echo "      * No exceptions to report"
	fi
fi

echo ""
gzip -f ${AUDITDIR}/${SUFILE}?

echo "---+++++Comments:"
echo "   * [%X%Scheduled migrations, upgrades, etc]"
echo "   * [%X%Significant incidents/changes including HD/CHG number]"
echo ""

#cd $MSGDIR/OLDLOGS
#for LOG in `ls -rt $LOGDATE 2>/dev/null`
#do
#	case $LOG in
#		*.gz)
#		CMD="gzcat"
#		;;
#
#		*.Z)
#		CMD="zcat"
#		;;
#
#		*)
#		CMD="cat"
#		;;
#	esac
#
#	$CMD ${LOG} |egrep -v "${IGNORE}" |sed -e 's,^,   * ,'
#done
#echo ""
echo "-^-Cut Here-^-------------------------------------------------------------------") >${MAILLOG}

# Mail failures report
mailx -s "Audit: ${SUBJECT}" $MAILLIST <${MAILLOG}
#less ${MAILLOG}
