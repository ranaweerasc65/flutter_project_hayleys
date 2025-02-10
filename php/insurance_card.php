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
        // INSERT query for insurance table
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

            // Insert primary user's insurance record
            $sql2 = "INSERT INTO customers_insurance (customers_id, insurance_id, is_revealed) VALUES (?, ?, 0)";
            $stmt2 = $conn_hayleys_medicalapp->prepare($sql2);
            $stmt2->bind_param("si", $customers_id, $insurance_id);
            $stmt2->execute();
            $stmt2->close();


            // Check if the customer is the primary user
            $sql_check = "SELECT phone_no FROM customers WHERE customers_id = ? AND customers_relationship = 'Me'";
            $stmt_check = $conn_hayleys_medicalapp->prepare($sql_check);
            $stmt_check->bind_param("i", $customers_id);
            $stmt_check->execute();
            $result_check = $stmt_check->get_result();
            
            if ($result_check->num_rows > 0) {
                $row = $result_check->fetch_assoc();
                $phone_no = $row['phone_no'];

                // Get all connected customers
                $sql_connections = "SELECT customers_id FROM customers WHERE phone_no = ? AND customers_id != ?";
                $stmt_connections = $conn_hayleys_medicalapp->prepare($sql_connections);
                $stmt_connections->bind_param("si", $phone_no, $customers_id);
                $stmt_connections->execute();
                $result_connections = $stmt_connections->get_result();

                while ($row_conn = $result_connections->fetch_assoc()) {
                    $connected_customers_id = $row_conn['customers_id'];

                    // Insert the same insurance_id for the connected customers
                    $sql_insert = "INSERT INTO customers_insurance (customers_id, insurance_id, is_revealed) VALUES (?, ?,0)";
                    $stmt_insert = $conn_hayleys_medicalapp->prepare($sql_insert);
                    $stmt_insert->bind_param("si", $connected_customers_id, $insurance_id);
                    $stmt_insert->execute();
                    $stmt_insert->close();
                }

                $stmt_connections->close();
            }

            $stmt_check->close();

            echo json_encode(array(
                "status" => "success", 
                "message" => "Insurance card details added successfully and linked to customer & their connections", 
                "insurance_id" => $insurance_id
            ));
        } else {
            echo json_encode(array("status" => "error", "message" => "Failed to insert insurance card details: " . $stmt->error));
        }
    }

    $stmt->close();
} else {
    echo json_encode(array("status" => "error", "message" => "Invalid request method"));
}

// Handle request to get the 'is_revealed' value
if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['customers_id']) && isset($_GET['insurance_id'])) {
    $customers_id = intval($_GET['customers_id']);
    $insurance_id = intval($_GET['insurance_id']);

    // SQL query to fetch the 'is_revealed' value from the customers_insurance table
    $sql = "SELECT is_revealed FROM customers_insurance WHERE customers_id = ? AND insurance_id = ?";
    $stmt = $conn_hayleys_medicalapp->prepare($sql);
    
    if ($stmt === false) {
        echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
        exit();
    }

    $stmt->bind_param("ii", $customers_id, $insurance_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Fetch the result
        $row = $result->fetch_assoc();
        $is_revealed = $row['is_revealed'];

        // Return the 'is_revealed' value
        echo json_encode(array("status" => "success", "is_revealed" => $is_revealed));
    } else {
        echo json_encode(array("status" => "error", "message" => "No record found"));
    }

    $stmt->close();
    exit();
}


// Close the connection
$conn_hayleys_medicalapp->close();
?>
