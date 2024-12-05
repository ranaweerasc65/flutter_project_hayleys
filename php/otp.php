<?php 
include('connect.php');

$phone_number = $_POST['phoneno'];
$password = $_POST['password']; // You can keep this, or skip for login-only checking

// Check if the phone number already exists
$sql = "SELECT * FROM users WHERE phone_number = ?";
$stmt = $conn_hayleys_medicalapp->prepare($sql);
$stmt->bind_param("s", $phone_number);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    // Phone number exists, return success for login
    echo json_encode(array("status" => "exists", "message" => "Phone number exists. Proceed to login"));
} else {
    // Phone number does not exist, return error message for registration
    echo json_encode(array("status" => "not_exists", "message" => "Phone number is available for registration"));
}

$stmt->close();
$conn_hayleys_medicalapp->close();
?>
