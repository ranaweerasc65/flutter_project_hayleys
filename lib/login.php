<?php
include 'connect.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect data from POST request
    $email = $_POST['email'] ?? null;
    $password = $_POST['password'] ?? null;

    // Check if required fields are provided
    if (!$email || !$password) {
        echo json_encode(["status" => "error", "message" => "Missing required fields."]);
        exit();
    }

    // if (empty($email) || empty($password)) {
    //     echo json_encode(['status' => 'error', 'message' => 'Email and password are required.']);
    //     exit();
    // }

    // Fetch the hashed password from the database
    // $stmt = $conn->prepare("SELECT * FROM users WHERE email = ? AND password = ?");
    // $stmt->bind_param("ss", $email, $password);

    $stmt = $conn->prepare("SELECT * FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    // // Check if user exists
    // if ($result->num_rows > 0) {
    //     $user = $result->fetch_assoc();
    //     echo json_encode(['status' => 'success', 'user' => $user['user_name']]);
    // } else {
    //     echo json_encode(['status' => 'error', 'message' => 'Invalid email or password.']);
    // }

    // Check if user exists
    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        
        // Verify the entered password with the stored hashed password
        if (password_verify($password, $user['password'])) {
            echo json_encode(["status" => "success", "message" => "Login successful."]);
        } else {
            echo json_encode(["status" => "error", "message" => "Incorrect password."]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "User not found."]);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
}
?>
