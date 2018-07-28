-----------------------------------------------------------------------------
-- Module: @(#)chunklayout.sql	1.0     Date: 2015/03/20
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Description: 
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;
select 	dbinfo ("DBSPACE", pe_partnum ) dbspace,
	pe_chunk	chunknum,
	pe_offset	ext_start,
	dbsname 	database,
	tabname 	partname,
	pe_partnum	partnum,
	pe_extnum	extnum,
	pe_size		ext_size
from 	sysptnext b, outer systabnames a
where 	a.partnum = b.pe_partnum
order by  2, 3
