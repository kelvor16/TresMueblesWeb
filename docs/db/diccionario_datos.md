# Diccionario de Datos - Inmobiliaria_db

## Tabla `usuario`
Guarda las credenciales y el estado de la cuenta.
| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| `id_usuario` | INT | PK, AUTO_INCREMENT | Identificador único del usuario. |
| `correo` | VARCHAR(150) | NOT NULL, UNIQUE | Correo electrónico usado para login. Debe ser único. |
| `clave` | VARCHAR(255) | NOT NULL | Contraseña encriptada (ej. con BCrypt). |
| `estado` | ENUM | DEFAULT 'activo' | Estado de la cuenta (activo, inactivo). |

## Tabla `perfil`
Datos personales del usuario. Relación 1:1 con `usuario`.
| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| `id_usuario` | INT | PK, FK, UNIQUE | Llave primaria y foránea hacia `usuario`. UNIQUE asegura 1:1. ON DELETE CASCADE, ON UPDATE CASCADE. |
| `nombres` | VARCHAR(100) | NOT NULL | Nombres del usuario. |
| `apellidos` | VARCHAR(100) | NOT NULL | Apellidos del usuario. |
| `documento` | VARCHAR(20) | NOT NULL, UNIQUE | Documento de identidad. |
| `telefono` | VARCHAR(20) | | Teléfono de contacto. |
| `direccion` | VARCHAR(200)| | Dirección de residencia. |
| `foto_url` | VARCHAR(255)| | URL de la foto de perfil. |

## Tabla `rol`
Roles disponibles en el sistema.
| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| `id_rol` | INT | PK, AUTO_INCREMENT | Identificador único del rol. |
| `nombre` | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del rol (Visitante, Cliente, Inmobiliaria, Administrador). |

## Tabla `usuario_rol`
Tabla intermedia N:M entre `usuario` y `rol`.
| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| `id_usuario` | INT | PK (Compuesta), FK | Referencia a `usuario`. ON DELETE CASCADE, ON UPDATE CASCADE. |
| `id_rol` | INT | PK (Compuesta), FK | Referencia a `rol`. ON DELETE CASCADE, ON UPDATE CASCADE. |
| `fecha_asignacion` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha en que se asignó el rol al usuario. |

## Tabla `propiedad`
Información principal de los inmuebles.
| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| `id_propiedad` | INT | PK, AUTO_INCREMENT | Identificador único de la propiedad. |
| `matricula_inmobiliaria`| VARCHAR(50)| NOT NULL, UNIQUE | Identificador legal irrepetible del inmueble. |
| `id_tipo` | INT | FK, NOT NULL | Tipo de inmueble. ON DELETE RESTRICT (no borrar si hay propiedades). |
| `id_ciudad` | INT | FK, NOT NULL | Ciudad donde se ubica. ON DELETE RESTRICT. |
| `id_agente` | INT | FK, NOT NULL | Agente que la publicó. ON DELETE RESTRICT. |
| `titulo` | VARCHAR(150)| NOT NULL | Título de la publicación. |
| `descripcion` | TEXT | | Descripción detallada. |
| `precio` | DECIMAL(15,2)| NOT NULL | Precio de venta o arriendo. |
| `area` | DECIMAL(8,2)| NOT NULL | Área en metros cuadrados. |
| `habitaciones` | INT | NOT NULL, DEFAULT 0 | Número de habitaciones. |
| `banos` | INT | NOT NULL, DEFAULT 0 | Número de baños. |
| `estado_publicacion` | ENUM | DEFAULT 'disponible' | Estado (disponible, vendida, arrendada, inactiva - baja lógica). |

*(Continúa con el resto de tablas como `cita`, `solicitud`, `favorito` detalladas en el script DDL)*
