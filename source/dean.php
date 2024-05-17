<?php
session_start();
if ($_SESSION['role'] != 'dean') {
    header('Location: dashboard.php');
    exit();
}

include 'config.php';

// Fetch departments for the dean's faculty
$stmt = $conn->prepare("SELECT id, name FROM departments WHERE faculty_id = ?");
$stmt->bind_param('i', $_SESSION['faculty_id']);
$stmt->execute();
$result = $stmt->get_result();
$departments = $result->fetch_all(MYSQLI_ASSOC);
$stmt->close();

$exams = [];
if (isset($_POST['department_id'])) {
    $department_id = $_POST['department_id'];
    $stmt = $conn->prepare("SELECT c.name, e.date, e.start_time, e.end_time 
                            FROM exams e 
                            JOIN courses c ON e.course_id = c.id 
                            WHERE c.department_id = ? 
                            ORDER BY e.date, e.start_time");
    $stmt->bind_param('i', $department_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $exams = $result->fetch_all(MYSQLI_ASSOC);
    $stmt->close();
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Dean Page</title>
</head>
<body>
    <h1>Welcome, <?php echo $_SESSION['name'], str_repeat("&nbsp;", 20), $_SESSION['department_name'], str_repeat("&nbsp;", 20), $_SESSION['faculty_name']; ?></h1>

    <h2>View Exams by Department</h2>
    <form id="departmentForm" method="POST">
        <label for="department">Select Department:</label>
        <select id="department" name="department_id">
            <?php foreach ($departments as $department) {
                $selected = ($department['id'] == $_POST['department_id']) ? 'selected' : ''; ?>
                <option value="<?php echo $department['id']; ?>" <?php echo $selected; ?>><?php echo $department['name']; ?></option>
            <?php } ?>
        </select>
        <button type="button" id="submitBtn">View Exams</button>
    </form>

    <?php if (!empty($exams)) { ?>
        <h2>Exam Schedule</h2>
        <table>
            <tr>
                <th>Course</th>
                <th>Date</th>
                <th>Start Time</th>
                <th>End Time</th>
            </tr>
            <?php foreach ($exams as $exam) { ?>
                <tr>
                    <td><?php echo $exam['name']; ?></td>
                    <td><?php echo $exam['date']; ?></td>
                    <td><?php echo $exam['start_time']; ?></td>
                    <td><?php echo $exam['end_time']; ?></td>
                </tr>
            <?php } ?>
        </table>
    <?php } else { ?>
        <p>No exams scheduled for this department.</p>
    <?php } ?>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('submitBtn').addEventListener('click', function() {
            document.getElementById('departmentForm').submit();
        });
    });
    </script>
</body>
</html>
