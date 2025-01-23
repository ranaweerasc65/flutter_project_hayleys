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

$customerId = isset($_GET['customers_id']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_GET['customers_id']) : null;

if (!$customerId) {
    echo json_encode(array("status" => "error", "message" => "Missing or invalid customer ID."));
    exit();
}

$sql = "SELECT insurance_company, insurance_card_holder_name, insurance_membership_no, insurance_policy_no FROM insurance WHERE CUSTOMERS_ID = ?";
$stmt = $conn_hayleys_medicalapp->prepare($sql);

if ($stmt) {
    $stmt->bind_param("i", $customerId);
    $stmt->execute();
    $result = $stmt->get_result();

    $cards = [];
    while ($row = $result->fetch_assoc()) {
        $cards[] = $row;
    }

    if (!empty($cards)) {
        echo json_encode(array("status" => "success", "addedCards" => $cards));
    } else {
        echo json_encode(array("status" => "success", "message" => "No cards found.", "addedCards" => []));
    }
} else {
    echo json_encode(array("status" => "error", "message" => "Failed to prepare SQL statement."));
}
?>
