<?php
session_start();

// Check if user is not logged in, redirect to login page
if (!isset($_SESSION['loggedin'])) {
    header('Location: /');
    exit;
}
?>