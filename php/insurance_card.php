<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Include database connection
include('connect.php');

// Check if database connection is successful
if ($conn_hayleys_medicalapp->connect_error) {
    echo json_encode(array("status" => "error", "message" => "Database connection failed: " . $conn_hayleys_medicalapp->connect_error));
    exit();
}

// Initialize an array to keep track of missing fields
$missingFields = [];

// Check if required fields are provided
$requiredFields = [
    'phone_no', 'customers_id', 'insurance_card_holder_name', 'insurance_membership_no', 'insurance_policy_no', 
    'insurance_company'
];

foreach ($requiredFields as $field) {
    if (!isset($_POST[$field])) {
        $missingFields[] = $field;  // Add missing field to the array
    }
}

if (!empty($missingFields)) {
    echo json_encode(array("status" => "error", "message" => "Required fields are missing", "missing_fields" => $missingFields));
    exit();
}

// Get POST data from the Flutter app

$phone_no = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['phone_no']);
$customers_id = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_id']);
$insurance_card_holder_name = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['insurance_card_holder_name']);
$insurance_membership_no = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['insurance_membership_no']);
$insurance_company = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['insurance_company']);
$insurance_policy_no = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['insurance_policy_no']);

// Get the customer_id (required for update)
$insurance_id = isset($_POST['insurance_id']) ? intval($_POST['insurance_id']) : null;

if ($insurance_id) {
    // UPDATE query if customer_id is provided
    $sql = "UPDATE insurance SET 
            phone_no = ?, customers_id = ?, insurance_card_holder_name = ?, insurance_membership_no = ?, 
            insurance_policy_no = ?, insurance_company = ?
            WHERE INSURANCE_ID = ?";

    $stmt = $conn_hayleys_medicalapp->prepare($sql);

    // Check if the prepared statement was successful
    if ($stmt === false) {
        echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
        exit();
    }

    // Bind the parameters to the prepared statement
    $stmt->bind_param(
        "sssssss",
        $phone_no,
        $customers_id,
        $insurance_card_holder_name,
        $insurance_membership_no,
        $insurance_policy_no, 
        $insurance_company,
        $insurance_id // This is the ID of the customer we are updating
    );

    // Execute the query and check for success
    if ($stmt->execute()) {
        echo json_encode(array("status" => "success", "message" => "Insurance card details updated successfully"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to update insurance card details: " . $stmt->error));
    }
} else {
    // If customer_id is not provided, insert a new record
    $sql = "INSERT INTO insurance (phone_no, customers_id, insurance_card_holder_name, insurance_membership_no, insurance_policy_no, insurance_company) 
            VALUES (?, ?, ?, ?, ?, ?)";

    $stmt = $conn_hayleys_medicalapp->prepare($sql);

    // Check if the prepared statement was successful
    if ($stmt === false) {
        echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
        exit();
    }

    // Bind the parameters to the prepared statement
    $stmt->bind_param(
        "ssssss",
        $phone_no,
        $customers_id,
        $insurance_card_holder_name,
        $insurance_membership_no,
        $insurance_policy_no, 
        $insurance_company
    );

    // Execute the query and check for success
    if ($stmt->execute()) {
        $insurance_id = $conn_hayleys_medicalapp->insert_id; // Get the last inserted customer ID
        echo json_encode(array(
            "status" => "success", 
            "message" => "Insurance card details added successfully", 
            "insurance_id" => $insurance_id // Pass the customer ID in the response
        ));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to insert insurance card details: " . $stmt->error));
    }
}

// Close the statement and connection
$stmt->close();
$conn_hayleys_medicalapp->close();
?>