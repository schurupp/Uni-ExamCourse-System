<?php
session_start();
if ($_SESSION['role'] != 'assistant') {
    header('Location: dashboard.php');
    exit();
}

include 'config.php';
$assistant_id = $_SESSION['assistant_id'];

// Fetch courses the assistant can select
$stmt = $conn->prepare("SELECT id, name FROM courses WHERE department_id = ?");
$stmt->bind_param('i', $_SESSION['department_id']);
$stmt->execute();
$result = $stmt->get_result();
$courses = $result->fetch_all(MYSQLI_ASSOC);
$stmt->close();

// Fetch the weekly program for the assistant (Courses)
$stmt = $conn->prepare("
    SELECT DISTINCT c.id, c.code, c.name, cs.day_of_week, cs.start_time, cs.end_time
    FROM courses c
    JOIN course_schedule cs ON c.id = cs.course_id
    JOIN course_assistants ca ON c.id = ca.course_id
    WHERE ca.assistant_id = ?
");
$stmt->bind_param('i', $assistant_id);
$stmt->execute();
$result = $stmt->get_result();
$weekly_courses = $result->fetch_all(MYSQLI_ASSOC);
$stmt->close();

// Fetch the weekly program for the assistant (Exams)
$stmt = $conn->prepare("
    SELECT c.name, e.date, e.start_time, e.end_time
    FROM exams e
    JOIN exam_assistants ea ON e.id = ea.exam_id
    JOIN courses c ON e.course_id = c.id
    WHERE ea.assistant_id = ?
");
$stmt->bind_param('i', $assistant_id);
$stmt->execute();
$result = $stmt->get_result();
$weekly_exams = $result->fetch_all(MYSQLI_ASSOC);
$stmt->close();

// Handle course selection
$error_message = '';
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['course_id'])) {
    $course_id = $_POST['course_id'];

    // Fetch the schedule for the selected course
    $stmt = $conn->prepare("
        SELECT cs.day_of_week, cs.start_time, cs.end_time
        FROM course_schedule cs
        WHERE cs.course_id = ?
    ");
    $stmt->bind_param('i', $course_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $selected_course_schedule = $result->fetch_all(MYSQLI_ASSOC);
    $stmt->close();

    // Check for time conflicts with existing courses and exams
    $conflict = false;
    foreach ($selected_course_schedule as $selected_course) {
        $selected_day = $selected_course['day_of_week'];
        $selected_start_time = $selected_course['start_time'];
        $selected_end_time = $selected_course['end_time'];

        // Check conflicts with courses
        foreach ($weekly_courses as $course) {
            if ($selected_day == $course['day_of_week']) {
                if (($selected_start_time < $course['end_time']) && ($selected_end_time > $course['start_time'])) {
                    $conflict = true;
                    break;
                }
            }
        }

        // Check conflicts with exams
        foreach ($weekly_exams as $exam) {
            $exam_date = date('Y-m-d', strtotime($exam['date']));
            $exam_day = date('l', strtotime($exam_date));
            if ($selected_day == $exam_day) {
                if (($selected_start_time < $exam['end_time']) && ($selected_end_time > $exam['start_time'])) {
                    $conflict = true;
                    break;
                }
            }
        }

        if ($conflict) break;
    }

    if (!$conflict) {
        $stmt = $conn->prepare("INSERT INTO course_assistants (assistant_id, course_id) VALUES (?, ?)");
        $stmt->bind_param('ii', $assistant_id, $course_id);
        $stmt->execute();
        $stmt->close();

        // Refresh the page to reflect the new course
        header("Location: " . $_SERVER['PHP_SELF']);
        exit();
    } else {
        $error_message = 'The selected course conflicts with an existing course or exam.';
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assistant Page</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            width: 14.28%; /* 100% divided by 7 days */
            border: 1px solid #ccc;
            text-align: center;
            padding: 10px;
            vertical-align: top;
        }
        th {
            background-color: #f2f2f2;
        }
        .empty {
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>
    <h1>Welcome, <?php echo $_SESSION['name'], str_repeat("&nbsp;", 20), $_SESSION['department_name'], str_repeat("&nbsp;", 20), $_SESSION['faculty_name']; ?></h1>

    <h2>Select Courses</h2>
    <?php if ($error_message): ?>
        <p style="color: red;"><?php echo $error_message; ?></p>
    <?php endif; ?>
    <form method="POST">
        <label for="course">Select Course:</label>
        <select id="course" name="course_id">
            <?php foreach ($courses as $course) { ?>
                <option value="<?php echo $course['id']; ?>"><?php echo $course['name']; ?></option>
            <?php } ?>
        </select>
        <input type="submit" value="Select Course">
    </form>
    
    <h2>Weekly Program - Calendar View</h2>

    <?php
    // Get the current month and year, or use the ones from the query parameters
    if (isset($_GET['month']) && isset($_GET['year'])) {
        $month = intval($_GET['month']);
        $year = intval($_GET['year']);
    } else {
        $month = date('n');
        $year = date('Y');
    }

    // Calculate previous and next month
    $prevMonth = $month - 1;
    $prevYear = $year;
    if ($prevMonth < 1) {
        $prevMonth = 12;
        $prevYear--;
    }

    $nextMonth = $month + 1;
    $nextYear = $year;
    if ($nextMonth > 12) {
        $nextMonth = 1;
        $nextYear++;
    }

    $firstDayOfMonth = mktime(0, 0, 0, $month, 1, $year);
    $daysInMonth = date('t', $firstDayOfMonth);
    $startDayOfWeek = date('w', $firstDayOfMonth);

    $dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    // Helper function to get the course schedule for a specific day of the week
    function getCoursesForDay($courses, $dayOfWeek) {
        $dayCourses = [];
        foreach ($courses as $course) {
            if ($course['day_of_week'] == $dayOfWeek) {
                $dayCourses[] = $course;
            }
        }
        return $dayCourses;
    }
    ?>

    <div>
        <a href="?month=<?php echo $prevMonth; ?>&year=<?php echo $prevYear; ?>">&laquo; Previous Month</a>
        <span><?php echo date('F Y', $firstDayOfMonth); ?></span>
        <a href="?month=<?php echo $nextMonth; ?>&year=<?php echo $nextYear; ?>">Next Month &raquo;</a>
    </div>

    <table>
        <tr>
            <?php foreach ($dayNames as $day) { ?>
                <th><?php echo $day; ?></th>
            <?php } ?>
        </tr>
        <tr>
            <?php
            for ($i = 0; $i < $startDayOfWeek; $i++) {
                echo '<td class="empty"></td>';
            }

            $currentDay = 1;
            while ($currentDay <= $daysInMonth) {
                if (($currentDay + $startDayOfWeek - 1) % 7 == 0 && $currentDay != 1) {
                    echo '</tr><tr>';
                }

                echo '<td>';
                echo $currentDay;

                $currentDate = date('Y-m-d', mktime(0, 0, 0, $month, $currentDay, $year));

                $dayOfWeek = date('l', strtotime($currentDate));
                $coursesForDay = getCoursesForDay($weekly_courses, $dayOfWeek);
                foreach ($coursesForDay as $course) {
                    echo '<div>' . $course['name'] . '<br>' . $course['start_time'] . ' - ' . $course['end_time'] . '</div>';
                }

                foreach ($weekly_exams as $exam) {
                    if ($exam['date'] == $currentDate) {
                        echo '<div>' . $exam['name'] . '<br>' . $exam['start_time'] . ' - ' . $exam['end_time'] . '</div>';
                    }
                }

                echo '</td>';
                $currentDay++;
            }

            // Fill the last row with empty cells if the month doesn't end on Saturday
            while (($currentDay + $startDayOfWeek - 1) % 7 != 0) {
                echo '<td class="empty"></td>';
                $currentDay++;
            }
            ?>
        </tr>
    </table>

    <form method="GET">
        <input type="submit" value="Refresh">
    </form>
</body>
</html>
