<?php
include('connect.php');


//$phone_no = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['phone_no']) ;  
$name = mysqli_real_escape_string($conn_hayleys_medicalapp,$_POST['fullName']);                  
$email = mysqli_real_escape_string($conn_hayleys_medicalapp,$_POST['email']);                
$password = mysqli_real_escape_string($conn_hayleys_medicalapp,$_POST['password']);         

$hashed_password = password_hash($password, PASSWORD_DEFAULT);


$sql_insert = "INSERT INTO users (name, email, password, datetime) 
               VALUES ('$name', '$email', '$hashed_password', NOW())";

if ($conn_hayleys_medicalapp->query($sql_insert) === TRUE) {
    echo json_encode(array("status" => "success", "message" => "Registration successful"));
} else {
    echo json_encode(array("status" => "error", "message" => "Error: " . $conn_hayleys_medicalapp->error));
}

// Close the database connection
$conn_hayleys_medicalapp->close();
?>
