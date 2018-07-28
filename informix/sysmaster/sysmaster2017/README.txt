-----------------------------------------------------------------------------
-- Module: @(#)README	3.0    Date: 2017/05/01
-- Author: Lester Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	This is a set of SQL scripts that use the sysmaster
-- 	database to provide information on the status of your server
-----------------------------------------------------------------------------
-- New Scripts updated in 2017 and 2016
index_usage.sql - Ratio of index reads to writes
server_ratios2.sql - Several Server ratios
table_with_seqscans.sql -  Updated
checkpointhistory.sql - Display checkpoint history
chunkio.sql - Display IO by chunk
chunklayout.sql - Display layout of what is in a chunk
iohistory.sq - Display chunk I/O hostory for the past hourl
licensehistory.sql - Display Informix Usages history
logicallogs.sql - Display Logical Logs 
machineinfo.sql - Display information about the hardware and OS
memsegments.sql - Display Informix Memory Segments
smiversion.sql - Display Sysmaster Version
sqlhosts.sql - Display SQL hosts file
syslicense.sql - Display data from the license table`
sysrstcb.sqla - Display all threads 
syssqexplain.sql - Display Query Stats
tableextents.sql - Display data about tables and extents
tableinfo_freerows.sql - Display data about tables and free row space
tableseqscans.sql - Display table scans
vpcpustats.sql - Display more Oninit VP stats
-- Orginal Scripts
buff_btr_ratio.sql - Display Buffer Turnovers per hour 
buff_cach_ratio.sql - Display Buffer read and write cache ratios by buffer pool
buff_cach_sum.sql - Displays % of reads and writes from buffers
chunk_free_list.sql - Displays free space within a chunk
chunk_io_stat.sql - Displays chunk IO statistics 
chunk_io_sum.sql - Displays chunk IO percent of total IO ordered by chunk
chunk_status.sql - Displays info and status for a chunk
database_list.sql - Displays database list,owner and logging status
database_size.sql - Displays size of database based on pages allocated
dbspace_blob_free.sql - Display number of free blob pages in blobspace 
dbspace_free.sql - Displays free space in all dbspaces like Unix "df -k " command
dbwho.sh - Displays who is using what database
dbwho.sql - Displays who is using what database
log_position.sql - Displays users and position in logical logs
log_statistics.sqla - Displays how many open transactions are in each log.
log_transaction.sql - Displays how many open transactions are in each log.
server_onconfig.sql - Displays boot and effective configuration parameters 
server_readahead.sql - Calculate the percent of read ahead used
server_statics.sql - Displays key server profile/perfomance statatics
server_uptime.sql - Displays  server uptime and when the stats were last reset
session_list.sql - Displays short list of user sessions
session_locks.sql - Displays locks, users and tables
session_lockwait.sql - Displays Only locks with other users waiting on them
session_statistics.sql - Displays user session profile info
session_wait_list.sql - Displays session wait status
sql_statistics.sql - Displays users SQL statement
table_disk_layout.sql - Displays tables and extents
table_extent_plan.sqla - Display extents and proposed new extent sizes
table_io_statistics.sql - Displays table IO performance
table_with_extents.sql - Displays tables, number of extents and size of table
table_with_seqscans.sql - Displays tables with sequence scans
vp_profile.sql  - Displays VP status
vp_statistics.sql - Displays VP status like onstat -g sch

-------------------------------------------------------------------------------
                                 Lester Knutsen
                         Advanced DataTools Corporation
                            4216 Evergreen Lane, #126
                               Annandale, VA 22003 USA
                                   703-256-0267
                           lester@advancedatatools.com
                             www.advancedatatools.com
-------------------------------------------------------------------------------


