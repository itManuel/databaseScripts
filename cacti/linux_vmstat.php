<?

$uptime=explode(" ",exec('/usr/bin/vmstat 1 2'));
// print_r($uptime);
for($i=0; $i<count($uptime);$i++){
	if($uptime[$i]!=""){
		$data[]=$uptime[$i];
	}
}
// print_r($data);
echo "r:".$data[0]." b:".$data[1]." swpd:".$data[2]." free:".$data[3]." buff:".$data[4]." cache:".$data[5]." si:".$data[6]." so:".$data[7];
echo " bi:".$data[8]." bo:".$data[9]." in:".$data[10]." cs:".$data[11]." us:".$data[12]." sy:".$data[13]." id:".$data[14]." wa:".$data[15]." st:".$data[16];
echo "\n";
?>

