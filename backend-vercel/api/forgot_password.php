
<?php
include "config.php";
include "response.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    sendResponse(false, "Invalid Request Method");
}

$email = trim($_POST["email"] ?? "");
$new_password = $_POST["new_password"] ?? "";

if ($email === "" || $new_password === "") {
    sendResponse(false, "All fields are required");
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    sendResponse(false, "Invalid email address");
}

if (strlen($new_password) < 8) {
    sendResponse(false, "Password must be at least 8 characters");
}

// Check whether the account exists.
$stmt = $conn->prepare(
    "SELECT id FROM users WHERE email = ?"
);

if (!$stmt) {
    sendResponse(false, "Database error");
}

$stmt->bind_param("s", $email);
$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows === 0) {
    $stmt->close();
    $conn->close();
    sendResponse(false, "Email not registered");
}

$stmt->close();

// Hash the new password.
$hashedPassword = password_hash(
    $new_password,
    PASSWORD_DEFAULT
);

// Update the password.
$update = $conn->prepare(
    "UPDATE users SET password = ? WHERE email = ?"
);

if (!$update) {
    $conn->close();
    sendResponse(false, "Database error");
}

$update->bind_param("ss", $hashedPassword, $email);

if ($update->execute()) {
    $update->close();
    $conn->close();
    sendResponse(true, "Password reset successfully");
}

$update->close();
$conn->close();
sendResponse(false, "Failed to reset password");
