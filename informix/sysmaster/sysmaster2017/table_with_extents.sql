-----------------------------------------------------------------------------
-- Module: @(#)tabextent.sql	2.5     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays tables, number of extents and size of table.
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select  dbsname,
        tabname,
        count(*) num_of_extents,
        sum( pe_size ) total_size
from systabnames, sysptnext
where partnum = pe_partnum
group by 1, 2
order by 3 desc, 4 desc;
