# Sprint 3 Retrospective - Operación y Cierre

**Proyecto:** Inmobiliaria Tres Muebles Web  
**Fecha:** Cierre del Sprint 3 y Cierre del Proyecto  
**Participantes:** Scrum Master y Equipo de Desarrollo  

---

## 1. Evaluación Global del Proyecto en los Tres Sprints

### Puntos Fuertes Destacados (Success Factors)
1. **Adherencia Rigurosa al Alcance:** Se cubrieron todas y cada una de las 13 historias de usuario priorizadas del Product Backlog original sin dejar ninguna funcionalidad por fuera.
2. **Arquitectura Limpia y Mantenible:** La separación en capas (Controladores Servlet, Acceso a Datos DAO, Modelos POJO y Vistas JSP/JSPF) facilitó la incorporación incremental de módulos sin romper código previo.
3. **Manejo Seguro de Sesiones y Datos:** El uso de `HttpSession`, control de acceso en `AuthFilter`, cifrado no reversible con BCrypt y consultas parametrizadas con `PreparedStatement` garantizan que no existan vulnerabilidades de inyección SQL ni accesos indebidos.
4. **Respaldo Documental Completo:** Se cuenta con el MER y modelo relacional normalizado hasta 3FN, diccionario de datos, las 5 consultas avanzadas documentadas y la memoria de los 3 sprints en formato Scrum.

### Principales Desafíos Superados
* **Coordinación de Nombres de Roles:** La sincronización entre la definición de roles en base de datos (`Administrador`) y las llamadas lógicas en servlets se resolvió centralizadamente en `Usuario.hasRol()`.
* **Cruce de Horarios en Citas:** Se aprovechó la restricción `UNIQUE (id_propiedad, fecha_hora)` a nivel de motor de base de datos capturando la `SQLException` en el Servlet para brindar una experiencia de usuario clara y sin colisiones de agenda.

---

## 2. Conclusiones y Preparación para la Sustentación
* El equipo domina con precisión la estructura relacional, la justificación de las relaciones 1:1, 1:N y N:M, así como las consultas con `JOIN` y funciones de agregación.
* El software se encuentra desplegado y operativo en servidor Tomcat local listo para demostración en vivo.
* Proyecto finalizado con éxito para evaluación final (100% de cumplimiento).
