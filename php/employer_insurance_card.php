<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Include database connection
include('connect.php');

// Check if action is set in the POST request
if (isset($_POST['action']) && ($_POST['action'] == 'REVEAL' || $_POST['action'] == 'HIDE')) {
    // Get insurance_id and customer_id from POST request
    $insurance_id = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['insurance_id']);
    $customers_id = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_id']);

    // Ensure the data is being received correctly
    if (empty($insurance_id) || empty($customers_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Missing data (insurance_id or customers_id)']);
        exit;
    }

    // Fetch the current 'is_revealed' value from the database
    $sql = "SELECT is_revealed FROM customers_insurance WHERE insurance_id = ? AND customers_id = ?";
    if ($stmt = $conn_hayleys_medicalapp->prepare($sql)) {
        // Bind parameters
        $stmt->bind_param("ii", $insurance_id, $customers_id);
        // Execute the query
        if ($stmt->execute()) {
            // Get the result
            $stmt->store_result();
            if ($stmt->num_rows > 0) {
                // Bind the result to a variable
                $stmt->bind_result($current_is_revealed);
                $stmt->fetch();
                
                // Check if the current 'is_revealed' value matches the action
                if ($_POST['action'] == 'REVEAL' && $current_is_revealed == 0) {
                    // Set the 'is_revealed' value to 1 if it was previously 0
                    $is_revealed = 1;
                } elseif ($_POST['action'] == 'HIDE' && $current_is_revealed == 1) {
                    // Set the 'is_revealed' value to 0 if it was previously 1
                    $is_revealed = 0;
                } else {
                    // If no change needed, return an error message with current status
                    echo json_encode(['status' => 'error', 'message' => 'No change in is_revealed value', 'current_is_revealed' => $current_is_revealed]);
                    exit;
                }
                
                // Now update the 'is_revealed' field based on the action
                $update_sql = "UPDATE customers_insurance SET is_revealed = ? WHERE insurance_id = ? AND customers_id = ?";
                if ($update_stmt = $conn_hayleys_medicalapp->prepare($update_sql)) {
                    // Bind parameters for the update query
                    $update_stmt->bind_param("iii", $is_revealed, $insurance_id, $customers_id);
                    // Execute the query
                    if ($update_stmt->execute()) {
                        // Return a success response with the new 'is_revealed' status
                        echo json_encode(['status' => 'success', 'message' => 'Card updated successfully', 'is_revealed' => $is_revealed]);
                    } else {
                        // Return failure response if query execution fails
                        echo json_encode(['status' => 'error', 'message' => 'Failed to update the record']);
                    }
                    // Close update statement
                    $update_stmt->close();
                } else {
                    // Return failure response if query preparation fails
                    echo json_encode(['status' => 'error', 'message' => 'Failed to prepare update query']);
                }
            } else {
                // If no matching record found
                echo json_encode(['status' => 'error', 'message' => 'Record not found']);
            }
        } else {
            // Return failure response if query execution fails
            echo json_encode(['status' => 'error', 'message' => 'Failed to execute select query']);
        }
        // Close select statement
        $stmt->close();
    } else {
        // Return failure response if query preparation fails
        echo json_encode(['status' => 'error', 'message' => 'Failed to prepare select query']);
    }
} else {
    // Return an error if the action is not 'REVEAL' or 'HIDE'
    echo json_encode(['status' => 'error', 'message' => 'Invalid action']);
}

// Close the database connection
$conn_hayleys_medicalapp->close();
?>
