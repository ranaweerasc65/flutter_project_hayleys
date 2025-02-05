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

// Handle DELETE request first
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'delete' && isset($_POST['insurance_id'])) {
    $insurance_id = intval($_POST['insurance_id']);

    // Start a transaction
    $conn_hayleys_medicalapp->begin_transaction();

    try {
        // Delete from customers_insurance first
        $sql1 = "DELETE FROM customers_insurance WHERE insurance_id = ?";
        $stmt1 = $conn_hayleys_medicalapp->prepare($sql1);
        $stmt1->bind_param("i", $insurance_id);
        $stmt1->execute();
        $stmt1->close();

        // Delete from insurance table
        $sql2 = "DELETE FROM insurance WHERE INSURANCE_ID = ?";
        $stmt2 = $conn_hayleys_medicalapp->prepare($sql2);
        $stmt2->bind_param("i", $insurance_id);
        $stmt2->execute();
        $stmt2->close();

        // Commit transaction
        $conn_hayleys_medicalapp->commit();
        echo json_encode(array("status" => "success", "message" => "Insurance card deleted successfully"));
        exit(); // Stop further execution
    } catch (Exception $e) {
        // Rollback transaction in case of error
        $conn_hayleys_medicalapp->rollback();
        echo json_encode(array("status" => "error", "message" => "Failed to delete insurance card: " . $e->getMessage()));
        exit();
    }
}

// Now check for required fields for insert/update operations
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $missingFields = [];
    $requiredFields = [
        'customers_id', 'insurance_card_holder_name', 'insurance_membership_no', 'insurance_policy_no', 
        'insurance_company'
    ];

    foreach ($requiredFields as $field) {
        if (!isset($_POST[$field])) {
            $missingFields[] = $field;
        }
    }

    if (!empty($missingFields)) {
        echo json_encode(array("status" => "error", "message" => "Required fields are missing", "missing_fields" => $missingFields));
        exit();
    }

    $customers_id = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_id']);
    $insurance_card_holder_name = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['insurance_card_holder_name']);
    $insurance_membership_no = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['insurance_membership_no']);
    $insurance_policy_no = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['insurance_policy_no']);
    $insurance_company = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['insurance_company']);

    $insurance_id = isset($_POST['insurance_id']) ? intval($_POST['insurance_id']) : null;

    if ($insurance_id) {
        // UPDATE query
        $sql = "UPDATE insurance SET 
                insurance_card_holder_name = ?, insurance_membership_no = ?, 
                insurance_policy_no = ?, insurance_company = ?
                WHERE INSURANCE_ID = ?";

        $stmt = $conn_hayleys_medicalapp->prepare($sql);

        if ($stmt === false) {
            echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
            exit();
        }

        $stmt->bind_param("ssssi",
           
            $insurance_card_holder_name,
            $insurance_membership_no,
            $insurance_policy_no, 
            $insurance_company,
            $insurance_id
        );

        if ($stmt->execute()) {
            echo json_encode(array("status" => "success", "message" => "Insurance card details updated successfully", "insurance_id" => $insurance_id));
        } else {
            echo json_encode(array("status" => "error", "message" => "Failed to update insurance card details: " . $stmt->error));
        }
    } else {
        // INSERT query
        $sql = "INSERT INTO insurance (insurance_card_holder_name, insurance_membership_no, insurance_policy_no, insurance_company) 
                VALUES (?, ?, ?, ?)";

        $stmt = $conn_hayleys_medicalapp->prepare($sql);

        if ($stmt === false) {
            echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
            exit();
        }

        $stmt->bind_param("ssss",
           
            $insurance_card_holder_name,
            $insurance_membership_no,
            $insurance_policy_no, 
            $insurance_company
        );

        if ($stmt->execute()) {
            $insurance_id = $conn_hayleys_medicalapp->insert_id;

            // Insert into customers_insurance table
            $sql2 = "INSERT INTO customers_insurance (customers_id, insurance_id) VALUES (?, ?)";
            $stmt2 = $conn_hayleys_medicalapp->prepare($sql2);

            if ($stmt2 === false) {
                echo json_encode(array("status" => "error", "message" => "Error preparing SQL for customers_insurance: " . $conn_hayleys_medicalapp->error));
                exit();
            }

            $stmt2->bind_param("si", $customers_id, $insurance_id);
            
            if ($stmt2->execute()) {
                echo json_encode(array(
                    "status" => "success", 
                    "message" => "Insurance card details added successfully and linked to customer", 
                    "insurance_id" => $insurance_id
                ));
            } else {
                echo json_encode(array("status" => "error", "message" => "Failed to link insurance to customer: " . $stmt2->error));
            }

            $stmt2->close();
        } else {
            echo json_encode(array("status" => "error", "message" => "Failed to insert insurance card details: " . $stmt->error));
        }
    }

    // Close statements
    $stmt->close();
} else {
    echo json_encode(array("status" => "error", "message" => "Invalid request method"));
}

// Close the connection
$conn_hayleys_medicalapp->close();
?>
