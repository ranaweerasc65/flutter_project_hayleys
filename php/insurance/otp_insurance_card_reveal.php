<?php

header("Content-Type: application/json");
include('connect.php');
ini_set('display_errors', 'on');
include('./ESMSWS.php'); 

// Retrieve POST data
$phone_no = isset($_POST['phoneno']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['phoneno']) : null;

if (!$phone_no) {
    echo json_encode(["status" => "error", "message" => "Invalid phone number."]);
    exit;
}

// Function to check if the phone number exists in the users table
function checkIfUserExists($conn_hayleys_medicalapp, $phone_no) {
    error_log("CHECK USER IN PHP");
    $sql = "SELECT * FROM users WHERE phone_no = ?";
    $stmt = $conn_hayleys_medicalapp->prepare($sql);
    $stmt->bind_param("s", $phone_no);
    $stmt->execute();
    $result = $stmt->get_result();

    return $result->num_rows > 0; // If user exists, return true
}

$action = isset($_POST['action']) ? $_POST['action'] : null;
error_log("Action: $action");
if ($action === 'generate') {
    

    // Logic for generating and sending OTP
    if (checkIfUserExists($conn_hayleys_medicalapp, $phone_no)) {
        generateAndSendOtp($conn_hayleys_medicalapp, $phone_no);
    } else {
        echo json_encode([
            "status" => "not_exists",
            "message" => "Phone number does not exist. Please register first."
        ]);
    }
} elseif ($action === 'verify') {
    // Logic for verifying OTP
    $user_otp = isset($_POST['otp']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['otp']) : null;

    if (verifyOtp($conn_hayleys_medicalapp, $phone_no, $user_otp)) {
        echo json_encode(["status" => "success", "message" => "OTP verified."]);
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid or expired OTP."]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid action."]);
}

function verifyOtp($conn_hayleys_medicalapp, $phone_no, $user_otp) {
    $sql = "SELECT otp, timestamp 
            FROM otp_table 
            WHERE phone_no = ? AND otp = ?";
    $stmt = $conn_hayleys_medicalapp->prepare($sql);
    $stmt->bind_param("ss", $phone_no, $user_otp);
    $stmt->execute();
    $result = $stmt->get_result();

    return $result->num_rows > 0; // Return true if OTP is valid
}


function generateAndSendOtp($conn_hayleys_medicalapp, $phone_no)
{
    $generated_otp = rand(100000, 999999); // Generate a new OTP
    $timestamp = date('Y-m-d H:i:s');

    // Insert or update OTP in the OTP table
    $otp_sql = "INSERT INTO otp_table (phone_no, otp, timestamp) 
                VALUES (?, ?, ?)
                ON DUPLICATE KEY UPDATE otp = VALUES(otp), timestamp = VALUES(timestamp)";
    $stmt = $conn_hayleys_medicalapp->prepare($otp_sql);
    $stmt->bind_param("sss", $phone_no, $generated_otp, $timestamp);

    if ($stmt->execute()) {
        sendOtpMessage($phone_no, $generated_otp); // Send OTP via message service
        echo json_encode([
            "status" => "exists",
            "message" => "OTP $generated_otp sent to $phone_no. Please verify."
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to generate OTP. Please try again."]);
    }
}


function sendOtpMessage($phone_no, $otp)
{
    $alias = "Fentons"; // Sender ID
    $message = "Dear User,
We have received a request to reveal your insurance card for Fentons Medical System. Please use the following One-Time Password (OTP) to complete your request:
$otp


Thank you,
Fentons Medical System";

    // Placeholder for SMS Gateway API call
    $session = createSession('', 'esmsusr_168l', '2pr8jmh', '');
    $smsStatus = sendMessages($session, $alias, $message, $phone_no, 0);

    closeSession($session);
    if ($smsStatus !== '200') {
        error_log("Failed to send OTP to $phone_no");
    }
}

?>