# 🚚 Supply Chain Management System
## Database Systems (DBS) Mini Project

A comprehensive database-driven supply chain management system built with MySQL and PHP for XAMPP server.

---

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Quick Start Guide](#quick-start-guide)
- [File Structure](#file-structure)
- [Database Schema](#database-schema)
- [Screenshots & Demo](#screenshots--demo)
- [Default Credentials](#default-credentials)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Future Enhancements](#future-enhancements)

---

## 🎯 Project Overview

The Supply Chain Management System is designed to automate and streamline supply chain operations including:

- **Supplier Management** - Track supplier information and performance
- **Product Catalog** - Maintain product details with categories
- **Inventory Tracking** - Real-time stock monitoring across warehouses
- **Purchase Orders** - Create and manage procurement orders
- **Shipment Tracking** - Monitor delivery status and logistics
- **Warehouse Operations** - Manage multiple storage facilities
- **Admin Dashboard** - Comprehensive analytics and reporting

### Project Goals
- Reduce inventory holding costs by 20%
- Improve order fulfillment accuracy to 98%
- Decrease stockout incidents by 30%
- Provide real-time visibility into supply chain operations

---

## ✨ Features

### Database Features
- ✅ 7 normalized tables (3NF)
- ✅ Complete referential integrity with foreign keys
- ✅ CHECK constraints for data validation
- ✅ 3 custom views for reporting
- ✅ 4 stored procedures for business logic
- ✅ 4 triggers for automation
- ✅ 8 indexes for performance optimization

### Application Features
- ✅ Secure login system with role-based access
- ✅ Interactive dashboard with real-time statistics
- ✅ Complete CRUD operations for all entities
- ✅ Low stock alerts and notifications
- ✅ Supplier performance analytics
- ✅ Inventory value calculations
- ✅ Order status tracking
- ✅ Responsive UI with modern design

---

## 🛠 Technology Stack

- **Database:** MySQL 8.0
- **Server:** XAMPP (Apache + MySQL + PHP)
- **Backend:** PHP 7.4+
- **Frontend:** HTML5, CSS3, JavaScript
- **Design:** Custom CSS with gradient themes

---

## 🚀 Quick Start Guide

### Prerequisites
- XAMPP installed on your system
- Web browser (Chrome, Firefox, Edge)
- Basic knowledge of SQL and PHP

### Installation Steps

**1. Install XAMPP**
```
Download from: https://www.apachefriends.org/
Install to: C:\xampp (default)
```

**2. Start Services**
- Open XAMPP Control Panel
- Start Apache
- Start MySQL

**3. Create Database**
- Open browser: http://localhost/phpmyadmin
- Click "SQL" tab
- Copy and paste entire content from `COMPLETE_SQL_FILE.sql`
- Click "Go" button
- Wait for success message

**4. Setup PHP Files**
```cmd
Copy php_files folder contents to:
C:\xampp\htdocs\supplychain\
```

**5. Access Application**
```
Open browser: http://localhost/supplychain/
Login with: admin / admin123
```

### Verification
- Test database connection: http://localhost/supplychain/test_connection.php
- Should display "Database Connected Successfully!"

---

## 📁 File Structure

```
Supply-Chain-Management-System/
│
├── README.md                          # This file
├── PROJECT_DOCUMENTATION.md           # Complete project description
├── XAMPP_IMPLEMENTATION_GUIDE.md      # Detailed setup guide
├── FINAL_DELIVERABLES.md             # Project summary & viva prep
│
├── COMPLETE_SQL_FILE.sql             # All-in-one SQL file
├── database_schema.sql               # Table creation scripts
├── sample_data.sql                   # Sample data inserts
├── sql_queries.sql                   # Queries, views, procedures
│
└── php_files/                        # Web application
    ├── index.php
    ├── test_connection.php
    ├── config/
    │   └── database.php
    ├── includes/
    │   ├── header.php
    │   └── footer.php
    ├── admin/
    │   ├── login.php
    │   ├── dashboard.php
    │   └── logout.php
    ├── suppliers/
    │   ├── add_supplier.php
    │   └── view_suppliers.php
    ├── inventory/
    │   ├── view_inventory.php
    │   └── update_inventory.php
    └── orders/
        ├── create_order.php
        └── view_orders.php
```

---

## 🗄 Database Schema

### Tables (7)

1. **suppliers** - Supplier information and ratings
2. **warehouses** - Storage facility details
3. **admins** - System users with roles
4. **products** - Product catalog
5. **inventory** - Stock levels by warehouse
6. **purchase_orders** - Procurement orders
7. **shipments** - Delivery tracking

### Relationships

```
suppliers (1) ----< (N) products
products (1) ----< (N) inventory
warehouses (1) ----< (N) inventory
suppliers (1) ----< (N) purchase_orders
purchase_orders (1) ----< (N) shipments
warehouses (1) ----< (N) shipments
admins (1) ----< (N) purchase_orders
```

### ER Diagram (Text Format)

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│  SUPPLIERS  │──────<│  PRODUCTS   │──────<│  INVENTORY  │
└─────────────┘       └─────────────┘       └─────────────┘
      │                                             │
      │                                             │
      ▼                                             ▼
┌─────────────┐                             ┌─────────────┐
│PURCHASE_ORD │                             │ WAREHOUSES  │
└─────────────┘                             └─────────────┘
      │                                             │
      │                                             │
      ▼                                             ▼
┌─────────────┐                             ┌─────────────┐
│  SHIPMENTS  │─────────────────────────────│  (receives) │
└─────────────┘                             └─────────────┘
```

---

## 🔐 Default Credentials

### Admin Accounts

| Username  | Password    | Role        |
|-----------|-------------|-------------|
| admin     | admin123    | Super Admin |
| manager1  | manager123  | Manager     |
| staff1    | staff123    | Staff       |

**⚠️ Important:** Change these passwords in production!

---

## 🧪 Testing

### Test Database Connection
```
http://localhost/supplychain/test_connection.php
```

### Test SQL Queries in phpMyAdmin

**1. View Inventory Summary**
```sql
SELECT * FROM vw_product_inventory_summary;
```

**2. Get Low Stock Products**
```sql
CALL sp_get_low_stock_products();
```

**3. Check Pending Orders**
```sql
SELECT * FROM vw_active_orders;
```

**4. Supplier Performance**
```sql
SELECT s.supplier_name, COUNT(po.order_id) as orders, 
       SUM(po.total_amount) as total_value
FROM suppliers s
LEFT JOIN purchase_orders po ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id
ORDER BY total_value DESC;
```

### Test Application Features

- [ ] Login with admin credentials
- [ ] View dashboard statistics
- [ ] Add new supplier
- [ ] View all suppliers
- [ ] Check inventory levels
- [ ] Update inventory (add/remove stock)
- [ ] Create purchase order
- [ ] View all orders

---

## 🔧 Troubleshooting

### Common Issues

**Issue: Apache won't start (Port 80 in use)**
```
Solution:
1. XAMPP Control Panel → Apache Config → httpd.conf
2. Change "Listen 80" to "Listen 8080"
3. Restart Apache
4. Access via: http://localhost:8080/
```

**Issue: MySQL won't start (Port 3306 in use)**
```
Solution:
1. XAMPP Control Panel → MySQL Config → my.ini
2. Change "port=3306" to "port=3307"
3. Update database.php with new port
4. Restart MySQL
```

**Issue: "Access Denied" database error**
```
Solution:
1. Check config/database.php credentials
2. Default: username=root, password=(blank)
3. Update if you changed MySQL password
```

**Issue: "Table doesn't exist"**
```
Solution:
1. Ensure COMPLETE_SQL_FILE.sql was executed
2. Check database name is "supply_chain_db"
3. Verify all tables created in phpMyAdmin
```

**Issue: CSS not loading**
```
Solution:
1. Check file paths in header.php
2. Ensure folder structure is correct
3. Clear browser cache
```

---

## 📚 Documentation Files

- **PROJECT_DOCUMENTATION.md** - Complete project description, ER diagram, objectives
- **XAMPP_IMPLEMENTATION_GUIDE.md** - Step-by-step installation and setup
- **FINAL_DELIVERABLES.md** - Project summary, viva preparation, testing checklist
- **database_schema.sql** - Table creation with constraints
- **sample_data.sql** - Sample data for testing
- **sql_queries.sql** - All queries, views, procedures, triggers

---

## 🚀 Future Enhancements

### Phase 2 Features
- Order items table (many-to-many relationship)
- Email notifications for low stock
- PDF report generation
- Advanced analytics with charts
- Export to Excel functionality

### Security Improvements
- Bcrypt password hashing
- Prepared statements for all queries
- CSRF token protection
- Input validation with regex
- Session timeout

### UI Enhancements
- AJAX for real-time updates
- Charts and graphs (Chart.js)
- Advanced search and filters
- Pagination for large datasets
- Mobile responsive design

---

## 📝 Viva Preparation

### Key Points to Remember

1. **Normalization:** Database is in 3NF (Third Normal Form)
2. **Constraints:** Used PRIMARY KEY, FOREIGN KEY, CHECK, UNIQUE, NOT NULL
3. **Joins:** Implemented INNER JOIN and LEFT JOIN for relationships
4. **Views:** Created 3 views for data abstraction
5. **Procedures:** 4 stored procedures for business logic
6. **Triggers:** 4 triggers for automation
7. **Indexes:** 8 indexes for query optimization

### Expected Questions

**Q: Why use foreign keys?**
A: To maintain referential integrity and ensure data consistency across related tables.

**Q: Difference between INNER JOIN and LEFT JOIN?**
A: INNER JOIN returns only matching records. LEFT JOIN returns all records from left table plus matches from right.

**Q: Purpose of triggers?**
A: Automate actions when events occur, like updating inventory when shipments are delivered.

**Q: What is a stored procedure?**
A: Pre-compiled SQL code stored in database for reusability and better performance.

---

## 👥 Credits

- **Project Type:** Database Systems (DBS) Mini Project
- **Database:** MySQL 8.0
- **Server:** XAMPP
- **Language:** PHP 7.4+
- **Version:** 1.0
- **Status:** Ready for Submission

---

## 📞 Support

For issues or questions:
1. Check XAMPP_IMPLEMENTATION_GUIDE.md
2. Review FINAL_DELIVERABLES.md troubleshooting section
3. Verify all SQL files executed successfully
4. Ensure XAMPP services are running

---

## ✅ Project Checklist

- [x] Database schema designed (7 tables)
- [x] ER diagram created
- [x] Sample data inserted
- [x] SQL queries written (20+ queries)
- [x] Views created (3)
- [x] Stored procedures implemented (4)
- [x] Triggers implemented (4)
- [x] PHP application developed
- [x] Login system with authentication
- [x] CRUD operations for all entities
- [x] Dashboard with statistics
- [x] Error handling implemented
- [x] Documentation completed
- [x] Testing completed
- [x] Ready for viva

---

**Good luck with your DBS project! 🎓**

---

*Last Updated: November 2024*
