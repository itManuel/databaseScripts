-----------------------------------------------------------------------------
-- Module: @(#)database_size.sql	2.1     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays size of database based on pages allocated
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select  dbsname,
        sum( pe_size ) total_pages
from systabnames, sysptnext
where partnum = pe_partnum
group by 1
order by 2 desc
