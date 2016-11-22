<?
$DB_NAME=$_GET['database'];
if($DB_NAME=='yourdb1'||$DB_NAME=='yourdb2'){
$connstring="host=localhost dbname=".$DB_NAME." user=youruser password=yourpwd";
$conn=pg_connect($connstring);
$sql="SELECT numbackends as CONN, xact_commit as TX_COMM, xact_rollback as TX_RLBCK, blks_read + blks_hit as READ_TOTAL, 
blks_hit * 100 / (blks_read + blks_hit) as BUFFER
FROM pg_stat_database
WHERE datname = '$DB_NAME' ;";
$res=pg_query($conn,$sql);
while($row=pg_fetch_assoc($res)){
	echo "conn:".$row['conn']." tx_comm:".$row['tx_comm']." tx_rlbck:".$row['tx_rlbck']." read_total:".$row['read_total']." buffer:".$row['buffer']." ";
}

$sql2="SELECT 
  sum(heap_blks_read) as heap_read,
  sum(heap_blks_hit)  as heap_hit,
  sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) as ratio
FROM 
  pg_statio_user_tables;";
$res2=pg_query($conn,$sql2);
while($row=pg_fetch_assoc($res2)){
	echo "heap_read:".$row['heap_read']." heap_hit:".$row['heap_hit']." ratio:".$row['ratio']." ";
}

$sql3="SELECT 
  sum(idx_blks_read) as idx_read,
  sum(idx_blks_hit)  as idx_hit,
  (sum(idx_blks_hit) - sum(idx_blks_read)) / sum(idx_blks_hit) as ratio
FROM 
  pg_statio_user_indexes;";

$res3=pg_query($conn,$sql3);
while($row=pg_fetch_assoc($res3)){
	echo "idx_read:".$row['idx_read']." idx_hit:".$row['idx_hit']." idx_ratio:".$row['ratio']."\n";
}
pg_close($conn);

}
?>
