<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
include('connect.php');

if ($conn_hayleys_medicalapp->connect_error) {
    echo json_encode(array("status" => "error", "message" => "Database connection failed: " . $conn_hayleys_medicalapp->connect_error));
    exit();
}



// Check for 'action' parameter to identify the operation (add/update/delete)
if (isset($_POST['action']) && $_POST['action'] === 'delete' && isset($_POST['illness_id'])) {
    $illness_id = intval($_POST['illness_id']);

    // Prepare DELETE SQL statement
    $sql = "DELETE FROM illnesses WHERE illness_id = ?";
    $stmt = $conn_hayleys_medicalapp->prepare($sql);

    if ($stmt === false) {
        echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
        exit();
    }

    // Bind illness_id to the prepared statement
    $stmt->bind_param("i", $illness_id);

    if ($stmt->execute()) {
        echo json_encode(array("status" => "success", "message" => "Illness record deleted successfully"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to delete illness record: " . $stmt->error));
    }

    $stmt->close();
    $conn_hayleys_medicalapp->close();
    exit();
}

$missingFields = [];

$requiredFields = [
    'customers_id', 'illness_name', 'illness_symptoms', 
    'illness_status', 'illness_diagnosis_date', 'illness_next_follow_up_date'
];

foreach ($requiredFields as $field) {
    if (!isset($_POST[$field]) || empty($_POST[$field])) {
        $missingFields[] = $field;
    }
}

if (!empty($missingFields)) {
    echo json_encode(array("status" => "error", "message" => "Required fields are missing", "missing_fields" => $missingFields));
    exit();
}

$customers_id = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_id']);

$illness_name = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['illness_name']);
$illness_symptoms = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['illness_symptoms']);
$illness_status = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['illness_status']);

$illness_diagnosis_date = !empty($_POST['illness_diagnosis_date']) ? $_POST['illness_diagnosis_date'] : null;
$illness_next_follow_up_date = !empty($_POST['illness_next_follow_up_date']) ? $_POST['illness_next_follow_up_date'] : null;

if ($illness_diagnosis_date) {
    $diagnosis_date_obj = DateTime::createFromFormat('Y-m-d', $illness_diagnosis_date);
    if (!$diagnosis_date_obj) {
        echo json_encode(array("status" => "error", "message" => "Incorrect date format for illness_diagnosis_date"));
        exit();
    }
}

if ($illness_next_follow_up_date) {
    $follow_up_date_obj = DateTime::createFromFormat('Y-m-d', $illness_next_follow_up_date);
    if (!$follow_up_date_obj) {
        echo json_encode(array("status" => "error", "message" => "Incorrect date format for illness_next_follow_up_date"));
        exit();
    }
}

$illness_id = isset($_POST['illness_id']) ? intval($_POST['illness_id']) : null;

if ($illness_id) {
    
    $sql = "UPDATE illnesses SET 
            customers_id = ?,  illness_name = ?, illness_symptoms = ?, 
            illness_status = ?, illness_diagnosis_date = ?, illness_next_follow_up_date = ?
            WHERE illness_id = ?";

    $stmt = $conn_hayleys_medicalapp->prepare($sql);

    if ($stmt === false) {
        echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
        exit();
    }

    $stmt->bind_param(
        "ssssssi",
        $customers_id,
      
        $illness_name,
        $illness_symptoms,
        $illness_status,
        $illness_diagnosis_date,
        $illness_next_follow_up_date,
        $illness_id
    );

    if ($stmt->execute()) {
        echo json_encode(array("status" => "success", "message" => "Illness details updated successfully","illness_id"=>$illness_id));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to update illness details: " . $stmt->error));
    }
} else {
 
    $sql = "INSERT INTO illnesses (customers_id, illness_name, illness_symptoms, illness_status, illness_diagnosis_date, illness_next_follow_up_date) 
        VALUES (?, ?, ?,  ?, ?, ?)";

    $stmt = $conn_hayleys_medicalapp->prepare($sql);

    if ($stmt === false) {
        echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
        exit();
    }

    $stmt->bind_param(
        "ssssss",
        $customers_id,
        $illness_name,
        $illness_symptoms,
        $illness_status,
        $illness_diagnosis_date,
        $illness_next_follow_up_date
    );

    if ($stmt->execute()) {
        $illness_id = $conn_hayleys_medicalapp->insert_id;
        echo json_encode(array(
            "status" => "success", 
            "message" => "Illness details added successfully", 
            "illness_id" => $illness_id
        ));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to insert illness details: " . $stmt->error));
    }
}

$stmt->close();
$conn_hayleys_medicalapp->close();
?>
