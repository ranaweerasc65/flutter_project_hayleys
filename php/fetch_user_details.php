<?php

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Include database connection
include('connect.php');

// Retrieve parameters from GET request
$phone_no = isset($_GET['phone_no']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_GET['phone_no']) : null;
$customer_id = isset($_GET['customer_id']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_GET['customer_id']) : null;

// Check if both phone number and customer ID are provided
if (!$phone_no || !$customer_id) {
    echo json_encode(array("status" => "error", "message" => "Phone number or Customer ID is missing"));
    exit();
}

// Prepare the SQL query to fetch the customer details based on phone number and customer ID
$sql_fetch = "SELECT * FROM customers WHERE phone_no = ? AND customer_id = ? ";
$stmt_fetch = $conn_hayleys_medicalapp->prepare($sql_fetch);
$stmt_fetch->bind_param("si", $phone_no, $customer_id); // Assuming customer_id is an integer
$stmt_fetch->execute();
$result_fetch = $stmt_fetch->get_result();

// Check if any customer data is found
if ($result_fetch->num_rows > 0) {
    $customer = $result_fetch->fetch_assoc();
    echo json_encode(array(
        "status" => "success",
        "message" => "Customer details fetched successfully",
        "existing_data" => $customer
    ));
} else {
    echo json_encode(array("status" => "error", "message" => "Customer not found"));
}

// Close the statement and connection
$stmt_fetch->close();
$conn_hayleys_medicalapp->close();
?>
