<?php
require_once '../config/database.php';
include '../includes/header.php';

if (!isset($_SESSION['admin_id'])) {
    header("Location: ../admin/login.php");
    exit();
}

// Fetch all orders
$orders = fetch_all("SELECT po.order_id, s.supplier_name, po.order_date, 
                     po.expected_delivery, po.total_amount, po.status, a.full_name
                     FROM purchase_orders po
                     INNER JOIN suppliers s ON po.supplier_id = s.supplier_id
                     INNER JOIN admins a ON po.created_by = a.admin_id
                     ORDER BY po.order_date DESC");
?>

<style>
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
        font-weight: 600;
    }
    
    tr:hover {
        background: #f5f5f5;
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
    }
    
    .status-pending {
        color: #ff9800;
        font-weight: bold;
    }
    
    .status-completed {
        color: #4caf50;
        font-weight: bold;
    }
    
    .status-cancelled {
        color: #f44336;
        font-weight: bold;
    }
</style>

<div class="container">
    <div class="card">
        <h2>Purchase Orders</h2>
        <a href="create_order.php" class="btn">+ Create New Order</a>
        
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Supplier</th>
                    <th>Order Date</th>
                    <th>Expected Delivery</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th>Created By</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($orders as $order): ?>
                <tr>
                    <td>#<?php echo $order['order_id']; ?></td>
                    <td><?php echo htmlspecialchars($order['supplier_name']); ?></td>
                    <td><?php echo date('d M Y', strtotime($order['order_date'])); ?></td>
                    <td><?php echo date('d M Y', strtotime($order['expected_delivery'])); ?></td>
                    <td>₹<?php echo number_format($order['total_amount'], 2); ?></td>
                    <td class="status-<?php echo strtolower($order['status']); ?>">
                        <?php echo $order['status']; ?>
                    </td>
                    <td><?php echo htmlspecialchars($order['full_name']); ?></td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>

<?php include '../includes/footer.php'; ?>
