<?php

mysqli_report(MYSQLI_REPORT_OFF);

$host = getenv("DB_HOST");
$dbname = getenv("DB_NAME") ?: "taskflow_pro";
$username = getenv("DB_USER");
$password = getenv("DB_PASSWORD");
$port = (int)(getenv("DB_PORT") ?: 4000);
$caPath = __DIR__ . "/../isrgrootx1.pem";

if (!$host || !$username || !$password || !$caPath) {
    error_log("Database configuration is incomplete.");
    http_response_code(500);
    exit(json_encode([
        "success" => false,
        "message" => "Server database configuration is incomplete"
    ]));
}

$conn = mysqli_init();

if (!$conn) {
    error_log("Could not initialize database connection.");
    http_response_code(500);
    exit(json_encode([
        "success" => false,
        "message" => "Database connection failed"
    ]));
}

$conn->options(MYSQLI_OPT_SSL_VERIFY_SERVER_CERT, true);
$conn->ssl_set(null, null, $caPath, null, null);

if (!$conn->real_connect(
    $host,
    $username,
    $password,
    $dbname,
    $port,
    null,
    MYSQLI_CLIENT_SSL
)) {
    error_log("Database connection failed: " . $conn->connect_error);
    http_response_code(500);
    exit(json_encode([
        "success" => false,
        "message" => "Database connection failed"
    ]));
}

$conn->set_charset("utf8mb4");

?>
