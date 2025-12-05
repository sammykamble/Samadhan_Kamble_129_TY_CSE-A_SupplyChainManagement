<?php
require_once '../config/database.php';
include '../includes/header.php';

if (!isset($_SESSION['admin_id'])) {
    header("Location: ../admin/login.php");
    exit();
}

$error = '';
$success = '';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $supplier_name = sanitize_input($_POST['supplier_name']);
    $contact_person = sanitize_input($_POST['contact_person']);
    $email = sanitize_input($_POST['email']);
    $phone = sanitize_input($_POST['phone']);
    $address = sanitize_input($_POST['address']);
    $city = sanitize_input($_POST['city']);
    $country = sanitize_input($_POST['country']);
    $rating = sanitize_input($_POST['rating']);
    
    // Validation
    if (empty($supplier_name) || empty($contact_person) || empty($email) || empty($phone)) {
        $error = "Please fill all required fields";
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error = "Invalid email format";
    } elseif ($rating < 1 || $rating > 5) {
        $error = "Rating must be between 1 and 5";
    } else {
        $query = "INSERT INTO suppliers (supplier_name, contact_person, email, phone, address, city, country, rating) 
                  VALUES ('$supplier_name', '$contact_person', '$email', '$phone', '$address', '$city', '$country', $rating)";
        
        if (execute_query($query)) {
            $success = "Supplier added successfully!";
            // Clear form
            $_POST = array();
        } else {
            $error = "Error adding supplier. Email might already exist.";
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
    
    input, select, textarea {
        width: 100%;
        padding: 10px;
        border: 2px solid #e0e0e0;
        border-radius: 5px;
        font-size: 14px;
    }
    
    input:focus, select:focus, textarea:focus {
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
    }
    
    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
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
        <h2>Add New Supplier</h2>
        
        <?php if ($error): ?>
            <div class="error"><?php echo $error; ?></div>
        <?php endif; ?>
        
        <?php if ($success): ?>
            <div class="success"><?php echo $success; ?></div>
        <?php endif; ?>
        
        <form method="POST" action="">
            <div class="form-grid">
                <div class="form-group">
                    <label for="supplier_name">Supplier Name *</label>
                    <input type="text" id="supplier_name" name="supplier_name" required>
                </div>
                
                <div class="form-group">
                    <label for="contact_person">Contact Person *</label>
                    <input type="text" id="contact_person" name="contact_person" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" required>
                </div>
                
                <div class="form-group">
                    <label for="phone">Phone *</label>
                    <input type="text" id="phone" name="phone" required>
                </div>
                
                <div class="form-group">
                    <label for="city">City</label>
                    <input type="text" id="city" name="city">
                </div>
                
                <div class="form-group">
                    <label for="country">Country</label>
                    <input type="text" id="country" name="country" value="India">
                </div>
                
                <div class="form-group full-width">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" rows="3"></textarea>
                </div>
                
                <div class="form-group">
                    <label for="rating">Rating (1-5)</label>
                    <input type="number" id="rating" name="rating" min="1" max="5" step="0.1" value="4.0">
                </div>
            </div>
            
            <button type="submit" class="btn">Add Supplier</button>
            <a href="view_suppliers.php" class="btn" style="background: #666; text-decoration: none; display: inline-block; margin-left: 10px;">View All Suppliers</a>
        </form>
    </div>
</div>

<?php include '../includes/footer.php'; ?>
