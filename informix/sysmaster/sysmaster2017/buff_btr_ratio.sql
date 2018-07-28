-----------------------------------------------------------------------------
-- Module: @(#)buff_btr_ratio.sql     2.0     Date: 2013/04/10
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription: Display Buffer Turnovers per hour 
--		Based on Art Kagels performance tuning tip on monitoring 
--		how much buffer churn your server has.
--		Goal is BTR of less then 7 times per hour
--	Tested with Informix 11.70 and Informix 12.10
--  The Error - 1202: An attempt was made to divide by zero. happens when
--  the server has been up less then one hour
-----------------------------------------------------------------------------

select
	bufsize,
        pagreads,
        bufwrites,
        nbuffs,
        ((( pagreads + bufwrites ) /nbuffs ) 
		/ ( select (ROUND ((( sh_curtime - sh_pfclrtime)/60)/60) )  
			from sysshmvals ) 
	) BTR
from sysbufpool;
