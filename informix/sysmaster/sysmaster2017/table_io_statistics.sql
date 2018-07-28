-----------------------------------------------------------------------------
-- Module: @(#)tabprof.sql	2.5     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays table IO performance
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select
	dbsname,
	tabname,
	partnum,
	lockreqs,
	lockwts,
	deadlks,
	lktouts,
	isreads,
	iswrites,
	isrewrites,
	isdeletes,
	bufreads,
	bufwrites,
	seqscans,
	pagreads,
	pagwrites   
from sysptprof
order by isreads desc; -- change this sort to whatever you need to monitor.
