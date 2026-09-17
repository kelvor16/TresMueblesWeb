# Sprint 2 Retrospective - Núcleo del Negocio

**Proyecto:** Inmobiliaria Tres Muebles Web  
**Fecha:** Cierre del Sprint 2  
**Participantes:** Scrum Master y Equipo de Desarrollo  

---

## 1. Dinámica de la Retrospectiva

### ¿Qué salió bien?
* **Gestión eficiente de transacciones JDBC:** En `PropiedadDAO`, el uso de transacciones con `con.setAutoCommit(false)` y `addBatch()` para insertar características e imágenes en un solo paso aseguró consistencia absoluta sin dejar propiedades huérfanas.
* **Buscador flexible:** El armado dinámico de la cláusula `WHERE` con `StringBuilder` y parámetros seguros mediante `PreparedStatement` previene inyecciones SQL y soporta cualquier combinación de filtros sin fallar.
* **Diseño visual:** El catálogo de inmuebles y la ficha técnica obtuvieron una presentación atractiva que cumple con los estándares web modernos.

### ¿Qué se puede mejorar?
* **Navegación del agente inmobiliario:** Inicialmente el panel del agente carecía de accesos directos hacia las secciones de solicitudes y citas. Se debe unificar la barra de navegación en todo el módulo.
* **Formatos de fecha y hora:** En el agendamiento y visualización se debe garantizar que el horario sea comprensible para el usuario (formato 12 horas con indicador AM/PM).

---

## 2. Compromisos de Mejora para el Sprint 3
1. Integrar formato legible de 12 horas (`hh:mm a`) en la visualización de citas agendadas tanto para el cliente como para el agente.
2. Implementar una barra de navegación unificada en todas las vistas de cada rol para evitar enlaces rotos o desorientación del usuario.
3. Asegurar la captura de excepciones SQL al agendar citas simultáneas mediante la restricción `UNIQUE(id_propiedad, fecha_hora)`.
4. Diseñar los reportes analíticos con sentencias SQL avanzadas (`GROUP BY`, `HAVING`, `LEFT JOIN`) en el panel del Administrador.
