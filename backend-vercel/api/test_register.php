```php
<?php
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Test</title>
</head>
<body>

<h2>Test User Registration</h2>

<form action="register.php" method="POST">

    <input
        type="text"
        name="full_name"
        placeholder="Full Name"
        required
    ><br><br>

    <input
        type="email"
        name="email"
        placeholder="Email"
        required
    ><br><br>

    <input
        type="password"
        name="password"
        placeholder="Password"
        minlength="8"
        required
    ><br><br>

    <button type="submit">
        Register
    </button>

</form>

</body>
</html>
```