<?php
/**
 * Database Configuration File
 * Supply Chain Management System
 */

// Database credentials
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');  // Default XAMPP has no password
define('DB_NAME', 'supply_chain_db');

// Create connection
$conn = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Set charset to utf8mb4 for proper character support
mysqli_set_charset($conn, "utf8mb4");

// Function to sanitize input
function sanitize_input($data) {
    global $conn;
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    $data = mysqli_real_escape_string($conn, $data);
    return $data;
}

// Function to execute query with error handling
function execute_query($query) {
    global $conn;
    $result = mysqli_query($conn, $query);
    
    if (!$result) {
        error_log("Query Error: " . mysqli_error($conn));
        return false;
    }
    
    return $result;
}

// Function to fetch all results
function fetch_all($query) {
    $result = execute_query($query);
    if ($result) {
        return mysqli_fetch_all($result, MYSQLI_ASSOC);
    }
    return [];
}

// Function to fetch single row
function fetch_one($query) {
    $result = execute_query($query);
    if ($result) {
        return mysqli_fetch_assoc($result);
    }
    return null;
}
?>
