<?php

include "config.php";
include "response.php";

if ($_SERVER["REQUEST_METHOD"] != "POST") {
    sendResponse(false, "Invalid Request Method");
}

$email = trim($_POST["email"] ?? "");
$new_password = trim($_POST["new_password"] ?? "");

if ($email == "" || $new_password == "") {
    sendResponse(false, "All fields are required");
}


// Check email exists

$stmt = $conn->prepare(
    "SELECT id FROM users WHERE email=?"
);

$stmt->bind_param(
    "s",
    $email
);

$stmt->execute();

$result = $stmt->get_result();


if ($result->num_rows == 0) {

    sendResponse(false, "Email not registered");

}


// Hash password

$hashedPassword = password_hash(
    $new_password,
    PASSWORD_DEFAULT
);


// Update password

$update = $conn->prepare(
    "UPDATE users SET password=? WHERE email=?"
);

$update->bind_param(
    "ss",
    $hashedPassword,
    $email
);


if ($update->execute()) {

    sendResponse(
        true,
        "Password reset successfully"
    );

} else {

    sendResponse(
        false,
        "Failed to reset password"
    );

}


$stmt->close();
$update->close();
$conn->close();

?>