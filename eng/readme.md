# WordPress Auto Installer Script

This Bash script automates the installation of WordPress on a Linux server using Apache, MySQL, and PHP. It downloads WordPress in the same directory where the script is executed, then moves it to `/var/www/html/wordpress`.

## 🚀 Features
- 📥 **Downloads WordPress** in the current directory before moving it  
- 🔧 **Configures MySQL** (creates a database and user)  
- 🌍 **Installs Apache, MySQL, and PHP** automatically  
- 🔑 **Sets correct permissions** for WordPress  
- ⚙ **Automatically updates wp-config.php** with database details  
- ❓ **Asks for confirmation before installing**  

## 📌 Prerequisites
Ensure you have:
- A Linux-based server (Debian/Ubuntu recommended)
- Root or sudo access
- Internet connection to download packages

## 🔧 Installation & Usage
1. Clone this repository:
   ```bash
   git clone https://github.com/TheHellishPandaa/WP_Install
   cd WP_Install

2. Make the script executable
   ````bash
   chmod +x wp_installs.sh
``
3. Execute the script
````bash
./wp_install.sh
````
🎯 What This Script Does

- Updates system packages
- Installs Apache, MySQL, and PHP
- Asks the user for database credentials
- Downloads WordPress in the current directory
- Moves WordPress to /var/www/html/wordpress
- Configures permissions and updates wp-config.php

