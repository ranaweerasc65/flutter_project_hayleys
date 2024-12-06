<?php

ini_set('display_errors', 'on');
include('./ESMSWS.php');
//ini_set('log_errors', 'On');
//ini_set('error_log', '/path/to/error.log'); // Set a valid log file path

$da = date('Y-m-d H:i:s');
// include('connect.php');
$randomdata = rand(100000, 999999);

$to = filter_input(INPUT_POST, 'mobile', FILTER_SANITIZE_NUMBER_INT); // Validate mobile number
$subject = "OTP: $randomdata";
$etxt = "Dear User, Please use the following OTP: $randomdata to complete your online request.";
$footer = "Fentons";

function url_get_contents($url) {
    if (!function_exists('curl_init')) {
        die('CURL is not installed!');
    }
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $output = curl_exec($ch);
    curl_close($ch);
    return $output;
}

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
    if ($smsStatus == 'SUCCESS') {
        echo "SMS sent successfully";
    } else {
        echo "Failed to send SMS";
    }

    closeSession($session);
}

if ($to && ctype_digit($to)) {
    sendMSG($subject, $to, $etxt, $footer);
} else {
    echo "Invalid mobile number.";
}

?>







