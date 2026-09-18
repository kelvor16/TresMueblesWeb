CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE ciudad (
    id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    departamento VARCHAR(100) NOT NULL
);

CREATE TABLE tipo_propiedad (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE caracteristica (
    id_caracteristica INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(150) NOT NULL UNIQUE,
    clave VARCHAR(255) NOT NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo'
);

CREATE TABLE perfil (
    id_usuario INT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    documento VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    foto_url VARCHAR(255),
    CONSTRAINT fk_perfil_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE usuario_rol (
    id_usuario INT,
    id_rol INT,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_rol),
    CONSTRAINT fk_usurol_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usurol_rol FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE propiedad (
    id_propiedad INT AUTO_INCREMENT PRIMARY KEY,
    matricula_inmobiliaria VARCHAR(50) NOT NULL UNIQUE,
    id_tipo INT NOT NULL,
    id_ciudad INT NOT NULL,
    id_agente INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(15, 2) NOT NULL,
    area DECIMAL(8, 2) NOT NULL,
    habitaciones INT NOT NULL DEFAULT 0,
    banos INT NOT NULL DEFAULT 0,
    estado_publicacion ENUM('disponible', 'vendida', 'arrendada', 'inactiva') DEFAULT 'disponible',
    fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_propiedad_tipo FOREIGN KEY (id_tipo) REFERENCES tipo_propiedad(id_tipo) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_propiedad_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_propiedad_agente FOREIGN KEY (id_agente) REFERENCES usuario(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE imagen_propiedad (
    id_imagen INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    es_principal BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_imagen_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE propiedad_caracteristica (
    id_propiedad INT,
    id_caracteristica INT,
    PRIMARY KEY (id_propiedad, id_caracteristica),
    CONSTRAINT fk_propcar_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_propcar_caract FOREIGN KEY (id_caracteristica) REFERENCES caracteristica(id_caracteristica) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE cita (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    id_cliente INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    estado ENUM('programada', 'realizada', 'cancelada') DEFAULT 'programada',
    UNIQUE (id_propiedad, fecha_hora),
    CONSTRAINT fk_cita_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cita_cliente FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE solicitud (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    id_cliente INT NOT NULL,
    tipo ENUM('compra', 'arriendo') NOT NULL,
    estado ENUM('pendiente', 'aprobada', 'rechazada') DEFAULT 'pendiente',
    fecha_radicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_solicitud_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_solicitud_cliente FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE documento_solicitud (
    id_documento INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT NOT NULL,
    nombre_documento VARCHAR(100) NOT NULL,
    url_documento VARCHAR(255) NOT NULL,
    CONSTRAINT fk_doc_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitud(id_solicitud) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE favorito (
    id_favorito INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    id_cliente INT NOT NULL,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_propiedad, id_cliente),
    CONSTRAINT fk_favorito_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_favorito_cliente FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    accion VARCHAR(255) NOT NULL,
    modulo VARCHAR(100) NOT NULL,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_auditoria_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL ON UPDATE CASCADE
);
