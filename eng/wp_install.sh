#!/bin/bash

# Enable strict mode: stop script execution if any command fails
set -e

# Define variables
WP_URL="https://wordpress.org/latest.tar.gz"
WP_ARCHIVE="latest.tar.gz"
WP_DIR="/var/www/html/wordpress"

# Ask user for database details
read -p "Enter the database name: " DB_NAME
read -p "Enter the database username: " DB_USER
read -s -p "Enter the database password: " DB_PASS
echo ""

# Display installation details
echo ""
echo "🔹 WordPress will be installed with the following settings:"
echo "   📂 Download and extraction in: $(pwd)"
echo "   🚀 Installation in: $WP_DIR"
echo "   💾 Database name: $DB_NAME"
echo "   👤 Database user: $DB_USER"
echo ""
read -p "❓ Do you want to continue? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "❌ Installation canceled."
    exit 1
fi

# Update system
echo "🔄 Updating packages..."
sudo apt update && sudo apt upgrade -y

# Install Apache
echo "🌍 Installing Apache..."
sudo apt install -y apache2

# Install MySQL
echo "💾 Installing MySQL..."
sudo apt install -y mysql-server
sudo systemctl enable --now mysql

# Configure MySQL (create DB and user)
echo "🛠 Configuring MySQL..."
sudo mysql -e "CREATE DATABASE $DB_NAME;"
sudo mysql -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Install PHP and required modules
echo "🐘 Installing PHP and modules..."
sudo apt install -y php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

# Download and extract WordPress in the script's directory
echo "⬇ Downloading WordPress in $(pwd)..."
wget -q $WP_URL -O $WP_ARCHIVE
tar -xzf $WP_ARCHIVE

# Move WordPress to /var/www/html
echo "📂 Moving WordPress to $WP_DIR..."
sudo mv wordpress $WP_DIR

# Set permissions
echo "🔑 Setting permissions..."
sudo chown -R www-data:www-data $WP_DIR
sudo chmod -R 755 $WP_DIR

# Configure wp-config.php automatically
echo "⚙ Configuring WordPress..."
sudo cp $WP_DIR/wp-config-sample.php $WP_DIR/wp-config.php
sudo sed -i "s/database_name_here/$DB_NAME/" $WP_DIR/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" $WP_DIR/wp-config.php
sudo sed -i "s/password_here/$DB_PASS/" $WP_DIR/wp-config.php

echo "   💾 Database name: $DB_NAME"
echo "   👤 Database user: $DB_USER"
echo ""

# Cleanup
echo "🧹 Removing installation archive..."
rm -f $WP_ARCHIVE

echo "✅ Installation complete. Access http://your-server to finish WordPress setup."

