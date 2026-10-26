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
$password = trim($_POST["password"] ?? "");

// Check if fields are empty
if ($full_name == "" || $email == "" || $password == "") {
    sendResponse(false, "All fields are required");
}

// Check if email already exists
$stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    sendResponse(false, "Email already exists");
}

$stmt->close();

// Hash password
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

// Insert new user
$stmt = $conn->prepare(
    "INSERT INTO users (full_name, email, password) VALUES (?, ?, ?)"
);

$stmt->bind_param(
    "sss",
    $full_name,
    $email,
    $hashedPassword
);

if ($stmt->execute()) {
    sendResponse(true, "Account created successfully");
} else {
    error_log("Registration insert failed: " . $stmt->error);
    sendResponse(false, "Registration failed");
}

$stmt->close();
$conn->close();

?>