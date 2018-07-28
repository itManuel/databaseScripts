-- #############################################################################
-- ## Module: @(#)index_usage.sql      2.0     Date: 01/01/2017
-- ## Author: Lester Knutsen  Email: lester@advancedatatools.com
-- ##         Advanced DataTools Corporation
-- #############################################################################

select
        a.tabname,
        b.idxname,
        bufreads,
        bufwrites,
        case
                when bufwrites = 0 then bufreads
                when bufreads = 0 then 0
                else ( bufreads /bufwrites )
        end ratio
from    systables a, sysindexes b,  outer sysmaster:sysptprof p
where   a.tabid = b.tabid
and     p.tabname = b.idxname
and     a.tabid > 99;

