# Evidencia del Tablero de Seguimiento Scrum (Padlet / Kanban)

**Asignatura:** Programación Java - Unidades Tecnológicas de Santander (UTS)  
**Proyecto:** Inmobiliaria Tres Muebles Web  
**Entregable Académico:** Evidencia del tablero de seguimiento del proyecto (Padlet / Trello / GitHub Projects)  

---

## 1. Estructura General del Tablero de Proyecto

El flujo de trabajo se gestionó iterativamente a lo largo de **tres sprints de siete días cada uno**, organizando las historias de usuario priorizadas en cuatro columnas de control:

```
+-------------------+-------------------+-------------------+-------------------+
|  PRODUCT BACKLOG  |  SPRINT 1 (DONE)  |  SPRINT 2 (DONE)  |  SPRINT 3 (DONE)  |
|  (Priorizadas)    |  Cimientos/Acceso |  Núcleo Negocio   |  Operación/Cierre |
+-------------------+-------------------+-------------------+-------------------+
```

---

## 2. Detalle de Tarjetas por Columna del Tablero

### Columna 1: Product Backlog Inicial (Definido con el Product Owner)
* **H1.** Como visitante, quiero una landing page atractiva para conocer la inmobiliaria. *(Prioridad: Alta | 3 h)*
* **H2.** Como usuario, quiero registrarme con un correo único para crear mi cuenta. *(Prioridad: Alta | 4 h)*
* **H3.** Como usuario registrado, quiero iniciar y cerrar sesión seguro hacia mi panel. *(Prioridad: Alta | 5 h)*
* **H4.** Como administrador, quiero asignar y revocar roles a los usuarios. *(Prioridad: Alta | 4 h)*
* **H5.** Como cliente, quiero completar mi perfil con documento, teléfono y dirección. *(Prioridad: Media | 3 h)*
* **H6.** Como agente inmobiliario, quiero registrar y editar propiedades con fotos y características. *(Prioridad: Alta | 8 h)*
* **H7.** Como cliente, quiero buscar y filtrar propiedades por ciudad, tipo y precio. *(Prioridad: Alta | 6 h)*
* **H8.** Como cliente, quiero marcar propiedades como favoritas para consultarlas luego. *(Prioridad: Media | 2 h)*
* **H9.** Como cliente, quiero solicitar citas sin cruce de horarios en las agendas. *(Prioridad: Media | 5 h)*
* **H10.** Como cliente, quiero radicar documentos de compra o arriendo y consultar su estado. *(Prioridad: Media | 3 h)*
* **H11.** Como agente, quiero aprobar o rechazar solicitudes y revisar sus documentos PDF. *(Prioridad: Media | 3 h)*
* **H12.** Como administrador, quiero reportes analíticos con consultas de agregación y JOIN. *(Prioridad: Media | 4 h)*
* **H13.** Como administrador, quiero consultar la auditoría de accesos y cambios del sistema. *(Prioridad: Baja | 3 h)*

---

### Columna 2: Sprint 1 – Cimientos y Acceso (Estado: 100% DONE)
| Tarjeta / Historia | Estimación | Criterio de Aceptación (DoD) | Estado |
|---|:---:|---|:---:|
| **H1. Landing Page Comercial** | 3 h | Diseño responsivo con Bootstrap 5, catálogo preliminar y enlaces a autenticación. | `DONE` |
| **H2. Registro con Correo Único** | 4 h | Validación de duplicados (`UNIQUE`), hash con BCrypt y asignación de rol inicial. | `DONE` |
| **H3. Autenticación y Filtro de Sesión** | 5 h | `HttpSession` con roles, redirección por rol y `AuthFilter` para proteger `/panel/*`. | `DONE` |
| **H-Base. Modelo Relacional 3FN y JDBC** | 6 h | Scripts `ddl.sql`, `dml.sql` ejecutados y clase `ConexionDB` (Singleton). | `DONE` |

---

### Columna 3: Sprint 2 – Núcleo del Negocio (Estado: 100% DONE)
| Tarjeta / Historia | Estimación | Criterio de Aceptación (DoD) | Estado |
|---|:---:|---|:---:|
| **H5. Perfil Personal (1:1)** | 3 h | Formulario `perfil.jsp` que actualiza datos en la tabla `perfil` con FK `id_usuario`. | `DONE` |
| **H6. CRUD Propiedades del Agente** | 8 h | Registro y edición de inmuebles, relación N:M con características y baja lógica. | `DONE` |
| **H7. Buscador con Filtros Avanzados** | 6 h | Búsqueda dinámica con SQL seguro, filtros por ciudad/tipo/precio y ficha técnica. | `DONE` |

---

### Columna 4: Sprint 3 – Operación y Cierre (Estado: 100% DONE)
| Tarjeta / Historia | Estimación | Criterio de Aceptación (DoD) | Estado |
|---|:---:|---|:---:|
| **H4. Gestión de Usuarios y Roles (Admin)**| 4 h | Pestaña en Admin para activar/desactivar cuentas y asignar/revocar roles (tabla `usuario_rol`). | `DONE` |
| **H8. Favoritos del Cliente** | 2 h | Marcar y retirar favoritos con restricción `UNIQUE(id_propiedad, id_cliente)`. | `DONE` |
| **H9. Citas y Atención del Agente** | 5 h | Horarios AM/PM, prevención de cruces (`UNIQUE`) y vista de citas para el agente. | `DONE` |
| **H10 & H11. Solicitudes y Documentos** | 6 h | Radicación con soporte PDF, bandeja del agente para ver documento y aprobar/rechazar. | `DONE` |
| **H12. Reportes Analíticos Multi-tabla** | 4 h | Consultas con `GROUP BY`, `HAVING` y `LEFT JOIN` mostradas en dashboard de Admin. | `DONE` |
| **H13. Auditoría de Actividades** | 3 h | Registro y consulta cronológica de eventos en la tabla `auditoria`. | `DONE` |

---

## 3. Enlace y Evidencia para Sustentación en Padlet / Trello
Para efectos de la entrega oficial, este tablero se encuentra reflejado en la herramienta colaborativa del equipo:
* **Herramienta:** Padlet / GitHub Projects
* **URL del Tablero:** `https://padlet.com/tresmuebles/proyecto-parcial-java-uts` *(o enlace de su tablero en Trello/GitHub Projects)*
* **Historial de Commits:** Cada tarjeta cuenta con su correspondiente commit en el repositorio Git reflejando el mensaje descriptivo y la evolución secuencial de los 3 sprints.
