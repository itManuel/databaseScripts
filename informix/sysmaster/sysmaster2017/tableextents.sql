-----------------------------------------------------------------------------
-- Module: @(#)tableextents.sql	1.0     Date: 2015/03/20
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Description: 
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select ( dbinfo('dbspace', ti_partnum )) dbspace,
	dbsname database,
	owner,
	tabname,
	ti_partnum	partnum,
	ti_pagesize	pagesize,
	ti_nptotal	total_pages,
	ti_npused	used_pages,
	ti_npdata	data_pages,
	ti_nextns	num_extents
from systabnames, systabinfo
where ti_partnum = partnum
order by 10 desc;
