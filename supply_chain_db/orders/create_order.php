<?php
require_once '../config/database.php';
include '../includes/header.php';

if (!isset($_SESSION['admin_id'])) {
    header("Location: ../admin/login.php");
    exit();
}

$error = '';
$success = '';

// Fetch suppliers for dropdown
$suppliers = fetch_all("SELECT supplier_id, supplier_name FROM suppliers ORDER BY supplier_name");

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $supplier_id = sanitize_input($_POST['supplier_id']);
    $order_date = sanitize_input($_POST['order_date']);
    $expected_delivery = sanitize_input($_POST['expected_delivery']);
    $total_amount = sanitize_input($_POST['total_amount']);
    $created_by = $_SESSION['admin_id'];
    
    // Validation
    if (empty($supplier_id) || empty($order_date) || empty($expected_delivery) || empty($total_amount)) {
        $error = "Please fill all required fields";
    } elseif ($total_amount <= 0) {
        $error = "Total amount must be greater than 0";
    } elseif (strtotime($expected_delivery) < strtotime($order_date)) {
        $error = "Expected delivery date must be after order date";
    } else {
        $query = "INSERT INTO purchase_orders (supplier_id, order_date, expected_delivery, total_amount, created_by) 
                  VALUES ($supplier_id, '$order_date', '$expected_delivery', $total_amount, $created_by)";
        
        if (execute_query($query)) {
            $order_id = mysqli_insert_id($conn);
            $success = "Purchase order #$order_id created successfully!";
            $_POST = array();
        } else {
            $error = "Error creating purchase order";
        }
    }
}
?>

<style>
    .form-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group.full-width {
        grid-column: 1 / -1;
    }
    
    label {
        display: block;
        margin-bottom: 8px;
        color: #333;
        font-weight: 500;
    }
    
    input, select {
        width: 100%;
        padding: 10px;
        border: 2px solid #e0e0e0;
        border-radius: 5px;
        font-size: 14px;
    }
    
    input:focus, select:focus {
        outline: none;
        border-color: #667eea;
    }
    
    .btn {
        padding: 12px 30px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        font-weight: 600;
        text-decoration: none;
        display: inline-block;
    }
    
    .error {
        background: #fee;
        color: #c33;
        padding: 12px;
        border-radius: 5px;
        margin-bottom: 20px;
    }
    
    .success {
        background: #efe;
        color: #3c3;
        padding: 12px;
        border-radius: 5px;
        margin-bottom: 20px;
    }
</style>

<div class="container">
    <div class="card">
        <h2>Create Purchase Order</h2>
        
        <?php if ($error): ?>
            <div class="error"><?php echo $error; ?></div>
        <?php endif; ?>
        
        <?php if ($success): ?>
            <div class="success"><?php echo $success; ?></div>
        <?php endif; ?>
        
        <form method="POST" action="">
            <div class="form-grid">
                <div class="form-group">
                    <label for="supplier_id">Select Supplier *</label>
                    <select id="supplier_id" name="supplier_id" required>
                        <option value="">-- Choose Supplier --</option>
                        <?php foreach ($suppliers as $supplier): ?>
                            <option value="<?php echo $supplier['supplier_id']; ?>">
                                <?php echo htmlspecialchars($supplier['supplier_name']); ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="total_amount">Total Amount (₹) *</label>
                    <input type="number" id="total_amount" name="total_amount" step="0.01" min="0" required>
                </div>
                
                <div class="form-group">
                    <label for="order_date">Order Date *</label>
                    <input type="date" id="order_date" name="order_date" value="<?php echo date('Y-m-d'); ?>" required>
                </div>
                
                <div class="form-group">
                    <label for="expected_delivery">Expected Delivery Date *</label>
                    <input type="date" id="expected_delivery" name="expected_delivery" required>
                </div>
            </div>
            
            <button type="submit" class="btn">Create Order</button>
            <a href="view_orders.php" class="btn" style="background: #666; margin-left: 10px;">View All Orders</a>
        </form>
    </div>
</div>

<?php include '../includes/footer.php'; ?>
