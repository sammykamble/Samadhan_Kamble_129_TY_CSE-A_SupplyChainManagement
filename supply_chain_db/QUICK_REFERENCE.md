# Quick Reference Guide
## Supply Chain Management System

---

## 🎯 5-Minute Setup

```
1. Install XAMPP → Start Apache & MySQL
2. Open http://localhost/phpmyadmin
3. SQL Tab → Paste COMPLETE_SQL_FILE.sql → Go
4. Copy php_files to C:\xampp\htdocs\supplychain\
5. Open http://localhost/supplychain/
6. Login: admin / admin123
```

---

## 📊 Database Quick Stats

- **Tables:** 7
- **Sample Records:** 100+
- **Views:** 3
- **Stored Procedures:** 4
- **Triggers:** 4
- **Indexes:** 8

---

## 🔑 Login Credentials

```
Super Admin: admin / admin123
Manager:     manager1 / manager123
Staff:       staff1 / staff123
```

---

## 📝 Essential SQL Queries

### View All Inventory
```sql
SELECT * FROM vw_product_inventory_summary;
```

### Low Stock Alert
```sql
CALL sp_get_low_stock_products();
```

### Pending Orders
```sql
SELECT * FROM vw_active_orders;
```

### Supplier Performance
```sql
SELECT s.supplier_name, COUNT(po.order_id) as orders
FROM suppliers s
LEFT JOIN purchase_orders po ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id;
```

### Warehouse Utilization
```sql
SELECT * FROM vw_warehouse_utilization;
```

---

## 🌐 Application URLs

```
Main:           http://localhost/supplychain/
Test DB:        http://localhost/supplychain/test_connection.php
Login:          http://localhost/supplychain/admin/login.php
Dashboard:      http://localhost/supplychain/admin/dashboard.php
Suppliers:      http://localhost/supplychain/suppliers/view_suppliers.php
Inventory:      http://localhost/supplychain/inventory/view_inventory.php
Orders:         http://localhost/supplychain/orders/view_orders.php
```

---

## 🗂 Table Structure

### suppliers
```
supplier_id (PK), supplier_name, contact_person, email, 
phone, address, city, country, rating, created_at
```

### products
```
product_id (PK), product_name, category, description, 
unit_price, reorder_level, supplier_id (FK), created_at
```

### inventory
```
inventory_id (PK), product_id (FK), warehouse_id (FK), 
quantity, last_updated
```

### purchase_orders
```
order_id (PK), supplier_id (FK), order_date, expected_delivery, 
status, total_amount, created_by (FK), created_at
```

### shipments
```
shipment_id (PK), order_id (FK), warehouse_id (FK), 
shipment_date, delivery_date, status, tracking_number, created_at
```

### warehouses
```
warehouse_id (PK), warehouse_name, location, city, 
capacity, manager_name, phone, created_at
```

### admins
```
admin_id (PK), username, password, full_name, 
email, role, created_at
```

---

## 🔧 Common Fixes

### Port 80 Busy
```
httpd.conf → Listen 8080
Access: http://localhost:8080/
```

### Port 3306 Busy
```
my.ini → port=3307
database.php → Update port
```

### Database Connection Failed
```
Check: config/database.php
Default: root / (no password)
```

### Tables Not Found
```
Run: COMPLETE_SQL_FILE.sql in phpMyAdmin
```

---

## 📋 Testing Checklist

- [ ] XAMPP services running
- [ ] Database created successfully
- [ ] All tables visible in phpMyAdmin
- [ ] Sample data inserted
- [ ] Test connection page works
- [ ] Login successful
- [ ] Dashboard loads with stats
- [ ] Can add supplier
- [ ] Can view inventory
- [ ] Can create order
- [ ] All queries execute
- [ ] Views return data
- [ ] Procedures work

---

## 🎓 Viva Quick Points

**Normalization:** 3NF - No transitive dependencies

**Constraints Used:**
- PRIMARY KEY (all tables)
- FOREIGN KEY (7 relationships)
- CHECK (rating, prices, dates)
- UNIQUE (email, tracking)
- NOT NULL (required fields)

**Joins:**
- INNER JOIN: Only matching records
- LEFT JOIN: All left + matching right

**Views:** Pre-defined queries for reporting

**Procedures:** Reusable SQL code blocks

**Triggers:** Automatic actions on events

**Indexes:** Speed up query performance

---

## 📞 File Locations

```
Database Config:  php_files/config/database.php
Login Page:       php_files/admin/login.php
Dashboard:        php_files/admin/dashboard.php
Add Supplier:     php_files/suppliers/add_supplier.php
View Inventory:   php_files/inventory/view_inventory.php
Create Order:     php_files/orders/create_order.php
```

---

## 🚀 Key Features

✅ Real-time inventory tracking
✅ Supplier performance analytics
✅ Purchase order management
✅ Shipment tracking
✅ Low stock alerts
✅ Multi-warehouse support
✅ Role-based access control
✅ Automated inventory updates

---

## 📊 Sample Data Summary

- **8 Suppliers** (TechParts, Global Electronics, etc.)
- **5 Warehouses** (Mumbai, Delhi, Bangalore, Pune, Kolkata)
- **15 Products** (Electronics, Accessories, Cables)
- **38 Inventory Records** across warehouses
- **10 Purchase Orders** (Pending & Completed)
- **10 Shipments** (In Transit & Delivered)
- **5 Admin Users** (Super Admin, Managers, Staff)

---

## 🔐 Security Features

- MD5 password hashing
- Session management
- Input sanitization
- SQL injection prevention
- Role-based access
- Error logging

---

## 📈 Dashboard Metrics

- Total Suppliers Count
- Total Products Count
- Total Inventory Value (₹)
- Pending Orders Count
- Low Stock Items Count
- Recent Orders Table

---

## 💡 Pro Tips

1. Always run COMPLETE_SQL_FILE.sql first
2. Check XAMPP services before accessing app
3. Use test_connection.php to verify setup
4. Clear browser cache if CSS doesn't load
5. Check PHP error logs for debugging
6. Backup database before making changes
7. Use phpMyAdmin for quick SQL testing

---

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| README.md | Main documentation |
| PROJECT_DOCUMENTATION.md | Project details & ER diagram |
| XAMPP_IMPLEMENTATION_GUIDE.md | Setup instructions |
| FINAL_DELIVERABLES.md | Viva preparation |
| QUICK_REFERENCE.md | This file |
| COMPLETE_SQL_FILE.sql | All-in-one SQL |

---

## ⚡ Quick Commands

### Backup Database
```cmd
cd C:\xampp\mysql\bin
mysqldump -u root -p supply_chain_db > backup.sql
```

### Restore Database
```cmd
mysql -u root -p supply_chain_db < backup.sql
```

### Check MySQL Status
```cmd
cd C:\xampp\mysql\bin
mysql -u root -p
SHOW DATABASES;
USE supply_chain_db;
SHOW TABLES;
```

---

## 🎯 Project Objectives Met

✅ Automate supply chain operations
✅ Real-time inventory visibility
✅ Track supplier performance
✅ Manage warehouse operations
✅ Enable data-driven decisions
✅ Reduce manual errors
✅ Improve order accuracy
✅ Decrease stockout incidents

---

**Print this page for quick reference during viva! 📄**

---

*Last Updated: November 2024*
