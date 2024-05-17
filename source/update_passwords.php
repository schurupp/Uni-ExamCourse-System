<?php
// Include your database configuration file
include 'config.php';

// Retrieve existing passwords from the database
$stmt = $conn->prepare("SELECT id, password FROM users");
$stmt->execute();
$result = $stmt->get_result();

// Update each password with its hashed version
while ($row = $result->fetch_assoc()) {
    // Hash the password using password_hash()
    $hashed_password = password_hash($row['password'], PASSWORD_DEFAULT);
    
    // Update the password in the database
    $stmt2 = $conn->prepare("UPDATE users SET password = ? WHERE id = ?");
    $stmt2->bind_param('si', $hashed_password, $row['id']);
    $stmt2->execute();
    $stmt2->close();
}

$stmt->close();

echo "Passwords updated successfully.";
?>
