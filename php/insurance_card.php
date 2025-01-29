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

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Handle DELETE request
    if (isset($_POST['action']) && $_POST['action'] === 'delete' && isset($_POST['insurance_id'])) {
        $insurance_id = intval($_POST['insurance_id']);

        // Prepare the DELETE query
        $sql = "DELETE FROM insurance WHERE INSURANCE_ID = ?";
        $stmt = $conn_hayleys_medicalapp->prepare($sql);

        if ($stmt === false) {
            echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
            exit();
        }

        // Bind the insurance_id parameter
        $stmt->bind_param("i", $insurance_id);

        // Execute the DELETE query
        if ($stmt->execute()) {
            echo json_encode(array("status" => "success", "message" => "Insurance card deleted successfully"));
        } else {
            echo json_encode(array("status" => "error", "message" => "Failed to delete insurance card: " . $stmt->error));
        }

        // Close the statement
        $stmt->close();
    } else {
        // Handle INSERT/UPDATE request (existing logic)
        $missingFields = [];
        $requiredFields = [
            'phone_no', 'customers_id', 'insurance_card_holder_name', 'insurance_membership_no', 'insurance_policy_no', 
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

        $phone_no = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['phone_no']);
        $customers_id = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_id']);
        $insurance_card_holder_name = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['insurance_card_holder_name']);
        $insurance_membership_no = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['insurance_membership_no']);
        $insurance_company = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['insurance_company']);
        $insurance_policy_no = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['insurance_policy_no']);

        $insurance_id = isset($_POST['insurance_id']) ? intval($_POST['insurance_id']) : null;

        if ($insurance_id) {
            // UPDATE query
            $sql = "UPDATE insurance SET 
                    phone_no = ?, customers_id = ?, insurance_card_holder_name = ?, insurance_membership_no = ?, 
                    insurance_policy_no = ?, insurance_company = ?
                    WHERE INSURANCE_ID = ?";

            $stmt = $conn_hayleys_medicalapp->prepare($sql);

            if ($stmt === false) {
                echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
                exit();
            }

            $stmt->bind_param(
                "sssssss",
                $phone_no,
                $customers_id,
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
            $sql = "INSERT INTO insurance (phone_no, customers_id, insurance_card_holder_name, insurance_membership_no, insurance_policy_no, insurance_company) 
                    VALUES (?, ?, ?, ?, ?, ?)";

            $stmt = $conn_hayleys_medicalapp->prepare($sql);

            if ($stmt === false) {
                echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
                exit();
            }

            $stmt->bind_param(
                "ssssss",
                $phone_no,
                $customers_id,
                $insurance_card_holder_name,
                $insurance_membership_no,
                $insurance_policy_no, 
                $insurance_company
            );

            if ($stmt->execute()) {
                $insurance_id = $conn_hayleys_medicalapp->insert_id;
                echo json_encode(array(
                    "status" => "success", 
                    "message" => "Insurance card details added successfully", 
                    "insurance_id" => $insurance_id
                ));
            } else {
                echo json_encode(array("status" => "error", "message" => "Failed to insert insurance card details: " . $stmt->error));
            }
        }

        // Close the statement
        $stmt->close();
    }
} else {
    echo json_encode(array("status" => "error", "message" => "Invalid request method"));
}

// Close the connection
$conn_hayleys_medicalapp->close();
?>