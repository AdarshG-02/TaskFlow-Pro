<?php
?>

<!DOCTYPE html>
<html>
<head>
    <title>Register Test</title>
</head>
<body>

<form action="register.php" method="POST">

    <input
        type="text"
        name="full_name"
        placeholder="Full Name"
    ><br><br>

    <input
        type="email"
        name="email"
        placeholder="Email"
    ><br><br>

    <input
        type="password"
        name="password"
        placeholder="Password"
    ><br><br>

    <button type="submit">
        Register
    </button>

</form>

</body>
</html>