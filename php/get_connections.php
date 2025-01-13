<?php

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Include database connection
include('connect.php');

// Retrieve parameters from GET request
$phone_no = isset($_GET['phone_no']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_GET['phone_no']) : null;

// Check if the phone number is provided
if (!$phone_no) {
    echo json_encode(array("status" => "error", "message" => "Phone number is missing"));
    exit();
}

// Prepare the SQL query to fetch customer details excluding CUSTOMERS_RELATIONSHIP = 'ME'
$sql_fetch = "SELECT CUSTOMERS_ID, CUSTOMERS_FIRST_NAME, CUSTOMERS_LAST_NAME, phone_no 
              FROM customers 
              WHERE phone_no = ? AND CUSTOMERS_RELATIONSHIP != 'ME'";
$stmt_fetch = $conn_hayleys_medicalapp->prepare($sql_fetch);

if (!$stmt_fetch) {
    echo json_encode(array("status" => "error", "message" => "Failed to prepare SQL statement"));
    exit();
}

$stmt_fetch->bind_param("s", $phone_no);
$stmt_fetch->execute();
$result_fetch = $stmt_fetch->get_result();

// Check if any connections are found
if ($result_fetch->num_rows > 0) {
    $connections = [];
    while ($row = $result_fetch->fetch_assoc()) {
        $connections[] = array(
            "CUSTOMERS_ID" => $row['CUSTOMERS_ID'],
            "CUSTOMERS_FIRST_NAME" => $row['CUSTOMERS_FIRST_NAME'],
            "CUSTOMERS_LAST_NAME" => $row['CUSTOMERS_LAST_NAME'],
            "phone_no" => $row['phone_no'],
        );
    }

    // Return the data as JSON
    echo json_encode(array(
        "status" => "success",
        "message" => "Connections fetched successfully",
        "total_count" => count($connections),
        "connections" => $connections
    ));
} else {
    echo json_encode(array("status" => "error", "message" => "No connections found"));
}

// Close the statement and connection
$stmt_fetch->close();
$conn_hayleys_medicalapp->close();

?>
