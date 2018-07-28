-----------------------------------------------------------------------------
-- Module: @(#)server_readahead.sql	2.0     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Calculate the percent of read ahead used - Goal is 99% or .99
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;



select value  btradata from sysprofile where name =  'btradata' ;
select value  btraidx from sysprofile where name =  'btraidx' ;
select value  dpra from sysprofile where name = 'dpra' ;
select value  rapgs_used from sysprofile where name = 'rapgs_used';


select 
	(( select value  rapgs_used from sysprofile where name = 'rapgs_used') /
	(( select value  btradata from sysprofile where name =  'btradata' ) + 
	( select value  btraidx from sysprofile where name =  'btraidx' ) +
	( select value  dpra from sysprofile where name = 'dpra' )))  Percent_Read_Ahead_Used
from sysdual
