<?
$connstring="host=localhost dbname=yourdb user=youruser password=yourpwd";
$conn=pg_connect($connstring);
$res=pg_query($conn,"select count(*),state from pg_stat_activity group by state;");
while($row=pg_fetch_assoc($res)){
//echo "idle:".$res[
	if($row['state']=='active'){
		$data['active']=$row['count'];
	}
	else if($row['state']=='idle'){
		$data['idle']=$row['count'];
	}
	else{
		$data['other']=$row['count'];
	}
}
pg_close($conn);
echo "idle:".$data['idle']." active:".$data['active']."\n";
?>

