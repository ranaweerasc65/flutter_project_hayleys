<?php
include('connect.php');

// Retrieve and sanitize inputs
$phone_no = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['phoneno']);
$password = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['password']);

// Hash the password before saving
$hashed_password = password_hash($password, PASSWORD_DEFAULT);

// Validate the inputs
if (empty($phone_no) || empty($password)) {
    echo json_encode(array("status" => "error", "message" => "Phone number or password is missing"));
    exit;
}

// Prepare the SQL query to update the user's password
$sql_update = "UPDATE users SET password = ?, datetime = NOW() WHERE phone_no = ?";
$stmt_update = $conn_hayleys_medicalapp->prepare($sql_update);

// Check if the query preparation was successful
if (!$stmt_update) {
    echo json_encode(array("status" => "error", "message" => "Failed to prepare SQL statement: " . $conn_hayleys_medicalapp->error));
    exit;
}

// Bind parameters
$stmt_update->bind_param("ss", $hashed_password, $phone_no);

// Execute the query and handle results
if ($stmt_update->execute()) {
    if ($stmt_update->affected_rows > 0) {
        echo json_encode(array("status" => "success", "message" => "Password changed successfully"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Phone number not found or no changes made"));
    }
} else {
    echo json_encode(array("status" => "error", "message" => "Failed to execute SQL query: " . $stmt_update->error));
}

// Close statement and connection
$stmt_update->close();
$conn_hayleys_medicalapp->close();
?>
