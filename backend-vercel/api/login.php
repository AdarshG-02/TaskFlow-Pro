<?php

include "config.php";
include "response.php";

// Allow only POST requests
if ($_SERVER["REQUEST_METHOD"] != "POST") {
    sendResponse(false, "Invalid Request Method");
}

// Get data from Flutter
$email = trim($_POST["email"] ?? "");
$password = trim($_POST["password"] ?? "");

// Check empty fields
if ($email == "" || $password == "") {
    sendResponse(false, "Email and password are required");
}

// Find user
$stmt = $conn->prepare(
    "SELECT id, full_name, email, password FROM users WHERE email = ?"
);

$stmt->bind_param("s", $email);
$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows == 0) {
    sendResponse(false, "User not found");
}

$user = $result->fetch_assoc();

// Verify password
if (password_verify($password, $user["password"])) {

    sendResponse(true, "Login successful", [
        "user_id" => $user["id"],
        "full_name" => $user["full_name"],
        "email" => $user["email"]
    ]);

} else {

    sendResponse(false, "Invalid password");

}

$stmt->close();
$conn->close();

?>
