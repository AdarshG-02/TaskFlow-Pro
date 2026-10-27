```php
<?php

include "config.php";
include "response.php";

// Allow only POST requests
if ($_SERVER["REQUEST_METHOD"] != "POST") {
    sendResponse(false, "Invalid Request Method");
}

// Get data from Flutter
$full_name = trim($_POST["full_name"] ?? "");
$email = trim($_POST["email"] ?? "");
$password = $_POST["password"] ?? "";

// Check if fields are empty
if ($full_name == "" || $email == "" || trim($password) == "") {
    sendResponse(false, "All fields are required");
}

// Check if email already exists
$stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $stmt->close();
    sendResponse(false, "Email already exists");
}
$stmt->close();

// Hash password
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

// Generate a positive 32-bit integer ID.
// The primary key prevents duplicate IDs; retry on a collision.
$maxAttempts = 5;
$inserted = false;

for ($attempt = 0; $attempt < $maxAttempts; $attempt++) {
    $id = random_int(1, 2147483647);

    $stmt = $conn->prepare(
        "INSERT INTO users (id, full_name, email, password)
         VALUES (?, ?, ?, ?)"
    );

    $stmt->bind_param(
        "isss",
        $id,
        $full_name,
        $email,
        $hashedPassword
    );

    if ($stmt->execute()) {
        $inserted = true;
        $stmt->close();
        break;
    }

    $errno = $stmt->errno;
    $error = $stmt->error;
    $stmt->close();

    // Retry only if the generated primary key collided.
    if ($errno == 1062) {
        $check = $conn->prepare("SELECT id FROM users WHERE id = ?");
        $check->bind_param("i", $id);
        $check->execute();
        $idResult = $check->get_result();
        $idExists = $idResult->num_rows > 0;
        $check->close();

        if ($idExists) {
            continue;
        }
    }

    error_log("Registration insert failed: " . $error);
    sendResponse(false, "Registration failed");
}

if ($inserted) {
    sendResponse(true, "Account created successfully");
}

error_log("Registration failed after ID generation retries");
sendResponse(false, "Registration failed. Please try again.");


```