<?php
session_start();
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit();
}
$name = $_SESSION['name'];
$role = $_SESSION['role'];
$department_name = $_SESSION['department_name'];
$faculty_name = $_SESSION['faculty_name'];
?>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome <?php echo $name; ?></title>
</head>
<body>
    <h1>Welcome, <?php echo $name ,str_repeat("&nbsp;", 20), $department_name, str_repeat("&nbsp;", 20), $faculty_name;	?></h1>
    <nav>
        <?php if ($role == 'assistant') { ?>
            <a href="assistant.php">Assistant Page</a>
        <?php } elseif ($role == 'secretary') { ?>
            <a href="secretary.php">Secretary Page</a>
        <?php } elseif ($role == 'head_of_department') { ?>
            <a href="head_of_department.php">Head of Department Page</a>
        <?php } elseif ($role == 'head_of_secretary') { ?>
            <a href="head_of_secretary.php">Head of Secretary Page</a>
        <?php } elseif ($role == 'dean') { ?>
            <a href="dean.php">Dean Page</a>
        <?php } ?>
    </nav>
</body>
</html>
