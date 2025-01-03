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
    'phone_no', 'customers_name', 'customers_dob', 'customers_city', 
    'customers_district', 'customers_province', 'customers_identification', 
    'customers_gender', 'customers_blood_group', 'customers_contact_no1', 
    'customers_contact_no2', 'customers_occupation', 'customers_relationship'
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
$phone_no = $_POST['phone_no'];
$customers_name = $_POST['customers_name'];
$customers_dob = $_POST['customers_dob'];
$customers_home_no = $_POST['customers_home_no'];
$customers_street_name = $_POST['customers_street_name'];
$customers_city = $_POST['customers_city'];
$customers_district = $_POST['customers_district'];
$customers_province = $_POST['customers_province'];
$customers_identification = $_POST['customers_identification'];
$customers_gender = $_POST['customers_gender'];
$customers_blood_group = $_POST['customers_blood_group'];
$customers_contact_no1 = $_POST['customers_contact_no1'];
$customers_contact_no2 = $_POST['customers_contact_no2'];
$customers_occupation = $_POST['customers_occupation'];
$customers_relationship = $_POST['customers_relationship'];

// Use prepared statements to prevent SQL injection
$sql = "INSERT INTO customers (phone_no, customers_name, customers_dob, customers_home_no, customers_street_name, customers_city, customers_district, customers_province, customers_identification, customers_gender, customers_blood_group, customers_contact_no1, customers_contact_no2, customers_occupation, customers_relationship) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
$stmt = $conn_hayleys_medicalapp->prepare($sql);

// Check if the prepared statement was successful
if ($stmt === false) {
    echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
    exit();
}

// Bind the parameters to the prepared statement
$stmt->bind_param(
    "sssssssssssssss",
    $phone_no,
    $customers_name,
    $customers_dob,
    $customers_home_no,
    $customers_street_name,
    $customers_city,
    $customers_district,
    $customers_province,
    $customers_identification,
    $customers_gender,
    $customers_blood_group,
    $customers_contact_no1,
    $customers_contact_no2,
    $customers_occupation,
    $customers_relationship
);

// Execute the query and check for success
if ($stmt->execute()) {
    echo json_encode(array("status" => "success", "message" => "User details inserted successfully"));
} else {
    echo json_encode(array("status" => "error", "message" => "Failed to insert user details: " . $stmt->error));
}

// Close the statement and connection
$stmt->close();
$conn_hayleys_medicalapp->close();
?>
