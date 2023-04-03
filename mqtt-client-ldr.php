<?php

$servername = "localhost";
$username = "tester";
$password = "raspberrypi";
$dbname = "smarthomepi";

$con = mysqli_connect($servername, $username, $password,$dbname);

$ldr1=$_GET['ldr1'];
$ldr2=$_GET['ldr2'];

$sql = "INSERT INTO `ldr` (`ldr_reading1`, `ldr_reading2`) VALUES ('{$ldr1}', '{$ldr2}')";

$q = mysqli_query($con, $sql);


?>
