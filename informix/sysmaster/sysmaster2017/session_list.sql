-----------------------------------------------------------------------------
-- Module: @(#)session.sql	2.3     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays short list of user sessions
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select 	sid,
	username,
	pid,
	hostname,
	l2date(connected) startdate
from 	syssessions
