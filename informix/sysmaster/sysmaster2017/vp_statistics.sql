-----------------------------------------------------------------------------
-- Module: @(#)vpstat.sql	2.5     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	 Displays VP status like onstat -g sch
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select    vpid,
       txt[1,5] class,
       pid,
       round(usecs_user,2) usercpu,
       round(usecs_sys,2)  syscpu,
       num_ready ready_threads
from sysvplst a, flags_text b
where a.flags != 6
and  a.class = b.flags
and b.tabname = 'sysvplst'
order by 1;
