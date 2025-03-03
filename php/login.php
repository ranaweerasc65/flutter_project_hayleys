<?php

// Include the database connection
include('connect.php');

// Get the POST data from the Flutter app
$phone_no = $_POST['phone_no'];
$password = $_POST['password'];

// Check if 'phone_no' and 'password' are present in POST
if (!isset($_POST['phone_no']) || !isset($_POST['password'])) {
    echo json_encode(array("status" => "error", "message" => "Please provide both phone number and password"));
    exit(); // Stop further execution if fields are missing
}

error_log(print_r($_POST, true));  // Log POST data to PHP error log

// // Check if the required fields are not empty
// if (empty($phone_no) || empty($password)) {
//     echo json_encode(array("status" => "error", "message" => "Please provide both phone number and password"));
//     exit(); // Stop further execution if fields are empty
// }

// Use prepared statements to prevent SQL injection
$sql = "SELECT * FROM users WHERE phone_no = ?";
$stmt = $conn_hayleys_medicalapp->prepare($sql);
$stmt->bind_param("s", $phone_no);
$stmt->execute();
$result = $stmt->get_result();

// Check if the phone number exists
if ($result->num_rows == 0) {
    echo json_encode(array("status" => "error", "message" => "Phone number not registered"));
    exit(); 
}

// Fetch the user record
$user = $result->fetch_assoc();

// Verify the password (assuming password is hashed using password_hash)
if (password_verify($password, $user['password'])) {
    // Password is correct, login successful


    //12/31/2024 ADD PHONE NO FOR THE BELOW LINE ---> FOR THE USAGE OF USER_DETAILS.PHP

    // echo json_encode(array(
    //     "status" => "success", 
    //     "message" => "Login successful", 
    //     "user_id" => $user['id'], 
    //     "name" => $user['name'], 
    //     "phone_no" => $user['phone_no']));

    echo json_encode([
        "status" => "success",
        "message" => "Login successful",
        "user_id" => $user['id'],
        "name" => $user['name'],
        "phone_no" => $user['phone_no']
    ]);


} else {

    echo json_encode(array("status" => "error", "message" => "Incorrect password"));
}

error_log(print_r($_POST, true));


// Close the database connection
$stmt->close();
$conn_hayleys_medicalapp->close();
?>