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
    'phone_no', 'customers_first_name','customers_last_name', 'customers_dob', 'customers_city', 
    'customers_district', 'customers_province', 'customers_identification', 
    'customers_gender', 'customers_blood_group', 'customers_contact_no1', 
    'customers_occupation'
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

// Check if 'customers_relationship' is provided, if not, set it to "ME"
$customers_relationship = isset($_POST['customers_relationship']) && !empty($_POST['customers_relationship']) 
    ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_relationship']) 
    : "ME";

// Always set "ME" as the relationship value
$customers_relationship = "ME";

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


// UPDATE EMPLOYEE DETAILS - 09/01/2025 
// Check if there's already a record with the same phone number and relationship 'ME'
$sql_check = "SELECT * FROM customers WHERE phone_no = ? AND customers_relationship = 'ME'";
$stmt_check = $conn_hayleys_medicalapp->prepare($sql_check);
$stmt_check->bind_param("s", $phone_no);
$stmt_check->execute();
$result_check = $stmt_check->get_result();

if ($result_check->num_rows > 0) {
    // If a record exists with 'ME' relationship for this phone number, update it instead of inserting
    $sql_update = "UPDATE customers SET 
                    customers_first_name = ?, 
                    customers_last_name = ?, 
                    customers_dob = ?, 
                    customers_city = ?, 
                    customers_district = ?, 
                    customers_province = ?, 
                    customers_identification = ?, 
                    customers_gender = ?, 
                    customers_blood_group = ?, 
                    customers_contact_no1 = ?, 
                    customers_contact_no2 = ?, 
                    customers_occupation = ?, 
                    customers_relationship = ?
                    WHERE phone_no = ? AND customers_relationship = 'ME'";

    $stmt_update = $conn_hayleys_medicalapp->prepare($sql_update);
    $stmt_update->bind_param("ssssssssssssss", 
                            $customers_first_name, 
                            $customers_last_name, 
                            $customers_dob, 
                            $customers_city, 
                            $customers_district, 
                            $customers_province, 
                            $customers_identification, 
                            $customers_gender, 
                            $customers_blood_group, 
                            $customers_contact_no1, 
                            $customers_contact_no2, 
                            $customers_occupation, 
                            $customers_relationship, 
                            $phone_no);

    if ($stmt_update->execute()) {
        echo json_encode(array("status" => "success", "message" => "Member details updated successfully"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to update user details: " . $stmt_update->error));
    }
    $stmt_update->close();
} else {
    // If no record exists with 'ME' relationship, insert a new one
    $sql_insert = "INSERT INTO customers (phone_no, customers_first_name, customers_last_name, customers_dob, customers_home_no, customers_street_name, customers_city, customers_district, customers_province, customers_identification, customers_gender, customers_blood_group, customers_contact_no1, customers_contact_no2, customers_occupation, customers_relationship) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    $stmt_insert = $conn_hayleys_medicalapp->prepare($sql_insert);

    // Bind parameters for insert query
    $stmt_insert->bind_param(
        "ssssssssssssssss", 
        $phone_no, 
        $customers_first_name, 
        $customers_last_name, 
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

    if ($stmt_insert->execute()) {
        echo json_encode(array("status" => "success", "message" => "Member added successfully"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to insert user details: " . $stmt_insert->error));
    }
    $stmt_insert->close();
}


// Close the connection
$conn_hayleys_medicalapp->close();
?>
