<?php

$servername = "localhost";
$username = "tester";
$password = "raspberrypi";
$dbname = "smarthomepi";

$con = mysqli_connect($servername, $username, $password,$dbname);

$housevoltage=$_GET['housevoltage'];
$housecurrent=$_GET['housecurrent'];

$sql= "INSERT INTO `voltage_and_current`(`voltage`, `current`) VALUES ('{$housevoltage}', '{$housecurrent}')";

$q = mysqli_query($con, $sql);


?>

