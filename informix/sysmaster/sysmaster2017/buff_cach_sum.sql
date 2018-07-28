-----------------------------------------------------------------------------
-- Module: @(#)buff_cach_sum.sql	2.4     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays % of reads and writes from buffers
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select 	dr.value dskreads,
	br.value bufreads,
	round ((( 1 - ( dr.value / br.value )) *100 ), 2) cached
from sysprofile dr, sysprofile br
where dr.name = "dskreads"
and   br.name = "bufreads";

select 	dw.value dskwrites,
	bw.value bufwrites,
	round ((( 1 - ( dw.value / bw.value )) *100 ), 2) cached
from sysprofile dw, sysprofile bw
where dw.name = "dskwrites"
and   bw.name = "bufwrites"
