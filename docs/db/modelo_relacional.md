# Modelo Relacional y Entidad-Relación (MER)

## Modelo Relacional en 3FN

El modelo cumple con la Tercera Forma Normal (3FN):
1. **1FN:** No hay grupos repetidos. Los atributos multivaluados (ej. características de propiedad, roles múltiples, imágenes) se separaron en las tablas `propiedad_caracteristica`, `usuario_rol` e `imagen_propiedad`.
2. **2FN:** Todas las tablas con llaves compuestas (`usuario_rol`, `propiedad_caracteristica`) dependen completamente de la llave compuesta, sin dependencias parciales.
3. **3FN:** No existen dependencias transitivas. Por ejemplo, el nombre de la ciudad o del tipo de propiedad no están en la tabla `propiedad`, sino en catálogos separados referenciados por FK.

### Diagrama MER (Mermaid)

```mermaid
erDiagram
    USUARIO ||--|| PERFIL : "tiene (1:1)"
    USUARIO ||--o{ USUARIO_ROL : "posee (1:N)"
    ROL ||--o{ USUARIO_ROL : "es asignado a (1:N)"
    
    USUARIO ||--o{ PROPIEDAD : "publica como agente (1:N)"
    CIUDAD ||--o{ PROPIEDAD : "ubica (1:N)"
    TIPO_PROPIEDAD ||--o{ PROPIEDAD : "clasifica (1:N)"
    
    PROPIEDAD ||--o{ IMAGEN_PROPIEDAD : "contiene (1:N)"
    
    PROPIEDAD ||--o{ PROPIEDAD_CARACTERISTICA : "posee (1:N)"
    CARACTERISTICA ||--o{ PROPIEDAD_CARACTERISTICA : "aplica a (1:N)"
    
    USUARIO ||--o{ CITA : "agenda como cliente (1:N)"
    PROPIEDAD ||--o{ CITA : "es visitada en (1:N)"
    
    USUARIO ||--o{ SOLICITUD : "radica (1:N)"
    PROPIEDAD ||--o{ SOLICITUD : "es objeto de (1:N)"
    
    SOLICITUD ||--o{ DOCUMENTO_SOLICITUD : "incluye (1:N)"
    
    USUARIO ||--o{ FAVORITO : "marca (1:N)"
    PROPIEDAD ||--o{ FAVORITO : "es marcada (1:N)"
```
