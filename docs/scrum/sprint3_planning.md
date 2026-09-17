# Sprint 3 Planning - Operación y Cierre

**Objetivo del Sprint:**
Implementar las interacciones finales entre el cliente y el agente (citas, solicitudes y favoritos), construir los reportes analíticos con SQL avanzado requeridos por la rúbrica y generar la guía de despliegue para la entrega.

## Historias de Usuario Abordadas

### 8. Marcar Favoritos (Prioridad Media)
- **Historia:** Como cliente, quiero marcar propiedades como favoritas para consultarlas más adelante sin tener que buscarlas de nuevo.
- **Estimación:** 2 horas.
- **Definition of Done (DoD):**
  - Opción funcional en la ficha de propiedad.
  - Listado de favoritos en el panel del cliente.

### 9. Agendamiento de Citas (Prioridad Media)
- **Historia:** Como cliente, quiero solicitar una cita en un horario disponible para visitar el inmueble sin que se crucen las agendas.
- **Estimación:** 4 horas.
- **Definition of Done (DoD):**
  - Formulario de cita en la ficha de propiedad.
  - Excepción atrapada de la BD por la llave UNIQUE `(id_propiedad, fecha_hora)` para evitar cruces.
  - Listado de citas agendadas.

### 10. & 11. Solicitudes y Documentos (Prioridad Media)
- **Historia:** Como cliente quiero radicar documentos, y como agente quiero aprobarlos o rechazarlos.
- **Estimación:** 5 horas.
- **Definition of Done (DoD):**
  - Radicación de la solicitud con URL de documento simulada.
  - Panel de agente muestra bandeja de entrada para cambiar estado (Pendiente -> Aprobada/Rechazada).

### 12. & 13. Reportes Administrativos (Prioridad Media/Baja)
- **Historia:** Como administrador, quiero un reporte de propiedades por ciudad/estado con consultas de agregación, y auditoría.
- **Estimación:** 4 horas.
- **Definition of Done (DoD):**
  - Sentencia SQL con `GROUP BY`, `HAVING` e `INNER JOIN` ejecutándose.
  - Sentencia SQL con `LEFT JOIN` (ej. propiedades sin citas).
  - Presentación en dashboard de Admin.
