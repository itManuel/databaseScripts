-----------------------------------------------------------------------------
-- Module: @(#)logicallogs.sql	1.0     Date: 2015/03/20
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Description: 
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select 	name dbspace,
        	chunk chunknum,
        	hex(address) address,
	a.number,
	a.uniqid,
	a.offset,
	a.size,
	a.used,
	a.flags,
	bitval(a.flags, '0x1') used,
	bitval(a.flags, '0x2')  current,
	bitval(a.flags, '0x4')  backedup,
	bitval(a.flags, '0x8')  new,
	bitval(a.flags, '0x10') archived,
	bitval(a.flags, '0x20') temp,
	bitval(a.flags, '0x40') dropped,
	DBINFO ('utc_to_datetime', filltime ) timefull
from syslogfil a, syschunks c, sysdbspaces d
where a.chunk = c.chknum
and c.dbsnum = d.dbsnum;

