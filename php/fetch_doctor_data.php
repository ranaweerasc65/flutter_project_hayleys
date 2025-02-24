<?php

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

include('connect.php');

$customer_id = isset($_GET['customer_id']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_GET['customer_id']) : null;

if (!$customer_id) {
    echo json_encode(array("status" => "error", "message" => "Customer ID is missing"));
    exit();
}

$sql_fetch_doctors = "SELECT 
                          DOCTOR_ID, 
                          DOCTOR_NAME, 
                          DOCTOR_SPECIALIZATION, 
                          DOCTOR_CONTACT_NUMBER, 
                          DOCTOR_HOSPITAL_NAME, 
                          
                      FROM doctors
                      WHERE CUSTOMERS_ID = ?";
$stmt_fetch_doctor = $conn_hayleys_medicalapp->prepare($sql_fetch_doctors);

if (!$stmt_fetch_doctor) {
    echo json_encode(array("status" => "error", "message" => "Failed to prepare SQL statement"));
    exit();
}

$stmt_fetch_doctor->bind_param("s", $customer_id);
$stmt_fetch_doctor->execute();
$result_fetch_doctors = $stmt_fetch_doctor->get_result();

if ($result_fetch_doctors->num_rows > 0) {
    $doctors = [];
    while ($row = $result_fetch_doctors->fetch_assoc()) {
        $doctors[] = array(
            "ILLNESS_ID" => $row['ILLNESS_ID'],
            "DOCTOR_ID" => $row['DOCTOR_ID'],
            "DOCTOR_SPECIALIZATION" => $row['DOCTOR_SPECIALIZATION'],
            "DOCTOR_CONTACT_NUMBER" => $row['DOCTOR_CONTACT_NUMBER'],
            "DOCTOR_HOSPITAL_NAME" => $row['DOCTOR_HOSPITAL_NAME'],
            "DOCTOR_NAME" => $row['DOCTOR_NAME'],
        );
    }

    echo json_encode(array(
        "status" => "success",
        "message" => "Doctor data fetched successfully",
        "total_count" => count($doctors),
        "doctors" => $doctors
    ));
} else {
    echo json_encode(array("status" => "error", "message" => "No doctor records found"));
}

$stmt_fetch_doctor->close();
$conn_hayleys_medicalapp->close();

?>
