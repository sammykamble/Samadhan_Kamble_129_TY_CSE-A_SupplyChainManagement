<?php
/**
 * Database Connection Test File
 * Use this to verify your database connection is working
 */

require_once 'config/database.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Database Connection Test</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        
        .test-box {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            text-align: center;
        }
        
        .success {
            color: #4caf50;
            font-size: 24px;
            font-weight: bold;
        }
        
        .info {
            margin-top: 20px;
            color: #666;
        }
        
        .icon {
            font-size: 60px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="test-box">
        <div class="icon">✅</div>
        <div class="success">Database Connected Successfully!</div>
        <div class="info">
            <p><strong>Server:</strong> <?php echo DB_SERVER; ?></p>
            <p><strong>Database:</strong> <?php echo DB_NAME; ?></p>
            <p><strong>Connection Status:</strong> Active</p>
        </div>
        <div style="margin-top: 30px;">
            <a href="admin/login.php" style="background: #667eea; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block;">
                Go to Login
            </a>
        </div>
    </div>
</body>
</html>
