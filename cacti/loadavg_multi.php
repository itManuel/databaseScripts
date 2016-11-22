<?php
// remote cacti plugin via webserver with php enabled
$uptime=exec('/usr/bin/uptime');
$uptime=preg_replace('/^.*: /','1min:',$uptime);
$pos = strpos($uptime, ", ");
if ($pos !== false) {
    $newstring = substr_replace($uptime, " 5min:", $pos, strlen(", "));
}
$uptime=str_replace(", "," 10min:",$newstring);
echo $uptime." test:2";
?>
