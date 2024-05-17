<?php
include 'config.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'];
    $stmt = $conn->prepare("SELECT id FROM users WHERE username = ?");
    $stmt->bind_param('s', $username);
    $stmt->execute();
    $stmt->store_result();
    if ($stmt->num_rows > 0) {
        // Generate a random password
        $new_password = substr(md5(uniqid(rand(), true)), 0, 8);
        $hashed_password = password_hash($new_password, PASSWORD_DEFAULT);

        $stmt->bind_result($id);
        $stmt->fetch();
        $stmt->close();

        // Update the new password in the database
        $stmt = $conn->prepare("UPDATE users SET password = ? WHERE id = ?");
        $stmt->bind_param('si', $hashed_password, $id);
        $stmt->execute();
        $stmt->close();

        echo "Your new password is: " . $new_password;
        // Ideally, send the new password via email
    } else {
        echo "Username not found";
    }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>
</head>
<body>
    <h2>Forgot Password</h2>
    <form method="POST">
        Username: <input type="text" name="username" required><br>
        <input type="submit" value="Reset Password">
    </form>
</body>
</html>
