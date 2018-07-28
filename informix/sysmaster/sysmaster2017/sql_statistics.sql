-----------------------------------------------------------------------------
-- Module: @(#)syssql.sql	2.3     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays users SQL statement
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select 	username,
	sqx_sessionid,
	sqx_conbno,
	sqx_sqlstatement
from syssqexplain, sysscblst
where 	sqx_sessionid = sid
order by sqx_sessionid,sqx_conbno
