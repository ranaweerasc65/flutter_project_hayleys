<?php
// Include the database connection
include 'connect.php'; // Ensure this file sets up a valid `$conn`

header('Content-Type: application/json'); // Set response type to JSON

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Collect data from POST request
    $username = $_POST['username'] ?? null;
    $password = $_POST['password'] ?? null;
    $email = $_POST['email'] ?? null;

    if (!$username || !$password || !$email) {
        echo json_encode(["status" => "error", "message" => "Missing required fields."]);
        exit();
    }

    // Hash the password
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);

    // Insert the new user
    $stmt = $conn->prepare("INSERT INTO users (user_name, password, email) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $username, $hashed_password, $email);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Registration successful."]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to register user."]);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method."]);
}
?>
