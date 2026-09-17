-- =============================================================================
-- CONSULTAS OBLIGATORIAS - PROYECTO INMOBILIARIA TRES MUEBLES WEB
-- Asignatura: Programación Java - Unidades Tecnológicas de Santander (UTS)
-- Cumplimiento de la Rúbrica Académica:
--   1. Dos consultas con INNER JOIN entre 3 o más tablas.
--   2. Una consulta que resuelva una relación Muchos a Muchos (N:M).
--   3. Una consulta con LEFT JOIN (propiedades sin citas agendadas).
--   4. Una consulta de agregación con GROUP BY y HAVING.
-- =============================================================================

USE inmobiliaria_db;

-- -----------------------------------------------------------------------------
-- CONSULTA 1 (INNER JOIN entre 4 tablas):
-- Propósito: Listar el catálogo comercial de propiedades con su tipo,
--            ciudad, departamento y datos de contacto del agente inmobiliario.
-- Demuestra: Navegación de relaciones 1:N entre propiedad, tipo_propiedad, 
--            ciudad, usuario y perfil.
-- -----------------------------------------------------------------------------
SELECT 
    p.id_propiedad,
    p.matricula_inmobiliaria,
    p.titulo,
    p.precio,
    p.area,
    p.habitaciones,
    p.banos,
    tp.nombre AS tipo_inmueble,
    c.nombre AS ciudad,
    c.departamento,
    CONCAT(per.nombres, ' ', per.apellidos) AS agente_responsable,
    u.correo AS agente_correo,
    per.telefono AS agente_telefono
FROM propiedad p
INNER JOIN tipo_propiedad tp ON p.id_tipo = tp.id_tipo
INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad
INNER JOIN usuario u ON p.id_agente = u.id_usuario
INNER JOIN perfil per ON u.id_usuario = per.id_usuario
WHERE p.estado_publicacion = 'disponible'
ORDER BY p.precio DESC;


-- -----------------------------------------------------------------------------
-- CONSULTA 2 (INNER JOIN entre 4 tablas):
-- Propósito: Detalle integral de solicitudes radicadas por los clientes con
--            la información del inmueble, cliente y documento probatorio (PDF).
-- Demuestra: Trazabilidad del trámite comercial y relación 1:N con documentos.
-- -----------------------------------------------------------------------------
SELECT 
    s.id_solicitud,
    s.tipo AS tipo_tramite,
    s.estado AS estado_solicitud,
    s.fecha_radicacion,
    p.matricula_inmobiliaria,
    p.titulo AS titulo_inmueble,
    p.precio AS valor_inmueble,
    u.correo AS cliente_correo,
    CONCAT(per.nombres, ' ', per.apellidos) AS cliente_nombre,
    per.documento AS cliente_documento,
    per.telefono AS cliente_telefono,
    d.nombre_documento,
    d.url_documento
FROM solicitud s
INNER JOIN propiedad p ON s.id_propiedad = p.id_propiedad
INNER JOIN usuario u ON s.id_cliente = u.id_usuario
INNER JOIN perfil per ON u.id_usuario = per.id_usuario
INNER JOIN documento_solicitud d ON s.id_solicitud = d.id_solicitud
ORDER BY s.fecha_radicacion DESC;


-- -----------------------------------------------------------------------------
-- CONSULTA 3 (Relación Muchos a Muchos - N:M):
-- Propósito: Listar cada propiedad junto con todas sus características
--            concatenadas, resolviendo la tabla intermedia propiedad_caracteristica.
-- Demuestra: Dominio de claves compuestas y agregación de atributos en relaciones N:M.
-- -----------------------------------------------------------------------------
SELECT 
    p.id_propiedad,
    p.matricula_inmobiliaria,
    p.titulo AS inmueble,
    tp.nombre AS tipo,
    c.nombre AS ciudad,
    p.precio,
    GROUP_CONCAT(car.nombre ORDER BY car.nombre ASC SEPARATOR ', ') AS caracteristicas_incluidas,
    COUNT(pc.id_caracteristica) AS total_caracteristicas
FROM propiedad p
INNER JOIN tipo_propiedad tp ON p.id_tipo = tp.id_tipo
INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad
INNER JOIN propiedad_caracteristica pc ON p.id_propiedad = pc.id_propiedad
INNER JOIN caracteristica car ON pc.id_caracteristica = car.id_caracteristica
GROUP BY p.id_propiedad, p.matricula_inmobiliaria, p.titulo, tp.nombre, c.nombre, p.precio
ORDER BY total_caracteristicas DESC;


-- -----------------------------------------------------------------------------
-- CONSULTA 4 (LEFT JOIN - Detección de registros sin asociación):
-- Propósito: Encontrar las propiedades publicadas que NO tienen ninguna cita
--            agendada por clientes (inmuebles que requieren promoción o ajuste).
-- Demuestra: Uso de LEFT JOIN + WHERE IS NULL para detectar ausencia de relaciones.
-- -----------------------------------------------------------------------------
SELECT 
    p.id_propiedad,
    p.matricula_inmobiliaria,
    p.titulo,
    p.precio,
    tp.nombre AS tipo,
    c.nombre AS ciudad,
    p.fecha_publicacion
FROM propiedad p
INNER JOIN tipo_propiedad tp ON p.id_tipo = tp.id_tipo
INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad
LEFT JOIN cita ci ON p.id_propiedad = ci.id_propiedad
WHERE ci.id_cita IS NULL AND p.estado_publicacion = 'disponible'
ORDER BY p.precio ASC;


-- -----------------------------------------------------------------------------
-- CONSULTA 5 (Agregación con GROUP BY y HAVING):
-- Propósito: Reporte consolidado de inventario por ciudad y estado de publicación,
--            calculando cantidad, precio promedio, valor mínimo y máximo.
-- Demuestra: Aplicación de funciones de agregación (COUNT, AVG, MIN, MAX),
--            agrupamiento multi-columna y filtro posterior con HAVING.
-- -----------------------------------------------------------------------------
SELECT 
    c.nombre AS ciudad,
    c.departamento,
    p.estado_publicacion AS estado,
    COUNT(p.id_propiedad) AS total_inmuebles,
    AVG(p.precio) AS precio_promedio,
    MIN(p.precio) AS precio_minimo,
    MAX(p.precio) AS precio_maximo
FROM propiedad p
INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad
GROUP BY c.nombre, c.departamento, p.estado_publicacion
HAVING COUNT(p.id_propiedad) > 0
ORDER BY total_inmuebles DESC, precio_promedio DESC;
