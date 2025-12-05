<?php
require_once '../config/database.php';
include '../includes/header.php';

if (!isset($_SESSION['admin_id'])) {
    header("Location: ../admin/login.php");
    exit();
}

// Fetch inventory with product and warehouse details
$inventory = fetch_all("SELECT i.inventory_id, p.product_name, p.category, p.unit_price, 
                        w.warehouse_name, w.city, i.quantity, i.last_updated,
                        (i.quantity * p.unit_price) as total_value,
                        p.reorder_level,
                        CASE 
                            WHEN i.quantity < p.reorder_level THEN 'Low Stock'
                            WHEN i.quantity < (p.reorder_level * 2) THEN 'Medium'
                            ELSE 'Good'
                        END as stock_status
                        FROM inventory i
                        INNER JOIN products p ON i.product_id = p.product_id
                        INNER JOIN warehouses w ON i.warehouse_id = w.warehouse_id
                        ORDER BY stock_status ASC, p.product_name");
?>

<style>
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        font-size: 14px;
    }
    
    th, td {
        padding: 10px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    
    th {
        background: #667eea;
        color: white;
        font-weight: 600;
    }
    
    tr:hover {
        background: #f5f5f5;
    }
    
    .status-low {
        color: #f44336;
        font-weight: bold;
    }
    
    .status-medium {
        color: #ff9800;
        font-weight: bold;
    }
    
    .status-good {
        color: #4caf50;
        font-weight: bold;
    }
    
    .btn {
        padding: 8px 15px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        margin-right: 10px;
    }
</style>

<div class="container">
    <div class="card">
        <h2>Inventory Management</h2>
        <a href="update_inventory.php" class="btn">Update Inventory</a>
        <a href="low_stock.php" class="btn" style="background: #f44336;">Low Stock Alert</a>
        
        <table>
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Category</th>
                    <th>Warehouse</th>
                    <th>City</th>
                    <th>Quantity</th>
                    <th>Unit Price</th>
                    <th>Total Value</th>
                    <th>Status</th>
                    <th>Last Updated</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($inventory as $item): ?>
                <tr>
                    <td><?php echo htmlspecialchars($item['product_name']); ?></td>
                    <td><?php echo htmlspecialchars($item['category']); ?></td>
                    <td><?php echo htmlspecialchars($item['warehouse_name']); ?></td>
                    <td><?php echo htmlspecialchars($item['city']); ?></td>
                    <td><strong><?php echo $item['quantity']; ?></strong></td>
                    <td>₹<?php echo number_format($item['unit_price'], 2); ?></td>
                    <td>₹<?php echo number_format($item['total_value'], 2); ?></td>
                    <td class="status-<?php echo strtolower(str_replace(' ', '', $item['stock_status'])); ?>">
                        <?php echo $item['stock_status']; ?>
                    </td>
                    <td><?php echo date('d M Y', strtotime($item['last_updated'])); ?></td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>

<?php include '../includes/footer.php'; ?>
