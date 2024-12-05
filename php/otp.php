<?php 
include('connect.php');

$phone_no = mysqli_real_escape_string($conn_hayleys_medicalapp,$_POST['phoneno']);

// Check if the phone number already exists
$sql = "SELECT * FROM users WHERE phone_no = ?";
$stmt = $conn_hayleys_medicalapp->prepare($sql);
$stmt->bind_param("s", $phone_no);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {

    $row = $result->fetch_assoc();
    $user_id = $row['id'];

    // Phone number exists, return success for login
    echo json_encode(array(
        "status"=> "exists",  
    "user_id" => $user_id, 
    "message" => "Phone number exists. Proceed to login"));
    error_log("Phone number $phone_no exists in the database.");
} else {

    $insert_sql = "INSERT INTO users (phone_no) VALUES (?)";
    $insert_stmt = $conn_hayleys_medicalapp->prepare($insert_sql);
    $insert_stmt->bind_param("s", $phone_no);

    if ($insert_stmt->execute()) {
        
        $last_id = $conn_hayleys_medicalapp->insert_id;

        echo json_encode(array(
            "status" => "not_exists", 
            "user_id" => $last_id,
            "message" => "Phone number registered successfully"));
        error_log("Phone number $phone_no added to the database.");
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to register phone number"));
        error_log("Failed to add phone number $phone_no to the database. Error: " . $insert_stmt->error);
    }

    $insert_stmt->close();
}

$stmt->close();
$conn_hayleys_medicalapp->close();
?>
