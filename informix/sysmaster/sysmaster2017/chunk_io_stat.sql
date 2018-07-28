-----------------------------------------------------------------------------
-- Module: @(#)chunk_io_stat.sql	2.5     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays chunk IO status
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select
     name dbspace, -- truncated to fit 80 char screen line
     chknum,
     "P" type,		-- Primary 
     reads,
     writes,
     pagesread,
     pageswritten
from syschktab c, sysdbstab d
where     c.dbsnum = d.dbsnum
union all
select
     name     dbspace,
     chknum,
     "M"    type,	-- Mirror
     reads,
     writes,
     pagesread,
     pageswritten
from sysmchktab c, sysdbstab d
where     c.dbsnum = d.dbsnum
order by 1,2,3;
