-----------------------------------------------------------------------------
-- Module: @(#)lockwait.sql	2.4     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays Only locks with other users waiting on them.
-- 	This script uses the base tables used to create the view syslocks.
--  	This script was tested with OnLine 7.3. It may not work in all
--	versions because the base tables may change with versions.
--      On a Busy system you may get a ERROR
--      244: Could not do a physical-order read to fetch next row.
--      That means one of the lock tables is being updated at the same time
--      so wait a minute and rerun this.
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select 	dbsname,
	b.tabname,
	rowidr,
	keynum,
	e.txt	type,
	d.sid 	ownersid,
	g.username ownername,
	f.sid	waitsid,
	h.username waitname
from 	syslcktab a,
	systabnames b,
	systxptab c,
	sysrstcb d,
	sysscblst g,
	flags_text e,
	sysrstcb f , sysscblst h
where 	a.partnum = b.partnum
and 	a.owner = c.address
and 	c.owner = d.address
and 	a.wtlist = f.address
and	d.sid = g.sid
and 	e.tabname = 'syslcktab'
and 	e.flags = a.type
and	f.sid = h.sid
into temp A;

select 	dbsname,
	tabname,
	type[1,4],
	ownersid,
	ownername,
	waitsid,
	waitname
from A;
