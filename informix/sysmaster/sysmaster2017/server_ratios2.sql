-----------------------------------------------------------------------------
-- Module: @(#)server_ratios.sql	1.0     Date: 2017/04/01
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays key server profile/perfomance ratios
-- 	The list of names is all the values in Informix 12.10
--	Tested with Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

--  Read Ahead ratio
select
	"Read Ahead Ratio", 
        (( select value  rapgs_used from sysprofile where name = 'rapgs_used') /
        (( select value  btradata from sysprofile where name =  'btradata' ) +
        ( select value  btraidx from sysprofile where name =  'btraidx' ) +
        ( select value  dpra from sysprofile where name = 'dpra' )))  Read_Ahead_Ratio
from sysdual;

-- Seqence Scans
select 	"Total Scans:", value
from sysprofile
where name in ( "seqscans" );

select 	
	"Scans per hour: ", 
	( Value / ( select (ROUND ((( sh_curtime - sh_pfclrtime)/60)/60) )
                        from sysshmvals )) 
from sysprofile
where name in ( "seqscans" );

-- Sort Information
select 	name, value
from sysprofile
where name in ( "totalsorts", "memsorts", "disksorts", "maxsortspace" );

select "Sorts per hour:",
        ( Value / ( select (ROUND ((( sh_curtime - sh_pfclrtime)/60)/60) )
                        from sysshmvals )) 
from sysprofile
where name in ( "totalsorts" );

-- Buffer Ratios per hour
select "Buffer Reads per hour:",
        ( Value / ( select (ROUND ((( sh_curtime - sh_pfclrtime)/60)/60) )
                        from sysshmvals )) 
from sysprofile
where name in ( "bufreads" );

select "Buffer Writes per hour:",
        ( Value / ( select (ROUND ((( sh_curtime - sh_pfclrtime)/60)/60) )
                        from sysshmvals )) 
from sysprofile
where name in ( "bufwrites" );

-- Transaction commits per hour
select "Commits per hour:",
        ( Value / ( select (ROUND ((( sh_curtime - sh_pfclrtime)/60)/60) )
                        from sysshmvals )) 
from sysprofile
where name in ( "iscommits" );

select "Buffer Waits per hour:",
        ( Value / ( select (ROUND ((( sh_curtime - sh_pfclrtime)/60)/60) )
                        from sysshmvals )) 
from sysprofile
where name in ( "buffwts" );

select "Checkpoints per hour:",
        ( Value / ( select (ROUND ((( sh_curtime - sh_pfclrtime)/60)/60) )
                        from sysshmvals )) 
from sysprofile
where name in ( "ckptwts" );

-- Lock Information
select 	name, value
from sysprofile
where name in ( "lockreqs", "lockwts", "deadlks" );

select
	"Lock Wait Ratio", 
	case when ( ( select value lockwts from sysprofile where name =  'lockwts' ) <> 0 ) 
        	then (( select value  lockreqs from sysprofile where name = 'lockreqs') /
        	( select value   lockwts from sysprofile where name =  'lockwts' )) 
		else 0
	end case
from sysdual;

-- Write Types
select 	name, value
from sysprofile
where name in ( "fgwrites", "lruwrites", "chunkwrites");

