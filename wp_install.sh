#!/bin/bash

# Habilitar modo estricto: detiene el script si algún comando falla
set -e

# Definir variables
WP_URL="https://wordpress.org/latest.tar.gz"
WP_ARCHIVE="latest.tar.gz"
WP_DIR="/var/www/html/wordpress"

# Pedir datos al usuario
read -p "Ingrese el nombre de la base de datos: " DB_NAME
read -p "Ingrese el nombre del usuario de la base de datos: " DB_USER
read -s -p "Ingrese la contraseña del usuario de la base de datos: " DB_PASS
echo ""

# Mostrar información de instalación
echo ""
echo "🔹 Se instalará WordPress con la siguiente configuración:"
echo "   📂 Descarga y extracción en: $(pwd)"
echo "   🚀 Instalación en: $WP_DIR"
echo "   💾 Base de datos: $DB_NAME"
echo "   👤 Usuario de la BD: $DB_USER"
echo ""
read -p "❓ ¿Desea continuar? (s/n): " CONFIRM
if [[ "$CONFIRM" != "s" && "$CONFIRM" != "S" ]]; then
    echo "❌ Instalación cancelada."
    exit 1
fi

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

# Descargar y extraer WordPress en el mismo directorio donde se ejecuta el script
echo "⬇ Descargando WordPress en $(pwd)..."
wget -q $WP_URL -O $WP_ARCHIVE
tar -xzf $WP_ARCHIVE

# Mover WordPress a /var/www/html
echo "📂 Moviendo WordPress a $WP_DIR..."
sudo mv wordpress $WP_DIR

# Configurar permisos
echo "🔑 Configurando permisos..."
sudo chown -R www-data:www-data $WP_DIR
sudo chmod -R 755 $WP_DIR

# Configurar wp-config.php automáticamente
echo "⚙ Configurando WordPress..."
sudo cp $WP_DIR/wp-config-sample.php $WP_DIR/wp-config.php
sudo sed -i "s/database_name_here/$DB_NAME/" $WP_DIR/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" $WP_DIR/wp-config.php
sudo sed -i "s/password_here/$DB_PASS/" $WP_DIR/wp-config.php

# Habilitar mod_rewrite y reiniciar Apache
echo "🚀 Habilitando mod_rewrite en Apache..."
sudo a2enmod rewrite
sudo systemctl restart apache2

echo "------------------------------------------------------------"
echo "-----------------------------------------"
echo ""
echo "   💾 Base de datos: $DB_NAME"
echo "   👤 Usuario de la BD: $DB_USER"
echo ""
echo "-----------------------------------------"
echo "------------------------------------------------------------"

echo "✅ Instalación completa. Accede a http://tu-servidor/wordpress para finalizar la instalación de WordPress."
