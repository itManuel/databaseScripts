-----------------------------------------------------------------------------
-- Module: @(#)log_statistics.sql	2.3     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays logical log status. This script is based on an
--	undocumented sysmaster table systrans and may not work in all versions.
--	It was tested with 7.23.
--	This script shows how many open transactions are in each log.
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select 	tx_logbeg,
	tx_loguniq
from 	systrans
into temp b;

select tx_logbeg, count(*) cnt
from B
where tx_logbeg > 0
group by tx_logbeg
into temp C;

select tx_loguniq, count(*) cnt
from B
where tx_loguniq > 0
group by tx_loguniq
into temp D;

select
	-- number,
	uniqid,
	-- size,
	-- used,
	-- is_used,
	-- is_current,
	is_backed_up,
	is_archived,
	c.cnt	tx_beg_cnt,
	d.cnt	tx_curr_cnt
from 	syslogs, outer c, outer D
where 	uniqid = c.tx_logbeg
and 	uniqid = d.tx_loguniq
order by uniqid
