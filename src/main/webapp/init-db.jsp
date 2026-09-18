<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.tresmuebles.util.ConexionDB" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Inicializador de Base de Datos - Tres Muebles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light p-4">
    <div class="container" style="max-width: 800px;">
        <div class="card shadow p-4">
            <h3 class="text-primary mb-3">Instalador Automático de Base de Datos en la Nube</h3>
            <p class="text-muted">Este script ejecuta directamente las tablas y datos en la base de datos conectada.</p>
            
            <%
                String action = request.getParameter("action");
                if ("ejecutar".equals(action)) {
                    Connection con = null;
                    Statement st = null;
                    try {
                        con = ConexionDB.getInstancia().getConexion();
                        st = con.createStatement();
                        
                        // 1. DDL
                        String[] ddl = {
                            "CREATE TABLE IF NOT EXISTS rol (id_rol INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL UNIQUE)",
                            "CREATE TABLE IF NOT EXISTS ciudad (id_ciudad INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) NOT NULL, departamento VARCHAR(100) NOT NULL)",
                            "CREATE TABLE IF NOT EXISTS tipo_propiedad (id_tipo INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL UNIQUE)",
                            "CREATE TABLE IF NOT EXISTS caracteristica (id_caracteristica INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL UNIQUE)",
                            "CREATE TABLE IF NOT EXISTS usuario (id_usuario INT AUTO_INCREMENT PRIMARY KEY, correo VARCHAR(150) NOT NULL UNIQUE, clave VARCHAR(255) NOT NULL, estado ENUM('activo', 'inactivo') DEFAULT 'activo')",
                            "CREATE TABLE IF NOT EXISTS perfil (id_usuario INT PRIMARY KEY, nombres VARCHAR(100) NOT NULL, apellidos VARCHAR(100) NOT NULL, documento VARCHAR(20) NOT NULL UNIQUE, telefono VARCHAR(20), direccion VARCHAR(200), foto_url VARCHAR(255), CONSTRAINT fk_perfil_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE)",
                            "CREATE TABLE IF NOT EXISTS usuario_rol (id_usuario INT, id_rol INT, fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (id_usuario, id_rol), CONSTRAINT fk_usurol_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE, CONSTRAINT fk_usurol_rol FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON DELETE CASCADE ON UPDATE CASCADE)",
                            "CREATE TABLE IF NOT EXISTS propiedad (id_propiedad INT AUTO_INCREMENT PRIMARY KEY, matricula_inmobiliaria VARCHAR(50) NOT NULL UNIQUE, id_tipo INT NOT NULL, id_ciudad INT NOT NULL, id_agente INT NOT NULL, titulo VARCHAR(150) NOT NULL, descripcion TEXT, precio DECIMAL(15, 2) NOT NULL, area DECIMAL(8, 2) NOT NULL, habitaciones INT NOT NULL DEFAULT 0, banos INT NOT NULL DEFAULT 0, estado_publicacion ENUM('disponible', 'vendida', 'arrendada', 'inactiva') DEFAULT 'disponible', fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, CONSTRAINT fk_propiedad_tipo FOREIGN KEY (id_tipo) REFERENCES tipo_propiedad(id_tipo) ON DELETE RESTRICT ON UPDATE CASCADE, CONSTRAINT fk_propiedad_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE, CONSTRAINT fk_propiedad_agente FOREIGN KEY (id_agente) REFERENCES usuario(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE)",
                            "CREATE TABLE IF NOT EXISTS imagen_propiedad (id_imagen INT AUTO_INCREMENT PRIMARY KEY, id_propiedad INT NOT NULL, url_imagen VARCHAR(255) NOT NULL, es_principal BOOLEAN DEFAULT FALSE, CONSTRAINT fk_imagen_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE)",
                            "CREATE TABLE IF NOT EXISTS propiedad_caracteristica (id_propiedad INT, id_caracteristica INT, PRIMARY KEY (id_propiedad, id_caracteristica), CONSTRAINT fk_propcar_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE, CONSTRAINT fk_propcar_caract FOREIGN KEY (id_caracteristica) REFERENCES caracteristica(id_caracteristica) ON DELETE CASCADE ON UPDATE CASCADE)",
                            "CREATE TABLE IF NOT EXISTS cita (id_cita INT AUTO_INCREMENT PRIMARY KEY, id_propiedad INT NOT NULL, id_cliente INT NOT NULL, fecha_hora DATETIME NOT NULL, estado ENUM('programada', 'realizada', 'cancelada') DEFAULT 'programada', UNIQUE (id_propiedad, fecha_hora), CONSTRAINT fk_cita_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE, CONSTRAINT fk_cita_cliente FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE)",
                            "CREATE TABLE IF NOT EXISTS solicitud (id_solicitud INT AUTO_INCREMENT PRIMARY KEY, id_propiedad INT NOT NULL, id_cliente INT NOT NULL, tipo ENUM('compra', 'arriendo') NOT NULL, estado ENUM('pendiente', 'aprobada', 'rechazada') DEFAULT 'pendiente', fecha_radicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, CONSTRAINT fk_solicitud_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE, CONSTRAINT fk_solicitud_cliente FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE)",
                            "CREATE TABLE IF NOT EXISTS documento_solicitud (id_documento INT AUTO_INCREMENT PRIMARY KEY, id_solicitud INT NOT NULL, nombre_documento VARCHAR(100) NOT NULL, url_documento VARCHAR(255) NOT NULL, CONSTRAINT fk_doc_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitud(id_solicitud) ON DELETE CASCADE ON UPDATE CASCADE)",
                            "CREATE TABLE IF NOT EXISTS favorito (id_favorito INT AUTO_INCREMENT PRIMARY KEY, id_propiedad INT NOT NULL, id_cliente INT NOT NULL, fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP, UNIQUE (id_propiedad, id_cliente), CONSTRAINT fk_favorito_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE, CONSTRAINT fk_favorito_cliente FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE)",
                            "CREATE TABLE IF NOT EXISTS auditoria (id_auditoria INT AUTO_INCREMENT PRIMARY KEY, id_usuario INT, accion VARCHAR(255) NOT NULL, modulo VARCHAR(100) NOT NULL, fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP, CONSTRAINT fk_auditoria_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL ON UPDATE CASCADE)"
                        };

                        for (String sql : ddl) {
                            st.executeUpdate(sql);
                        }

                        // 2. DML (Ignorar si ya existen para no duplicar)
                        String[] dml = {
                            "INSERT IGNORE INTO rol (id_rol, nombre) VALUES (1, 'Visitante'), (2, 'Cliente'), (3, 'Inmobiliaria'), (4, 'Administrador')",
                            "INSERT IGNORE INTO ciudad (id_ciudad, nombre, departamento) VALUES (1, 'Bucaramanga', 'Santander'), (2, 'Floridablanca', 'Santander'), (3, 'Piedecuesta', 'Santander'), (4, 'Giron', 'Santander'), (5, 'Bogota', 'Cundinamarca'), (6, 'Medellin', 'Antioquia'), (7, 'Cali', 'Valle del Cauca'), (8, 'Barranquilla', 'Atlantico'), (9, 'Cartagena', 'Bolivar'), (10, 'Santa Marta', 'Magdalena')",
                            "INSERT IGNORE INTO tipo_propiedad (id_tipo, nombre) VALUES (1, 'Casa'), (2, 'Apartamento'), (3, 'Local'), (4, 'Oficina'), (5, 'Terreno'), (6, 'Finca'), (7, 'Bodega'), (8, 'Consultorio'), (9, 'Edificio'), (10, 'Lote')",
                            "INSERT IGNORE INTO caracteristica (id_caracteristica, nombre) VALUES (1, 'Piscina'), (2, 'Parqueadero'), (3, 'Ascensor'), (4, 'Gimnasio'), (5, 'Vigilancia 24/7'), (6, 'Zona BBQ'), (7, 'Cancha Multiple'), (8, 'Balcon'), (9, 'Aire Acondicionado'), (10, 'Cocina Integral')",
                            "INSERT IGNORE INTO usuario (id_usuario, correo, clave, estado) VALUES "
                                + "(1, 'admin@tresmuebles.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),"
                                + "(2, 'agente1@tresmuebles.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),"
                                + "(3, 'agente2@tresmuebles.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),"
                                + "(4, 'cliente1@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),"
                                + "(5, 'cliente2@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),"
                                + "(6, 'cliente3@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),"
                                + "(7, 'cliente4@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),"
                                + "(8, 'cliente5@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),"
                                + "(9, 'cliente6@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),"
                                + "(10, 'cliente7@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo')",
                            "INSERT IGNORE INTO perfil (id_usuario, nombres, apellidos, documento, telefono, direccion) VALUES "
                                + "(1, 'Admin', 'Sistema', '123456789', '3001234567', 'Oficina Central'),"
                                + "(2, 'Agente', 'Uno', '987654321', '3109876543', 'Sucursal Norte'),"
                                + "(3, 'Agente', 'Dos', '1122334455', '3201122334', 'Sucursal Sur'),"
                                + "(4, 'Carlos', 'Perez', '1098765432', '3151234567', 'Calle 10 # 20-30'),"
                                + "(5, 'Maria', 'Gomez', '1098111222', '3161234567', 'Carrera 15 # 40-50'),"
                                + "(6, 'Juan', 'Rodriguez', '1098333444', '3171234567', 'Avenida 20 # 10-20'),"
                                + "(7, 'Ana', 'Martinez', '1098555666', '3181234567', 'Transversal 5 # 3-4'),"
                                + "(8, 'Luis', 'Hernandez', '1098777888', '3191234567', 'Diagonal 10 # 5-6'),"
                                + "(9, 'Laura', 'Lopez', '1098999000', '3201234567', 'Calle 50 # 10-20'),"
                                + "(10, 'Pedro', 'Garcia', '1098222333', '3211234567', 'Carrera 30 # 20-10')",
                            "INSERT IGNORE INTO usuario_rol (id_usuario, id_rol) VALUES (1, 4), (2, 3), (3, 3), (4, 2), (5, 2), (6, 2), (7, 2), (8, 2), (9, 2), (10, 2)",
                            "INSERT IGNORE INTO propiedad (id_propiedad, matricula_inmobiliaria, id_tipo, id_ciudad, id_agente, titulo, descripcion, precio, area, habitaciones, banos, estado_publicacion) VALUES "
                                + "(1, 'MAT-001', 2, 1, 2, 'Hermoso Apartamento en Cabecera', 'Amplio apartamento con excelente vista.', 350000000, 80.5, 3, 2, 'disponible'),"
                                + "(2, 'MAT-002', 1, 2, 3, 'Casa campestre en Ruitoque', 'Casa con amplias zonas verdes.', 850000000, 250.0, 4, 3, 'disponible'),"
                                + "(3, 'MAT-003', 3, 1, 2, 'Local comercial céntrico', 'Ideal para restaurantes.', 200000000, 45.0, 0, 1, 'disponible'),"
                                + "(4, 'MAT-004', 4, 5, 3, 'Oficina moderna en Chicó', 'Edificio inteligente.', 450000000, 60.0, 0, 2, 'disponible'),"
                                + "(5, 'MAT-005', 2, 6, 2, 'Apto en El Poblado', 'Acabados de lujo.', 600000000, 120.0, 3, 3, 'disponible'),"
                                + "(6, 'MAT-006', 1, 7, 3, 'Casa Ciudad Jardin', 'Excelente ubicacion.', 550000000, 180.0, 4, 4, 'disponible'),"
                                + "(7, 'MAT-007', 5, 3, 2, 'Lote urbanizable', 'Cerca a via principal.', 150000000, 500.0, 0, 0, 'disponible'),"
                                + "(8, 'MAT-008', 2, 8, 3, 'Apartamento Alto Prado', 'Balcon con vista al mar.', 420000000, 95.0, 3, 2, 'disponible'),"
                                + "(9, 'MAT-009', 1, 9, 2, 'Casa en Manga', 'Estilo republicano.', 900000000, 300.0, 5, 4, 'vendida'),"
                                + "(10, 'MAT-010', 2, 10, 3, 'Apto en Rodadero', 'Cerca a la playa.', 280000000, 70.0, 2, 2, 'arrendada')",
                            "INSERT IGNORE INTO imagen_propiedad (id_propiedad, url_imagen, es_principal) VALUES "
                                + "(1, 'img/prop1_1.jpg', TRUE), (1, 'img/prop1_2.jpg', FALSE), (1, 'img/prop1_3.jpg', FALSE),"
                                + "(2, 'img/prop2_1.jpg', TRUE), (2, 'img/prop2_2.jpg', FALSE), (2, 'img/prop2_3.jpg', FALSE),"
                                + "(3, 'img/prop3_1.png', TRUE), (3, 'img/prop3_2.png', FALSE), (3, 'img/prop3_3.png', FALSE),"
                                + "(4, 'img/prop4_1.png', TRUE), (4, 'img/prop4_2.png', FALSE), (4, 'img/prop4_3.png', FALSE),"
                                + "(5, 'img/prop5_1.jpg', TRUE), (5, 'img/prop5_2.jpg', FALSE), (5, 'img/prop5_3.jpg', FALSE),"
                                + "(6, 'img/prop6_1.jpg', TRUE), (6, 'img/prop6_2.jpg', FALSE), (6, 'img/prop6_3.jpg', FALSE),"
                                + "(7, 'img/prop7_1.png', TRUE), (7, 'img/prop7_2.png', FALSE), (7, 'img/prop7_3.png', FALSE),"
                                + "(8, 'img/prop8_1.png', TRUE), (8, 'img/prop8_2.png', FALSE), (8, 'img/prop8_3.png', FALSE),"
                                + "(9, 'img/prop2_1.jpg', TRUE), (9, 'img/prop2_2.jpg', FALSE), (9, 'img/prop2_3.jpg', FALSE),"
                                + "(10, 'img/prop5_1.jpg', TRUE), (10, 'img/prop5_2.jpg', FALSE), (10, 'img/prop5_3.jpg', FALSE)",
                            "INSERT IGNORE INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES "
                                + "(1, 2), (1, 3), (1, 10), (2, 1), (2, 2), (2, 6), (5, 1), (5, 2), (5, 3), (5, 4), (8, 2), (8, 3), (8, 8), (10, 1), (10, 9)",
                            "INSERT IGNORE INTO cita (id_cita, id_propiedad, id_cliente, fecha_hora, estado) VALUES "
                                + "(1, 1, 4, '2026-09-20 09:00:00', 'realizada'),"
                                + "(2, 1, 5, '2026-09-22 10:30:00', 'programada'),"
                                + "(3, 2, 6, '2026-09-21 14:00:00', 'realizada'),"
                                + "(4, 2, 7, '2026-09-23 16:00:00', 'programada'),"
                                + "(5, 3, 8, '2026-09-22 11:00:00', 'programada'),"
                                + "(6, 4, 9, '2026-09-24 15:30:00', 'programada'),"
                                + "(7, 5, 10, '2026-09-20 16:00:00', 'cancelada'),"
                                + "(8, 6, 4, '2026-09-25 09:30:00', 'programada'),"
                                + "(9, 9, 5, '2026-09-21 10:00:00', 'realizada'),"
                                + "(10, 10, 6, '2026-09-26 11:30:00', 'programada')",
                            "INSERT IGNORE INTO solicitud (id_solicitud, id_propiedad, id_cliente, tipo, estado) VALUES "
                                + "(1, 1, 4, 'compra', 'aprobada'), (2, 1, 5, 'compra', 'pendiente'), (3, 2, 6, 'compra', 'aprobada'), (4, 2, 7, 'arriendo', 'pendiente'),"
                                + "(5, 3, 8, 'arriendo', 'pendiente'), (6, 4, 9, 'compra', 'rechazada'), (7, 5, 10, 'compra', 'aprobada'), (8, 6, 4, 'arriendo', 'pendiente'),"
                                + "(9, 9, 5, 'compra', 'aprobada'), (10, 10, 6, 'arriendo', 'pendiente')",
                            "INSERT IGNORE INTO documento_solicitud (id_documento, id_solicitud, nombre_documento, url_documento) VALUES "
                                + "(1, 1, 'Carta_Laboral_CarlosPerez.pdf', 'docs/solicitudes/carta_laboral_carlos.pdf'),"
                                + "(2, 2, 'Extractos_Bancarios_MariaGomez.pdf', 'docs/solicitudes/extractos_maria.pdf'),"
                                + "(3, 3, 'Declaracion_Renta_JuanRodriguez.pdf', 'docs/solicitudes/renta_juan.pdf'),"
                                + "(4, 4, 'Fiador_Codeudor_AnaMartinez.pdf', 'docs/solicitudes/codeudor_ana.pdf'),"
                                + "(5, 5, 'Certificado_Ingresos_LuisHernandez.pdf', 'docs/solicitudes/ingresos_luis.pdf'),"
                                + "(6, 6, 'Cedula_LauraLopez.pdf', 'docs/solicitudes/cedula_laura.pdf'),"
                                + "(7, 7, 'Preaprobado_Credito_PedroGarcia.pdf', 'docs/solicitudes/credito_pedro.pdf'),"
                                + "(8, 8, 'Referencias_Comerciales_CarlosPerez.pdf', 'docs/solicitudes/referencias_carlos.pdf'),"
                                + "(9, 9, 'Promesa_Compraventa_MariaGomez.pdf', 'docs/solicitudes/promesa_maria.pdf'),"
                                + "(10, 10, 'Formulario_Arrendamiento_JuanRodriguez.pdf', 'docs/solicitudes/formulario_juan.pdf')",
                            "INSERT IGNORE INTO favorito (id_favorito, id_propiedad, id_cliente) VALUES (1, 1, 4), (2, 2, 4), (3, 5, 4), (4, 1, 5), (5, 6, 5), (6, 2, 6), (7, 8, 6), (8, 3, 7), (9, 4, 7), (10, 5, 8)",
                            "INSERT IGNORE INTO auditoria (id_auditoria, id_usuario, accion, modulo) VALUES "
                                + "(1, 1, 'Inicio de sesión exitoso', 'Autenticación'), (2, 1, 'Asignación de rol Inmobiliaria a usuario ID 2', 'Seguridad'),"
                                + "(3, 1, 'Asignación de rol Inmobiliaria a usuario ID 3', 'Seguridad'), (4, 2, 'Publicación de nueva propiedad MAT-001', 'Inmuebles'),"
                                + "(5, 3, 'Publicación de nueva propiedad MAT-002', 'Inmuebles'), (6, 4, 'Inicio de sesión exitoso', 'Autenticación'),"
                                + "(7, 4, 'Radicación de solicitud de compra para MAT-001', 'Solicitudes'), (8, 2, 'Aprobación de solicitud ID 1', 'Solicitudes'),"
                                + "(9, 5, 'Agendamiento de cita para propiedad MAT-001', 'Citas'), (10, 1, 'Consulta de reporte general de propiedades', 'Reportes')"
                        };

                        for (String sql : dml) {
                            st.executeUpdate(sql);
                        }
            %>
                        <div class="alert alert-success">
                            <h4 class="alert-heading">¡BASE DE DATOS INICIALIZADA CON ÉXITO!</h4>
                            <p class="mb-0">Se crearon las 15 tablas y se cargaron todos los datos de prueba (usuarios, perfiles, propiedades, citas, solicitudes y auditoría).</p>
                        </div>
                        <div class="mt-3">
                            <a href="test-db.jsp" class="btn btn-success me-2">Verificar Diagnóstico</a>
                            <a href="login.jsp" class="btn btn-primary">Ir a Iniciar Sesión</a>
                        </div>
            <%
                    } catch (Exception e) {
            %>
                        <div class="alert alert-danger">
                            <h4>Error al inicializar:</h4>
                            <code><%= e.getClass().getName() %>: <%= e.getMessage() %></code>
                        </div>
            <%
                    } finally {
                        if (st != null) try { st.close(); } catch (Exception ignored) {}
                        if (con != null) try { con.close(); } catch (Exception ignored) {}
                    }
                } else {
            %>
                    <p>Haz clic en el siguiente botón para crear automáticamente todas las tablas y datos en la base de datos de Clever Cloud:</p>
                    <a href="init-db.jsp?action=ejecutar" class="btn btn-primary btn-lg">
                        Instalar Tablas y Datos Ahora
                    </a>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>
