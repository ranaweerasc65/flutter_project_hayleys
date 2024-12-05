<?php
$servername = "localhost";  
$username = "root";         
$password = "Abc@1234";             
$dbname = "hayleys_db";   

// Create a connection to the database
$conn_hayleys_medicalapp = new mysqli($servername, $username, $password, $dbname);

// Check if the connection was successful
if ($conn_hayleys_medicalapp->connect_error) {
    die("Connection failed: " . $conn_hayleys_medicalapp->connect_error);
} else {
    // echo("pass");
}

// Optional: You can set the character encoding to avoid character issues
$conn_hayleys_medicalapp->set_charset("utf8");

?>
