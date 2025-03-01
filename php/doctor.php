<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
include('connect.php');

if ($conn_hayleys_medicalapp->connect_error) {
    echo json_encode(array("status" => "error", "message" => "Database connection failed: " . $conn_hayleys_medicalapp->connect_error));
    exit();
}

if (isset($_POST['action']) && $_POST['action'] === 'delete' && isset($_POST['doctor_id'])) {
    $doctor_id = intval($_POST['doctor_id']);

    $sql = "DELETE FROM doctor WHERE doctor_id = ?";
    $stmt = $conn_hayleys_medicalapp->prepare($sql);

    if ($stmt === false) {
        echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
        exit();
    }

    $stmt->bind_param("i", $doctor_id);

    if ($stmt->execute()) {
        echo json_encode(array("status" => "success", "message" => "Doctor record deleted successfully"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to delete doctor record: " . $stmt->error));
    }

    $stmt->close();
    $conn_hayleys_medicalapp->close();
    exit();
}

$missingFields = [];

$requiredFields = [
    'illness_id', 'doctor_name', 'doctor_specialization', 
    'doctor_contact_number', 'doctor_hospital_name', 'customers_id'
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

$doctor_name = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['doctor_name']);
$doctor_specialization = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['doctor_specialization']);
$doctor_contact_number = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['doctor_contact_number']);
$doctor_hospital_name = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['doctor_hospital_name']);
$customers_id = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['customers_id']); 
$illness_id = mysqli_real_escape_string($conn_hayleys_medicalapp, $_POST['illness_id']); 

$doctor_id = isset($_POST['doctor_id']) ? intval($_POST['doctor_id']) : null;

if ($doctor_id) {
    
    $sql = "UPDATE doctor SET 
            illness_id = ?, doctor_name = ?, doctor_specialization = ?, 
            doctor_contact_number = ?, doctor_hospital_name = ?, customers_id = ?
            WHERE doctor_id = ?";

    $stmt = $conn_hayleys_medicalapp->prepare($sql);

    if ($stmt === false) {
        echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
        exit();
    }

    $stmt->bind_param(
        "ssssssi",
        $illness_id,
        $doctor_name,
        $doctor_specialization,
        $doctor_contact_number,
        $doctor_hospital_name,
        $customers_id, 
        $doctor_id
    );

    if ($stmt->execute()) {
        echo json_encode(array("status" => "success", "message" => "Doctor details updated successfully", "doctor_id" => $doctor_id));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to update doctor details: " . $stmt->error));
    }
} else {
    // Insert new doctor record
    $sql = "INSERT INTO doctor (illness_id, doctor_name, doctor_specialization, doctor_contact_number, doctor_hospital_name, customers_id) 
        VALUES (?, ?, ?, ?, ?, ?)";

    $stmt = $conn_hayleys_medicalapp->prepare($sql);

    if ($stmt === false) {
        echo json_encode(array("status" => "error", "message" => "Error preparing SQL statement: " . $conn_hayleys_medicalapp->error));
        exit();
    }

    $stmt->bind_param(
        "sssssi",
        $illness_id,
        $doctor_name,
        $doctor_specialization,
        $doctor_contact_number,
        $doctor_hospital_name,
        $customers_id 
    );

    if ($stmt->execute()) {
        $doctor_id = $conn_hayleys_medicalapp->insert_id;
        echo json_encode(array(
            "status" => "success", 
            "message" => "Doctor details added successfully", 
            "doctor_id" => $doctor_id
        ));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to insert doctor details: " . $stmt->error));
    }
}

$stmt->close();
$conn_hayleys_medicalapp->close();
?>
