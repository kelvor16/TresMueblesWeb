# Sprint 1 Planning - Cimientos y Acceso

**Objetivo del Sprint:**
Diseñar el modelo de datos robusto, configurar el ambiente Java Web y habilitar el acceso seguro a la plataforma con roles diferenciados para la Inmobiliaria Tres Muebles.

## Historias de Usuario Abordadas

### 1. Landing Page Pública (Prioridad Alta)
- **Historia:** Como visitante, quiero una landing page atractiva para conocer la inmobiliaria y buscar propiedades rápidamente.
- **Estimación:** 3 horas.
- **Definition of Done (DoD):**
  - Página responsiva creada con Bootstrap.
  - Accesos claros a registro y login.
  - Diseño alineado al concepto "Tres Muebles".

### 2. Registro de Usuario (Prioridad Alta)
- **Historia:** Como usuario, quiero registrarme con un correo único y validado para crear mi cuenta sin duplicados.
- **Estimación:** 4 horas.
- **Definition of Done (DoD):**
  - Formulario de registro funcional.
  - Clave encriptada en la base de datos (BCrypt).
  - Manejo de error claro (UNIQUE constraint) si el correo ya existe.
  - Rol por defecto asignado (ej. Cliente).

### 3. Inicio y Cierre de Sesión Seguro (Prioridad Alta)
- **Historia:** Como usuario registrado, quiero iniciar y cerrar sesión de forma segura para que el sistema me lleve al panel que corresponde a mi rol.
- **Estimación:** 5 horas.
- **Definition of Done (DoD):**
  - Autenticación validada contra la BD comparando hashes.
  - `HttpSession` guarda ID y Rol.
  - Filtro `AuthFilter` que impide entrar a `/panel/*` sin sesión.
  - Redirección post-login según el rol.
  - Opción de logout que invalida sesión.

### 4. Modelo de Datos y Conexión (Fundamental para Sprint 1)
- **Historia:** Requisito técnico y académico.
- **Estimación:** 6 horas.
- **Definition of Done (DoD):**
  - MER y modelo relacional 3FN documentado.
  - Diccionario de datos creado.
  - DDL y DML ejecutados con éxito.
  - Clase `ConexionDB` implementada usando patrón Singleton.
