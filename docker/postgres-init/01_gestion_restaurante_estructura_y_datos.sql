-- =====================================================
-- SCRIPT: 01_gestion_restaurante_estructura_y_datos.sql
-- DESCRIPCIÓN: Estructura + Datos básicos (zonas y categorías)
-- =====================================================

-- =====================================================
-- 1. ZONAS
-- =====================================================
CREATE TABLE IF NOT EXISTS zonas (
    id_zona SERIAL PRIMARY KEY,
    codigo_zona VARCHAR(10) NOT NULL UNIQUE,
    nombre_zona VARCHAR(60) NOT NULL,
    descripcion TEXT,
    region VARCHAR(40),
    activo BOOLEAN DEFAULT TRUE
);

-- TRUNCATE en lugar de DROP
TRUNCATE TABLE zonas CASCADE;

-- INSERTAR ZONAS (10 registros)
INSERT INTO zonas (codigo_zona, nombre_zona, descripcion, region, activo)
VALUES
    ('ZON-001', 'Centro Historico', 'Zona centrica de la ciudad', 'Centro', TRUE),
    ('ZON-002', 'Zona Norte', 'Zona residencial y comercial del norte', 'Norte', TRUE),
    ('ZON-003', 'Zona Sur', 'Zona industrial y residencial del sur', 'Sur', TRUE),
    ('ZON-004', 'Valles', 'Valles cercanos a la ciudad', 'Valles', TRUE),
    ('ZON-005', 'Zona Occidental', 'Zona oeste de la ciudad', 'Occidente', TRUE),
    ('ZON-006', 'Zona Oriental', 'Zona este de la ciudad', 'Oriente', TRUE),
    ('ZON-007', 'Costanera', 'Zona cerca de la costa', 'Litoral', TRUE),
    ('ZON-008', 'Sierra Norte', 'Zona norte de la sierra', 'Sierra', TRUE),
    ('ZON-009', 'Sierra Centro', 'Zona centro de la sierra', 'Sierra', TRUE),
    ('ZON-010', 'Sierra Sur', 'Zona sur de la sierra', 'Sierra', TRUE);

-- =====================================================
-- 2. CATEGORIAS_INSUMOS
-- =====================================================
CREATE TABLE IF NOT EXISTS categorias_insumos (
    id_categoria SERIAL PRIMARY KEY,
    codigo_categoria VARCHAR(10) NOT NULL UNIQUE,
    nombre_categoria VARCHAR(40) NOT NULL,
    descripcion TEXT,
    requiere_refrigeracion BOOLEAN DEFAULT TRUE,
    temperatura_minima DECIMAL(4,1),
    temperatura_maxima DECIMAL(4,1)
);

TRUNCATE TABLE categorias_insumos CASCADE;

-- INSERTAR CATEGORIAS (15 registros)
INSERT INTO categorias_insumos (codigo_categoria, nombre_categoria, descripcion, requiere_refrigeracion, temperatura_minima, temperatura_maxima)
VALUES
    ('CAT-001', 'Carnes Rojas', 'Carnes de res, cerdo, cordero', TRUE, 0, 4),
    ('CAT-002', 'Aves', 'Pollos, pavos, patos', TRUE, 0, 4),
    ('CAT-003', 'Pescados', 'Pescados y mariscos', TRUE, -2, 2),
    ('CAT-004', 'Verduras', 'Verduras frescas', TRUE, 4, 8),
    ('CAT-005', 'Frutas', 'Frutas frescas', TRUE, 4, 8),
    ('CAT-006', 'Lacteos', 'Quesos, yogures, mantequilla', TRUE, 0, 4),
    ('CAT-007', 'Huevos', 'Huevos frescos', TRUE, 0, 4),
    ('CAT-008', 'Cereales', 'Arroz, trigo, maiz', FALSE, 15, 25),
    ('CAT-009', 'Legumbres', 'Frijoles, lentejas, garbanzos', FALSE, 15, 25),
    ('CAT-010', 'Especias', 'Condimentos y especias', FALSE, 15, 25),
    ('CAT-011', 'Aceites', 'Aceites y grasas', FALSE, 15, 25),
    ('CAT-012', 'Bebidas', 'Bebidas no alcoholicas', TRUE, 4, 8),
    ('CAT-013', 'Panaderia', 'Panes, pasteles, galletas', FALSE, 15, 25),
    ('CAT-014', 'Pastas', 'Pastas secas y frescas', FALSE, 15, 25),
    ('CAT-015', 'Conservas', 'Alimentos enlatados', FALSE, 15, 25);

-- =====================================================
-- 3. PROVEEDORES_OFICIALES
-- =====================================================
CREATE TABLE IF NOT EXISTS proveedores_oficiales (
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
-- 4. SUCURSALES_OFICIALES
-- =====================================================
CREATE TABLE IF NOT EXISTS sucursales_oficiales (
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
-- 5. METAS_ABASTECIMIENTO
-- =====================================================
CREATE TABLE IF NOT EXISTS metas_abastecimiento (
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
-- 6. EVALUACIONES_CALIDAD
-- =====================================================
CREATE TABLE IF NOT EXISTS evaluaciones_calidad (
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

-- =====================================================
-- MENSAJE DE CONFIRMACIÓN
-- =====================================================
DO $$
BEGIN
    RAISE NOTICE '✅ ESTRUCTURA CREADA';
    RAISE NOTICE '   - Zonas: %', (SELECT COUNT(*) FROM zonas);
    RAISE NOTICE '   - Categorias Insumos: %', (SELECT COUNT(*) FROM categorias_insumos);
END $$;