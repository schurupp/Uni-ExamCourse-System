<?php
session_start();
include 'config.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

	$stmt = $conn->prepare("
    SELECT users.id, users.password, users.role, users.name, users.department_id, departments.faculty_id, departments.name AS department_name, faculties.name AS faculty_name, assistants.id AS assistant_id 
    FROM users 
    JOIN departments ON users.department_id = departments.id
    LEFT JOIN assistants ON users.id = assistants.user_id
    JOIN faculties ON departments.faculty_id = faculties.id
    WHERE users.username = ?
	");

    $stmt->bind_param('s', $username);
    $stmt->execute();
    $stmt->store_result();
    if ($stmt->num_rows > 0) {
        $stmt->bind_result($id, $hashed_password, $role, $name, $department_id, $faculty_id, $department_name, $faculty_name, $assistant_id);
        $stmt->fetch();
        if (password_verify($password, $hashed_password)) {
            $_SESSION['user_id'] = $id;
            $_SESSION['role'] = $role;
            $_SESSION['name'] = $name;
			$_SESSION['department_id'] = $department_id;
			$_SESSION['faculty_id'] = $faculty_id;
			$_SESSION['assistant_id'] = $assistant_id;
			$_SESSION['department_name'] = $department_name; // Session department name
			$_SESSION['faculty_name'] = $faculty_name; // Session faculty name
            header('Location: dashboard.php');
        } else {
            echo "Invalid password";
        }
    } else {
        echo "Invalid username";
    }
    $stmt->close();
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>
    <form method="POST">
        Username: <input type="text" name="username" required><br>
        Password: <input type="password" name="password" required><br>
        <input type="submit" value="Login">
    </form>
    <a href="forgot_password.php">Forgot Password?</a>
</body>
</html>
