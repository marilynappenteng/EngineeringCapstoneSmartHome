<?php

$servername = "localhost";
$username = "tester";
$password = "raspberrypi";
$dbname = "smarthomepi";

$con = mysqli_connect($servername, $username, $password,$dbname);

$kitchenflow = $_GET['kitchenflow'];
$kitchendistance = $_GET['kitchendistance'];

$sql = "INSERT INTO `water_flow_ultrasonic`(`flow_rate`,`distance`) VALUES ('{$kitchenflow}', '{$kitchendistance}')";

$q = mysqli_query($con, $sql);


?>
