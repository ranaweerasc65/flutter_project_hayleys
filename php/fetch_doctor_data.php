<?php

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

include('connect.php');

header('Content-Type: application/json'); // Ensure the response is JSON

$customer_id = isset($_GET['customer_id']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_GET['customer_id']) : null;

if (!$customer_id) {
    echo json_encode(array("status" => "error", "message" => "Customer ID is missing"));
    exit();
}

// Corrected SQL Query (Removed the extra comma)
$sql_fetch_doctor = "SELECT 
                          DOCTOR_ID, 
                          DOCTOR_NAME, 
                          DOCTOR_SPECIALIZATION, 
                          DOCTOR_CONTACT_NUMBER, 
                          DOCTOR_HOSPITAL_NAME,
                          ILLNESS_ID
                      FROM doctor
                      WHERE CUSTOMERS_ID = ?";

$stmt_fetch_doctor = $conn_hayleys_medicalapp->prepare($sql_fetch_doctor);

if (!$stmt_fetch_doctor) {
    echo json_encode(array("status" => "error", "message" => "Failed to prepare SQL statement"));
    exit();
}

$stmt_fetch_doctor->bind_param("s", $customer_id);
$stmt_fetch_doctor->execute();
$result_fetch_doctor = $stmt_fetch_doctor->get_result();

if ($result_fetch_doctor->num_rows > 0) {
    $doctor = []; // Corrected array declaration
    while ($row = $result_fetch_doctor->fetch_assoc()) { // Corrected loop variable
        $doctor[] = array(
            "DOCTOR_ID" => $row['DOCTOR_ID'],
            "DOCTOR_NAME" => $row['DOCTOR_NAME'],
            "DOCTOR_SPECIALIZATION" => $row['DOCTOR_SPECIALIZATION'],
            "DOCTOR_CONTACT_NUMBER" => $row['DOCTOR_CONTACT_NUMBER'],
            "DOCTOR_HOSPITAL_NAME" => $row['DOCTOR_HOSPITAL_NAME'],
            "ILLNESS_ID" => $row['ILLNESS_ID']
        );
    }

    echo json_encode(array(
        "status" => "success",
        "message" => "Doctor data fetched successfully",
        "total_count" => count($doctor),
        "doctor" => $doctor
    ));
} else {
    echo json_encode(array("status" => "error", "message" => "No doctor records found"));
}

// Close statement and connection
$stmt_fetch_doctor->close();
$conn_hayleys_medicalapp->close();

?>
