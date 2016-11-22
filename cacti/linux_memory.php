<?
// remote cacti plugin via webserver with php enabled
$memtotal=exec("/bin/grep MemTotal /proc/meminfo|/usr/bin/awk '{print $2}'");
$memfree=exec("/bin/grep MemFree /proc/meminfo|/usr/bin/awk '{print $2}'");
	$memavailable=$memtotal-$memfree;

echo "MemTotal:".$memtotal." MemFree:".$memfree." MemAvailable:".$memavailable;
?>

