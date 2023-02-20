<?php
header('Access-Control-Allow-Origin: *');
$db = mysqli_connect('localhost', 'root', '', 'smarthome');

if(!$db){
    echo "Database Connection Failed";
}

$username = $_POST['username'];
$password = $_POST['password'];

$sql = "SELECT username FROM users WHERE username = '".$username."'";
$result = mysqli_query($db,$sql);
$count = mysqli_num_rows($result);

if($count == 1){
    echo json_decode("Error");
}
else{
    $insert = "INSERT INTO users(username,password) VALUES ('".$username."','".$password."')";
    $query = mysqli_query($db, $insert);
    if($query){
        echo json_decode("Success");
    }
}

?>