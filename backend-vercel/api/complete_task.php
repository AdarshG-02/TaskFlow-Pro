
<?php
include "config.php";
include "response.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    sendResponse(false, "Invalid Request Method");
}

$id = intval($_POST["id"] ?? 0);
$user_id = intval($_POST["user_id"] ?? 0);

if ($id <= 0 || $user_id <= 0) {
    sendResponse(false, "Invalid Request");
}

try {
    $stmt = $conn->prepare(
        "UPDATE tasks
         SET status = 'Completed',
             status_percentage = 100
         WHERE id = ? AND user_id = ?"
    );

    $stmt->bind_param("ii", $id, $user_id);
    $stmt->execute();

    if ($stmt->affected_rows === 0) {
        $check = $conn->prepare(
            "SELECT id FROM tasks WHERE id = ? AND user_id = ?"
        );
        $check->bind_param("ii", $id, $user_id);
        $check->execute();
        $check->store_result();
        $exists = $check->num_rows > 0;
        $check->close();

        if (!$exists) {
            $stmt->close();
            $conn->close();
            sendResponse(false, "Task not found");
        }
    }

    $stmt->close();
    $conn->close();
    sendResponse(true, "Task completed successfully");

} catch (Throwable $e) {
    error_log("Complete task error: " . $e->getMessage());
    sendResponse(false, "Unable to complete task");
}
?>
