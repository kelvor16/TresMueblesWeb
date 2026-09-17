# Documentación de Consultas SQL Obligatorias

**Asignatura:** Programación Java  
**Institución:** Unidades Tecnológicas de Santander (UTS)  
**Proyecto:** Inmobiliaria Tres Muebles Web  

Este documento describe formalmente las **cinco consultas obligatorias** solicitadas en la rúbrica del proyecto para sustentar el dominio del modelo de datos normalizado (3FN).

---

## Resumen de Consultas

| No. | Tipo de Consulta | Tablas Involucradas | Propósito en el Sistema |
|:---:|---|---|---|
| **1** | `INNER JOIN` (4 tablas) | `propiedad`, `tipo_propiedad`, `ciudad`, `usuario`, `perfil` | Ficha técnica y catálogo público con datos del agente. |
| **2** | `INNER JOIN` (4 tablas) | `solicitud`, `propiedad`, `usuario`, `perfil`, `documento_solicitud` | Trazabilidad de solicitudes radicadas y sus PDFs adjuntos. |
| **3** | Muchos a Muchos (`N:M`) | `propiedad`, `propiedad_caracteristica`, `caracteristica`, `tipo_propiedad`, `ciudad` | Características consolidadas por inmueble (`GROUP_CONCAT`). |
| **4** | `LEFT JOIN` (Exclusión) | `propiedad`, `tipo_propiedad`, `ciudad`, `cita` | Detección de inmuebles disponibles sin citas agendadas. |
| **5** | Agregación (`GROUP BY` + `HAVING`) | `propiedad`, `ciudad` | Reporte ejecutivo de propiedades por ciudad con promedios y límites. |

---

## Detalle y Justificación Técnica de cada Consulta

### Consulta 1: Catálogo Comercial de Propiedades (INNER JOIN de 4 tablas)
* **Objetivo:** Obtener la información completa de cada propiedad disponible para la venta o arriendo, relacionándola con su clasificación (`tipo_propiedad`), ubicación geográfica (`ciudad`) y el agente inmobiliario asignado (`usuario` y `perfil`).
* **Sentencia SQL:**
```sql
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
```
* **Justificación:** Cumple con la exigencia de cruzar tres o más tablas mediante llaves foráneas (`id_tipo`, `id_ciudad`, `id_agente` e `id_usuario`).

---

### Consulta 2: Trazabilidad de Solicitudes y Documentos (INNER JOIN de 4 tablas)
* **Objetivo:** Gestionar el estado de las solicitudes radicadas por los clientes (compra/arriendo), vinculando los datos personales del solicitante y el archivo PDF adjunto como soporte.
* **Sentencia SQL:**
```sql
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
```
* **Justificación:** Integra la tabla transaccional `solicitud` con la tabla `documento_solicitud` y el usuario cliente, evidenciando integridad referencial en el flujo de negocio.

---

### Consulta 3: Resolución de Relación Muchos a Muchos (N:M)
* **Objetivo:** Resolver la relación de muchos a muchos existente entre `propiedad` y `caracteristica` a través de la tabla intermedia `propiedad_caracteristica`, agrupando y listando todas las amenidades del inmueble en una sola fila.
* **Sentencia SQL:**
```sql
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
```
* **Justificación:** Demuestra la eliminación de dependencias multivaluadas en la base de datos (1FN/2FN) mediante tabla puente y llave primaria compuesta `(id_propiedad, id_caracteristica)`.

---

### Consulta 4: Propiedades Sin Citas Agendadas (LEFT JOIN)
* **Objetivo:** Identificar los inmuebles activos que no registran visitas ni citas agendadas por ningún cliente.
* **Sentencia SQL:**
```sql
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
```
* **Justificación:** Demuestra el uso del `LEFT JOIN` combinado con `WHERE ci.id_cita IS NULL` para capturar la ausencia de registros hijos en una relación 1:N.

---

### Consulta 5: Reporte Agregado con GROUP BY y HAVING
* **Objetivo:** Alimentar el reporte del panel de administración calculando estadísticas consolidadas por ciudad y estado de publicación.
* **Sentencia SQL:**
```sql
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
```
* **Justificación:** Emplea múltiples funciones de agregación (`COUNT`, `AVG`, `MIN`, `MAX`), agrupamiento por dimensiones espaciales y de estado, y filtrado pos-agregación mediante la cláusula `HAVING`.
