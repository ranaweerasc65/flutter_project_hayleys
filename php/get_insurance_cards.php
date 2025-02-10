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

// APPEAR PRIMARY USER INSURANCE CARDS FOR THE CONNECTIONS

$phoneQuery = "SELECT phone_no FROM customers WHERE CUSTOMERS_ID = ?";
$stmt = $conn_hayleys_medicalapp->prepare($phoneQuery);
$stmt->bind_param("i", $customerId);
$stmt->execute();
$result = $stmt->get_result();
$row = $result->fetch_assoc();
$phoneNumber = $row ? $row['phone_no'] : null;
$stmt->close();

if (!$phoneNumber) {
    echo json_encode(array("status" => "error", "message" => "Phone number not found for customer."));
    exit();
}

// Find the primary user's customer ID (relationship = 'ME')
$primaryUserQuery = "SELECT customers_id FROM customers WHERE phone_no = ? AND CUSTOMERS_RELATIONSHIP = 'ME'";
$stmt = $conn_hayleys_medicalapp->prepare($primaryUserQuery);
$stmt->bind_param("s", $phoneNumber);
$stmt->execute();
$result = $stmt->get_result();
$row = $result->fetch_assoc();
$primaryUserId = $row ? $row['customers_id'] : null;
$stmt->close();

if ($primaryUserId) {
//$sql = "SELECT insurance_id, insurance_company, insurance_card_holder_name, insurance_membership_no, insurance_policy_no FROM insurance WHERE CUSTOMERS_ID = ?";
$sql = "
    SELECT 
    ci.customers_id,
        i.insurance_id, 
        i.insurance_company, 
        i.insurance_card_holder_name, 
        i.insurance_membership_no, 
        i.insurance_policy_no,
         ci.is_revealed
    FROM insurance i
    INNER JOIN customers_insurance ci ON i.insurance_id = ci.insurance_id
    WHERE ci.customers_id = ? OR ci.customers_id = ?
";
$stmt = $conn_hayleys_medicalapp->prepare($sql);

if ($stmt) {
    // $stmt->bind_param("i", $customerId);
    $stmt->bind_param("ii", $customerId, $primaryUserId);
    $stmt->execute();
    $result = $stmt->get_result();

    $cards = [];
    while ($row = $result->fetch_assoc()) {
        $cards[] = $row;
    }

    if (!empty($cards)) {
        echo json_encode(array("status" => "success",  "primaryUserId" => $primaryUserId,"addedCards" => $cards));
    } else {
        echo json_encode(array("status" => "success", "primaryUserId" => $primaryUserId, "message" => "No cards found.", "addedCards" => []));
    }
} else {
    echo json_encode(array("status" => "error", "message" => "Failed to prepare SQL statement."));
}
}

?>
