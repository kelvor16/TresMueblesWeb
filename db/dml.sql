-- Script DML para la Inmobiliaria Tres Muebles (Datos de prueba - 10 registros min)
USE inmobiliaria_db;

-- 1. ROLES
INSERT INTO rol 
(nombre) VALUES ('Visitante'), ('Cliente'), ('Inmobiliaria'), ('Administrador');

-- 2. CIUDADES
INSERT INTO ciudad (nombre, departamento) VALUES 
('Bucaramanga', 'Santander'), ('Floridablanca', 'Santander'), 
('Piedecuesta', 'Santander'), ('Giron', 'Santander'), 
('Bogota', 'Cundinamarca'), ('Medellin', 'Antioquia'),
('Cali', 'Valle del Cauca'), ('Barranquilla', 'Atlantico'),
('Cartagena', 'Bolivar'), ('Santa Marta', 'Magdalena');

-- 3. TIPOS DE PROPIEDAD
INSERT INTO tipo_propiedad (nombre) VALUES 
('Casa'), ('Apartamento'), ('Local'), ('Oficina'), ('Terreno'),
('Finca'), ('Bodega'), ('Consultorio'), ('Edificio'), ('Lote');

-- 4. CARACTERISTICAS
INSERT INTO caracteristica (nombre) VALUES 
('Piscina'), ('Parqueadero'), ('Ascensor'), ('Gimnasio'), ('Vigilancia 24/7'),
('Zona BBQ'), ('Cancha Multiple'), ('Balcon'), ('Aire Acondicionado'), ('Cocina Integral');

-- 5. USUARIOS (Claves encriptadas con BCrypt - Contraseña para todos es '123456')
-- Hashes generados previamente: $2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6
INSERT INTO usuario (correo, clave, estado) VALUES 
('admin@tresmuebles.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),
('agente1@tresmuebles.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),
('agente2@tresmuebles.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),
('cliente1@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),
('cliente2@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),
('cliente3@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),
('cliente4@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),
('cliente5@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),
('cliente6@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo'),
('cliente7@correo.com', '$2a$10$wTf3X/t2wHlK/N.rB8o.qO1KXZ9V/E1X9Y2.y3H/5H.1z9z5z9/g6', 'activo');

-- 6. PERFILES
INSERT INTO perfil (id_usuario, nombres, apellidos, documento, telefono, direccion) VALUES 
(1, 'Admin', 'Sistema', '123456789', '3001234567', 'Oficina Central'),
(2, 'Agente', 'Uno', '987654321', '3109876543', 'Sucursal Norte'),
(3, 'Agente', 'Dos', '1122334455', '3201122334', 'Sucursal Sur'),
(4, 'Carlos', 'Perez', '1098765432', '3151234567', 'Calle 10 # 20-30'),
(5, 'Maria', 'Gomez', '1098111222', '3161234567', 'Carrera 15 # 40-50'),
(6, 'Juan', 'Rodriguez', '1098333444', '3171234567', 'Avenida 20 # 10-20'),
(7, 'Ana', 'Martinez', '1098555666', '3181234567', 'Transversal 5 # 3-4'),
(8, 'Luis', 'Hernandez', '1098777888', '3191234567', 'Diagonal 10 # 5-6'),
(9, 'Laura', 'Lopez', '1098999000', '3201234567', 'Calle 50 # 10-20'),
(10, 'Pedro', 'Garcia', '1098222333', '3211234567', 'Carrera 30 # 20-10');

-- 7. USUARIO_ROL
INSERT INTO usuario_rol (id_usuario, id_rol) VALUES 
(1, 4), -- Admin
(2, 3), -- Agente 1
(3, 3), -- Agente 2
(4, 2), (5, 2), (6, 2), (7, 2), (8, 2), (9, 2), (10, 2); -- Clientes

-- 8. PROPIEDADES
INSERT INTO propiedad (matricula_inmobiliaria, id_tipo, id_ciudad, id_agente, titulo, descripcion, precio, area, habitaciones, banos, estado_publicacion) VALUES 
('MAT-001', 2, 1, 2, 'Hermoso Apartamento en Cabecera', 'Amplio apartamento con excelente vista.', 350000000, 80.5, 3, 2, 'disponible'),
('MAT-002', 1, 2, 3, 'Casa campestre en Ruitoque', 'Casa con amplias zonas verdes.', 850000000, 250.0, 4, 3, 'disponible'),
('MAT-003', 3, 1, 2, 'Local comercial céntrico', 'Ideal para restaurantes.', 200000000, 45.0, 0, 1, 'disponible'),
('MAT-004', 4, 5, 3, 'Oficina moderna en Chicó', 'Edificio inteligente.', 450000000, 60.0, 0, 2, 'disponible'),
('MAT-005', 2, 6, 2, 'Apto en El Poblado', 'Acabados de lujo.', 600000000, 120.0, 3, 3, 'disponible'),
('MAT-006', 1, 7, 3, 'Casa Ciudad Jardin', 'Excelente ubicacion.', 550000000, 180.0, 4, 4, 'disponible'),
('MAT-007', 5, 3, 2, 'Lote urbanizable', 'Cerca a via principal.', 150000000, 500.0, 0, 0, 'disponible'),
('MAT-008', 2, 8, 3, 'Apartamento Alto Prado', 'Balcon con vista al mar.', 420000000, 95.0, 3, 2, 'disponible'),
('MAT-009', 1, 9, 2, 'Casa en Manga', 'Estilo republicano.', 900000000, 300.0, 5, 4, 'vendida'),
('MAT-010', 2, 10, 3, 'Apto en Rodadero', 'Cerca a la playa.', 280000000, 70.0, 2, 2, 'arrendada');

-- 9. IMAGEN_PROPIEDAD (Múltiples imágenes por propiedad para el Carrusel)
INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal) VALUES 
(1, 'img/prop1_1.jpg', TRUE), (1, 'img/prop1_2.jpg', FALSE), (1, 'img/prop1_3.jpg', FALSE),
(2, 'img/prop2_1.jpg', TRUE), (2, 'img/prop2_2.jpg', FALSE), (2, 'img/prop2_3.jpg', FALSE),
(3, 'img/prop3_1.png', TRUE), (3, 'img/prop3_2.png', FALSE), (3, 'img/prop3_3.png', FALSE),
(4, 'img/prop4_1.png', TRUE), (4, 'img/prop4_2.png', FALSE), (4, 'img/prop4_3.png', FALSE),
(5, 'img/prop5_1.jpg', TRUE), (5, 'img/prop5_2.jpg', FALSE), (5, 'img/prop5_3.jpg', FALSE),
(6, 'img/prop6_1.jpg', TRUE), (6, 'img/prop6_2.jpg', FALSE), (6, 'img/prop6_3.jpg', FALSE),
(7, 'img/prop7_1.png', TRUE), (7, 'img/prop7_2.png', FALSE), (7, 'img/prop7_3.png', FALSE),
(8, 'img/prop8_1.png', TRUE), (8, 'img/prop8_2.png', FALSE), (8, 'img/prop8_3.png', FALSE),
(9, 'img/prop2_1.jpg', TRUE), (9, 'img/prop2_2.jpg', FALSE), (9, 'img/prop2_3.jpg', FALSE),
(10, 'img/prop5_1.jpg', TRUE), (10, 'img/prop5_2.jpg', FALSE), (10, 'img/prop5_3.jpg', FALSE);

-- 10. PROPIEDAD_CARACTERISTICA
INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES 
(1, 2), (1, 3), (1, 10), -- Apto 1: Parqueadero, Ascensor, Cocina Int.
(2, 1), (2, 2), (2, 6), -- Casa 2: Piscina, Parqueadero, BBQ
(5, 1), (5, 2), (5, 3), (5, 4), -- Apto 5: Piscina, Parq, Ascensor, Gym
(8, 2), (8, 3), (8, 8), -- Apto 8: Parq, Ascensor, Balcon
(10, 1), (10, 9); -- Apto 10: Piscina, Aire Acondicionado

-- 11. CITAS (10 registros de prueba - Se dejan las propiedades 7 y 8 sin citas para evidenciar la Consulta 4 con LEFT JOIN)
INSERT INTO cita (id_propiedad, id_cliente, fecha_hora, estado) VALUES 
(1, 4, '2026-09-20 09:00:00', 'realizada'),
(1, 5, '2026-09-22 10:30:00', 'programada'),
(2, 6, '2026-09-21 14:00:00', 'realizada'),
(2, 7, '2026-09-23 16:00:00', 'programada'),
(3, 8, '2026-09-22 11:00:00', 'programada'),
(4, 9, '2026-09-24 15:30:00', 'programada'),
(5, 10, '2026-09-20 16:00:00', 'cancelada'),
(6, 4, '2026-09-25 09:30:00', 'programada'),
(9, 5, '2026-09-21 10:00:00', 'realizada'),
(10, 6, '2026-09-26 11:30:00', 'programada');

-- 12. SOLICITUDES (10 registros de prueba: compras y arriendos)
INSERT INTO solicitud (id_propiedad, id_cliente, tipo, estado) VALUES 
(1, 4, 'compra', 'aprobada'),
(1, 5, 'compra', 'pendiente'),
(2, 6, 'compra', 'aprobada'),
(2, 7, 'arriendo', 'pendiente'),
(3, 8, 'arriendo', 'pendiente'),
(4, 9, 'compra', 'rechazada'),
(5, 10, 'compra', 'aprobada'),
(6, 4, 'arriendo', 'pendiente'),
(9, 5, 'compra', 'aprobada'),
(10, 6, 'arriendo', 'pendiente');

-- 13. DOCUMENTO_SOLICITUD (10 documentos de soporte asociados a las solicitudes)
INSERT INTO documento_solicitud (id_solicitud, nombre_documento, url_documento) VALUES 
(1, 'Carta_Laboral_CarlosPerez.pdf', 'docs/solicitudes/carta_laboral_carlos.pdf'),
(2, 'Extractos_Bancarios_MariaGomez.pdf', 'docs/solicitudes/extractos_maria.pdf'),
(3, 'Declaracion_Renta_JuanRodriguez.pdf', 'docs/solicitudes/renta_juan.pdf'),
(4, 'Fiador_Codeudor_AnaMartinez.pdf', 'docs/solicitudes/codeudor_ana.pdf'),
(5, 'Certificado_Ingresos_LuisHernandez.pdf', 'docs/solicitudes/ingresos_luis.pdf'),
(6, 'Cedula_LauraLopez.pdf', 'docs/solicitudes/cedula_laura.pdf'),
(7, 'Preaprobado_Credito_PedroGarcia.pdf', 'docs/solicitudes/credito_pedro.pdf'),
(8, 'Referencias_Comerciales_CarlosPerez.pdf', 'docs/solicitudes/referencias_carlos.pdf'),
(9, 'Promesa_Compraventa_MariaGomez.pdf', 'docs/solicitudes/promesa_maria.pdf'),
(10, 'Formulario_Arrendamiento_JuanRodriguez.pdf', 'docs/solicitudes/formulario_juan.pdf');

-- 14. FAVORITOS (10 registros de prueba respetando UNIQUE (id_propiedad, id_cliente))
INSERT INTO favorito (id_propiedad, id_cliente) VALUES 
(1, 4), (2, 4), (5, 4),
(1, 5), (6, 5),
(2, 6), (8, 6),
(3, 7), (4, 7),
(5, 8);

-- 15. AUDITORIA (10 registros de prueba para registro de actividades)
INSERT INTO auditoria (id_usuario, accion, modulo) VALUES 
(1, 'Inicio de sesión exitoso', 'Autenticación'),
(1, 'Asignación de rol Inmobiliaria a usuario ID 2', 'Seguridad'),
(1, 'Asignación de rol Inmobiliaria a usuario ID 3', 'Seguridad'),
(2, 'Publicación de nueva propiedad MAT-001', 'Inmuebles'),
(3, 'Publicación de nueva propiedad MAT-002', 'Inmuebles'),
(4, 'Inicio de sesión exitoso', 'Autenticación'),
(4, 'Radicación de solicitud de compra para MAT-001', 'Solicitudes'),
(2, 'Aprobación de solicitud ID 1', 'Solicitudes'),
(5, 'Agendamiento de cita para propiedad MAT-001', 'Citas'),
(1, 'Consulta de reporte general de propiedades', 'Reportes');
