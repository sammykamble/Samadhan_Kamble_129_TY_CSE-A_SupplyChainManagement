<?php
require_once '../config/database.php';
include '../includes/header.php';

if (!isset($_SESSION['admin_id'])) {
    header("Location: ../admin/login.php");
    exit();
}

$error = '';
$success = '';

// Fetch products and warehouses
$products = fetch_all("SELECT product_id, product_name FROM products ORDER BY product_name");
$warehouses = fetch_all("SELECT warehouse_id, warehouse_name FROM warehouses ORDER BY warehouse_name");

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $product_id = sanitize_input($_POST['product_id']);
    $warehouse_id = sanitize_input($_POST['warehouse_id']);
    $quantity = sanitize_input($_POST['quantity']);
    $action = sanitize_input($_POST['action']);
    
    if (empty($product_id) || empty($warehouse_id) || empty($quantity)) {
        $error = "Please fill all fields";
    } elseif ($quantity <= 0) {
        $error = "Quantity must be greater than 0";
    } else {
        // Check if inventory record exists
        $check = fetch_one("SELECT quantity FROM inventory 
                           WHERE product_id = $product_id AND warehouse_id = $warehouse_id");
        
        if ($check) {
            // Update existing inventory
            if ($action == 'add') {
                $new_qty = $check['quantity'] + $quantity;
            } else {
                $new_qty = $check['quantity'] - $quantity;
                if ($new_qty < 0) {
                    $error = "Cannot remove more than available quantity";
                }
            }
            
            if (!$error) {
                $query = "UPDATE inventory SET quantity = $new_qty 
                         WHERE product_id = $product_id AND warehouse_id = $warehouse_id";
                if (execute_query($query)) {
                    $success = "Inventory updated successfully!";
                }
            }
        } else {
            // Insert new inventory record
            if ($action == 'add') {
                $query = "INSERT INTO inventory (product_id, warehouse_id, quantity) 
                         VALUES ($product_id, $warehouse_id, $quantity)";
                if (execute_query($query)) {
                    $success = "Inventory added successfully!";
                }
            } else {
                $error = "Cannot remove from non-existent inventory";
            }
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
        <h2>Update Inventory</h2>
        
        <?php if ($error): ?>
            <div class="error"><?php echo $error; ?></div>
        <?php endif; ?>
        
        <?php if ($success): ?>
            <div class="success"><?php echo $success; ?></div>
        <?php endif; ?>
        
        <form method="POST" action="">
            <div class="form-grid">
                <div class="form-group">
                    <label for="product_id">Select Product *</label>
                    <select id="product_id" name="product_id" required>
                        <option value="">-- Choose Product --</option>
                        <?php foreach ($products as $product): ?>
                            <option value="<?php echo $product['product_id']; ?>">
                                <?php echo htmlspecialchars($product['product_name']); ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="warehouse_id">Select Warehouse *</label>
                    <select id="warehouse_id" name="warehouse_id" required>
                        <option value="">-- Choose Warehouse --</option>
                        <?php foreach ($warehouses as $warehouse): ?>
                            <option value="<?php echo $warehouse['warehouse_id']; ?>">
                                <?php echo htmlspecialchars($warehouse['warehouse_name']); ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="quantity">Quantity *</label>
                    <input type="number" id="quantity" name="quantity" min="1" required>
                </div>
                
                <div class="form-group">
                    <label for="action">Action *</label>
                    <select id="action" name="action" required>
                        <option value="add">Add Stock</option>
                        <option value="remove">Remove Stock</option>
                    </select>
                </div>
            </div>
            
            <button type="submit" class="btn">Update Inventory</button>
            <a href="view_inventory.php" class="btn" style="background: #666; margin-left: 10px;">View Inventory</a>
        </form>
    </div>
</div>

<?php include '../includes/footer.php'; ?>
