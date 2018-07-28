-----------------------------------------------------------------------------
-- Module: @(#)dbspace_blob_free.sql	2.6     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Display number of free blob pages in blobspace 
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select
	name dbspace,       
	sum(chksize) Size_in_Pages, 	-- sum of all chuncks size pages
	sum(nfree) Num_free_blob_page   -- sum of all chunks free pages
from	sysdbspaces d, syschunks c
where	d.dbsnum = c.dbsnum
and 	d.is_blobspace = 1
group by 1
order by 1
