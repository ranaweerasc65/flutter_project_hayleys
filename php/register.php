<?php
include('connect.php');


// print_r($_POST);

// Retrieve and sanitize inputs
$user_id = isset($_POST['user_id']) ? (int)$_POST['user_id'] : null;
//$phone_no = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['phoneno']); 
$name = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['fullName']);                  
$email = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['email']);                
$password = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['password']);         

// Hash the password
$hashed_password = password_hash($password, PASSWORD_DEFAULT);

// Debug: Check input values
if (!$user_id) {
    echo json_encode(array("status" => "error", "message" => "Invalid user ID.$user_id "));
    exit;
}


// Prepare the SQL query to update user data
$sql_update = "UPDATE users SET name = ?, email = ?, password = ?, datetime = NOW() WHERE id = ?";
$stmt_update = $conn_hayleys_medicalapp->prepare($sql_update);

// Check if the query preparation was successful
if (!$stmt_update) {
    echo json_encode(array("status" => "error", "message" => "Failed to prepare SQL statement: " . $conn_hayleys_medicalapp->error));
    exit;
}

// Bind parameters
$stmt_update->bind_param("sssi", $name, $email, $hashed_password, $user_id);

// Execute the query and handle results
if ($stmt_update->execute()) {
    if ($stmt_update->affected_rows > 0) {
        echo json_encode(array("status" => "success", "message" => "Registration updated successfully"));
    } else {
        echo json_encode(array("status" => "error", "message" => "No changes were made or user ID not found."));
    }
} else {
    echo json_encode(array("status" => "error", "message" => "Failed to execute SQL query: " . $stmt_update->error));
}

// Close statement and connection
$stmt_update->close();
$conn_hayleys_medicalapp->close();
?>
