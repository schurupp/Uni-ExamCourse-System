<?php
session_start();
if ($_SESSION['role'] != 'secretary') {
    header('Location: dashboard.php');
    exit();
}

include 'config.php';
$department_id = $_SESSION['department_id'];

// Fetch existing courses for the department
$stmt = $conn->prepare("SELECT id, name FROM courses WHERE department_id = ?");
$stmt->bind_param('i', $department_id);
$stmt->execute();
$result = $stmt->get_result();
$courses = $result->fetch_all(MYSQLI_ASSOC);
$stmt->close();

// Handle course insertion
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['insert_course'])) {
    $course_code = $_POST['course_code'];
    $course_name = $_POST['course_name'];
    $day_of_week = $_POST['day_of_week'];
    $start_time = $_POST['start_time'];
    $end_time = $_POST['end_time'];

    // Insert course
    $stmt = $conn->prepare("INSERT INTO courses (code, name, department_id) VALUES (?, ?, ?)");
    $stmt->bind_param('ssi', $course_code, $course_name, $department_id);
    $stmt->execute();
    $course_id = $stmt->insert_id;
    $stmt->close();

    // Insert course schedule
    $stmt = $conn->prepare("INSERT INTO course_schedule (course_id, day_of_week, start_time, end_time) VALUES (?, ?, ?, ?)");
    $stmt->bind_param('isss', $course_id, $day_of_week, $start_time, $end_time);
    $stmt->execute();
    $stmt->close();
}

// Function to check for conflicts
function has_conflict($conn, $assistant_id, $date, $start_time, $end_time) {
    // Fetch all course schedules and exams for the assistant
    $stmt = $conn->prepare("
        SELECT 'course' AS type, cs.day_of_week, NULL AS date, cs.start_time, cs.end_time
        FROM course_schedule cs
        JOIN course_assistants ca ON cs.course_id = ca.course_id
        WHERE ca.assistant_id = ?
        UNION
        SELECT 'exam' AS type, NULL AS day_of_week, e.date, e.start_time, e.end_time
        FROM exams e
        JOIN exam_assistants ea ON e.id = ea.exam_id
        WHERE ea.assistant_id = ?
    ");
    $stmt->bind_param('ii', $assistant_id, $assistant_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $schedules = $result->fetch_all(MYSQLI_ASSOC);
    $stmt->close();

    $day_of_week = date('l', strtotime($date)); // Get the full day name

    foreach ($schedules as $schedule) {
        if ($schedule['type'] == 'course' && $schedule['day_of_week'] == $day_of_week) {
            if (($start_time < $schedule['end_time']) && ($end_time > $schedule['start_time'])) {
                return true; // Conflict found with a course
            }
        } elseif ($schedule['type'] == 'exam' && $schedule['date'] == $date) {
            if (($start_time < $schedule['end_time']) && ($end_time > $schedule['start_time'])) {
                return true; // Conflict found with an exam
            }
        }
    }

    return false; // No conflicts
}

// Handle exam insertion and assistant matching
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['insert_exam'])) {
    $course_id = $_POST['course_id'];
    $date = $_POST['date'];
    $start_time = $_POST['start_time'];
    $end_time = $_POST['end_time'];
    $num_assistants = $_POST['num_assistants'];
    $department_id = $_SESSION['department_id'];

    // Insert the exam
    $stmt = $conn->prepare("INSERT INTO exams (course_id, date, start_time, end_time, num_assistants) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param('isssi', $course_id, $date, $start_time, $end_time, $num_assistants);
    $stmt->execute();
    $exam_id = $stmt->insert_id; // Get the ID of the inserted exam
    $stmt->close();

    // Fetch assistants sorted by score
    $stmt = $conn->prepare("SELECT a.id as user_id, u.name as name FROM assistants a JOIN users u ON u.id = a.user_id WHERE a.department_id = ? ORDER BY score");
    $stmt->bind_param('i', $department_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $assistants = $result->fetch_all(MYSQLI_ASSOC);
    $stmt->close();

    // Store the IDs and names of attached assistants
    $attached_assistants = [];
    $assigned_count = 0;

    foreach ($assistants as $assistant) {
        if ($assigned_count >= $num_assistants) {
            break;
        }

        $assistant_id = $assistant['user_id'];
        $assistant_name = $assistant['name'];

        if (!has_conflict($conn, $assistant_id, $date, $start_time, $end_time)) {
            $stmt = $conn->prepare("INSERT INTO exam_assistants (exam_id, assistant_id) VALUES (?, ?)");
            $stmt->bind_param('ii', $exam_id, $assistant_id);
            if ($stmt->execute()) {
                $stmt->close();

                // Update the assistant's score
                $stmt = $conn->prepare("UPDATE assistants SET score = score + 1 WHERE id = ?");
                $stmt->bind_param('i', $assistant_id);
                $stmt->execute();
                $stmt->close();

                // Store attached assistant's user name
                $attached_assistants[] = $assistant_name;
                $assigned_count++;
            } else {
                echo "Error inserting assistant: " . $conn->error;
                // Handle the error appropriately (e.g., log, display error message, etc.)
                // Exit the loop or take corrective action
                $stmt->close();
                break;
            }
        }
    }

    if ($assigned_count < $num_assistants) {
        echo "<p>Could not assign the requested number of assistants.Proposed assistants have intersecting courses. Assigned " . $assigned_count . " assistants.</p>";
    } else {
        echo "<p>Exam created successfully. Attached assistants: " . implode(", ", $attached_assistants) . "</p>";
    }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Secretary Page</title>
</head>
<body>
    <h1>Welcome, <?php echo $_SESSION['name'], str_repeat("&nbsp;", 20), $_SESSION['department_name'], str_repeat("&nbsp;", 20), $_SESSION['faculty_name']; ?></h1>

    <h2>Insert Course Information</h2>
	<form method="POST">
		<input type="hidden" name="insert_course">
		<label for="course_code">Course Code:</label>
		<input type="text" id="course_code" name="course_code" required>
		<label for="course_name">Course Name:</label>
		<input type="text" id="course_name" name="course_name" required>
		<label for="day_of_week">Day of the Week:</label> <!-- Added -->
		<select id="day_of_week" name="day_of_week"> <!-- Added -->
			<option value="Monday">Monday</option>
			<option value="Tuesday">Tuesday</option>
			<option value="Wednesday">Wednesday</option>
			<option value="Thursday">Thursday</option>
			<option value="Friday">Friday</option>
			<option value="Saturday">Saturday</option>
			<option value="Sunday">Sunday</option>
		</select>
		<label for="start_time">Start Time:</label> <!-- Added -->
		<input type="time" id="start_time" name="start_time" required> <!-- Added -->
		<label for="end_time">End Time:</label> <!-- Added -->
		<input type="time" id="end_time" name="end_time" required> <!-- Added -->
		<input type="submit" value="Insert Course">
	</form>

    <h2>Create Exam</h2>
	<?php if (!empty($error_message)): ?>
        <p style="color: red;"><?php echo $error_message; ?></p>
    <?php endif; ?>
    <form method="POST">
        <input type="hidden" name="insert_exam">
        <label for="course">Select Course:</label>
        <select id="course" name="course_id">
            <?php foreach ($courses as $course) { ?>
                <option value="<?php echo $course['id']; ?>"><?php echo $course['name']; ?></option>
            <?php } ?>
        </select>
        <label for="date">Date:</label>
        <input type="date" id="date" name="date" required>
        <label for="start_time">Start Time:</label>
        <input type="time" id="start_time" name="start_time" required>
        <label for="end_time">End Time:</label>
        <input type="time" id="end_time" name="end_time" required>
        <label for="num_assistants">Number of Assistants:</label>
        <input type="number" id="num_assistants" name="num_assistants" required>
        <input type="submit" value="Create Exam">
    </form>

    <h2>Assistant Scores</h2>
    <table>
        <tr>
            <th>Assistant</th>
            <th>Score</th>
        </tr>
        <?php
        $stmt = $conn->prepare("SELECT u.name, a.score FROM assistants a JOIN users u ON a.user_id = u.id WHERE a.department_id = ?");
        $stmt->bind_param('i', $department_id);
        $stmt->execute();
        $result = $stmt->get_result();
        while ($row = $result->fetch_assoc()) {
            echo "<tr><td>{$row['name']}</td><td>{$row['score']}</td></tr>";
        }
        $stmt->close();
        ?>
    </table>
	
	<form method="GET">
        <input type="submit" value="Refresh">
    </form>
</body>
</html>
