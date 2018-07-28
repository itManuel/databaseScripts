-----------------------------------------------------------------------------
-- Module: @(#)memsegments.sql	1.0     Date: 2015/03/20
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Description: 
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

-- Summary by Memory Segments Class
select 
	-- seg_class,
	case 
		when seg_class = 1 then "Resident"
		when seg_class = 2 then "Virtual"
		when seg_class = 3 then "Message"
		when seg_class = 4 then "Buffer"
		else "Unknown"
	end class,
	count(*) number ,
	sum( seg_size ) total_size,
	sum( seg_blkused )	total_blkused,
	sum( seg_blkfree )	total_blkfree
from sysseglst
group by 1;

-- Detail by Memory Segment
select 
	-- seg_class,
	case 
		when seg_class = 1 then "Resident"
		when seg_class = 2 then "Virtual"
		when seg_class = 3 then "Message"
		when seg_class = 4 then "Buffer"
		else "Unknown"
	end class,
	seg_size,
	seg_blkused,
	seg_blkfree
from sysseglst;

-- select * from sysseglst;
