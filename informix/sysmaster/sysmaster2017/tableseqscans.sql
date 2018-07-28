-----------------------------------------------------------------------------
-- Module: @(#)tableseqscans.sql	1.0     Date: 2015/03/20
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Description: 
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select 	dbsname	database,
	tabname,
	( dbinfo('dbspace', ti_partnum )) dbspace,
	ti_npdata    	pages_data,
	seqscans	num_seqscans,
	ti_npdata * seqscans 	pages_scanned
from 	sysptprof, systabinfo
where 	partnum = ti_partnum
and 	seqscans > 0
order 	by 6 desc;

