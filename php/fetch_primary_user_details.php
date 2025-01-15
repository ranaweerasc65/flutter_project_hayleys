<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Include database connection
include('connect.php');

$phone_no = isset($_GET['phone_no']) ? mysqli_real_escape_string($conn_hayleys_medicalapp, $_GET['phone_no']) : null;

if (!$phone_no) {
    echo json_encode(array("status" => "error", "message" => "Phone number is missing"));
    exit();
}

$sql_fetch = "SELECT * FROM customers WHERE phone_no = ? AND customers_relationship = 'ME'";
$stmt_fetch = $conn_hayleys_medicalapp->prepare($sql_fetch);
$stmt_fetch->bind_param("s", $phone_no);
$stmt_fetch->execute();
$result_fetch = $stmt_fetch->get_result();

if ($result_fetch->num_rows > 0) {
    $customer = $result_fetch->fetch_assoc();
        echo json_encode(array(
            "status" => "success",
            "message" => "Customer fetched successfully",
            "existing_data" => $customer
        ));
} else {
    echo json_encode(array("status" => "error", "message" => "Customer not found"));
}

$stmt_fetch->close();
        


// Close the connection
$conn_hayleys_medicalapp->close();
?>
