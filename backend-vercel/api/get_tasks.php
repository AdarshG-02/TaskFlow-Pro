<?php

include "config.php";
include "response.php";

// Allow only POST requests
if ($_SERVER["REQUEST_METHOD"] != "POST") {
    sendResponse(false, "Invalid Request Method");
}

// Get user id
$user_id = intval($_POST["user_id"] ?? 0);

if ($user_id <= 0) {
    sendResponse(false, "Invalid User");
}

// Get tasks
$stmt = $conn->prepare(
    "SELECT
        id,
        user_id,
        transaction_date,
        project,
        client,
        assigned_employee,
        title,
        start_date,
        end_date,
        priority,
        status,
        status_percentage,
        description,
        created_at
     FROM tasks
     WHERE user_id = ?
     ORDER BY created_at DESC"
);

$stmt->bind_param("i", $user_id);

$stmt->execute();

$result = $stmt->get_result();

$tasks = [];

while ($row = $result->fetch_assoc()) {
    $tasks[] = $row;
}

sendResponse(true, "Tasks loaded successfully", $tasks);

$stmt->close();
$conn->close();

?>