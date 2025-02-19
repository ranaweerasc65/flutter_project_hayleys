<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

include('connect.php');
$customer_id = isset($_GET['customer_id']) ? intval($_GET['customer_id']) : 0;

if ($customer_id == 0) {
    echo json_encode(array("status" => "error", "message" => "Customer ID is missing or invalid"));
    exit();
}

$sql_count = "SELECT COUNT(*) AS illness_count FROM illnesses WHERE CUSTOMERS_ID = ?";
$stmt_count = $conn_hayleys_medicalapp->prepare($sql_count);

if (!$stmt_count) {
    echo json_encode(array("status" => "error", "message" => "Failed to prepare SQL statement"));
    exit();
}

$stmt_count->bind_param("i", $customer_id);
$stmt_count->execute();
$result_count = $stmt_count->get_result();


if ($row = $result_count->fetch_assoc()) {
    echo json_encode(array("status" => "success", "illness_count" => $row['illness_count']));
} else {
    echo json_encode(array("status" => "error", "message" => "Failed to fetch illness count"));
}

$stmt_count->close();
$conn_hayleys_medicalapp->close();

?>
