```php
<?php

error_reporting(E_ALL);
ini_set('display_errors', 0);

header("Content-Type: application/json");

include "config.php";

if ($conn->connect_error) {
    http_response_code(500);

    echo json_encode([
        "success" => false,
        "message" => "Database connection failed"
    ]);

    exit();
}

echo json_encode([
    "success" => true,
    "message" => "Database Connected Successfully"
]);

?>
```