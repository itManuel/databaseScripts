-----------------------------------------------------------------------------
-- Module: @(#)table_with_seqscans.sql	2.2     Date: 2017/04/01
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays tables with sequence scans
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select 	dbsname,
	tabname, 
	ti_npdata   pages_used,
	sum(seqscans) total_scans,
	(ti_npdata * (sum(seqscans))) total_pages_scaned
from 	sysptprof, systabinfo
where 	sysptprof.partnum = systabinfo.ti_partnum	
and seqscans > 0
and tabname not in ( select tabname from systables where tabid < 100 )
and dbsname not in ( "sysmaster", "sysadmin" , "sysuser", "sysutils" )
group 	by 1, 2, 3
order 	by 5 desc
