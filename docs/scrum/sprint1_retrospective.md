# Sprint 1 Retrospective - Cimientos y Acceso

**Proyecto:** Inmobiliaria Tres Muebles Web  
**Fecha:** Cierre del Sprint 1  
**Participantes:** Scrum Master y Equipo de Desarrollo  

---

## 1. Dinámica de la Retrospectiva (Estrella de Mar / Qué salió bien, Qué mejorar)

### ¿Qué salió bien? (Continuar haciendo)
* **Modelado en 3FN sólido:** El diseño previo del MER y modelo relacional evitó retrabajos en las entidades base de usuarios, roles y perfiles.
* **Seguridad desde el inicio:** La integración de `jbcrypt` en `UsuarioDAO` funcionó sin fricciones y asegura el cumplimiento estricto del criterio de seguridad del parcial.
* **Uso de Bootstrap 5:** Permitió obtener un acabado estético moderno y responsivo para la landing page en poco tiempo.
* **Filtro de Servlet:** `AuthFilter` centraliza la seguridad eficientemente sin duplicar validaciones en cada JSP.

### ¿Qué se puede mejorar? (Acciones de mejora)
* **Nombres de roles consistentes:** Se identificó que en la base de datos el rol se denomina `"Administrador"`, mientras que algunas variables temporales hacían referencia a `"Admin"`. Se debe unificar para evitar inconsistencias en el código.
* **Mensajes de excepción amigables:** Mejorar los mensajes visuales cuando una restricción UNIQUE falla (por ejemplo correo duplicado), para que el usuario reciba un feedback más elegante en lugar de alertas genéricas.

---

## 2. Compromisos de Mejora para el Sprint 2
1. Estandarizar la comprobación de roles en la clase `Usuario` mediante un método tolerante a variantes (`hasRol`).
2. Diseñar los formularios del CRUD de propiedades con selectores dinámicos y checkboxes precargados desde la base de datos para agilizar el registro de características múltiples.
3. Mantener commits en Git más frecuentes asociados a cada historia de usuario.
