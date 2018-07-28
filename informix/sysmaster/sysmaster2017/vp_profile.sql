-----------------------------------------------------------------------------
-- Module: @(#)vpprof.sql	2.3     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays VP status
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select
	vpid,
	pid,
	txt[1,5] class,
	round( usecs_user, 2) usercpu,
	round( usecs_sys, 2)  syscpu
from 	sysvplst a, flags_text b
where 	a.class = b.flags
and   	b.tabname = "sysvplst"
