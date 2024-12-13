<?php

header("Content-Type: application/json");
include('connect.php');
ini_set('display_errors', 'on');
include('./ESMSWS.php'); 

// Retrieve POST data
$phone_no = isset($_POST['phoneno']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['phoneno']) : null;
$otp = isset($_POST['otp']) ? $_POST['otp'] : null;

if (!$phone_no) {
    echo json_encode(["status" => "error", "message" => "Invalid phone number."]);
    exit;
}

// Initialize database statement
$stmt = null;

if ($otp) {
    // Verify OTP
    verifyOtp($conn_hayleys_medicalapp, $phone_no, $otp);
} else {
    // Generate and send OTP
    generateAndSendOtp($conn_hayleys_medicalapp, $phone_no);
}

/**
 * Function to verify OTP
 */
function verifyOtp($conn_hayleys_medicalapp, $phone_no, $otp)
{
    // Check OTP validity
    $sql = "SELECT * FROM otp_table WHERE phone_no = ? AND otp = ?";
    $stmt = $conn_hayleys_medicalapp->prepare($sql);
    $stmt->bind_param("ss", $phone_no, $otp);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $timestamp = strtotime($row['timestamp']);
        $current_time = time();

        if (($current_time - $timestamp) <= 300) { // OTP valid for 5 minutes
            handleUserRegistration($conn_hayleys_medicalapp, $phone_no);
        } else {
            echo json_encode(["status" => "expired", "message" => "OTP has expired. Please request a new one."]);
        }
    } else {
        echo json_encode(["status" => "invalid", "message" => "Invalid OTP. Please try again."]);
    }
}

/**
 * Function to handle user registration
 */
// function handleUserRegistration($conn_hayleys_medicalapp, $phone_no)
// {
//     // Check if user already exists
//     $check_user_sql = "SELECT * FROM users WHERE phone_no = ?";
//     $stmt = $conn_hayleys_medicalapp->prepare($check_user_sql);
//     $stmt->bind_param("s", $phone_no);
//     $stmt->execute();
//     $result = $stmt->get_result();

//     if ($result->num_rows > 0) {
//         $user_row = $result->fetch_assoc();
//         $user_id = $user_row['id'];
//         echo json_encode([
//             "status" => "exists",
//             "user_id" => $user_id,
//             "message" => "Phone number exists. Proceed to login."
//         ]);
//     } else {
//         // Insert user to the users table if otp verification success
//         $insert_sql = "INSERT INTO users (phone_no) VALUES (?)";
//         $stmt = $conn_hayleys_medicalapp->prepare($insert_sql);
//         $stmt->bind_param("s", $phone_no);
//         $last_id = $conn_hayleys_medicalapp->insert_id;

        

//         if ($stmt->execute()) {
//             echo json_encode([
//                 "status" => "success",
//                 "user_id" => $last_id,
//                 "message" => "Phone number registered successfully."
//             ]);
//         } else {
//             echo json_encode(array("status" => "error", "message" => "Failed to update registration: " . $stmt_update->error));

//         }
//     }
// }

function handleUserRegistration($conn_hayleys_medicalapp, $phone_no)
{
    // Check if user already exists
    $check_user_sql = "SELECT * FROM users WHERE phone_no = ?";
    $stmt = $conn_hayleys_medicalapp->prepare($check_user_sql);
    $stmt->bind_param("s", $phone_no);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user_row = $result->fetch_assoc();
        $user_id = $user_row['id'];
        echo json_encode([
            "status" => "exists",
            "user_id" => $user_id,
            "message" => "Phone number exists. Proceed to login."
        ]);
    } else {
        // Insert user into the users table if OTP verification is successful
        $insert_sql = "INSERT INTO users (phone_no) VALUES (?)";
        $stmt = $conn_hayleys_medicalapp->prepare($insert_sql);


        if (!$stmt) {
            echo json_encode([
                "status" => "error",
                "message" => "Failed to prepare insert statement: " . $conn_hayleys_medicalapp->error
            ]);
            return;
        }

        
        $stmt->bind_param("s", $phone_no);








        if ($stmt->execute()) {
           
            $last_id = $conn_hayleys_medicalapp->insert_id;


            //echo json_encode(array("status" => "success", "message" => "Phone number registered successfully. $last_id "));

            //echo json_encode(array("status" => "not_exists", "message" => "Phone number registered successfully. $last_id "));
            // echo json_encode([
            //     "status" => "success",
            //     "user_id" => $last_id,
            //     "message" => "Phone number registered successfully."
            // ]);

            echo json_encode([
                "status" => "not_exists",
                "last_id" => $last_id, 
                "message" => "Phone number registered successfully."
            ]);

        } 
        else {
            echo json_encode([
                "status" => "error",
                "message" => "Failed to register user: " . $stmt->error
            ]);
        }
    }
}


/**
 * Function to generate and send OTP
 */
function generateAndSendOtp($conn_hayleys_medicalapp, $phone_no)
{
    $generated_otp = rand(100000, 999999); // Generate 6-digit OTP
    $timestamp = date('Y-m-d H:i:s');

    // Insert or update OTP
    $otp_sql = "INSERT INTO otp_table (phone_no, otp, timestamp) 
                VALUES (?, ?, ?)
                ON DUPLICATE KEY UPDATE otp = VALUES(otp), timestamp = VALUES(timestamp)";
    $stmt = $conn_hayleys_medicalapp->prepare($otp_sql);
    $stmt->bind_param("sss", $phone_no, $generated_otp, $timestamp);

    if ($stmt->execute()) {
        sendOtpMessage($phone_no, $generated_otp);
        echo json_encode([
            "status" => "not_exists",
            "message" => "OTP $generated_otp sent to $phone_no. Please verify."
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to generate OTP. Please try again."]);
    }
}





/**echo json_encode(array("status" => "error", "message" => "Invalid user ID.$user_id "));
 * Function to send OTP message
 */
function sendOtpMessage($phone_no, $otp)
{
    $alias = "Fentons"; // Sender ID
    $message = "Dear User, Please use the following OTP: $otp to complete your online request. Fentons Medical System";

    // Placeholder for SMS Gateway API call
    $session = createSession('', 'esmsusr_168l', '2pr8jmh', '');
    $smsStatus = sendMessages($session, $alias, $message, $phone_no, 0);

    closeSession($session);
    if ($smsStatus !== '200') {
        error_log("Failed to send OTP to $phone_no");
    }
}

?>
