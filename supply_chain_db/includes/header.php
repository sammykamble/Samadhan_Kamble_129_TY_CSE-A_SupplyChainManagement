<?php
session_start();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supply Chain Management System</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .navbar h1 {
            color: #667eea;
            display: inline-block;
        }
        
        .navbar nav {
            float: right;
            margin-top: 10px;
        }
        
        .navbar a {
            color: #333;
            text-decoration: none;
            margin-left: 20px;
            padding: 8px 15px;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .navbar a:hover {
            background: #667eea;
            color: white;
        }
        
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 20px;
        }
        
        .card {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .clearfix::after {
            content: "";
            display: table;
            clear: both;
        }
    </style>
</head>
<body>
    <div class="navbar clearfix">
        <h1>🚚 Supply Chain System</h1>
        <nav>
            <?php if (isset($_SESSION['admin_id'])): ?>
                <a href="../admin/dashboard.php">Dashboard</a>
                <a href="../suppliers/view_suppliers.php">Suppliers</a>
                <a href="../inventory/view_inventory.php">Inventory</a>
                <a href="../orders/view_orders.php">Orders</a>
                <a href="../admin/logout.php">Logout</a>
            <?php else: ?>
                <a href="../admin/login.php">Login</a>
            <?php endif; ?>
        </nav>
    </div>
