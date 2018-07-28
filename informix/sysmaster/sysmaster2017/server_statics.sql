-----------------------------------------------------------------------------
-- Module: @(#)keyprofile.sql	2.3     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays key server profile/perfomance statatics
-- 	The list of names is all the values in Informix 12.10, some do
--	exist in earlier versions.  Pick the ones your want to see.
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select * from sysprofile
where name in ( 
	"dskreads",
	"bufreads",
	"dskwrites",
	"bufwrites",
	"isamtot",
	"isopens",
	"isstarts",
	"isreads",
	"iswrites",
	"isrewrites",
	"isdeletes",
	"iscommits",
	"isrollbacks",
	"ovlock",
	"ovuser",
	"ovtrans",
	"latchwts",
	"buffwts",
	"lockreqs",
	"lockwts",
	"ckptwts",
	"deadlks",
	"lktouts",
	"numckpts",
	"plgpagewrites",
	"plgwrites",
	"llgrecs",
	"llgpagewrites",
	"llgwrites",
	"pagreads",
	"pagwrites",
	"flushes",
	"compress",
	"fgwrites",
	"lruwrites",
	"chunkwrites",
	"btradata",
	"btraidx",
	"dpra",
	"rapgs_used",
	"seqscans",
	"totalsorts",
	"memsorts",
	"disksorts",
	"maxsortspace",
	"ll_niowaits",
	"ll_iowait_ms",
	"num_cpu_ready",
	"num_ready",
	"ll_nbfwaits",
	"ll_bfwait_ms"
	)
	
