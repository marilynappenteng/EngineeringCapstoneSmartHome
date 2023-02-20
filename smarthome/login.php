<?php
header('Access-Control-Allow-Origin: *');
$db = mysqli_connect('localhost', 'root', '', 'smarthome');

$username = $_GET['username'];
$password = $_GET['password'];

$sql = "SELECT * FROM users WHERE username = '".$username."' AND password = '".$password."'";
$result = mysqli_query($db,$sql);
$count = mysqli_num_rows($result);

if($count >= 1){
    echo json_decode("Success");
    echo ("Success");
}
else{
    echo json_decode("Error");
    echo ("Error");
}

?>