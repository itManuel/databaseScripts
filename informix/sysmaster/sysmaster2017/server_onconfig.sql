-----------------------------------------------------------------------------
-- Module: @(#)server_onconfig.sql	2.4     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	displays effective configuration paramaters
--	Tested with Informix 11.70 and Informix 12.10
-----------------------------------------------------------------------------

database sysmaster;

select 	cf_name parameter, 
	cf_original  boot_value,
	cf_effective effective_value
from 	sysconfig
