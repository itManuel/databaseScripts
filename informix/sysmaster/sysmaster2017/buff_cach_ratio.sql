-----------------------------------------------------------------------------
-- Module: @(#)buff_cach_ratio.sql	2.0     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription: Display Buffer read and write cach ratios by buffer pool
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------


select bufsize,
	dskreads,
	pagreads,
	bufreads,
	round ((( 1 - ( dskreads / bufreads )) *100 ), 2) read_cach,
	dskwrites,
	pagwrites,
	bufwrites,
	round ((( 1 - ( dskwrites / bufwrites )) *100 ), 2) write_cach
from sysbufpool;
	
