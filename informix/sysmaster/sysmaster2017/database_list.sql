-----------------------------------------------------------------------------
-- Module: @(#)database_list.sql	2.5     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays database list,owner and logging status
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select
        dbinfo("DBSPACE",partnum) dbspace,
        name database,
        owner,
        is_logging,
        is_buff_log
from sysdatabases
order by dbspace, name;
