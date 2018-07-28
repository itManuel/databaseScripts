-----------------------------------------------------------------------------
-- Module: @(#)tablayout.sql	2.5     Date:2013/04/10 
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays tables and extents
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select dbinfo( "DBSPACE" , pe_partnum ) dbspace,
     dbsname,
     tabname,
     -- pe_phys   start,  -- use this for IDS < 9.40
     pe_offset    start,  -- use this for IDS >= 9.40 
     pe_size size
from      sysptnext, outer systabnames
where     pe_partnum = partnum
order by dbspace, start;
