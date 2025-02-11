#!/bin/bash

# Configuración
DB_NAME="wordpress"
DB_USER="wp_user"
DB_PASS="StrongPassword123!"
WP_URL="https://wordpress.org/latest.tar.gz"
WP_DIR="/var/www/html/wordpress"

# Actualizar sistema
echo "🔄 Actualizando paquetes..."
sudo apt update && sudo apt upgrade -y

# Instalar Apache
echo "🌍 Instalando Apache..."
sudo apt install -y apache2

# Instalar MySQL
echo "💾 Instalando MySQL..."
sudo apt install -y mysql-server
sudo systemctl enable --now mysql

# Configurar MySQL (crear DB y usuario)
echo "🛠 Configurando MySQL..."
sudo mysql -e "CREATE DATABASE $DB_NAME;"
sudo mysql -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Instalar PHP y módulos
echo "🐘 Instalando PHP y módulos..."
sudo apt install -y php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

# Descargar WordPress
echo "⬇ Descargando WordPress..."
wget -q $WP_URL -O /tmp/latest.tar.gz
tar -xzf /tmp/latest.tar.gz
sudo mv wordpress $WP_DIR

# Configurar permisos
echo "🔑 Configurando permisos..."
sudo chown -R www-data:www-data $WP_DIR
sudo chmod -R 755 $WP_DIR

# Configurar Apache
echo "⚙ Configurando Apache..."
sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null <<EOL
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot $WP_DIR
    <Directory $WP_DIR>
        AllowOverride All
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

# Habilitar sitio y reiniciar Apache
echo "🚀 Habilitando configuración de Apache..."
sudo a2ensite wordpress
sudo a2enmod rewrite
sudo systemctl restart apache2


# Configuración final
echo "✅ Instalación completa. Accede a http://tu-servidor para finalizar la instalación de WordPress."
