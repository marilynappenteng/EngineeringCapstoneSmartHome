<?php

$servername = "localhost";
$username = "tester";
$password = "raspberrypi";
$dbname = "smarthomepi";

$con = mysqli_connect($servername, $username, $password,$dbname);

$door1ultra1=$_GET['ultrasonic1'];
$door1ultra2=$_GET['ultrasonic2'];

$sql = "INSERT INTO `door`(`ultrasonic1`, `ultrasonic2`) VALUES ('{$door1ultra1}','{$door1ultra2}')";

$q = mysqli_query($con, $sql);


?>

