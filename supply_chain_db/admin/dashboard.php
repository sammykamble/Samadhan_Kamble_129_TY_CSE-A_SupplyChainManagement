<?php
require_once '../config/database.php';
include '../includes/header.php';

// Check if user is logged in
if (!isset($_SESSION['admin_id'])) {
    header("Location: login.php");
    exit();
}

// Fetch dashboard statistics
$stats = [];

// Total suppliers
$result = execute_query("SELECT COUNT(*) as count FROM suppliers");
$stats['suppliers'] = mysqli_fetch_assoc($result)['count'];

// Total products
$result = execute_query("SELECT COUNT(*) as count FROM products");
$stats['products'] = mysqli_fetch_assoc($result)['count'];

// Total inventory value
$result = execute_query("SELECT SUM(i.quantity * p.unit_price) as total 
                         FROM inventory i 
                         INNER JOIN products p ON i.product_id = p.product_id");
$stats['inventory_value'] = mysqli_fetch_assoc($result)['total'] ?? 0;

// Pending orders
$result = execute_query("SELECT COUNT(*) as count FROM purchase_orders WHERE status = 'Pending'");
$stats['pending_orders'] = mysqli_fetch_assoc($result)['count'];

// Low stock products
$result = execute_query("SELECT COUNT(*) as count 
                         FROM (
                             SELECT p.product_id 
                             FROM products p 
                             LEFT JOIN inventory i ON p.product_id = i.product_id 
                             GROUP BY p.product_id, p.reorder_level 
                             HAVING COALESCE(SUM(i.quantity), 0) < p.reorder_level
                         ) as low_stock_items");
$stats['low_stock'] = mysqli_fetch_assoc($result)['count'] ?? 0;

// Recent orders
$recent_orders = fetch_all("SELECT po.order_id, s.supplier_name, po.order_date, 
                            po.total_amount, po.status 
                            FROM purchase_orders po 
                            INNER JOIN suppliers s ON po.supplier_id = s.supplier_id 
                            ORDER BY po.order_date DESC LIMIT 5");
?>

<style>
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }
    
    .stat-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 25px;
        border-radius: 10px;
        text-align: center;
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    }
    
    .stat-card h3 {
        font-size: 36px;
        margin-bottom: 10px;
    }
    
    .stat-card p {
        font-size: 14px;
        opacity: 0.9;
    }
    
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    
    th, td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    
    th {
        background: #667eea;
        color: white;
    }
    
    tr:hover {
        background: #f5f5f5;
    }
    
    .status-pending {
        color: #ff9800;
        font-weight: bold;
    }
    
    .status-completed {
        color: #4caf50;
        font-weight: bold;
    }
</style>

<div class="container">
    <div class="card">
        <h2>Welcome, <?php echo htmlspecialchars($_SESSION['full_name']); ?>!</h2>
        <p>Role: <?php echo htmlspecialchars($_SESSION['role']); ?></p>
    </div>
    
    <div class="stats-grid">
        <div class="stat-card">
            <h3><?php echo $stats['suppliers']; ?></h3>
            <p>Total Suppliers</p>
        </div>
        
        <div class="stat-card">
            <h3><?php echo $stats['products']; ?></h3>
            <p>Total Products</p>
        </div>
        
        <div class="stat-card">
            <h3>₹<?php echo number_format($stats['inventory_value'], 2); ?></h3>
            <p>Inventory Value</p>
        </div>
        
        <div class="stat-card">
            <h3><?php echo $stats['pending_orders']; ?></h3>
            <p>Pending Orders</p>
        </div>
        
        <div class="stat-card">
            <h3><?php echo $stats['low_stock']; ?></h3>
            <p>Low Stock Items</p>
        </div>
    </div>
    
    <div class="card">
        <h2>Recent Purchase Orders</h2>
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Supplier</th>
                    <th>Date</th>
                    <th>Amount</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($recent_orders as $order): ?>
                <tr>
                    <td>#<?php echo $order['order_id']; ?></td>
                    <td><?php echo htmlspecialchars($order['supplier_name']); ?></td>
                    <td><?php echo date('d M Y', strtotime($order['order_date'])); ?></td>
                    <td>₹<?php echo number_format($order['total_amount'], 2); ?></td>
                    <td class="status-<?php echo strtolower($order['status']); ?>">
                        <?php echo $order['status']; ?>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>

<?php include '../includes/footer.php'; ?>
