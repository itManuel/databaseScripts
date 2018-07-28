-----------------------------------------------------------------------------
-- Module: @(#)chunkio.sql	1.0     Date: 2015/03/20
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Description: 
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select 
	name dbspace,
	chknum,
	pagesread,
	pageswritten,
	readtime,
	writetime,
	round(	pagesread / ( select sum( pagesread ) from sysmaster:syschktab ) , 2) read_percent,
	round(	pageswritten / ( select sum( pageswritten ) from sysmaster:syschktab ) , 2) write_percent
from 	sysmaster:syschktab c, sysmaster:sysdbstab d
where     c.dbsnum = d.dbsnum
order by 1, 2 desc;


