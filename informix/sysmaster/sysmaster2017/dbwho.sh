#!/bin/sh
###########################################################################
# Program:  @(#)dbwho.sh	1.2     Date: 97/07/17
# Author:  Lester Knutsen  Email: lester@advancedatatools.com
# Date:    10/28/1995      Advanced DataTools Corporation
# Description: List database, user and workstation of all db users
###########################################################################

echo "Generating list of users by database ..."

dbaccess sysmaster - <<EOF
select
        sysdatabases.name database,
        syssessions.username,
        syssessions.hostname,
        syslocks.owner sid
from  syslocks, sysdatabases , outer syssessions
where syslocks.rowidlk = sysdatabases.rowid
and   syslocks.tabname = "sysdatabases"
and   syslocks.owner = syssessions.sid
order by 1;
EOF
