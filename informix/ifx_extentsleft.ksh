#!/bin/ksh

# 12/05/2008 -- Andres Repossi
# Performs ifx_extentsleft.ksh for objects extents left

# Laura S. Rado 01/07/2010
# Changed MAILLIST from tech-dba-informix@lastminute.com to tech-dba-informix-alert@lastminute.com

# Manuel Aller 02/09/2010
# Changed MAILLIST from tech-dba-informix-alert@lastminute.com to LMN-DBA-INFORMIX-ALERT@lastminute.com


#set -x

if [ $# -ne 3 ]
then
  echo "Param one: IFX SERVER {qatdbs01v2|qatebasket|qareporting} | Param two: CRITICAL_LEVEL | Param three: WARNING_LEVEL"
  echo 
  echo "Example:"
  echo "Run: /usr/dba/scripts/ifx_extentsleft.ksh qatdbs01v2 50 100"

  exit 1
fi

INFORMIXSERVER=$1
CRITICAL_LEVEL=$2
WARNING_LEVEL=$3
OUTPUT_FILE=/tmp/`basename $0`.out.$$
MAILLIST="LMN-DBA-INFORMIX-ALERT@lastminute.com"

# Set Informix server common environment variables
. /usr/dba/environ/common_env

# Set Informix server specific environment variables
[ -f /usr/dba/environ/$INFORMIXSERVER.env ] && . /usr/dba/environ/$INFORMIXSERVER.env >/dev/null 2>&1

# Check we are running on the Secondary
onstat - >/dev/null 2>&1
ret=$?
if [ $ret -ne 2 ]
then
  echo "VALUE:$ret"
  echo "Run Against Secondary Only!"
  exit 1
fi

echo "WARNING LEVEL  - extents left below: $WARNING_LEVEL\n" > $OUTPUT_FILE
echo "CRITICAL LEVEL - extents left below: $CRITICAL_LEVEL" >> $OUTPUT_FILE
echo  >> $OUTPUT_FILE

#    "      12        |      12        |    5    |     100     "
echo "=====================================================================================================================================" >> $OUTPUT_FILE
echo "Datbase Name	|	DBSpace Name	|	ELeft	|	Object Name" >> $OUTPUT_FILE
echo "=====================================================================================================================================" >> $OUTPUT_FILE

col=0
flag=0
#typeset -L99 lv_object
typeset -L12 lv_database
typeset -L12 lv_dbspace
typeset -L5 lv_freeext

#set -x

{ 
dbaccess sysmaster <<EOF 2>/dev/null
SET ISOLATION TO DIRTY READ;
OUTPUT TO PIPE "pr -t" WITHOUT HEADINGS
select {+ ordered, index(a, syspaghdridx) } -- necessary 
c.tabname[1,25],                            -- the table or index 
CASE
  WHEN c.tabname[26,50] = "" THEN "£" ELSE c.tabname[26,50]
END CASE,
CASE
  WHEN c.tabname[51,75] = "" THEN "£" ELSE c.tabname[51,75]
END CASE,
CASE
  WHEN c.tabname[76,100] = "" THEN "£" ELSE c.tabname[76,100]
END CASE,
c.dbsname,                                  -- the database 
b.name,                                     -- the dbspace 
TRUNC(a.pg_frcnt / 8) frext,                -- the free extents 
"END_OF_LINE"
  FROM sysmaster:sysdbspaces b, 
       sysmaster:syspaghdr a, 
       sysmaster:systabnames c 
    WHERE a.pg_partnum = sysmaster:partaddr(b.dbsnum, 1) AND
          sysmaster:bitval(a.pg_flags, 2) = 1 AND
          a.pg_nslots = 5 AND
          c.partnum = sysmaster:partaddr(b.dbsnum, a.pg_pagenum) AND
          TRUNC(a.pg_frcnt / 8) <= $WARNING_LEVEL AND
          b.name NOT IN ("dba01")
ORDER BY frext ASC; 
EOF
} | sed '/^$/d' | while read line
do
  col=`expr $col + 1`

  case $col in
    1) lv_object=$line
       ;;
2|3|4) if [ "${line}X" != "X" -a "${line}£" != "£" ]
       then
         lv_object=$lv_object$line
       fi
       ;;
    5) lv_database=$line
       ;;
    6) lv_dbspace=$line
       ;;
    7) lv_freeext=$line
       ;;
    8) lv_eol=$line
       if [ ${lv_freeext} -ge $CRITICAL_LEVEL -a $flag == 0 ]
       then
         echo "-------------------------------------------------------------------------------------------------------------------------------------" >> $OUTPUT_FILE
	 flag=1
       fi
       echo "${lv_database}	|	${lv_dbspace}	|	${lv_freeext}	|	`echo ${lv_object} | sed 's/£//g'`" >> $OUTPUT_FILE
       col=0
       lv_object=""
       lv_database=""
       lv_dbspace=""
       lv_freeext=""
       line=""
       ;;
  esac
done

echo "-------------------------------------------------------------------------------------------------------------------------------------" >> $OUTPUT_FILE

cat $OUTPUT_FILE | mailx -s "Objects Extents Free List: $INFORMIXSERVER" $MAILLIST

rm $OUTPUT_FILE
