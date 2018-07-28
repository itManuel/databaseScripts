-----------------------------------------------------------------------------
-- Module: @(#)tableinfo2.sql	1.0     Date: 2015/03/20
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Description: 
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select
	dbsname      database,
	tabname      tabname,
	( dbinfo('dbspace', ti_partnum )) dbspace,
	partnum,
	ti_rowsize   row_size,
	ti_ncols     num_columns,
	ti_nkeys     num_indexes,
	ti_nextns    num_extents,
	ti_pagesize  page_size,
	ti_nptotal   pages_total,
	ti_npused    	pages_used,
	ti_npdata    	pages_data,
	(ti_nptotal - ti_npused ) pages_free,
	ti_nrows 	num_rows,
	case
		when ( ti_pagesize -24)  <  ti_rowsize   then "Row larger then pagesize"
		else "Row smaller the pagesize"
	end rowfit,
	case
		when ti_rowsize > 0 then 
			trunc ((ti_pagesize -24) / ti_rowsize ) 
		else 0
	end rows_per_page,
	case
		when ti_rowsize > 0 then 
			( ( trunc ((ti_pagesize -24) / ti_rowsize ) ) * (ti_nptotal - ti_npused ) ) 
		else 0
	end free_rows,
	DBINFO ('utc_to_datetime', ti_created ) create_date
from systabnames, systabinfo
where ti_partnum = partnum
and dbsname not in ( "sysmaster", "sysuser", "sysutils", "sysadmin" );
