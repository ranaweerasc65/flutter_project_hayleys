<?php

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Include database connection
include('connect.php');

// Retrieve parameters from GET request
$phone_no = isset($_GET['phone_no']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_GET['phone_no']) : null;

// Check if the phone number is provided
if (!$phone_no) {
    echo json_encode(array("status" => "error", "message" => "Phone number is missing"));
    exit();
}

// Prepare the SQL query to fetch illness details for the customer
$sql_fetch_illness = "SELECT i.ILLNESS_ID, i.ILLNESS_NAME, i.ILLNESS_SYMPTOMS, i.ILLNESS_STATUS, i.ILLNESS_DIAGNOSIS_DATE, i.ILLNESS_NEXT_FOLLOW_UP_DATE
                      FROM illnesses i
                      JOIN customers c ON i.CUSTOMERS_ID = c.CUSTOMERS_ID
                      WHERE c.phone_no = ?";
$stmt_fetch_illness = $conn_hayleys_medicalapp->prepare($sql_fetch_illness);

if (!$stmt_fetch_illness) {
    echo json_encode(array("status" => "error", "message" => "Failed to prepare SQL statement"));
    exit();
}

$stmt_fetch_illness->bind_param("s", $phone_no);
$stmt_fetch_illness->execute();
$result_fetch_illness = $stmt_fetch_illness->get_result();

// Check if any illness records are found
if ($result_fetch_illness->num_rows > 0) {
    $illnesses = [];
    while ($row = $result_fetch_illness->fetch_assoc()) {
        $illnesses[] = array(
            "ILLNESS_ID" => $row['ILLNESS_ID'],
            "ILLNESS_NAME" => $row['ILLNESS_NAME'],
            "ILLNESS_SYMPTOMS" => $row['ILLNESS_SYMPTOMS'],
            "ILLNESS_STATUS" => $row['ILLNESS_STATUS'],
            "ILLNESS_DIAGNOSIS_DATE" => $row['ILLNESS_DIAGNOSIS_DATE'],
            "ILLNESS_NEXT_FOLLOW_UP_DATE" => $row['ILLNESS_NEXT_FOLLOW_UP_DATE'],
        );
    }

    // Return the data as JSON
    echo json_encode(array(
        "status" => "success",
        "message" => "Illness data fetched successfully",
        "total_count" => count($illnesses),
        "illnesses" => $illnesses
    ));
} else {
    echo json_encode(array("status" => "error", "message" => "No illness records found"));
}

// Close the statement and connection
$stmt_fetch_illness->close();
$conn_hayleys_medicalapp->close();

?>
