-----------------------------------------------------------------------------
-- Module: @(#)dbspace_free.sql	2.5     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays free space in all dbspaces like Unix "df -k " command
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select    name[1,8] dbspace,       -- name truncated to fit on one line
          sum(chksize) Pages_size, -- sum of all chuncks size pages
          sum(chksize) - sum(nfree) Pages_used,
          sum(nfree) Pages_free,   -- sum of all chunks free pages
          round ((sum(nfree)) / (sum(chksize)) * 100, 2) percent_free
from      sysdbspaces d, syschunks c
where     d.dbsnum = c.dbsnum
group by 1
order by 1;
