# Sprint 2 Review - Núcleo del Negocio

**Proyecto:** Inmobiliaria Tres Muebles Web  
**Fecha de Cierre:** Fin del Sprint 2 (Día 14)  
**Asistentes:** Development Team, Scrum Master, Product Owner (Docente)  

---

## 1. Objetivo del Sprint
Construir el núcleo operativo de la inmobiliaria: permitir a los agentes inmobiliarios publicar, editar y dar de baja lógica propiedades con múltiples fotos y características; habilitar el buscador avanzado con filtros combinados para clientes y visitantes; y permitir la actualización de perfiles personales.

---

## 2. Demostración Funcional de Historias de Usuario

| Historia de Usuario | Estimación | Estado | Evidencia de Demostración Funcional |
|---|:---:|:---:|---|
| **H5. Completar Perfil de Cliente** | 3 h | **Completado (Done)** | Vista `perfil.jsp` y `PerfilServlet`. Formulario que actualiza documento, teléfono, dirección y nombres en la tabla `perfil` (relación 1:1 con `usuario`). |
| **H6. CRUD de Propiedades (Agente)** | 8 h | **Completado (Done)** | Módulo de gestión en `panel/agente/`. Formulario para registrar y editar propiedades con selección de características múltiples (tabla intermedia `propiedad_caracteristica`) e imágenes principales y secundarias (`imagen_propiedad`). Botón funcional de baja lógica/activación (`estado_publicacion`). |
| **H7. Buscador y Filtros Avanzados** | 6 h | **Completado (Done)** | Servlet `BuscadorServlet` y vista `buscador.jsp`. Filtrado dinámico por ciudad, tipo de inmueble y rangos de precio. Vista de detalle `detalle-propiedad.jsp` con galería de fotos, lista de características y especificaciones técnicas completas. |

**Total Horas Estimadas:** 17 h | **Total Horas Reales:** 17 h  
**Velocidad del Sprint:** 100% de historias entregadas y validadas contra el Definition of Done (DoD).

---

## 3. Feedback del Product Owner (Docente)
* La visualización de la ficha técnica de la propiedad con sus características asociadas resuelve adecuadamente la relación muchos a muchos exigida.
* La baja lógica cumple con el requisito de no eliminar físicamente registros para preservar la integridad referencial histórica.
* Se da aval para proceder al Sprint 3 de operaciones transaccionales (citas, solicitudes y reportes de agregación).
