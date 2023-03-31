<?php

$servername = "localhost";
$username = "tester";
$password = "raspberrypi";
$dbname = "smarthomepi";

$con = mysqli_connect($servername, $username, $password,$dbname);

$ldr1=$_GET['ldr1'];
$ldr2=$_GET['ldr2'];
$ultrasonic1=$_GET['ultrasonic1'];
$ultrasonic2=$_GET['ultrasonic2'];
$housevoltage=$_GET['housevoltage'];
$housecurrent=$_GET['housecurrent'];
$kitchenflow = $_GET['kitchenflow'];
$kitchendistance = $_GET['kitchendistance'];

$sql = "INSERT INTO `ldr` (`ldr_reading1`, `ldr_reading2`) VALUES ('{$ldr1}', '{$ldr2}')";
$sql2 = "INSERT INTO `door`(`ultrasonic11`, `ultrasonic2`) VALUES ('{$ultrasonic1}','{$ultrasonic2}')";
$sql3 = "INSERT INTO `voltage_and_current`(`voltage`, `current`) VALUES ('{$housevoltage}', '{$housecurrent}')";
$sql4 = "INSERT INTO `water_flow_ultrasonic`(`flow_rate`,`distance`) VALUES ('{$kitchenflow}', '{$kitchendistance}')";

$q = mysqli_query($con, $sql);
$q2 = mysqli_query($con, $sql2);
$q3 = mysqli_query($con, $sql3);
$q4 = mysqli_query($con, $sql4);


?>
