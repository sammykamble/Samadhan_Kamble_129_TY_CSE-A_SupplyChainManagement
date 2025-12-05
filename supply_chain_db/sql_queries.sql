-- ============================================
-- SQL QUERIES SECTION
-- Supply Chain Management System
-- ============================================

USE supply_chain_db;

-- ============================================
-- 1. VIEW AVAILABLE INVENTORY BY PRODUCT
-- ============================================

-- Query to show all products with their total inventory across warehouses
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    SUM(i.quantity) AS total_quantity,
    p.reorder_level,
    CASE 
        WHEN SUM(i.quantity) < p.reorder_level THEN 'Low Stock - Reorder Required'
        WHEN SUM(i.quantity) < (p.reorder_level * 2) THEN 'Medium Stock'
        ELSE 'Sufficient Stock'
    END AS stock_status
FROM products p
LEFT JOIN inventory i ON p.product_id = i.product_id
GROUP BY p.product_id, p.product_name, p.category, p.unit_price, p.reorder_level
ORDER BY total_quantity ASC;

-- Detailed inventory by warehouse
SELECT 
    w.warehouse_name,
    w.city,
    p.product_name,
    p.category,
    i.quantity,
    p.unit_price,
    (i.quantity * p.unit_price) AS inventory_value
FROM inventory i
INNER JOIN products p ON i.product_id = p.product_id
INNER JOIN warehouses w ON i.warehouse_id = w.warehouse_id
ORDER BY w.warehouse_name, p.category;

-- ============================================
-- 2. LIST PENDING PURCHASE ORDERS
-- ============================================

SELECT 
    po.order_id,
    s.supplier_name,
    s.contact_person,
    s.phone,
    po.order_date,
    po.expected_delivery,
    po.total_amount,
    po.status,
    a.full_name AS created_by,
    DATEDIFF(po.expected_delivery, CURDATE()) AS days_until_delivery
FROM purchase_orders po
INNER JOIN suppliers s ON po.supplier_id = s.supplier_id
INNER JOIN admins a ON po.created_by = a.admin_id
WHERE po.status = 'Pending'
ORDER BY po.expected_delivery ASC;

-- ============================================
-- 3. SUPPLIER PERFORMANCE DATA
-- ============================================

-- Comprehensive supplier performance analysis
SELECT 
    s.supplier_id,
    s.supplier_name,
    s.rating,
    COUNT(DISTINCT po.order_id) AS total_orders,
    SUM(po.total_amount) AS total_business_value,
    AVG(po.total_amount) AS avg_order_value,
    COUNT(CASE WHEN po.status = 'Completed' THEN 1 END) AS completed_orders,
    COUNT(CASE WHEN po.status = 'Pending' THEN 1 END) AS pending_orders,
    COUNT(CASE WHEN po.status = 'Cancelled' THEN 1 END) AS cancelled_orders,
    ROUND((COUNT(CASE WHEN po.status = 'Completed' THEN 1 END) * 100.0 / COUNT(po.order_id)), 2) AS completion_rate
FROM suppliers s
LEFT JOIN purchase_orders po ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id, s.supplier_name, s.rating
ORDER BY total_business_value DESC;

-- Supplier delivery performance
SELECT 
    s.supplier_name,
    COUNT(sh.shipment_id) AS total_shipments,
    COUNT(CASE WHEN sh.status = 'Delivered' THEN 1 END) AS delivered_shipments,
    COUNT(CASE WHEN sh.status = 'Delayed' THEN 1 END) AS delayed_shipments,
    AVG(DATEDIFF(sh.delivery_date, sh.shipment_date)) AS avg_delivery_days
FROM suppliers s
INNER JOIN purchase_orders po ON s.supplier_id = po.supplier_id
INNER JOIN shipments sh ON po.order_id = sh.order_id
WHERE sh.delivery_date IS NOT NULL
GROUP BY s.supplier_id, s.supplier_name
ORDER BY avg_delivery_days ASC;

-- ============================================
-- 4. TOTAL SHIPMENTS HANDLED BY EACH WAREHOUSE
-- ============================================

SELECT 
    w.warehouse_id,
    w.warehouse_name,
    w.city,
    w.manager_name,
    COUNT(sh.shipment_id) AS total_shipments,
    COUNT(CASE WHEN sh.status = 'Delivered' THEN 1 END) AS delivered,
    COUNT(CASE WHEN sh.status = 'In Transit' THEN 1 END) AS in_transit,
    COUNT(CASE WHEN sh.status = 'Delayed' THEN 1 END) AS delayed,
    SUM(CASE WHEN sh.status = 'Delivered' THEN 1 ELSE 0 END) * 100.0 / COUNT(sh.shipment_id) AS delivery_success_rate
FROM warehouses w
LEFT JOIN shipments sh ON w.warehouse_id = sh.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name, w.city, w.manager_name
ORDER BY total_shipments DESC;

-- ============================================
-- 5. INNER JOIN QUERIES
-- ============================================

-- Products with supplier information
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    s.supplier_name,
    s.contact_person,
    s.email,
    s.rating
FROM products p
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
ORDER BY p.category, p.product_name;

-- Orders with shipment tracking
SELECT 
    po.order_id,
    s.supplier_name,
    po.order_date,
    po.total_amount,
    sh.tracking_number,
    sh.shipment_date,
    sh.status AS shipment_status,
    w.warehouse_name
FROM purchase_orders po
INNER JOIN suppliers s ON po.supplier_id = s.supplier_id
INNER JOIN shipments sh ON po.order_id = sh.order_id
INNER JOIN warehouses w ON sh.warehouse_id = w.warehouse_id
ORDER BY po.order_date DESC;

-- ============================================
-- 6. LEFT JOIN QUERIES
-- ============================================

-- All suppliers with their order count (including suppliers with no orders)
SELECT 
    s.supplier_id,
    s.supplier_name,
    s.city,
    s.rating,
    COUNT(po.order_id) AS total_orders,
    COALESCE(SUM(po.total_amount), 0) AS total_value
FROM suppliers s
LEFT JOIN purchase_orders po ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id, s.supplier_name, s.city, s.rating
ORDER BY total_orders DESC;

-- All products with inventory (including products not in any warehouse)
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    w.warehouse_name,
    COALESCE(i.quantity, 0) AS quantity
FROM products p
LEFT JOIN inventory i ON p.product_id = i.product_id
LEFT JOIN warehouses w ON i.warehouse_id = w.warehouse_id
ORDER BY p.product_name, w.warehouse_name;

-- ============================================
-- 7. SUBQUERIES
-- ============================================

-- Products with below reorder level inventory
SELECT 
    product_name,
    category,
    reorder_level,
    (SELECT SUM(quantity) FROM inventory WHERE product_id = p.product_id) AS current_stock
FROM products p
WHERE (SELECT SUM(quantity) FROM inventory WHERE product_id = p.product_id) < p.reorder_level
ORDER BY current_stock ASC;

-- Suppliers with above average order value
SELECT 
    supplier_name,
    (SELECT COUNT(*) FROM purchase_orders WHERE supplier_id = s.supplier_id) AS order_count,
    (SELECT AVG(total_amount) FROM purchase_orders WHERE supplier_id = s.supplier_id) AS avg_order_value
FROM suppliers s
WHERE (SELECT AVG(total_amount) FROM purchase_orders WHERE supplier_id = s.supplier_id) > 
      (SELECT AVG(total_amount) FROM purchase_orders)
ORDER BY avg_order_value DESC;

-- Warehouses with highest inventory value
SELECT 
    w.warehouse_name,
    w.city,
    (SELECT SUM(i.quantity * p.unit_price) 
     FROM inventory i 
     INNER JOIN products p ON i.product_id = p.product_id 
     WHERE i.warehouse_id = w.warehouse_id) AS total_inventory_value
FROM warehouses w
ORDER BY total_inventory_value DESC;

-- ============================================
-- 8. VIEWS
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
-- 9. STORED PROCEDURES
-- ============================================

-- Procedure: Add new product to inventory
DELIMITER //
CREATE PROCEDURE sp_add_product_to_inventory(
    IN p_product_id INT,
    IN p_warehouse_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE existing_qty INT DEFAULT 0;
    
    -- Check if product already exists in warehouse
    SELECT quantity INTO existing_qty 
    FROM inventory 
    WHERE product_id = p_product_id AND warehouse_id = p_warehouse_id;
    
    IF existing_qty > 0 THEN
        -- Update existing inventory
        UPDATE inventory 
        SET quantity = quantity + p_quantity 
        WHERE product_id = p_product_id AND warehouse_id = p_warehouse_id;
    ELSE
        -- Insert new inventory record
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
    
    -- If delivered, update purchase order status
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
-- 10. TRIGGERS
-- ============================================

-- Trigger: Update inventory after shipment delivery
DELIMITER //
CREATE TRIGGER trg_update_inventory_after_delivery
AFTER UPDATE ON shipments
FOR EACH ROW
BEGIN
    -- Only execute if status changed to 'Delivered'
    IF NEW.status = 'Delivered' AND OLD.status != 'Delivered' THEN
        -- This is a simplified trigger
        -- In real scenario, you'd need order_items table to know quantities
        INSERT INTO inventory (product_id, warehouse_id, quantity)
        SELECT p.product_id, NEW.warehouse_id, 10  -- Default quantity for demo
        FROM products p
        WHERE p.supplier_id = (
            SELECT supplier_id FROM purchase_orders WHERE order_id = NEW.order_id
        )
        ON DUPLICATE KEY UPDATE quantity = quantity + 10;
    END IF;
END //
DELIMITER ;

-- Trigger: Log supplier rating changes
CREATE TABLE IF NOT EXISTS supplier_rating_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT,
    old_rating DECIMAL(2,1),
    new_rating DECIMAL(2,1),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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
-- USAGE EXAMPLES
-- ============================================

-- Using stored procedures
-- CALL sp_add_product_to_inventory(1, 1, 50);
-- CALL sp_get_low_stock_products();
-- CALL sp_update_shipment_status(1, 'Delivered', '2024-11-28');

-- Using views
-- SELECT * FROM vw_product_inventory_summary;
-- SELECT * FROM vw_active_orders;
-- SELECT * FROM vw_warehouse_utilization;
