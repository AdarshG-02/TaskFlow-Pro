
<?php

include "config.php";
include "response.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    sendResponse(false, "Invalid Request Method");
}

$user_id = intval($_POST["user_id"] ?? 0);
$transaction_date = trim($_POST["transaction_date"] ?? "");
$project = trim($_POST["project"] ?? "");
$client = trim($_POST["client"] ?? "");
$assigned_employee = trim($_POST["assigned_employee"] ?? "");
$title = trim($_POST["title"] ?? "");
$start_date = trim($_POST["start_date"] ?? "");
$end_date = trim($_POST["end_date"] ?? "");
$priority = trim($_POST["priority"] ?? "");
$status = trim($_POST["status"] ?? "");
$status_percentage = intval($_POST["status_percentage"] ?? 0);
$description = trim($_POST["description"] ?? "");

if ($user_id <= 0) {
    sendResponse(false, "Invalid User");
}

if ($title === "") {
    sendResponse(false, "Task title is required");
}

if ($status_percentage < 0 || $status_percentage > 100) {
    sendResponse(false, "Status percentage must be between 0 and 100");
}

try {
    // Explicit ID supports tables where id is not AUTO_INCREMENT.
    $id = random_int(1, 2147483647);

    $stmt = $conn->prepare(
        "INSERT INTO tasks (
            id, user_id, transaction_date, project, client,
            assigned_employee, title, start_date, end_date,
            priority, status, status_percentage, description
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
    );

    $types = "ii" . str_repeat("s", 9) . "is";

    $stmt->bind_param(
        $types,
        $id,
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

    $stmt->execute();

    $stmt->close();
    $conn->close();

    sendResponse(true, "Task added successfully", ["id" => $id]);

} catch (Throwable $e) {
    error_log("Add task error: " . $e->getMessage());

    sendResponse(false, "Unable to add task. Please check the task table and database configuration.");
}
?>
