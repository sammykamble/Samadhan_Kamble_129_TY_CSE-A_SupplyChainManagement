<?php
require_once '../config/database.php';
include '../includes/header.php';

if (!isset($_SESSION['admin_id'])) {
    header("Location: ../admin/login.php");
    exit();
}

// Fetch all suppliers
$suppliers = fetch_all("SELECT * FROM suppliers ORDER BY supplier_name");
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
        font-size: 14px;
    }
    
    .btn-small {
        padding: 5px 10px;
        font-size: 12px;
    }
    
    .rating {
        color: #ff9800;
        font-weight: bold;
    }
</style>

<div class="container">
    <div class="card">
        <h2>All Suppliers</h2>
        <a href="add_supplier.php" class="btn">+ Add New Supplier</a>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Supplier Name</th>
                    <th>Contact Person</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>City</th>
                    <th>Rating</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($suppliers as $supplier): ?>
                <tr>
                    <td><?php echo $supplier['supplier_id']; ?></td>
                    <td><?php echo htmlspecialchars($supplier['supplier_name']); ?></td>
                    <td><?php echo htmlspecialchars($supplier['contact_person']); ?></td>
                    <td><?php echo htmlspecialchars($supplier['email']); ?></td>
                    <td><?php echo htmlspecialchars($supplier['phone']); ?></td>
                    <td><?php echo htmlspecialchars($supplier['city']); ?></td>
                    <td class="rating">⭐ <?php echo $supplier['rating']; ?></td>
                    <td>
                        <a href="edit_supplier.php?id=<?php echo $supplier['supplier_id']; ?>" class="btn btn-small">Edit</a>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>

<?php include '../includes/footer.php'; ?>
