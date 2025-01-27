<?php
// Enable error reporting for debugging<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Include database connection
include('connect.php');

// Get the insurance ID from the GET request

$insurance_id = isset($_GET['INSURANCE_ID']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_GET['INSURANCE_ID']) : null;

// Check if insurance ID is provided
if (!$insurance_id) {
    echo json_encode(array("status" => "error", "message" => "Insurance ID is missing"));
    exit();
}

// SQL query to fetch the insurance details by ID
$sql_fetch = "SELECT * FROM insurance WHERE INSURANCE_ID = ?";
$stmt_fetch = $conn_hayleys_medicalapp->prepare($sql_fetch);
$stmt_fetch->bind_param("i", $insurance_id);
$stmt_fetch->execute();
$result_fetch = $stmt_fetch->get_result();

// Check if a insurance card is found
if ($result_fetch->num_rows > 0) {
    $insurance = $result_fetch->fetch_assoc();
    echo json_encode(array(
        "status" => "success",
        "message" => "Insurance details fetched successfully",
        "insurance_data" => $insurance
    ));
} else {
    echo json_encode(array("status" => "error", "message" => "Insurance not found"));
}

// Close the statement and connection
$stmt_fetch->close();
$conn_hayleys_medicalapp->close();
?>

