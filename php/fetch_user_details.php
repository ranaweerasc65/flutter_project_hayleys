<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Include database connection
include('connect.php');

// Get the customer ID from the GET request

$customer_id = isset($_GET['CUSTOMERS_ID']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_GET['CUSTOMERS_ID']) : null;

// Check if customer ID is provided
if (!$customer_id) {
    echo json_encode(array("status" => "error", "message" => "Customer ID is missing"));
    exit();
}

// SQL query to fetch the customer details by ID
$sql_fetch = "SELECT * FROM customers WHERE CUSTOMERS_ID = ?";
$stmt_fetch = $conn_hayleys_medicalapp->prepare($sql_fetch);
$stmt_fetch->bind_param("i", $customer_id);
$stmt_fetch->execute();
$result_fetch = $stmt_fetch->get_result();

// Check if a customer is found
if ($result_fetch->num_rows > 0) {
    $customer = $result_fetch->fetch_assoc();
    echo json_encode(array(
        "status" => "success",
        "message" => "Customer details fetched successfully",
        "customer_data" => $customer
    ));
} else {
    echo json_encode(array("status" => "error", "message" => "Customer not found"));
}

// Close the statement and connection
$stmt_fetch->close();
$conn_hayleys_medicalapp->close();
?>
