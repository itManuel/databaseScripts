-----------------------------------------------------------------------------
-- Module: @(#)tabextplan.sql	2.5     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Display extents and proposed new extent sizes
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------
-- NOTE: if you page size is 4096 change the "* 2 { Your systems page " to 4
-- 	 if you growth factor is greater the 20% per year make the nessary
--	 changes.

database sysmaster;

select dbsname,
        tabname,
        count(*) num_of_extents,
        sum (pe_size ) pages_used,
        round (sum (pe_size )
                * 4 { Your systems page size in KB }
                * 1.2 { Add 20% Growth factor })
                ext_size, { First Extent Size in KB }
        round (sum (pe_size )
                * 4 { Your systems page size in KB }
                * .2 { Estimated 20% Yearly Growth })
                next_size { Next Extent Size in KB }
from systabnames, sysptnext
where partnum = pe_partnum
group by 1, 2
order by 3 desc, 4 desc;
