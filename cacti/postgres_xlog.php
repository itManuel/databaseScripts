<?
$connstring="host=localhost dbname=postgres user=youruser password=yourpwd";
$conn=pg_connect($connstring);
$now=time();
$xlogs=0;

function text2unixts($fecha){
	list($anio,$mes,$dia,$offset)=explode("-",$fecha);
	list ($dia,$horario)=explode(" ",$dia);
	list ($hora,$minuto,$segundo)=explode(":",$horario);
	$myfecha=mktime($hora,$minuto,$segundo,$mes,$dia,$anio);
	return($myfecha);
}

$res=pg_query($conn,"Select pg_ls_dir('pg_xlog') ;");
while($row=pg_fetch_row($res)){
	$res2=pg_query($conn,"select * from pg_stat_file('pg_xlog/".$row[0]."');");
	$row2=pg_fetch_assoc($res2);
	if($row[0]!="archive_status"){
		if($now-text2unixts($row2['access'])<300 || $now-text2unixts($row2['modification'])<300 || $now-text2unixts($row2['change'])<300){
			$xlogs++;
		} else {
			$xlogfiles[$row[0]]=$row2;
		}
	}
}
echo "used5min:".$xlogs." total:".count($xlogfiles)."\n";
?>

