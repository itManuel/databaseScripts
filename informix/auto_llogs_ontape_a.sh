#!/bin/ksh
# Script to perform automatics backup of the logical logs using ontape.                        
# Description: This script is the one to be invoked by informix in tha ALARMPROGRAM value
#              of the $ONCONFIG file
# pre-requisite: libgcc, tcl, tk & expect installed

ARG1=$1
ARG2=$2
ARG3=$3
ARG4=$4
ARG5=$5

PATH=$PATH:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

FILE=`$INFORMIXDIR/bin/onstat -c | grep ^LTAPEDEV | awk '{print $2}'`
PATH=`$INFORMIXDIR/bin/onstat -c | grep ^LTAPEDEV | awk '{print $2}'`
DEVICEFILE=`/bin/basename $FILE`
DEVICEPATH=`/usr/bin/dirname $FILE`
integer CURRENTLOG=`$INFORMIXDIR/bin/onstat -l | /bin/grep -v "Dynamic Server" | /bin/grep C | /bin/awk '{print $4}'`
eval '(('ARCHIVELOG=${CURRENTLOG}-1'))'

DEVICE=`${INFORMIXDIR}/bin/onstat -c |/bin/grep "^TAPEDEV" |/bin/awk '{print $2}'`
BASENAME=`/bin/basename ${DEVICE}`
#FILENAME=`/bin/basename $i`
FILENAME=`/bin/ls -r ${DEVICE}.* |/usr/bin/head -1`
if [ $? -eq 0 ]; then
	FILENAME=`/bin/basename ${FILENAME}`
	DATEFILE=`echo ${FILENAME}|/bin/sed '1,$s/'${BASENAME}'//'|/bin/cut -c2-9`
	ARCHIVELOG=${DATEFILE}-${ARCHIVELOG}
fi
#echo $DEVICE "<- device"
#echo $BASENAME "<- basename"
#echo $FILENAME "<- filename"
#echo $DATEFILE "<-datefile"
#echo $ARCHIVELOG "<- archivelog"
#exit
#LASTBACKUP=`basename ${LASTBACKUP}`


export DEVICEFILE DEVICEPATH CURRENTLOG ARCHIVELOG

checkPid()
{

PID=`/bin/cat ${DEVICEPATH}/${DEVICEFILE}.lck`
ps -p ${PID} > /dev/null 2>&1
if [ $? -ge 1 ] 
then
	/bin/rm -f ${DEVICEPATH}/${DEVICEFILE}.lck
else
	exit 0
fi

}

doBackup()
{
set -x
#echo ${DEVICEPATH}/${DEVICEFILE}.lck
if [ -f ${DEVICEPATH}/${DEVICEFILE}.lck ]
then
	checkPid
	echo $$ > ${DEVICEPATH}/${DEVICEFILE}.lck
	/home/informix/scripts/ontape_a_script.exp > /tmp/ontape_a_script.out 2>&1
	/bin/rm -f ${DEVICEPATH}/${DEVICEFILE}.lck
else
	echo $$ > ${DEVICEPATH}/${DEVICEFILE}.lck
	/home/informix/scripts/ontape_a_script.exp > /tmp/ontape_a_script.out 2>&1
	/bin/rm -f ${DEVICEPATH}/${DEVICEFILE}.lck
fi


}

## MAIN

#check if sec
$INFORMIXDIR/bin/onstat - > /dev/null 2>&1
SEC=$?
[ ${SEC} -eq 2 ] && exit 0

[ ! $# -ge 2 ] && echo "missing arguments" && exit 1
[ ${ARG1} -eq 2 ] && [ ${ARG2} -eq 23 ] && doBackup 
#[ $? -ge 1 ] && exit 1
exit 0
