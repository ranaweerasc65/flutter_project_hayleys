<?php
// Include the database connection file
include('connect.php');

header('Content-Type: application/json');

// Check if phone number is passed via POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the phone number from POST data
    $phone_number = isset($_POST['phone_no']) ? $_POST['phone_no'] : null;

    if (!$phone_number) {
        echo json_encode(['error' => 'Phone number is required']);
        exit();
    }

    try {
        // Query to fetch the name based on phone number
        $stmt = $pdo->prepare("SELECT name FROM users WHERE phone_no = :phone_no");
        $stmt->bindParam(':phone_no', $phone_number);
        $stmt->execute();

        // Fetch the result
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($result) {
            // Return the name as JSON
            echo json_encode(['name' => $result['name']]);
        } else {
            echo json_encode(['error' => 'User not found']);
        }
    } catch (PDOException $e) {
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['error' => 'Invalid request method']);
}
?>
