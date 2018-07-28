-----------------------------------------------------------------------------
-- Module: @(#)chunk_free_list.sql	2.5     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays free space within a chunk
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select
     name dbspace,  -- dbspace name 
     f.chknum,      -- chunk number
     f.extnum,      -- extent number of free space
     f.start,       -- starting address of free space
     f.leng free_pages   -- length of free space
from      sysdbspaces d, syschunks c, syschfree f
where d.dbsnum = c.dbsnum
and   c.chknum = f.chknum
order by dbspace, chknum, extnum
