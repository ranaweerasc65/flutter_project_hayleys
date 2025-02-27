<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

include('connect.php');
$customer_id = isset($_GET['customer_id']) ? intval($_GET['customer_id']) : 0;

if ($customer_id == 0) {
    echo json_encode(array("status" => "error", "message" => "Customer ID is missing or invalid"));
    exit();
}

// Query to fetch illness count and illness IDs
$sql_illness = "SELECT illness_id FROM illnesses WHERE CUSTOMERS_ID = ?";
$stmt_illness = $conn_hayleys_medicalapp->prepare($sql_illness);

if (!$stmt_illness) {
    echo json_encode(array("status" => "error", "message" => "Failed to prepare SQL statement"));
    exit();
}

$stmt_illness->bind_param("i", $customer_id);
$stmt_illness->execute();
$result_illness = $stmt_illness->get_result();

$illness_ids = [];
$illness_count = 0;

while ($row = $result_illness->fetch_assoc()) {
    $illness_ids[] = $row['illness_id'];  // Collect illness IDs
    $illness_count++;  // Count illnesses
}

echo json_encode(array(
    "status" => "success",
    "illness_count" => $illness_count,
    "illness_ids" => $illness_ids
));

$stmt_illness->close();
$conn_hayleys_medicalapp->close();

?>
