<?php

include "config.php";
include "response.php";

if ($_SERVER["REQUEST_METHOD"] != "POST") {
    sendResponse(false, "Invalid Request Method");
}

$user_id = intval($_POST["user_id"] ?? 0);

if ($user_id <= 0) {
    sendResponse(false, "Invalid User");
}


// Total Tasks
$total = 0;

$result = $conn->query(
    "SELECT COUNT(*) AS total
     FROM tasks
     WHERE user_id = $user_id"
);

if ($row = $result->fetch_assoc()) {
    $total = intval($row["total"]);
}


// Completed Tasks
$completed = 0;

$result = $conn->query(
    "SELECT COUNT(*) AS total
     FROM tasks
     WHERE user_id = $user_id
     AND status = 'Completed'"
);

if ($row = $result->fetch_assoc()) {
    $completed = intval($row["total"]);
}


// Pending Tasks
// Pending means:
// Not Started + In Progress
$pending = 0;

$result = $conn->query(
    "SELECT COUNT(*) AS total
     FROM tasks
     WHERE user_id = $user_id
     AND status IN ('Not Started', 'In Progress')"
);

if ($row = $result->fetch_assoc()) {
    $pending = intval($row["total"]);
}


// High Priority Tasks
$high = 0;

$result = $conn->query(
    "SELECT COUNT(*) AS total
     FROM tasks
     WHERE user_id = $user_id
     AND priority = 'High'"
);

if ($row = $result->fetch_assoc()) {
    $high = intval($row["total"]);
}


// Send response
sendResponse(true, "Success", [
    "total" => $total,
    "completed" => $completed,
    "pending" => $pending,
    "high" => $high
]);

$conn->close();

?>