-- ============================================
-- SUPPLY CHAIN MANAGEMENT SYSTEM
-- COMPLETE SQL FILE - RUN THIS IN phpMyAdmin
-- ============================================
-- This file contains:
-- 1. Database creation
-- 2. All table schemas
-- 3. Sample data
-- 4. Views, Stored Procedures, and Triggers
-- ============================================

-- ============================================
-- STEP 1: CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS supply_chain_db;
USE supply_chain_db;

-- ============================================
-- STEP 2: CREATE TABLES
-- ============================================

-- TABLE: SUPPLIERS
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(50),
    country VARCHAR(50) DEFAULT 'India',
    rating DECIMAL(2,1) CHECK (rating >= 1.0 AND rating <= 5.0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABLE: WAREHOUSES
CREATE TABLE warehouses (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0),
    manager_name VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABLE: ADMINS
CREATE TABLE admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('Super Admin', 'Manager', 'Staff') DEFAULT 'Staff',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABLE: PRODUCTS
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    reorder_level INT DEFAULT 10 CHECK (reorder_level >= 0),
    supplier_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- TABLE: INVENTORY
CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY unique_product_warehouse (product_id, warehouse_id)
);

-- TABLE: PURCHASE_ORDERS
CREATE TABLE purchase_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    order_date DATE NOT NULL,
    expected_delivery DATE NOT NULL,
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    total_amount DECIMAL(12,2) NOT NULL CHECK (total_amount >= 0),
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (created_by) REFERENCES admins(admin_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (expected_delivery >= order_date)
);

-- TABLE: SHIPMENTS
CREATE TABLE shipments (
    shipment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    shipment_date DATE NOT NULL,
    delivery_date DATE,
    status ENUM('In Transit', 'Delivered', 'Delayed') DEFAULT 'In Transit',
    tracking_number VARCHAR(50) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES purchase_orders(order_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (delivery_date IS NULL OR delivery_date >= shipment_date)
);

-- CREATE INDEXES
CREATE INDEX idx_products_supplier ON products(supplier_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_inventory_warehouse ON inventory(warehouse_id);
CREATE INDEX idx_orders_supplier ON purchase_orders(supplier_id);
CREATE INDEX idx_orders_status ON purchase_orders(status);
CREATE INDEX idx_shipments_order ON shipments(order_id);
CREATE INDEX idx_shipments_status ON shipments(status);


-- ============================================
-- STEP 3: INSERT SAMPLE DATA
-- ============================================

-- INSERT SUPPLIERS
INSERT INTO suppliers (supplier_name, contact_person, email, phone, address, city, country, rating) VALUES
('TechParts India Pvt Ltd', 'Rajesh Kumar', 'rajesh@techparts.com', '+91-9876543210', '123 Industrial Area', 'Mumbai', 'India', 4.5),
('Global Electronics Corp', 'Sarah Johnson', 'sarah@globalelec.com', '+91-9876543211', '456 Tech Park', 'Bangalore', 'India', 4.8),
('Prime Components Ltd', 'Amit Sharma', 'amit@primecomp.com', '+91-9876543212', '789 Business District', 'Delhi', 'India', 4.2),
('Quality Hardware Solutions', 'Priya Patel', 'priya@qualityhw.com', '+91-9876543213', '321 Market Road', 'Pune', 'India', 4.6),
('Mega Supplies Inc', 'John Smith', 'john@megasupplies.com', '+91-9876543214', '654 Commerce Street', 'Chennai', 'India', 4.3),
('Swift Distributors', 'Neha Gupta', 'neha@swiftdist.com', '+91-9876543215', '987 Trade Center', 'Hyderabad', 'India', 4.7),
('Reliable Parts Co', 'Vikram Singh', 'vikram@reliableparts.com', '+91-9876543216', '147 Supply Lane', 'Kolkata', 'India', 4.4),
('Express Components', 'Anjali Reddy', 'anjali@expresscomp.com', '+91-9876543217', '258 Vendor Plaza', 'Ahmedabad', 'India', 4.1);

-- INSERT WAREHOUSES
INSERT INTO warehouses (warehouse_name, location, city, capacity, manager_name, phone) VALUES
('Central Warehouse Mumbai', 'Andheri East, MIDC Area', 'Mumbai', 50000, 'Suresh Mehta', '+91-9123456780'),
('North Distribution Center', 'Sector 18, Industrial Zone', 'Delhi', 40000, 'Ramesh Verma', '+91-9123456781'),
('South Regional Hub', 'Whitefield Tech Park', 'Bangalore', 45000, 'Lakshmi Iyer', '+91-9123456782'),
('West Coast Facility', 'Hinjewadi Phase 2', 'Pune', 35000, 'Kiran Desai', '+91-9123456783'),
('East Zone Storage', 'Salt Lake Sector V', 'Kolkata', 30000, 'Debashis Roy', '+91-9123456784');

-- INSERT ADMINS
INSERT INTO admins (username, password, full_name, email, role) VALUES
('admin', MD5('admin123'), 'System Administrator', 'admin@supplychain.com', 'Super Admin'),
('manager1', MD5('manager123'), 'Rohit Malhotra', 'rohit@supplychain.com', 'Manager'),
('staff1', MD5('staff123'), 'Sneha Kapoor', 'sneha@supplychain.com', 'Staff'),
('manager2', MD5('manager123'), 'Arjun Nair', 'arjun@supplychain.com', 'Manager'),
('staff2', MD5('staff123'), 'Pooja Joshi', 'pooja@supplychain.com', 'Staff');

-- INSERT PRODUCTS
INSERT INTO products (product_name, category, description, unit_price, reorder_level, supplier_id) VALUES
('Laptop Battery', 'Electronics', 'High capacity lithium-ion battery', 2500.00, 20, 1),
('LED Monitor 24 inch', 'Electronics', 'Full HD display with HDMI', 8500.00, 15, 2),
('Wireless Mouse', 'Accessories', 'Ergonomic design with USB receiver', 450.00, 50, 3),
('Mechanical Keyboard', 'Accessories', 'RGB backlit gaming keyboard', 3200.00, 25, 3),
('USB-C Cable', 'Cables', '2 meter fast charging cable', 350.00, 100, 4),
('External Hard Drive 1TB', 'Storage', 'Portable USB 3.0 hard drive', 4500.00, 30, 2),
('Webcam HD', 'Electronics', '1080p video conferencing camera', 2800.00, 20, 5),
('Laptop Cooling Pad', 'Accessories', 'Dual fan cooling system', 1200.00, 40, 6),
('HDMI Cable 3m', 'Cables', 'High speed 4K compatible', 550.00, 80, 4),
('Power Bank 20000mAh', 'Electronics', 'Fast charging portable charger', 1800.00, 35, 7),
('Bluetooth Speaker', 'Electronics', 'Wireless portable speaker', 2200.00, 25, 5),
('Phone Case', 'Accessories', 'Shockproof protective case', 350.00, 100, 8),
('Screen Protector', 'Accessories', 'Tempered glass protection', 250.00, 150, 8),
('USB Hub 4-Port', 'Accessories', 'USB 3.0 multi-port hub', 850.00, 45, 6),
('Ethernet Cable 5m', 'Cables', 'Cat6 network cable', 400.00, 70, 4);

-- INSERT INVENTORY
INSERT INTO inventory (product_id, warehouse_id, quantity) VALUES
(1, 1, 150), (2, 1, 80), (3, 1, 200), (4, 1, 120), (5, 1, 350),
(6, 1, 95), (7, 1, 75), (8, 1, 140), (9, 1, 280), (10, 1, 160),
(1, 2, 120), (2, 2, 65), (3, 2, 180), (4, 2, 90), (5, 2, 300),
(11, 2, 110), (12, 2, 250), (13, 2, 400), (14, 2, 130), (15, 2, 220),
(2, 3, 100), (3, 3, 220), (6, 3, 110), (7, 3, 85), (10, 3, 145),
(11, 3, 95), (12, 3, 280), (13, 3, 450), (14, 3, 115), (15, 3, 190),
(1, 4, 90), (4, 4, 105), (5, 4, 270), (8, 4, 125), (9, 4, 240),
(10, 4, 135), (12, 4, 200), (13, 4, 380), (14, 4, 100), (15, 4, 180),
(3, 5, 160), (5, 5, 250), (9, 5, 200), (11, 5, 80), (12, 5, 220),
(13, 5, 350), (14, 5, 90), (15, 5, 160);

-- INSERT PURCHASE ORDERS
INSERT INTO purchase_orders (supplier_id, order_date, expected_delivery, status, total_amount, created_by) VALUES
(1, '2024-11-01', '2024-11-10', 'Completed', 125000.00, 1),
(2, '2024-11-05', '2024-11-15', 'Completed', 340000.00, 2),
(3, '2024-11-08', '2024-11-18', 'Completed', 89500.00, 3),
(4, '2024-11-12', '2024-11-22', 'Pending', 45000.00, 2),
(5, '2024-11-15', '2024-11-25', 'Pending', 78000.00, 4),
(6, '2024-11-18', '2024-11-28', 'Pending', 62000.00, 3),
(7, '2024-11-20', '2024-11-30', 'Pending', 54000.00, 5),
(8, '2024-11-22', '2024-12-02', 'Pending', 38000.00, 2),
(1, '2024-11-25', '2024-12-05', 'Pending', 95000.00, 1),
(2, '2024-11-26', '2024-12-06', 'Pending', 180000.00, 4);

-- INSERT SHIPMENTS
INSERT INTO shipments (order_id, warehouse_id, shipment_date, delivery_date, status, tracking_number) VALUES
(1, 1, '2024-11-02', '2024-11-09', 'Delivered', 'TRK1001234567'),
(2, 3, '2024-11-06', '2024-11-14', 'Delivered', 'TRK1001234568'),
(3, 2, '2024-11-09', '2024-11-17', 'Delivered', 'TRK1001234569'),
(4, 4, '2024-11-13', NULL, 'In Transit', 'TRK1001234570'),
(5, 1, '2024-11-16', NULL, 'In Transit', 'TRK1001234571'),
(6, 5, '2024-11-19', NULL, 'In Transit', 'TRK1001234572'),
(7, 2, '2024-11-21', NULL, 'In Transit', 'TRK1001234573'),
(1, 2, '2024-11-03', '2024-11-10', 'Delivered', 'TRK1001234574'),
(2, 1, '2024-11-07', '2024-11-15', 'Delivered', 'TRK1001234575'),
(3, 4, '2024-11-10', '2024-11-18', 'Delivered', 'TRK1001234576');


-- ============================================
-- STEP 4: CREATE VIEWS
-- ============================================

-- View: Product Inventory Summary
CREATE OR REPLACE VIEW vw_product_inventory_summary AS
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    s.supplier_name,
    SUM(i.quantity) AS total_stock,
    p.reorder_level,
    SUM(i.quantity * p.unit_price) AS total_value
FROM products p
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
LEFT JOIN inventory i ON p.product_id = i.product_id
GROUP BY p.product_id, p.product_name, p.category, p.unit_price, s.supplier_name, p.reorder_level;

-- View: Active Orders Dashboard
CREATE OR REPLACE VIEW vw_active_orders AS
SELECT 
    po.order_id,
    s.supplier_name,
    s.phone AS supplier_phone,
    po.order_date,
    po.expected_delivery,
    po.status,
    po.total_amount,
    a.full_name AS ordered_by,
    COUNT(sh.shipment_id) AS shipment_count
FROM purchase_orders po
INNER JOIN suppliers s ON po.supplier_id = s.supplier_id
INNER JOIN admins a ON po.created_by = a.admin_id
LEFT JOIN shipments sh ON po.order_id = sh.order_id
WHERE po.status IN ('Pending', 'In Transit')
GROUP BY po.order_id, s.supplier_name, s.phone, po.order_date, po.expected_delivery, 
         po.status, po.total_amount, a.full_name;

-- View: Warehouse Capacity Utilization
CREATE OR REPLACE VIEW vw_warehouse_utilization AS
SELECT 
    w.warehouse_id,
    w.warehouse_name,
    w.city,
    w.capacity,
    SUM(i.quantity) AS total_items_stored,
    ROUND((SUM(i.quantity) * 100.0 / w.capacity), 2) AS utilization_percentage
FROM warehouses w
LEFT JOIN inventory i ON w.warehouse_id = i.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name, w.city, w.capacity;

-- ============================================
-- STEP 5: CREATE STORED PROCEDURES
-- ============================================

-- Procedure: Add product to inventory
DELIMITER //
CREATE PROCEDURE sp_add_product_to_inventory(
    IN p_product_id INT,
    IN p_warehouse_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE existing_qty INT DEFAULT 0;
    
    SELECT quantity INTO existing_qty 
    FROM inventory 
    WHERE product_id = p_product_id AND warehouse_id = p_warehouse_id;
    
    IF existing_qty > 0 THEN
        UPDATE inventory 
        SET quantity = quantity + p_quantity 
        WHERE product_id = p_product_id AND warehouse_id = p_warehouse_id;
    ELSE
        INSERT INTO inventory (product_id, warehouse_id, quantity) 
        VALUES (p_product_id, p_warehouse_id, p_quantity);
    END IF;
    
    SELECT 'Inventory updated successfully' AS message;
END //
DELIMITER ;

-- Procedure: Create purchase order
DELIMITER //
CREATE PROCEDURE sp_create_purchase_order(
    IN p_supplier_id INT,
    IN p_order_date DATE,
    IN p_expected_delivery DATE,
    IN p_total_amount DECIMAL(12,2),
    IN p_created_by INT,
    OUT p_order_id INT
)
BEGIN
    INSERT INTO purchase_orders (supplier_id, order_date, expected_delivery, total_amount, created_by)
    VALUES (p_supplier_id, p_order_date, p_expected_delivery, p_total_amount, p_created_by);
    
    SET p_order_id = LAST_INSERT_ID();
    
    SELECT p_order_id AS new_order_id, 'Purchase order created successfully' AS message;
END //
DELIMITER ;

-- Procedure: Get low stock products
DELIMITER //
CREATE PROCEDURE sp_get_low_stock_products()
BEGIN
    SELECT 
        p.product_id,
        p.product_name,
        p.category,
        SUM(i.quantity) AS current_stock,
        p.reorder_level,
        s.supplier_name,
        s.contact_person,
        s.phone
    FROM products p
    LEFT JOIN inventory i ON p.product_id = i.product_id
    INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
    GROUP BY p.product_id, p.product_name, p.category, p.reorder_level, 
             s.supplier_name, s.contact_person, s.phone
    HAVING current_stock < p.reorder_level OR current_stock IS NULL
    ORDER BY current_stock ASC;
END //
DELIMITER ;

-- Procedure: Update shipment status
DELIMITER //
CREATE PROCEDURE sp_update_shipment_status(
    IN p_shipment_id INT,
    IN p_status VARCHAR(20),
    IN p_delivery_date DATE
)
BEGIN
    UPDATE shipments 
    SET status = p_status, 
        delivery_date = p_delivery_date 
    WHERE shipment_id = p_shipment_id;
    
    IF p_status = 'Delivered' THEN
        UPDATE purchase_orders po
        INNER JOIN shipments sh ON po.order_id = sh.order_id
        SET po.status = 'Completed'
        WHERE sh.shipment_id = p_shipment_id;
    END IF;
    
    SELECT 'Shipment status updated successfully' AS message;
END //
DELIMITER ;

-- ============================================
-- STEP 6: CREATE TRIGGERS
-- ============================================

-- Trigger: Update inventory after shipment delivery
DELIMITER //
CREATE TRIGGER trg_update_inventory_after_delivery
AFTER UPDATE ON shipments
FOR EACH ROW
BEGIN
    IF NEW.status = 'Delivered' AND OLD.status != 'Delivered' THEN
        INSERT INTO inventory (product_id, warehouse_id, quantity)
        SELECT p.product_id, NEW.warehouse_id, 10
        FROM products p
        WHERE p.supplier_id = (
            SELECT supplier_id FROM purchase_orders WHERE order_id = NEW.order_id
        )
        ON DUPLICATE KEY UPDATE quantity = quantity + 10;
    END IF;
END //
DELIMITER ;

-- Create log table for supplier rating changes
CREATE TABLE IF NOT EXISTS supplier_rating_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT,
    old_rating DECIMAL(2,1),
    new_rating DECIMAL(2,1),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger: Log supplier rating changes
DELIMITER //
CREATE TRIGGER trg_log_supplier_rating_change
AFTER UPDATE ON suppliers
FOR EACH ROW
BEGIN
    IF NEW.rating != OLD.rating THEN
        INSERT INTO supplier_rating_log (supplier_id, old_rating, new_rating)
        VALUES (NEW.supplier_id, OLD.rating, NEW.rating);
    END IF;
END //
DELIMITER ;

-- Trigger: Prevent deletion of suppliers with active orders
DELIMITER //
CREATE TRIGGER trg_prevent_supplier_deletion
BEFORE DELETE ON suppliers
FOR EACH ROW
BEGIN
    DECLARE active_orders INT;
    
    SELECT COUNT(*) INTO active_orders
    FROM purchase_orders
    WHERE supplier_id = OLD.supplier_id AND status = 'Pending';
    
    IF active_orders > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete supplier with active pending orders';
    END IF;
END //
DELIMITER ;

-- Trigger: Auto-update last_updated timestamp in inventory
DELIMITER //
CREATE TRIGGER trg_inventory_timestamp
BEFORE UPDATE ON inventory
FOR EACH ROW
BEGIN
    SET NEW.last_updated = CURRENT_TIMESTAMP;
END //
DELIMITER ;

-- ============================================
-- SETUP COMPLETE!
-- ============================================
-- You can now test the system with these queries:
-- SELECT * FROM vw_product_inventory_summary;
-- CALL sp_get_low_stock_products();
-- SELECT * FROM suppliers;
-- ============================================
