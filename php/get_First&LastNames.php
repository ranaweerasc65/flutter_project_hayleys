<?php
include('connect.php');

// Get the customerId from the request
$customer_id = $_GET['customer_id'];

// Query to fetch customer details based on customerId
$query = "SELECT CUSTOMERS_FIRST_NAME, CUSTOMERS_LAST_NAME FROM customers WHERE CUSTOMERS_ID = ?";

// Prepare and execute the query
if ($stmt = $conn_hayleys_medicalapp->prepare($query)) {
    $stmt->bind_param("i", $customer_id); // 'i' means integer
    $stmt->execute();
    $stmt->bind_result($first_name, $last_name);

    // Check if the customer exists
    if ($stmt->fetch()) {
        // Return success response with customer data
        echo json_encode([
            'status' => 'success',
            'first_name' => $first_name,
            'last_name' => $last_name
        ]);
    } else {
        // Return failure response if no customer found
        echo json_encode(['status' => 'failure', 'message' => 'Customer not found']);
    }

    $stmt->close();
} else {
    // Return error if query preparation fails
    echo json_encode(['status' => 'error', 'message' => 'Database query failed']);
}

$conn_hayleys_medicalapp->close();

?>