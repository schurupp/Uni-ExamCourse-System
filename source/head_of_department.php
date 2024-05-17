<?php
session_start();
if ($_SESSION['role'] != 'head_of_department') {
    header('Location: dashboard.php');
    exit();
}

include 'config.php';
$department_id = $_SESSION['department_id'];

// Fetch the exam schedule for the department
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

// Fetch the workloads of assistants
$stmt = $conn->prepare("SELECT u.name, a.score 
                        FROM assistants a 
                        JOIN users u ON a.user_id = u.id 
                        WHERE a.department_id = ?");
$stmt->bind_param('i', $department_id);
$stmt->execute();
$result = $stmt->get_result();
$workloads = $result->fetch_all(MYSQLI_ASSOC);
$stmt->close();

// Calculate total score
$totalScore = 0;
foreach ($workloads as $workload) {
    $totalScore += $workload['score'];
}

// Calculate percentage workload among assistants
$assistantWorkloads = array();
foreach ($workloads as $workload) {
    $percentage = ($workload['score'] / $totalScore) * 100;
	$percentage = number_format($percentage, 2); // Format to 2 decimal places
    $assistantWorkloads[] = array(
        'name' => $workload['name'],
        'score' => $percentage
    );
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Head of Department Page</title>
</head>
<body>
    <h1>Welcome, <?php echo $_SESSION['name'], str_repeat("&nbsp;", 20), $_SESSION['department_name'], str_repeat("&nbsp;", 20), $_SESSION['faculty_name']; ?></h1>
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

    <h2>Assistant Workloads</h2>
    <table>
        <tr>
            <th>Assistant</th>
            <th>Workload (%)</th>
        </tr>
        <?php foreach ($assistantWorkloads as $workload) { ?>
        <tr>
            <td><?php echo $workload['name']; ?></td>
            <td><?php echo $workload['score']; ?></td>
        </tr>
        <?php } ?>
    </table>
	
	<form method="GET">
        <input type="submit" value="Refresh">
    </form>
</body>
</html>
