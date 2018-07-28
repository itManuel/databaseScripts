-----------------------------------------------------------------------------
-- Module: @(#)syssqexplain.sql	1.0     Date: 2015/03/20
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Description: 
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select
        sqx_estcost,
        sqx_sqlstatement
from    syssqexplain
into    temp A;

select
        sqx_sqlstatement sqlstatement,
        sum(sqx_estcost) sum_estcost,
        count(*)        count_executions
from A
group by 1
order by 2 desc;
