# Guía de Despliegue - Tres Muebles Web

Este documento proporciona las instrucciones necesarias para desplegar el proyecto "Tres Muebles Web" tanto en un entorno local (desarrollo) como en un entorno de producción (en línea).

## 1. Requisitos Previos (Prerequisites)

Para ambos entornos, necesitas:
- **Java Development Kit (JDK):** Versión 17 o superior. (Asegúrate de tener la variable de entorno `JAVA_HOME` configurada).
- **Maven:** Versión 3.8+ instalada y en el `PATH`.
- **Motor de Base de Datos:** MySQL Server 8.0+.
- **Servidor de Aplicaciones:** Apache Tomcat 10.1.x (Jakarta EE 10+ compatible).

---

## 2. Configuración de la Base de Datos

Antes de correr el proyecto, debes inicializar la base de datos `inmobiliaria_db`.

1. Abre tu cliente MySQL preferido (MySQL Workbench, DBeaver, o consola).
2. Conéctate con un usuario con privilegios de administrador (`root`).
3. Ejecuta el script DDL para crear la estructura:
   - Archivo: `db/ddl.sql`
4. Ejecuta el script DML para cargar los catálogos base (tipos, ciudades, características) y los usuarios de prueba:
   - Archivo: `db/dml.sql`

*Nota: La contraseña por defecto de los usuarios de prueba en el DML es `123456`.*

---

## 3. Despliegue Local (Desarrollo)

### Paso 1: Configurar credenciales de Base de Datos
El proyecto utiliza un patrón Singleton para conectarse a la base de datos (`ConexionDB.java`). Asegúrate de que las credenciales coincidan con tu servidor local.
Ubicación: `src/main/java/com/tresmuebles/util/ConexionDB.java`
```java
private static final String URL = "jdbc:mysql://localhost:3306/inmobiliaria_db";
private static final String USER = "root";
private static final String PASS = "tu_contraseña_aqui";
```

### Paso 2: Compilar el proyecto con Maven
Abre una terminal en la raíz del proyecto (`TresMueblesWeb`) y ejecuta:
```bash
mvn clean package
```
Esto descargará las dependencias y generará un archivo `.war` dentro de la carpeta `target/`. Ejemplo: `target/tresmuebles-1.0-SNAPSHOT.war`.

### Paso 3: Desplegar en Tomcat
1. Copia el archivo `tresmuebles-1.0-SNAPSHOT.war`.
2. Pégalo en el directorio `webapps/` de tu instalación local de Tomcat.
3. Inicia Tomcat (ejecutando `bin/startup.bat` o `bin/startup.sh`).
4. Abre tu navegador y ve a: `http://localhost:8080/tresmuebles-1.0-SNAPSHOT/`.
*(Puedes renombrar el archivo `.war` a `tresmuebles.war` antes de copiarlo para que la URL sea más limpia: `http://localhost:8080/tresmuebles/`).*

---

## 4. Despliegue en Línea (Producción)

Para desplegar este proyecto en internet (por ejemplo en servicios como AWS, Heroku, Railway o un VPS clásico con Tomcat):

### Paso 1: Base de Datos en la Nube
1. Crea una instancia de MySQL en un servicio Cloud (Amazon RDS, PlanetScale, Aiven, etc.).
2. Ejecuta los scripts `ddl.sql` y `dml.sql` en esa instancia remota.
3. Actualiza el archivo `ConexionDB.java` con la URL remota, el usuario y la contraseña de producción.
   *(Importante: En entornos profesionales se recomienda usar variables de entorno `System.getenv("DB_URL")` en lugar de quemar las credenciales en el código).*

### Paso 2: Generar el WAR de Producción
1. Vuelve a ejecutar `mvn clean package` para empaquetar el WAR con la nueva conexión a la base de datos remota.

### Paso 3: Alojamiento (Hosting) de la Aplicación
**Opción A: Servidor VPS (Linux + Tomcat)**
- Transfiere el `.war` a tu VPS por SCP/SFTP.
- Colócalo en `/opt/tomcat/webapps/` (o la ruta correspondiente de tu servidor).
- Configura un proxy inverso (Nginx o Apache) para apuntar el puerto 80/443 al puerto 8080 de Tomcat.

**Opción B: PaaS (Platform as a Service)**
- Si utilizas servicios como Railway o Render (que admiten contenedores de Docker), puedes crear un archivo `Dockerfile` en la raíz de tu proyecto:
```dockerfile
# Usar Tomcat 10 (Jakarta)
FROM tomcat:10.1-jdk17
# Borrar las webapps por defecto
RUN rm -rf /usr/local/tomcat/webapps/*
# Copiar el WAR renombrado a ROOT para que quede en el index
COPY target/tresmuebles-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
```
- Vincula tu repositorio Git al servicio PaaS, el servicio leerá el Dockerfile, compilará la imagen e iniciará el proyecto.

---
**Tres Muebles Web - Fin de la Guía**

