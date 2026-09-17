# Sprint 3 Review - Operación y Cierre

**Proyecto:** Inmobiliaria Tres Muebles Web  
**Fecha de Cierre:** Fin del Sprint 3 (Día 21)  
**Asistentes:** Development Team, Scrum Master, Product Owner (Docente)  

---

## 1. Objetivo del Sprint
Implementar las interacciones transaccionales finales entre clientes y agentes (citas, solicitudes con documentos PDF y favoritos), desarrollar las funciones avanzadas de administración (gestión de roles, control de cuentas y auditoría), ejecutar las consultas analíticas multi-tabla exigidas por la rúbrica y preparar el empaquetado y guía de despliegue.

---

## 2. Demostración Funcional de Historias de Usuario

| Historia de Usuario | Estimación | Estado | Evidencia de Demostración Funcional |
|---|:---:|:---:|---|
| **H4. Asignar y Revocar Roles (Admin)** | 4 h | **Completado (Done)** | Panel de administración con listado completo de usuarios, activación/inactivación inmediata de cuentas y ventana modal para asignar roles adicionales o revocar roles respetando que conserve al menos uno (tabla `usuario_rol`). |
| **H8. Marcar Propiedades Favoritas** | 2 h | **Completado (Done)** | Botón de favoritos en ficha técnica con restricción `UNIQUE (id_propiedad, id_cliente)` para evitar duplicados. Sección de "Mis Favoritos" en el dashboard del cliente con opción de eliminación. |
| **H9. Agendamiento y Atención de Citas** | 5 h | **Completado (Done)** | Agendamiento por parte del cliente con formato de fecha/hora AM/PM. Control de cruce de horarios mediante llave `UNIQUE (id_propiedad, fecha_hora)`. Vista `panel/agente/citas.jsp` para que el agente revise visitas con datos de contacto del cliente y las marque como "Realizada" o "Cancelada". |
| **H10 & H11. Solicitudes y Documentos (PDF)** | 6 h | **Completado (Done)** | Radicación de solicitudes de compra o arriendo con adjunto probatorio en `documento_solicitud`. Bandeja de entrada del cliente para consultar estado y bandeja del agente `panel/agente/solicitudes.jsp` que permite **abrir/descargar el PDF** y aprobar o rechazar el trámite. |
| **H12. Reportes Analíticos Consolidados** | 4 h | **Completado (Done)** | Pestaña de reportes en el panel de Administrador: 1) Resumen de inmuebles por ciudad y estado con `INNER JOIN`, `GROUP BY` y `HAVING`. 2) Detección de inmuebles sin visitas con `LEFT JOIN`. |
| **H13. Auditoría de Accesos y Cambios** | 3 h | **Completado (Done)** | Pestaña de auditoría en el panel de Administrador que lista cronológicamente inicios de sesión, publicaciones, cambios de roles y radicaciones registradas en la tabla `auditoria`. |

**Total Horas Estimadas:** 24 h | **Total Horas Reales:** 24 h  
**Cumplimiento del Product Backlog:** 100% de las historias prioritarias (H1 a H13) finalizadas exitosamente.

---

## 3. Demostración de Entregables Técnicos
* **Base de Datos:** Scripts `ddl.sql`, `dml.sql` (con 10+ registros por tabla) y `consultas_obligatorias.sql` validados.
* **Modelos exportados:** Diagramas MER y Relacional en 3FN exportados en PDF (`docs/db/modelo_entidad_relacion.pdf`) e imagen (`docs/db/modelo_entidad_relacion.png`).
* **Despliegue:** Aplicación empaquetada en archivo WAR (`TresMueblesWeb-1.0-SNAPSHOT.war`) corriendo en Apache Tomcat 10.1 bajo el contexto `/TresMueblesWeb-1.0-SNAPSHOT/`.
* **Aprobación Final del Product Owner:** Se valida el sistema completo para la fase de sustentación individual y grupal.
