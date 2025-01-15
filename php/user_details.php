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
    'phone_no', 'customers_first_name', 'customers_last_name', 'customers_dob', 'customers_city', 
    'customers_district', 'customers_province', 'customers_identification', 
    'customers_gender', 'customers_contact_no1', 
    'customers_occupation', 'customers_relationship'
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
$customers_first_name = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_first_name']);
$customers_last_name = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_last_name']);
$customers_dob = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_dob']);

// Check if the date format is correct (yyyy-MM-dd)
$dob_date = DateTime::createFromFormat('Y-m-d', $customers_dob);
if (!$dob_date) {
    echo json_encode(array("status" => "error", "message" => "Incorrect date format"));
    exit();
}

$customers_city = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_city']);
$customers_district = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_district']);
$customers_province = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_province']);
$customers_identification = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_identification']);
$customers_gender = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_gender']);
$customers_blood_group = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_blood_group']);
$customers_contact_no1 = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_contact_no1']);
$customers_occupation = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_occupation']);
$customers_relationship = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_relationship']);

// Optional fields
$customers_home_no = isset($_POST['customers_home_no']) && !empty($_POST['customers_home_no']) 
    ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_home_no']) 
    : null;

$customers_street_name = isset($_POST['customers_street_name']) && !empty($_POST['customers_street_name']) 
    ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_street_name']) 
    : null;

$customers_contact_no2 = isset($_POST['customers_contact_no2']) && !empty($_POST['customers_contact_no2']) 
    ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_contact_no2']) 
    : null;

// Get the customer_id (required for update)
$customer_id = isset($_POST['customer_id']) ? intval($_POST['customer_id']) : null;

if ($customer_id) {
    // UPDATE query if customer_id is provided
    $sql = "UPDATE customers SET 
            phone_no = ?, customers_first_name = ?, customers_last_name = ?, customers_dob = ?, 
            customers_home_no = ?, customers_street_name = ?, customers_city = ?, customers_district = ?, 
            customers_province = ?, customers_identification = ?, customers_gender = ?, customers_blood_group = ?, 
            customers_contact_no1 = ?, customers_contact_no2 = ?, customers_occupation = ?, customers_relationship = ? 
            WHERE CUSTOMERS_ID = ?";

    $stmt = $conn_hayleys_medicalapp->prepare($sql);

    // Check if the prepared statement was successful
    if ($stmt === false) {
        echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
        exit();
    }

    // Bind the parameters to the prepared statement
    $stmt->bind_param(
        "sssssssssssssssss",
        $phone_no,
        $customers_first_name,
        $customers_last_name,
        $customers_dob,
        $customers_home_no, // Optional: can be NULL
        $customers_street_name, // Optional: can be NULL
        $customers_city,
        $customers_district,
        $customers_province,
        $customers_identification,
        $customers_gender,
        $customers_blood_group,
        $customers_contact_no1,
        $customers_contact_no2, // Optional: can be NULL
        $customers_occupation,
        $customers_relationship,
        $customer_id // This is the ID of the customer we are updating
    );

    // Execute the query and check for success
    if ($stmt->execute()) {
        echo json_encode(array("status" => "success", "message" => "Customer details updated successfully"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to update user details: " . $stmt->error));
    }
} else {
    // If customer_id is not provided, insert a new record
    $sql = "INSERT INTO customers (phone_no, customers_first_name, customers_last_name, customers_dob, customers_home_no, customers_street_name, customers_city, customers_district, customers_province, customers_identification, customers_gender, customers_blood_group, customers_contact_no1, customers_contact_no2, customers_occupation, customers_relationship) 
            VALUES (?, ?, ?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    $stmt = $conn_hayleys_medicalapp->prepare($sql);

    // Check if the prepared statement was successful
    if ($stmt === false) {
        echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
        exit();
    }

    // Bind the parameters to the prepared statement
    $stmt->bind_param(
        "ssssssssssssssss",
        $phone_no,
        $customers_first_name,
        $customers_last_name,
        $customers_dob,
        $customers_home_no,// Optional: can be NULL
        $customers_street_name,// Optional: can be NULL
        $customers_city,
        $customers_district,
        $customers_province,
        $customers_identification,
        $customers_gender,
        $customers_blood_group,
        $customers_contact_no1,
        $customers_contact_no2,// Optional: can be NULL
        $customers_occupation,
        $customers_relationship
    );

    // Execute the query and check for success
    if ($stmt->execute()) {
        $customer_id = $conn_hayleys_medicalapp->insert_id; // Get the last inserted customer ID
        echo json_encode(array(
            "status" => "success", 
            "message" => "Member details added successfully", 
            "customer_id" => $customer_id // Pass the customer ID in the response
        ));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to insert user details: " . $stmt->error));
    }
}

// Close the statement and connection
$stmt->close();
$conn_hayleys_medicalapp->close();
?>