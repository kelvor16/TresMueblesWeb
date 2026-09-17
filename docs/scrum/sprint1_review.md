# Sprint 1 Review - Cimientos y Acceso

**Proyecto:** Inmobiliaria Tres Muebles Web  
**Fecha de Cierre:** Fin del Sprint 1 (Día 7)  
**Asistentes:** Development Team, Scrum Master, Product Owner (Docente)  

---

## 1. Objetivo del Sprint
Establecer la arquitectura base del proyecto Java EE (JSP/Servlet), modelar y normalizar la base de datos relacional en 3FN, y habilitar el control de acceso seguro por roles con contraseñas encriptadas.

---

## 2. Demostración Funcional de Historias de Usuario

| Historia de Usuario | Estimación | Estado | Evidencia de Demostración Funcional |
|---|:---:|:---:|---|
| **H1. Landing Page Atractiva (Visitante)** | 3 h | **Completado (Done)** | Página pública `index.jsp` responsiva con Bootstrap, buscador rápido integrado, sección de publicaciones destacadas y accesos directos a Login y Registro. |
| **H2. Registro de Usuario Único** | 4 h | **Completado (Done)** | Formulario `registro.jsp` conectado a `AuthServlet`. Clave cifrada con BCrypt (salt dinámico). Control de error ante intento de correo duplicado (`UNIQUE`). |
| **H3. Inicio y Cierre de Sesión Seguro** | 5 h | **Completado (Done)** | Autenticación con verificación de hash en `UsuarioDAO`. Almacenamiento de usuario y roles en `HttpSession`. Redirección automática según el rol (Cliente, Inmobiliaria, Administrador). Inclusión del filtro `AuthFilter` para restringir `/panel/*`. |
| **H-Técnica. Modelo de Datos y Conexión** | 6 h | **Completado (Done)** | Scripts `ddl.sql` y `dml.sql` ejecutados en MySQL. Normalización en 3FN demostrada. Clase `ConexionDB` implementada mediante patrón Singleton. |

**Total Horas Estimadas:** 18 h | **Total Horas Reales:** 18 h  
**Velocidad del Sprint:** 100% de historias completadas conforme al DoD.

---

## 3. Feedback del Product Owner (Docente)
* El diseño de la landing page cumple con los criterios de responsividad y presentación comercial.
* Se validó positivamente que las contraseñas nunca se guarden en texto plano en la base de datos.
* Se aprobó el incremento funcional para dar paso al Sprint 2 (Gestión de Propiedades y Buscador).
