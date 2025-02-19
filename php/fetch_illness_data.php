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

$sql_fetch_illness = "SELECT 
                          ILLNESS_ID, 
                          ILLNESS_NAME, 
                          ILLNESS_SYMPTOMS, 
                          ILLNESS_STATUS, 
                          ILLNESS_DIAGNOSIS_DATE, 
                          ILLNESS_NEXT_FOLLOW_UP_DATE
                      FROM illnesses
                      WHERE CUSTOMERS_ID = ?";
$stmt_fetch_illness = $conn_hayleys_medicalapp->prepare($sql_fetch_illness);

if (!$stmt_fetch_illness) {
    echo json_encode(array("status" => "error", "message" => "Failed to prepare SQL statement"));
    exit();
}

$stmt_fetch_illness->bind_param("s", $customer_id);
$stmt_fetch_illness->execute();
$result_fetch_illness = $stmt_fetch_illness->get_result();

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

    echo json_encode(array(
        "status" => "success",
        "message" => "Illness data fetched successfully",
        "total_count" => count($illnesses),
        "illnesses" => $illnesses
    ));
} else {
    echo json_encode(array("status" => "error", "message" => "No illness records found"));
}

$stmt_fetch_illness->close();
$conn_hayleys_medicalapp->close();

?>
