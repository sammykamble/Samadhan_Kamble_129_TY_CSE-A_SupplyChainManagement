# 👥 USER REGISTRATION & LOGIN GUIDE
## Supply Chain Management System

---

## ✅ WHAT'S NEW?

I've added a **Registration Page** so new users can create their own accounts!

---

## 🔐 EXISTING USERS (Already in Database)

You can login with these accounts right now:

### **Super Admin:**
- **Username:** `admin`
- **Password:** `admin123`
- **Role:** Super Admin (Full Access)

### **Manager 1:**
- **Username:** `manager1`
- **Password:** `manager123`
- **Role:** Manager

### **Manager 2:**
- **Username:** `manager2`
- **Password:** `manager123`
- **Role:** Manager

### **Staff 1:**
- **Username:** `staff1`
- **Password:** `staff123`
- **Role:** Staff

### **Staff 2:**
- **Username:** `staff2`
- **Password:** `staff123`
- **Role:** Staff

---

## 🆕 REGISTER NEW USERS

### **Registration Page URL:**
```
http://localhost/supply_chain_db/admin/register.php
```

### **How to Register:**

1. **Open your browser**

2. **Go to:** `http://localhost/supply_chain_db/admin/register.php`

3. **Fill in the form:**
   - **Full Name:** Your complete name (e.g., John Doe)
   - **Username:** Choose a unique username (e.g., john123)
   - **Email:** Your email address (e.g., john@example.com)
   - **Role:** Select either:
     - **Staff** (Regular user)
     - **Manager** (Higher privileges)
   - **Password:** At least 6 characters
   - **Confirm Password:** Type the same password again

4. **Click "Register" button**

5. **Success!** You'll see a success message

6. **Click "Login here"** link to go to login page

7. **Login with your new credentials**

---

## 🌐 ALL IMPORTANT LINKS

### **Login Page:**
```
http://localhost/supply_chain_db/admin/login.php
```
Or simply:
```
http://localhost/supply_chain_db/
```

### **Registration Page:**
```
http://localhost/supply_chain_db/admin/register.php
```

### **Dashboard (after login):**
```
http://localhost/supply_chain_db/admin/dashboard.php
```

---

## 📋 REGISTRATION RULES

### **Username:**
- Must be unique (no duplicates)
- Can contain letters, numbers, underscores
- Case-sensitive

### **Email:**
- Must be valid email format
- Must be unique (no duplicates)
- Example: user@example.com

### **Password:**
- Minimum 6 characters
- Can contain letters, numbers, special characters
- Must match confirmation password

### **Role:**
- **Staff:** Regular user access
- **Manager:** Higher level access
- **Super Admin:** Only the main admin (cannot be selected during registration)

---

## 🎯 HOW TO USE

### **For New Users:**

1. Go to registration page
2. Fill in all required fields
3. Choose your role (Staff or Manager)
4. Click Register
5. Go to login page
6. Login with your new username and password
7. Access the dashboard!

### **For Existing Users:**

1. Go to login page
2. Enter your username and password (see list above)
3. Click Login
4. Access the dashboard!

---

## 🔄 SWITCHING BETWEEN LOGIN AND REGISTER

### **From Login Page → Register Page:**
- Click the "Register here" link at the bottom

### **From Register Page → Login Page:**
- Click the "Login here" link at the bottom

---

## ⚠️ COMMON ISSUES & SOLUTIONS

### **Issue 1: "Username already exists"**
**Solution:** Choose a different username

### **Issue 2: "Email already registered"**
**Solution:** Use a different email address

### **Issue 3: "Passwords do not match"**
**Solution:** Make sure both password fields have the exact same text

### **Issue 4: "Password must be at least 6 characters"**
**Solution:** Use a longer password (minimum 6 characters)

### **Issue 5: "Invalid email format"**
**Solution:** Use proper email format: name@domain.com

### **Issue 6: Can't access registration page**
**Solution:** 
- Make sure XAMPP Apache and MySQL are running
- Check the URL is correct
- Make sure files are in: `C:\xampp\htdocs\supply_chain_db\`

---

## 🎨 FEATURES OF REGISTRATION PAGE

✅ **User-friendly form** with clear labels
✅ **Real-time validation** for all fields
✅ **Password confirmation** to prevent typos
✅ **Role selection** (Staff or Manager)
✅ **Duplicate checking** for username and email
✅ **Success/Error messages** for feedback
✅ **Direct link to login** after registration
✅ **Responsive design** works on all screen sizes

---

## 📊 USER ROLES EXPLAINED

### **Super Admin:**
- Full system access
- Can manage everything
- Only one super admin (the main admin)
- Cannot be created through registration

### **Manager:**
- Higher level access
- Can manage suppliers, inventory, orders
- Can view all reports
- Can be created through registration

### **Staff:**
- Regular user access
- Can view and update inventory
- Can create orders
- Can view suppliers
- Can be created through registration

---

## 🔒 SECURITY FEATURES

✅ **Password Encryption:** All passwords are encrypted using MD5
✅ **Input Sanitization:** All inputs are cleaned to prevent SQL injection
✅ **Email Validation:** Ensures valid email format
✅ **Duplicate Prevention:** No duplicate usernames or emails
✅ **Session Management:** Secure login sessions
✅ **Password Confirmation:** Prevents typos during registration

---

## 📝 TESTING THE REGISTRATION

### **Test Registration:**

1. Open: `http://localhost/supply_chain_db/admin/register.php`

2. Fill in test data:
   - Full Name: `Test User`
   - Username: `testuser`
   - Email: `test@example.com`
   - Role: `Staff`
   - Password: `test123`
   - Confirm Password: `test123`

3. Click Register

4. You should see: "Registration successful! You can now login."

5. Click "Login here"

6. Login with:
   - Username: `testuser`
   - Password: `test123`

7. You should see the dashboard!

---

## 🎓 FOR DEMONSTRATION/VIVA

### **Show Registration Feature:**

1. Open registration page
2. Fill in sample data
3. Show validation (try wrong email, short password, etc.)
4. Complete registration
5. Show success message
6. Login with new account
7. Show dashboard access

### **Explain Security:**

- Passwords are encrypted (MD5)
- Duplicate usernames/emails are prevented
- Input validation prevents errors
- Session management for security

---

## 📞 QUICK REFERENCE

### **URLs:**
- **Main:** `http://localhost/supply_chain_db/`
- **Login:** `http://localhost/supply_chain_db/admin/login.php`
- **Register:** `http://localhost/supply_chain_db/admin/register.php`

### **Default Accounts:**
- **Admin:** admin / admin123
- **Manager:** manager1 / manager123
- **Staff:** staff1 / staff123

### **File Locations:**
- **Login:** `C:\xampp\htdocs\supply_chain_db\admin\login.php`
- **Register:** `C:\xampp\htdocs\supply_chain_db\admin\register.php`

---

## ✅ CHECKLIST

Before using registration:

- ☑ XAMPP Apache is running (green)
- ☑ XAMPP MySQL is running (green)
- ☑ Database `supply_chain_db` exists
- ☑ Files are in correct location
- ☑ Can access login page
- ☑ Can access registration page

---

## 🎉 SUCCESS!

You now have:
- ✅ Working login system
- ✅ Working registration system
- ✅ Multiple user roles
- ✅ Secure authentication
- ✅ User-friendly interface

**New users can now register and login to your system!**

---

**Created:** November 2024  
**Feature:** User Registration System  
**Status:** Ready to Use  

---

## 🚀 NEXT STEPS

1. Test the registration page
2. Create a few test accounts
3. Login with different roles
4. Explore the dashboard
5. Show it in your demonstration!

**Enjoy your enhanced system! 🎊**
