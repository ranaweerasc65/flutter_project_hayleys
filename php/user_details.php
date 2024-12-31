<?php
// Include the database connection


// 31/12/2024 BACKEND CODE START


include('connect.php');

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

// Check if required fields are provided
if (!isset($phone_no, $customers_name, $customers_dob, $customers_city)) {
    echo json_encode(array("status" => "error", "message" => "Required fields are missing"));
    exit();
}

// Use prepared statements to prevent SQL injection
$sql = "INSERT INTO customers (phone_no, customers_name, customers_dob, customers_home_no, customers_street_name, customers_city, customers_district, customers_province, customers_identification, customers_gender, customers_blood_group, customers_contact_no1, customers_contact_no2, customers_occupation, customers_relationship) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
$stmt = $conn_hayleys_medicalapp->prepare($sql);
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

if ($stmt->execute()) {
    echo json_encode(array("status" => "success", "message" => "User details inserted successfully"));
} else {
    echo json_encode(array("status" => "error", "message" => "Failed to insert user details"));
}

// Close the connection
$stmt->close();
$conn_hayleys_medicalapp->close();
?>
