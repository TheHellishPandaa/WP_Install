# WP_Install

Este script automatiza la instalación de WordPress en un servidor Ubuntu con Apache, MySQL y PHP.

## 📋 Requisitos
- Sistema operativo: **Ubuntu (Debian-based)**
- Acceso como usuario **root** o con permisos de **sudo**
- Conexión a Internet

## 📦 Tecnologías Utilizadas
- Apache2
- MySQL Server
- PHP y extensiones necesarias
- WordPress

## 📥 Instalación
### 1️⃣ Clonar el repositorio
```bash
git clone https://github.com/TheHellishPandaa/WP-Install.git
cd wp-install
```

### 2️⃣ Dar permisos de ejecución al script
```bash
chmod +x wp-install.sh
```

### 3️⃣ Ejecutar el script
```bash
sudo ./wp-install.sh
```


## 🌍 Acceso a WordPress
Después de la instalación, abre tu navegador y accede a:
```plaintext
http://tu-servidor/wordpress
```
Sigue el asistente de instalación de WordPress para completar la configuración.

## 🔥 Notas
✔ **Asegúrate de cambiar la contraseña de MySQL** en el script por una más segura.
✔ Si estás usando un servidor remoto, asegúrate de abrir el puerto **80** en tu firewall:
```bash
sudo ufw allow 80/tcp
```

## 🤝 Contribuciones
¡Las contribuciones son bienvenidas! Si encuentras un error o quieres mejorar el script, abre un **issue** o envía un **pull request**.

## 📄 Licencia
Este proyecto está bajo la licencia **GNU (General Public License)**.

