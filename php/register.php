<?php
include('connect.php');


$user_id = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['user_id']); 

$name = mysqli_real_escape_string($conn_hayleys_medicalapp,$_POST['fullName']);                  
$email = mysqli_real_escape_string($conn_hayleys_medicalapp,$_POST['email']);                
$password = mysqli_real_escape_string($conn_hayleys_medicalapp,$_POST['password']);         

$hashed_password = password_hash($password, PASSWORD_DEFAULT);


// $sql_insert = "INSERT INTO users (name, email, password, datetime) 
//                VALUES ('$name', '$email', '$hashed_password', NOW())";

// if ($conn_hayleys_medicalapp->query($sql_insert) === TRUE) {
//     echo json_encode(array("status" => "success", "message" => "Registration successful"));
// } else {
//     echo json_encode(array("status" => "error", "message" => "Error: " . $conn_hayleys_medicalapp->error));
// }

// Update the user record with registration details
$sql_update = "UPDATE users SET name = ?, email = ?, password = ?, datetime = NOW() WHERE id = ?";
$stmt_update = $conn_hayleys_medicalapp->prepare($sql_update);
$stmt_update->bind_param("sssi", $name, $email, $hashed_password, $user_id);

if ($stmt_update->execute()) {
    echo json_encode(array("status" => "success", "message" => "Registration updated successfully"));
} else {
    echo json_encode(array("status" => "error", "message" => "Failed to update registration"));
}

$stmt_update->close();

// Close the database connection
$conn_hayleys_medicalapp->close();
?>

