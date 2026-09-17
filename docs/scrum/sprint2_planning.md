# Sprint 2 Planning - Núcleo del Negocio

**Objetivo del Sprint:**
Desarrollar el CRUD completo de propiedades para que la Inmobiliaria pueda gestionar su catálogo (con imágenes y características), implementar el buscador de propiedades para los clientes, y permitir la actualización de perfiles personales.

## Historias de Usuario Abordadas

### 5. Completar Perfil de Cliente (Prioridad Media)
- **Historia:** Como cliente, quiero completar mi perfil con documento, teléfono y dirección asociados a mi cuenta para agilizar mis trámites.
- **Estimación:** 3 horas.
- **Definition of Done (DoD):**
  - Formulario de edición de perfil accesible desde el dashboard.
  - Actualización exitosa en la tabla `perfil` (relación 1:1).

### 6. CRUD de Propiedades (Prioridad Alta)
- **Historia:** Como agente de la inmobiliaria, quiero registrar y editar propiedades con fotos, características y precio para mantener el catálogo actualizado.
- **Estimación:** 8 horas.
- **Definition of Done (DoD):**
  - Formulario completo para registrar una propiedad.
  - Soporte para asociar múltiples características (relación N:M, guardado en `propiedad_caracteristica`).
  - Soporte para asociar múltiples imágenes mediante URLs o nombres de archivo (relación 1:N en `imagen_propiedad`).
  - Listado de propiedades publicadas por el agente.
  - Opción de dar de baja lógicamente (`estado_publicacion`).

### 7. Buscador y Filtros (Prioridad Alta)
- **Historia:** Como cliente, quiero buscar y filtrar propiedades por ciudad, tipo, precio y características para encontrar las opciones que se ajusten a mis necesidades.
- **Estimación:** 6 horas.
- **Definition of Done (DoD):**
  - Buscador público y buscador avanzado en el dashboard del cliente.
  - Filtros funcionales.
  - Vista de detalle ("Ficha técnica") mostrando la información completa, imágenes (carrusel o galería) y características del inmueble seleccionado.
