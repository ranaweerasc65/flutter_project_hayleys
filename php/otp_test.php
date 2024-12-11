<?php


header("Content-Type: application/json");


include('connect.php');
ini_set('display_errors', 'on');
include('./ESMSWS.php');


$input = json_decode(file_get_contents('php://input'), true);


// Retrieve phone number and OTP from the request
//$phone_no = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['phoneno']);

$phone_no = isset($_POST['phoneno']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['phoneno']) : null;

// if ($phone_no === null) {
//     die(json_encode(["status" => "error", "message" => "Invalid mobile number."]));
// }

// 2024/12/10 11:45AM commented as not in use
$otp = isset($_POST['otp']) ? $_POST['otp'] : null;
//$userOtp = isset($_POST['otp']) ? $_POST['otp'] : null;

if (!$phone_no) {
    echo json_encode(["status" => "error", "message" => "Invalid phone number."]);
    exit;
}

// Initialize $stmt variable
$stmt = null;

if ($otp !== null) {
    // Validate the submitted OTP
    $sql = "SELECT * FROM otp_table WHERE phone_no = ? AND otp = ?";
    $stmt = $conn_hayleys_medicalapp->prepare($sql);
    $stmt->bind_param("ss", $phone_no, $otp);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $stored_otp = $row['otp'];
        $timestamp = strtotime($row['timestamp']);
        $current_time = time();

        if (($current_time - $timestamp) <= 300) {
            
            // Proceed with user verification
            $check_user_sql = "SELECT * FROM users WHERE phone_no = ?";
            $stmt = $conn_hayleys_medicalapp->prepare($check_user_sql);
            $stmt->bind_param("s", $phone_no);
            $stmt->execute();
            $check_user_result = $stmt->get_result();

            if ($check_user_result->num_rows > 0) {
                $user_row = $check_user_result->fetch_assoc();
                $user_id = $user_row['id'];
                echo json_encode(array(
                    "status" => "exists",
                    "user_id" => $user_id,
                    "message" => "Phone number exists. Proceed to login"
                ));
            } else {

                if ($stored_otp === $otp){
                // when user entered otp and the generated otp is equal then the phone number insert to the users table
                $insert_sql = "INSERT INTO users (phone_no) VALUES (?)";
                $stmt = $conn_hayleys_medicalapp->prepare($insert_sql);
                $stmt->bind_param("s", $phone_no);
                if ($stmt->execute()) {
                    $last_id = $conn_hayleys_medicalapp->insert_id;
                    echo json_encode(array(
                        "status" => "success",
                        "user_id" => $last_id,
                        "message" => "Phone number registered successfully"
                    ));
                } else {
                    echo json_encode(array(
                        "status" => "error",
                        "message" => "Failed to register phone number"
                    ));
                }
                }

                
            }
        } else {
            echo json_encode(array(
                "status" => "expired",
                "message" => "OTP has expired. Please request a new one."
            ));
        }
    } else {
        echo json_encode(array(
            "status" => "invalid",
            "message" => "Invalid OTP. Please try again."
        ));
    }
} else {
    // Generate and send OTP
    $generated_otp = rand(100000, 999999); 
    $timestamp = date('Y-m-d H:i:s');

   // update the otp values according to the phone_no for the otp_table
    $otp_sql = "INSERT INTO otp_table (phone_no, otp, timestamp) VALUES (?, ?, ?)
                ON DUPLICATE KEY UPDATE otp = VALUES(otp), timestamp = VALUES(timestamp)";
    $stmt = $conn_hayleys_medicalapp->prepare($otp_sql);
    $stmt->bind_param("sss", $phone_no, $generated_otp, $timestamp);

    //check whether the entered phone number not in the users table.
    //if so it gives the status as not_exisits
    //then the otp send to that number
    if ($stmt->execute()) {
        echo json_encode(array(
            "status" => "not_exists",
            "message" => "Phone number is not in the users table. OTP: $generated_otp sent to $phone_no. Please verify."
        ));
        
    } else {
        echo json_encode(array(
            "status" => "error",
            "message" => "Failed to generate OTP. Please try again."
        ));
    }
}

$to = filter_input(INPUT_POST, 'phoneno', FILTER_SANITIZE_NUMBER_INT); // Validate mobile number
$subject = "OTP: $generated_otp";
$etxt = "Dear User, Please use the following OTP: $generated_otp to complete your online request.";
$footer = "Fentons";


function sendMSG($subject, $to, $etxt, $footer) {
    $alias = "Fentons"; // Sender ID
    $message = $etxt . " " . $footer;
    $recipients = $to; // Recipient's phone number

    // Placeholder for SMS Gateway API calls
    // Replace with actual implementation
    $session = createSession('', 'esmsusr_168l', '2pr8jmh', ''); // Initialize session with credentials
    $messageType = 0; // Message type: 0 for normal message
    $smsStatus = sendMessages($session, $alias, $message, $recipients, $messageType);

    // Check SMS status
    if ($smsStatus == '200') {
        //echo "SMS sent successfully";
    } else {
        //echo "Failed to send SMS";
    }
    //$myfile = fopen("WF_USER_CONNECTION_INFO.txt", "w") or die("Unable to open file!");

    // $txt = $smsStatus;
    // fwrite($myfile, $txt);
    // fclose($myfile);
    closeSession($session);
}

if ($to && ctype_digit($to)) {
    sendMSG($subject, $to, $etxt, $footer);
} else {
    echo "Invalid mobile number.";
}

// Close $stmt if it is initialized
if ($stmt) {
    $stmt->close();
}

// Close the database connection
$conn_hayleys_medicalapp->close();
?>