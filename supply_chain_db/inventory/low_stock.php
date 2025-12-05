<?php
require_once '../config/database.php';
include '../includes/header.php';

if (!isset($_SESSION['admin_id'])) {
    header("Location: ../admin/login.php");
    exit();
}

// Fetch low stock products using stored procedure
$low_stock = fetch_all("SELECT p.product_id, p.product_name, p.category, 
                        SUM(i.quantity) as current_stock, p.reorder_level,
                        s.supplier_name, s.contact_person, s.phone, s.email,
                        (p.reorder_level - SUM(i.quantity)) as shortage
                        FROM products p
                        LEFT JOIN inventory i ON p.product_id = i.product_id
                        INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
                        GROUP BY p.product_id, p.product_name, p.category, p.reorder_level,
                                 s.supplier_name, s.contact_person, s.phone, s.email
                        HAVING current_stock < p.reorder_level OR current_stock IS NULL
                        ORDER BY shortage DESC");
?>

<style>
    .alert-box {
        background: #fff3cd;
        border-left: 4px solid #ff9800;
        padding: 15px;
        margin-bottom: 20px;
        border-radius: 5px;
    }
    
    .alert-box h3 {
        color: #ff9800;
        margin-bottom: 10px;
    }
    
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        font-size: 14px;
    }
    
    th, td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    
    th {
        background: #f44336;
        color: white;
        font-weight: 600;
    }
    
    tr:hover {
        background: #fff3cd;
    }
    
    .critical {
        background: #ffebee;
    }
    
    .shortage {
        color: #f44336;
        font-weight: bold;
        font-size: 16px;
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
    
    .btn-danger {
        background: #f44336;
    }
    
    .count-badge {
        background: #f44336;
        color: white;
        padding: 5px 15px;
        border-radius: 20px;
        font-weight: bold;
        display: inline-block;
        margin-left: 10px;
    }
</style>

<div class="container">
    <div class="card">
        <h2>🚨 Low Stock Alert <span class="count-badge"><?php echo count($low_stock); ?> Items</span></h2>
        
        <?php if (count($low_stock) > 0): ?>
            <div class="alert-box">
                <h3>⚠️ Immediate Action Required!</h3>
                <p>The following products are below their reorder levels. Please contact suppliers to place orders.</p>
            </div>
            
            <a href="update_inventory.php" class="btn">Update Inventory</a>
            <a href="../orders/create_order.php" class="btn btn-danger">Create Purchase Order</a>
            
            <table>
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Category</th>
                        <th>Current Stock</th>
                        <th>Reorder Level</th>
                        <th>Shortage</th>
                        <th>Supplier</th>
                        <th>Contact Person</th>
                        <th>Phone</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($low_stock as $item): ?>
                    <tr class="<?php echo ($item['current_stock'] == 0 || $item['current_stock'] === null) ? 'critical' : ''; ?>">
                        <td><strong><?php echo htmlspecialchars($item['product_name']); ?></strong></td>
                        <td><?php echo htmlspecialchars($item['category']); ?></td>
                        <td class="shortage"><?php echo $item['current_stock'] ?? 0; ?></td>
                        <td><?php echo $item['reorder_level']; ?></td>
                        <td class="shortage">-<?php echo $item['shortage']; ?></td>
                        <td><?php echo htmlspecialchars($item['supplier_name']); ?></td>
                        <td><?php echo htmlspecialchars($item['contact_person']); ?></td>
                        <td><?php echo htmlspecialchars($item['phone']); ?></td>
                    </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
            
            <div style="margin-top: 20px; padding: 15px; background: #e3f2fd; border-radius: 5px;">
                <strong>💡 Tip:</strong> Products with 0 stock are highlighted in red. Contact suppliers immediately to avoid stockouts.
            </div>
        <?php else: ?>
            <div style="text-align: center; padding: 40px; color: #4caf50;">
                <h3>✅ All Products Have Sufficient Stock!</h3>
                <p>No items are below their reorder levels at this time.</p>
                <a href="view_inventory.php" class="btn" style="margin-top: 20px;">View Full Inventory</a>
            </div>
        <?php endif; ?>
    </div>
</div>

<?php include '../includes/footer.php'; ?>
