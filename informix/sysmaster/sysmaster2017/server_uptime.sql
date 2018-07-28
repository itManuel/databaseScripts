-----------------------------------------------------------------------------
-- Module: @(#)server_uptime.sql	2.0     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays how long the Informix Server has been up and when the 
-- 		last time stats (onstat -z) were cleared.
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select
        current current_time,
        DBINFO ('utc_to_datetime', sh_boottime ) boot_time,
        DBINFO ('utc_to_datetime',sh_pfclrtime)  stats_reset_time,
        current - DBINFO ('utc_to_datetime',sh_pfclrtime) interval_since_stats_reset,
        ( sh_curtime - sh_pfclrtime) units second secounds_since_stats_reset,
        (ROUND (( sh_curtime - sh_pfclrtime)/60) )  minutes_since_stats_reset
from sysshmvals;

