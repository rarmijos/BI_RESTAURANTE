USE restaurante_db;

-- =====================================================
-- TABLA 1: PROVEEDORES (150 registros)
-- =====================================================
DROP TABLE IF EXISTS proveedores;

CREATE TABLE proveedores (
    id_proveedor INT NOT NULL,
    nombre_empresa VARCHAR(100) NOT NULL,
    contacto_principal VARCHAR(80),
    telefono VARCHAR(20),
    email VARCHAR(80),
    direccion VARCHAR(150),
    ciudad VARCHAR(60),
    pais VARCHAR(50),
    tipo_proveedor CHAR(2) NOT NULL DEFAULT 'CA',
    fecha_registro DATE,
    calificacion_general DECIMAL(3,2) DEFAULT 0.00,
    estado_registro CHAR(1) DEFAULT 'A',
    observaciones VARCHAR(250),
    PRIMARY KEY (id_proveedor)
);

-- =====================================================
-- TABLA 2: TIPO_INSUMO (50 registros)
-- =====================================================
DROP TABLE IF EXISTS tipo_insumo;

CREATE TABLE tipo_insumo (
    id_tipo INT NOT NULL,
    nombre_tipo VARCHAR(60) NOT NULL,
    categoria VARCHAR(40),
    descripcion TEXT,
    temperatura_minima DECIMAL(4,1),
    temperatura_maxima DECIMAL(4,1),
    requiere_refrigeracion CHAR(1) DEFAULT 'S',
    PRIMARY KEY (id_tipo)
);

-- =====================================================
-- TABLA 3: INSUMOS (300 registros)
-- =====================================================
DROP TABLE IF EXISTS insumos;

CREATE TABLE insumos (
    id_insumo INT NOT NULL,
    id_tipo INT,
    nombre_insumo VARCHAR(80) NOT NULL,
    nombre_cientifico VARCHAR(80),
    variedad VARCHAR(50),
    unidad_medida VARCHAR(20) DEFAULT 'Kg',
    peso_aproximado DECIMAL(8,2),
    vida_util_dias INT,
    temporada VARCHAR(30),
    origen VARCHAR(60),
    calidad_estandar VARCHAR(20),
    PRIMARY KEY (id_insumo),
    FOREIGN KEY (id_tipo) REFERENCES tipo_insumo(id_tipo)
);

-- =====================================================
-- TABLA 4: SUCURSALES (200 registros)
-- =====================================================
DROP TABLE IF EXISTS sucursales;

CREATE TABLE sucursales (
    id_sucursal INT NOT NULL,
    codigo_sucursal VARCHAR(20),
    nombre_sucursal VARCHAR(80) NOT NULL,
    direccion VARCHAR(150),
    ciudad VARCHAR(60),
    estado VARCHAR(40),
    telefono VARCHAR(20),
    responsable VARCHAR(80),
    capacidad_almacenamiento INT,
    fecha_apertura DATE,
    horario_atencion VARCHAR(100),
    PRIMARY KEY (id_sucursal)
);

-- =====================================================
-- TABLA 5: ENTREGAS (500 registros)
-- =====================================================
DROP TABLE IF EXISTS entregas;

CREATE TABLE entregas (
    id_entrega INT NOT NULL,
    id_proveedor INT,
    id_sucursal INT,
    fecha_pedido DATE NOT NULL,
    fecha_entrega_programada DATE,
    fecha_entrega_real DATE,
    tipo_entrega VARCHAR(30) DEFAULT 'Ordinaria',
    prioridad VARCHAR(20) DEFAULT 'Media',
    numero_guia VARCHAR(30),
    transportista VARCHAR(60),
    observaciones TEXT,
    PRIMARY KEY (id_entrega),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal)
);

-- =====================================================
-- TABLA 6: DETALLE_ENTREGA (500 registros)
-- =====================================================
DROP TABLE IF EXISTS detalle_entrega;

CREATE TABLE detalle_entrega (
    id_detalle INT NOT NULL,
    id_entrega INT,
    id_insumo INT,
    cantidad_solicitada DECIMAL(10,2),
    cantidad_recibida DECIMAL(10,2),
    precio_unitario DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    estado_calidad VARCHAR(25),
    lote VARCHAR(30),
    fecha_caducidad DATE,
    observaciones VARCHAR(250),
    PRIMARY KEY (id_detalle),
    FOREIGN KEY (id_entrega) REFERENCES entregas(id_entrega),
    FOREIGN KEY (id_insumo) REFERENCES insumos(id_insumo)
);

-- =====================================================
-- TABLA 7: CONTROL_RECEPCION (300 registros)
-- =====================================================
DROP TABLE IF EXISTS control_recepcion;

CREATE TABLE control_recepcion (
    id_control INT NOT NULL,
    id_entrega INT,
    id_proveedor INT,
    id_sucursal INT,
    fecha_recepcion DATE,
    hora_llegada TIME,
    temperatura_ambiente DECIMAL(4,1),
    temperatura_producto DECIMAL(4,1),
    temperatura_esperada DECIMAL(4,1),
    cumple_refrigeracion CHAR(1),
    humedad_relativa DECIMAL(5,2),
    estado_empaque VARCHAR(30),
    condiciones_vehiculo VARCHAR(30),
    distancia_recorrida DECIMAL(8,2),
    tiempo_transporte DECIMAL(6,2),
    tiempo_descarga DECIMAL(6,2),
    cumple_plazo CHAR(1),
    minutos_retraso INT DEFAULT 0,
    inspector VARCHAR(80),
    calificacion_control DECIMAL(3,2),
    observaciones TEXT,
    PRIMARY KEY (id_control),
    FOREIGN KEY (id_entrega) REFERENCES entregas(id_entrega),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal)
);

-- =====================================================
-- ÍNDICES PARA MEJOR RENDIMIENTO
-- =====================================================
CREATE INDEX idx_proveedor_ciudad ON proveedores(ciudad);
CREATE INDEX idx_proveedor_nombre ON proveedores(nombre_empresa);
CREATE INDEX idx_sucursal_ciudad ON sucursales(ciudad);
CREATE INDEX idx_sucursal_nombre ON sucursales(nombre_sucursal);
CREATE INDEX idx_insumo_nombre ON insumos(nombre_insumo);
CREATE INDEX idx_entrega_fecha ON entregas(fecha_pedido);
CREATE INDEX idx_entrega_proveedor ON entregas(id_proveedor);
CREATE INDEX idx_control_fecha ON control_recepcion(fecha_recepcion);
CREATE INDEX idx_control_proveedor ON control_recepcion(id_proveedor);