-----------------------------------------------------------------------------
-- Module: @(#)seswait.sql	2.3     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays session status 
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select
	sid,
	username,
	-- pid,
	-- hostname,
	-- tty,
	-- l2date(connected),
	is_wlatch,
	is_wlock,
	is_wbuff,
	is_wckpt,
	is_wlogbuf,
	is_wtrans,
	is_monitor,
	is_incrit
	-- state
from 	syssessions
order by username
