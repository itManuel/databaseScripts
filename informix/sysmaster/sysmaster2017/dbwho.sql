-----------------------------------------------------------------------------
-- Module: @(#)dbwho.sql	2.5     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	 Displays who is using what database
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

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
