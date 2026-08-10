<?php

include "config.php";
include "response.php";

if ($_SERVER["REQUEST_METHOD"] != "POST") {
    sendResponse(false, "Invalid Request Method");
}

$id = intval($_POST["id"] ?? 0);
$user_id = intval($_POST["user_id"] ?? 0);

if ($id <= 0 || $user_id <= 0) {
    sendResponse(false, "Invalid Request");
}

$stmt = $conn->prepare("
UPDATE tasks
SET status='Completed'
WHERE id=? AND user_id=?
");

$stmt->bind_param("ii", $id, $user_id);

if ($stmt->execute()) {
    sendResponse(true, "Task marked as completed");
} else {
    sendResponse(false, "Failed to update task");
}

$stmt->close();
$conn->close();

?>