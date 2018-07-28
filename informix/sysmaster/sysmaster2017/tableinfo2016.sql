-----------------------------------------------------------------------------
-- Module: @(#)tableinfo2016.sql	1.0     Date: 2016/04/01
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Description: New Table Information Script - Unload the output to a file 
--              and the load the results into a worksheet for analysis
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

-- unload to tableinfo2016.uld
select
	systabnames.dbsname      database,
	systabnames.tabname      tabname,
	( dbinfo('dbspace', ti_partnum )) dbspace,
	systabnames.partnum,
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
		when ( (ti_pagesize +4)  -24)  <  ti_rowsize   then "Row larger then pagesize"
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
	DBINFO ('utc_to_datetime', ti_created ) create_date,
	lockreqs,
	lockwts,
	deadlks,
	lktouts,
	isreads,
	iswrites,
	isrewrites,
	isdeletes,
	bufreads,
	bufwrites,
	seqscans,
	pagreads,
	pagwrites,
	( bufreads + bufwrites ) total_io,
	case
		when pagreads > 0 then
			( pagreads / bufreads ) 
			else 0
	end buff_read_percent,
	case
		when pagwrites > 0 then 
			( pagwrites / bufwrites )
			else 0
	end  buff_write_percent,
	(( ti_npdata * seqscans ) * ti_pagesize ) total_bytes_scanned 
from systabnames, systabinfo, outer sysptprof
where 	systabinfo.ti_partnum = systabnames.partnum
and		systabinfo.ti_partnum = sysptprof.partnum
and 	systabnames.dbsname not in ( "sysmaster", "sysuser", "sysutils", "sysadmin" )
and 	ti_npdata > 0 -- remove partitions with no data pages
order by total_io desc;




