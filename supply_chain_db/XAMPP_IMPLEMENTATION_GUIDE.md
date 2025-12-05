# XAMPP Implementation Guide
## Supply Chain Management System

---

## STEP 1: INSTALL AND SETUP XAMPP

### Download and Install
1. Download XAMPP from: https://www.apachefriends.org/
2. Install XAMPP (default location: C:\xampp)
3. Run XAMPP Control Panel as Administrator

### Start Services
1. Click "Start" button for Apache
2. Click "Start" button for MySQL
3. Verify both services show green "Running" status

---

## STEP 2: CREATE DATABASE IN phpMyAdmin

### Access phpMyAdmin
1. Open browser and go to: http://localhost/phpmyadmin
2. Default login: username = `root`, password = (leave blank)

### Create Database
**Method 1: Using SQL Tab**
1. Click on "SQL" tab at the top
2. Copy entire content from `database_schema.sql`
3. Click "Go" button
4. Database `supply_chain_db` will be created with all tables

**Method 2: Manual Creation**
1. Click "New" in left sidebar
2. Enter database name: `supply_chain_db`
3. Select collation: `utf8mb4_general_ci`
4. Click "Create"
5. Select the database from left sidebar
6. Click "SQL" tab
7. Paste content from `database_schema.sql`
8. Click "Go"

---

## STEP 3: INSERT SAMPLE DATA

1. In phpMyAdmin, select `supply_chain_db` database
2. Click "SQL" tab
3. Copy entire content from `sample_data.sql`
4. Click "Go" button
5. Verify data by clicking on table names in left sidebar

---

## STEP 4: CREATE PROJECT FOLDER STRUCTURE

### Folder Structure
```
C:\xampp\htdocs\supplychain\
├── config\
│   └── database.php
├── includes\
│   ├── header.php
│   └── footer.php
├── css\
│   └── style.css
├── admin\
│   ├── login.php
│   ├── dashboard.php
│   └── logout.php
├── suppliers\
│   ├── add_supplier.php
│   ├── view_suppliers.php
│   └── edit_supplier.php
├── inventory\
│   ├── view_inventory.php
│   ├── update_inventory.php
│   └── low_stock.php
├── orders\
│   ├── create_order.php
│   ├── view_orders.php
│   └── order_details.php
└── index.php
```

### Create Folders
Open Command Prompt and run:
```cmd
cd C:\xampp\htdocs
mkdir supplychain
cd supplychain
mkdir config includes css admin suppliers inventory orders
```

---

## STEP 5: DATABASE CONNECTION FILE

Create file: `config/database.php`
(See PHP files section below)

---

## STEP 6: TEST DATABASE CONNECTION

1. Create test file: `test_connection.php` in supplychain folder
2. Add connection test code (provided in PHP section)
3. Open browser: http://localhost/supplychain/test_connection.php
4. Should display: "Database connected successfully"

---

## STEP 7: RUN SQL QUERIES

### Execute Queries in phpMyAdmin
1. Select `supply_chain_db` database
2. Click "SQL" tab
3. Copy queries from `sql_queries.sql`
4. Execute one by one or all together
5. View results in the output section

### Test Stored Procedures
```sql
CALL sp_get_low_stock_products();
CALL sp_add_product_to_inventory(1, 1, 50);
```

### Test Views
```sql
SELECT * FROM vw_product_inventory_summary;
SELECT * FROM vw_active_orders;
```

---

## STEP 8: ACCESS THE APPLICATION

1. Open browser
2. Navigate to: http://localhost/supplychain/
3. Login with default credentials:
   - Username: `admin`
   - Password: `admin123`

---

## COMMON XAMPP ISSUES & FIXES

### Issue 1: Apache Port 80 Already in Use
**Solution:**
1. Open XAMPP Control Panel
2. Click "Config" button next to Apache
3. Select "httpd.conf"
4. Find line: `Listen 80`
5. Change to: `Listen 8080`
6. Save and restart Apache
7. Access via: http://localhost:8080/

### Issue 2: MySQL Port 3306 Already in Use
**Solution:**
1. Click "Config" button next to MySQL
2. Select "my.ini"
3. Find line: `port=3306`
4. Change to: `port=3307`
5. Update database.php connection to use port 3307
6. Restart MySQL

### Issue 3: Access Denied for User 'root'@'localhost'
**Solution:**
1. Open phpMyAdmin
2. Go to User Accounts
3. Edit root user
4. Set password or remove password
5. Update config/database.php with correct password

### Issue 4: PHP Extensions Not Loaded
**Solution:**
1. Open php.ini (XAMPP Control Panel > Apache Config > php.ini)
2. Find and uncomment (remove semicolon):
   - `;extension=mysqli`
   - `;extension=pdo_mysql`
3. Save and restart Apache

### Issue 5: Cannot Access phpMyAdmin
**Solution:**
1. Check if MySQL is running
2. Clear browser cache
3. Try: http://localhost/phpmyadmin/
4. Check httpd-xampp.conf for phpMyAdmin alias

---

## SECURITY RECOMMENDATIONS

1. **Change Default Passwords**
   - MySQL root password
   - Admin login credentials

2. **Enable Password Protection**
   ```sql
   UPDATE admins SET password = MD5('new_secure_password') WHERE username = 'admin';
   ```

3. **Restrict phpMyAdmin Access**
   - Edit: C:\xampp\phpMyAdmin\config.inc.php
   - Add: `$cfg['Servers'][$i]['AllowNoPassword'] = false;`

4. **Use Prepared Statements**
   - Always use mysqli_prepare() for user inputs
   - Prevent SQL injection attacks

---

## BACKUP DATABASE

### Using phpMyAdmin
1. Select `supply_chain_db`
2. Click "Export" tab
3. Select "Quick" export method
4. Format: SQL
5. Click "Go"
6. Save the .sql file

### Using Command Line
```cmd
cd C:\xampp\mysql\bin
mysqldump -u root -p supply_chain_db > backup.sql
```

---

## RESTORE DATABASE

### Using phpMyAdmin
1. Select database
2. Click "Import" tab
3. Choose file
4. Click "Go"

### Using Command Line
```cmd
cd C:\xampp\mysql\bin
mysql -u root -p supply_chain_db < backup.sql
```
