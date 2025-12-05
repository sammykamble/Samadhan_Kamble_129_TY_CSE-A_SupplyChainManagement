-- ============================================
-- SAMPLE DATA INSERTION
-- Supply Chain Management System
-- ============================================

USE supply_chain_db;

-- ============================================
-- INSERT SUPPLIERS
-- ============================================
INSERT INTO suppliers (supplier_name, contact_person, email, phone, address, city, country, rating) VALUES
('TechParts India Pvt Ltd', 'Rajesh Kumar', 'rajesh@techparts.com', '+91-9876543210', '123 Industrial Area', 'Mumbai', 'India', 4.5),
('Global Electronics Corp', 'Sarah Johnson', 'sarah@globalelec.com', '+91-9876543211', '456 Tech Park', 'Bangalore', 'India', 4.8),
('Prime Components Ltd', 'Amit Sharma', 'amit@primecomp.com', '+91-9876543212', '789 Business District', 'Delhi', 'India', 4.2),
('Quality Hardware Solutions', 'Priya Patel', 'priya@qualityhw.com', '+91-9876543213', '321 Market Road', 'Pune', 'India', 4.6),
('Mega Supplies Inc', 'John Smith', 'john@megasupplies.com', '+91-9876543214', '654 Commerce Street', 'Chennai', 'India', 4.3),
('Swift Distributors', 'Neha Gupta', 'neha@swiftdist.com', '+91-9876543215', '987 Trade Center', 'Hyderabad', 'India', 4.7),
('Reliable Parts Co', 'Vikram Singh', 'vikram@reliableparts.com', '+91-9876543216', '147 Supply Lane', 'Kolkata', 'India', 4.4),
('Express Components', 'Anjali Reddy', 'anjali@expresscomp.com', '+91-9876543217', '258 Vendor Plaza', 'Ahmedabad', 'India', 4.1);

-- ============================================
-- INSERT WAREHOUSES
-- ============================================
INSERT INTO warehouses (warehouse_name, location, city, capacity, manager_name, phone) VALUES
('Central Warehouse Mumbai', 'Andheri East, MIDC Area', 'Mumbai', 50000, 'Suresh Mehta', '+91-9123456780'),
('North Distribution Center', 'Sector 18, Industrial Zone', 'Delhi', 40000, 'Ramesh Verma', '+91-9123456781'),
('South Regional Hub', 'Whitefield Tech Park', 'Bangalore', 45000, 'Lakshmi Iyer', '+91-9123456782'),
('West Coast Facility', 'Hinjewadi Phase 2', 'Pune', 35000, 'Kiran Desai', '+91-9123456783'),
('East Zone Storage', 'Salt Lake Sector V', 'Kolkata', 30000, 'Debashis Roy', '+91-9123456784');

-- ============================================
-- INSERT ADMINS
-- ============================================
INSERT INTO admins (username, password, full_name, email, role) VALUES
('admin', MD5('admin123'), 'System Administrator', 'admin@supplychain.com', 'Super Admin'),
('manager1', MD5('manager123'), 'Rohit Malhotra', 'rohit@supplychain.com', 'Manager'),
('staff1', MD5('staff123'), 'Sneha Kapoor', 'sneha@supplychain.com', 'Staff'),
('manager2', MD5('manager123'), 'Arjun Nair', 'arjun@supplychain.com', 'Manager'),
('staff2', MD5('staff123'), 'Pooja Joshi', 'pooja@supplychain.com', 'Staff');

-- ============================================
-- INSERT PRODUCTS
-- ============================================
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

-- ============================================
-- INSERT INVENTORY
-- ============================================
INSERT INTO inventory (product_id, warehouse_id, quantity) VALUES
-- Mumbai Warehouse
(1, 1, 150), (2, 1, 80), (3, 1, 200), (4, 1, 120), (5, 1, 350),
(6, 1, 95), (7, 1, 75), (8, 1, 140), (9, 1, 280), (10, 1, 160),
-- Delhi Warehouse
(1, 2, 120), (2, 2, 65), (3, 2, 180), (4, 2, 90), (5, 2, 300),
(11, 2, 110), (12, 2, 250), (13, 2, 400), (14, 2, 130), (15, 2, 220),
-- Bangalore Warehouse
(2, 3, 100), (3, 3, 220), (6, 3, 110), (7, 3, 85), (10, 3, 145),
(11, 3, 95), (12, 3, 280), (13, 3, 450), (14, 3, 115), (15, 3, 190),
-- Pune Warehouse
(1, 4, 90), (4, 4, 105), (5, 4, 270), (8, 4, 125), (9, 4, 240),
(10, 4, 135), (12, 4, 200), (13, 4, 380), (14, 4, 100), (15, 4, 180),
-- Kolkata Warehouse
(3, 5, 160), (5, 5, 250), (9, 5, 200), (11, 5, 80), (12, 5, 220),
(13, 5, 350), (14, 5, 90), (15, 5, 160);

-- ============================================
-- INSERT PURCHASE ORDERS
-- ============================================
INSERT INTO purchase_orders (supplier_id, order_date, expected_delivery, status, total_amount, created_by) VALUES
(1, '2024-11-01', '2024-11-10', 'Completed', 125000.00, 1),
(2, '2024-11-05', '2024-11-15', 'Completed', 340000.00, 2),
(3, '2024-11-08', '2024-11-18', 'Completed', 89500.00, 3),
(4, '2024-11-12', '2024-11-22', 'Pending', 45000.00, 2),
(5, '2024-11-15', '2024-11-25', 'Pending', 78000.00, 4),
(6, '2024-11-18', '2024-11-28', 'In Transit', 62000.00, 3),
(7, '2024-11-20', '2024-11-30', 'Pending', 54000.00, 5),
(8, '2024-11-22', '2024-12-02', 'Pending', 38000.00, 2),
(1, '2024-11-25', '2024-12-05', 'Pending', 95000.00, 1),
(2, '2024-11-26', '2024-12-06', 'Pending', 180000.00, 4);

-- ============================================
-- INSERT SHIPMENTS
-- ============================================
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
