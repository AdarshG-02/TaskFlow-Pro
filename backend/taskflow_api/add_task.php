<?php

include "config.php";
include "response.php";

// Allow only POST requests
if ($_SERVER["REQUEST_METHOD"] != "POST") {
    sendResponse(false, "Invalid Request Method");
}

// Get data from Flutter
$user_id = intval($_POST["user_id"] ?? 0);

$transaction_date = trim($_POST["transaction_date"] ?? "");
$project = trim($_POST["project"] ?? "");
$client = trim($_POST["client"] ?? "");
$assigned_employee = trim($_POST["assigned_employee"] ?? "");

$title = trim($_POST["title"] ?? "");

$start_date = trim($_POST["start_date"] ?? "");
$end_date = trim($_POST["end_date"] ?? "");

$priority = trim($_POST["priority"] ?? "Medium");
$status = trim($_POST["status"] ?? "Not Started");

$status_percentage = intval($_POST["status_percentage"] ?? 0);

$description = trim($_POST["description"] ?? "");


// Validation
if ($user_id <= 0) {
    sendResponse(false, "Invalid user");
}

if ($title == "") {
    sendResponse(false, "Task title is required");
}

// Validate priority
$allowed_priorities = ["High", "Medium", "Low"];

if (!in_array($priority, $allowed_priorities)) {
    sendResponse(false, "Invalid priority");
}

// Validate status
$allowed_statuses = ["Not Started", "In Progress", "Completed"];

if (!in_array($status, $allowed_statuses)) {
    sendResponse(false, "Invalid status");
}

// Validate percentage
if ($status_percentage < 0 || $status_percentage > 100) {
    sendResponse(false, "Status percentage must be between 0 and 100");
}


// Insert task
$stmt = $conn->prepare(
    "INSERT INTO tasks
    (
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
        description
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
);


$stmt->bind_param(
    "isssssssssis",
    $user_id,
    $transaction_date,
    $project,
    $client,
    $assigned_employee,
    $title,
    $start_date,
    $end_date,
    $priority,
    $status,
    $status_percentage,
    $description
);


if ($stmt->execute()) {

    sendResponse(true, "Task added successfully");

} else {

    sendResponse(false, "Failed to add task");

}


$stmt->close();
$conn->close();

?>