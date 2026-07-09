
-- =====================================================
-- TABLA 1: ZONAS
-- =====================================================
DROP TABLE IF EXISTS zonas CASCADE;

CREATE TABLE zonas (
    id_zona SERIAL PRIMARY KEY,
    codigo_zona VARCHAR(10) NOT NULL UNIQUE,
    nombre_zona VARCHAR(60) NOT NULL,
    descripcion TEXT,
    region VARCHAR(40),
    activo BOOLEAN DEFAULT TRUE
);

-- =====================================================
-- TABLA 2: CATEGORIAS_INSUMOS
-- =====================================================
DROP TABLE IF EXISTS categorias_insumos CASCADE;

CREATE TABLE categorias_insumos (
    id_categoria SERIAL PRIMARY KEY,
    codigo_categoria VARCHAR(10) NOT NULL UNIQUE,
    nombre_categoria VARCHAR(40) NOT NULL,
    descripcion TEXT,
    requiere_refrigeracion BOOLEAN DEFAULT TRUE,
    temperatura_minima DECIMAL(4,1),
    temperatura_maxima DECIMAL(4,1)
);

-- =====================================================
-- TABLA 3: PROVEEDORES_OFICIALES
-- =====================================================
DROP TABLE IF EXISTS proveedores_oficiales CASCADE;

CREATE TABLE proveedores_oficiales (
    id_proveedor SERIAL PRIMARY KEY,
    codigo_proveedor VARCHAR(10) NOT NULL UNIQUE,
    ruc VARCHAR(20) NOT NULL,
    razon_social VARCHAR(100) NOT NULL,
    nombre_comercial VARCHAR(80),
    contacto_principal VARCHAR(80),
    email_contacto VARCHAR(80),
    telefono VARCHAR(20),
    direccion VARCHAR(150),
    ciudad VARCHAR(60),
    id_zona INT REFERENCES zonas(id_zona),
    id_categoria INT REFERENCES categorias_insumos(id_categoria),
    fecha_registro DATE,
    calificacion_promedio DECIMAL(3,2),
    estado VARCHAR(20) DEFAULT 'Activo'
);

-- =====================================================
-- TABLA 4: SUCURSALES_OFICIALES
-- =====================================================
DROP TABLE IF EXISTS sucursales_oficiales CASCADE;

CREATE TABLE sucursales_oficiales (
    id_sucursal SERIAL PRIMARY KEY,
    codigo_sucursal VARCHAR(10) NOT NULL UNIQUE,
    nombre_oficial VARCHAR(80) NOT NULL,
    nombre_comercial VARCHAR(80),
    id_zona INT REFERENCES zonas(id_zona),
    direccion VARCHAR(150),
    ciudad VARCHAR(60),
    telefono VARCHAR(20),
    capacidad_almacenamiento INT,
    responsable VARCHAR(80),
    fecha_apertura DATE,
    estado VARCHAR(20) DEFAULT 'Activo'
);

-- =====================================================
-- TABLA 5: METAS_ABASTECIMIENTO
-- =====================================================
DROP TABLE IF EXISTS metas_abastecimiento CASCADE;

CREATE TABLE metas_abastecimiento (
    id_meta SERIAL PRIMARY KEY,
    id_proveedor INT REFERENCES proveedores_oficiales(id_proveedor),
    id_sucursal INT REFERENCES sucursales_oficiales(id_sucursal),
    anio INT NOT NULL,
    mes INT NOT NULL CHECK (mes BETWEEN 1 AND 12),
    meta_kg DECIMAL(10,2),
    meta_pedidos INT,
    calidad_objetivo DECIMAL(3,2),
    cumplimiento_refrigeracion_objetivo DECIMAL(5,2),
    puntualidad_objetivo DECIMAL(5,2),
    CONSTRAINT unique_meta_proveedor_mes UNIQUE (id_proveedor, id_sucursal, anio, mes)
);

-- =====================================================
-- TABLA 6: EVALUACIONES_CALIDAD
-- =====================================================
DROP TABLE IF EXISTS evaluaciones_calidad CASCADE;

CREATE TABLE evaluaciones_calidad (
    id_evaluacion SERIAL PRIMARY KEY,
    id_proveedor INT REFERENCES proveedores_oficiales(id_proveedor),
    id_sucursal INT REFERENCES sucursales_oficiales(id_sucursal),
    fecha_evaluacion DATE NOT NULL,
    calidad_general INT CHECK (calidad_general BETWEEN 1 AND 5),
    temperatura_cumple BOOLEAN,
    tiempo_cumple BOOLEAN,
    calidad_carnes INT CHECK (calidad_carnes BETWEEN 1 AND 5),
    calidad_verduras INT CHECK (calidad_verduras BETWEEN 1 AND 5),
    calidad_pollos INT CHECK (calidad_pollos BETWEEN 1 AND 5),
    observaciones TEXT,
    evaluador VARCHAR(80)
);