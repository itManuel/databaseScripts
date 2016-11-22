<?
$connstring="host=localhost dbname=postgres user=youruser password=yourpwd";

$conn=pg_connect($connstring);
$sql="SELECT numbackends,datname
FROM pg_stat_database";
$res=pg_query($conn,$sql);
while($row=pg_fetch_assoc($res)){
	echo $row['datname'].":".$row['numbackends']." ";
}
echo "\n";
pg_close($conn);

?>
