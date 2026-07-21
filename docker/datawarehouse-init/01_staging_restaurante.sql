-- =====================================================
-- SCRIPT: staging_tablas_dim_fact_audit.sql
-- DESCRIPCIÓN: Creación de tablas DIM, FACT y AUDITORÍA
-- ESQUEMA: staging y audit
-- =====================================================

SET client_encoding = 'UTF8';

-- =====================================================
-- 1. CREAR ESQUEMAS
-- =====================================================

DROP SCHEMA IF EXISTS staging CASCADE;
CREATE SCHEMA staging;

DROP SCHEMA IF EXISTS audit CASCADE;
CREATE SCHEMA audit;

-- =====================================================
-- 2. TABLAS DIM (Dimensiones)
-- =====================================================

-- =====================================================
-- 🟢 EXCEL (Archivos Excel)
-- =====================================================

-- 2.1 Excel_Compras
DROP TABLE IF EXISTS staging.Excel_Compras;
CREATE TABLE staging.Excel_Compras (
    id_compra VARCHAR(30),
    fecha_compra DATE,
    id_proveedor VARCHAR(30),
    nombre_proveedor VARCHAR(200),
    id_insumo VARCHAR(30),
    nombre_insumo VARCHAR(200),
    categoria_insumo VARCHAR(100),
    cantidad_comprada INTEGER,
    costo_unitario NUMERIC(14,4),
    descuento_porcentaje NUMERIC(8,4),
    valor_neto NUMERIC(14,2),
    id_sucursal VARCHAR(20),
    nombre_sucursal VARCHAR(150),
    estado_recepcion VARCHAR(30),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2.2 Excel_Proveedores
DROP TABLE IF EXISTS staging.Excel_Proveedores;
CREATE TABLE staging.Excel_Proveedores (
    id_proveedor VARCHAR(30),
    nombre_proveedor VARCHAR(200),
    ciudad VARCHAR(100),
    contacto_ventas VARCHAR(150),
    telefono VARCHAR(50),
    correo VARCHAR(200),
    condicion_pago VARCHAR(50),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2.3 Excel_Insumos
DROP TABLE IF EXISTS staging.Excel_Insumos;
CREATE TABLE staging.Excel_Insumos (
    id_insumo VARCHAR(30),
    nombre_insumo VARCHAR(200),
    categoria VARCHAR(100),
    tipo VARCHAR(50),
    unidad_medida VARCHAR(20),
    temperatura_requerida NUMERIC(8,2),
    vida_util_dias INTEGER,
    origen VARCHAR(60),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2.4 Excel_Sucursales
DROP TABLE IF EXISTS staging.Excel_Sucursales;
CREATE TABLE staging.Excel_Sucursales (
    id_sucursal VARCHAR(20),
    nombre_sucursal VARCHAR(150),
    zona VARCHAR(50),
    ciudad VARCHAR(100),
    direccion VARCHAR(250),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 🔵 MYSQL (Base de datos MySQL - puerto 3307)
-- =====================================================

-- 2.5 MySQL_Proveedores
DROP TABLE IF EXISTS staging.MySQL_Proveedores;
CREATE TABLE staging.MySQL_Proveedores (
    id_proveedor INTEGER,
    nombre_empresa VARCHAR(200),
    contacto_principal VARCHAR(150),
    telefono VARCHAR(50),
    email VARCHAR(200),
    ciudad VARCHAR(100),
    tipo_proveedor VARCHAR(10),
    calificacion_general NUMERIC(3,2),
    estado_registro VARCHAR(5),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2.6 MySQL_Sucursales
DROP TABLE IF EXISTS staging.MySQL_Sucursales;
CREATE TABLE staging.MySQL_Sucursales (
    id_sucursal INTEGER,
    codigo_sucursal VARCHAR(20),
    nombre_sucursal VARCHAR(150),
    ciudad VARCHAR(100),
    telefono VARCHAR(50),
    responsable VARCHAR(150),
    capacidad_almacenamiento INTEGER,
    fecha_apertura DATE,
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2.7 MySQL_Tipo_Insumo
DROP TABLE IF EXISTS staging.MySQL_Tipo_Insumo;
CREATE TABLE staging.MySQL_Tipo_Insumo (
    id_tipo INTEGER,
    nombre_tipo VARCHAR(100),
    categoria VARCHAR(50),
    temperatura_minima NUMERIC(8,2),
    temperatura_maxima NUMERIC(8,2),
    requiere_refrigeracion VARCHAR(5),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2.8 MySQL_Insumos
DROP TABLE IF EXISTS staging.MySQL_Insumos;
CREATE TABLE staging.MySQL_Insumos (
    id_insumo INTEGER,
    id_tipo INTEGER,
    nombre_insumo VARCHAR(150),
    unidad_medida VARCHAR(20),
    vida_util_dias INTEGER,
    origen VARCHAR(60),
    calidad_estandar VARCHAR(30),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 🟠 POSTGRESQL (Base de datos PostgreSQL - puerto 5444)
-- =====================================================

-- 2.9 PostGres_Zonas
DROP TABLE IF EXISTS staging.PostGres_Zonas;
CREATE TABLE staging.PostGres_Zonas (
    id_zona INTEGER,
    codigo_zona VARCHAR(20),
    nombre_zona VARCHAR(100),
    region VARCHAR(50),
    activo BOOLEAN,
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2.10 PostGres_Categorias_Insumos
DROP TABLE IF EXISTS staging.PostGres_Categorias_Insumos;
CREATE TABLE staging.PostGres_Categorias_Insumos (
    id_categoria INTEGER,
    codigo_categoria VARCHAR(20),
    nombre_categoria VARCHAR(100),
    requiere_refrigeracion BOOLEAN,
    temperatura_minima NUMERIC(8,2),
    temperatura_maxima NUMERIC(8,2),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2.11 PostGres_Proveedores_Oficiales
DROP TABLE IF EXISTS staging.PostGres_Proveedores_Oficiales;
CREATE TABLE staging.PostGres_Proveedores_Oficiales (
    id_proveedor INTEGER,
    codigo_proveedor VARCHAR(20),
    ruc VARCHAR(30),
    razon_social VARCHAR(200),
    nombre_comercial VARCHAR(150),
    ciudad VARCHAR(100),
    calificacion_promedio NUMERIC(3,2),
    estado VARCHAR(20),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2.12 PostGres_Sucursales_Oficiales
DROP TABLE IF EXISTS staging.PostGres_Sucursales_Oficiales;
CREATE TABLE staging.PostGres_Sucursales_Oficiales (
    id_sucursal INTEGER,
    codigo_sucursal VARCHAR(20),
    nombre_oficial VARCHAR(150),
    nombre_comercial VARCHAR(150),
    ciudad VARCHAR(100),
    telefono VARCHAR(50),
    responsable VARCHAR(150),
    fecha_apertura DATE,
    estado VARCHAR(20),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 3. TABLAS FACT (Hechos)
-- =====================================================

-- =====================================================
-- 🟢 EXCEL (Archivos Excel)
-- =====================================================

-- 3.1 Excel_Resumen_Mensual
DROP TABLE IF EXISTS staging.Excel_Resumen_Mensual;
CREATE TABLE staging.Excel_Resumen_Mensual (
    anio INTEGER,
    mes INTEGER,
    compras INTEGER,
    unidades NUMERIC(14,2),
    valor_neto NUMERIC(14,2),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 🔵 MYSQL (Base de datos MySQL - puerto 3307)
-- =====================================================

-- 3.2 MySQL_Entregas
DROP TABLE IF EXISTS staging.MySQL_Entregas;
CREATE TABLE staging.MySQL_Entregas (
    id_entrega INTEGER,
    id_proveedor INTEGER,
    id_sucursal INTEGER,
    fecha_pedido DATE,
    fecha_entrega_programada DATE,
    fecha_entrega_real DATE,
    tipo_entrega VARCHAR(30),
    prioridad VARCHAR(20),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3.3 MySQL_Detalle_Entregas
DROP TABLE IF EXISTS staging.MySQL_Detalle_Entregas;
CREATE TABLE staging.MySQL_Detalle_Entregas (
    id_detalle INTEGER,
    id_entrega INTEGER,
    id_insumo INTEGER,
    cantidad_solicitada NUMERIC(14,2),
    cantidad_recibida NUMERIC(14,2),
    precio_unitario NUMERIC(14,4),
    subtotal NUMERIC(14,2),
    estado_calidad VARCHAR(30),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3.4 MySQL_Control_Recepcion
DROP TABLE IF EXISTS staging.MySQL_Control_Recepcion;
CREATE TABLE staging.MySQL_Control_Recepcion (
    id_control INTEGER,
    id_entrega INTEGER,
    id_proveedor INTEGER,
    id_sucursal INTEGER,
    fecha_recepcion DATE,
    temperatura_producto NUMERIC(8,2),
    temperatura_esperada NUMERIC(8,2),
    cumple_refrigeracion VARCHAR(5),
    distancia_recorrida NUMERIC(10,2),
    tiempo_transporte NUMERIC(8,2),
    cumple_plazo VARCHAR(5),
    minutos_retraso INTEGER,
    calificacion_control NUMERIC(3,2),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 🟠 POSTGRESQL (Base de datos PostgreSQL - puerto 5444)
-- =====================================================

-- 3.5 PostGres_Metas_Abastecimiento
DROP TABLE IF EXISTS staging.PostGres_Metas_Abastecimiento;
CREATE TABLE staging.PostGres_Metas_Abastecimiento (
    id_meta INTEGER,
    id_proveedor INTEGER,
    id_sucursal INTEGER,
    anio INTEGER,
    mes INTEGER,
    meta_kg NUMERIC(14,2),
    meta_pedidos INTEGER,
    calidad_objetivo NUMERIC(3,2),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3.6 PostGres_Evaluaciones_Calidad
DROP TABLE IF EXISTS staging.PostGres_Evaluaciones_Calidad;
CREATE TABLE staging.PostGres_Evaluaciones_Calidad (
    id_evaluacion INTEGER,
    id_proveedor INTEGER,
    id_sucursal INTEGER,
    fecha_evaluacion DATE,
    calidad_general INTEGER,
    temperatura_cumple BOOLEAN,
    tiempo_cumple BOOLEAN,
    calidad_carnes INTEGER,
    calidad_verduras INTEGER,
    calidad_pollos INTEGER,
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 4. AUDITORÍA (con nombres ETL)
-- =====================================================

-- 4.1 etl_rechazo
DROP TABLE IF EXISTS audit.etl_rechazo;
CREATE TABLE audit.etl_rechazo (
    id_rechazo BIGSERIAL PRIMARY KEY,
    fuente VARCHAR(80),
    entidad VARCHAR(80),
    clave_origen VARCHAR(150),
    tipo_error VARCHAR(80),
    descripcion_error TEXT,
    registro_json JSONB,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4.2 etl_control
DROP TABLE IF EXISTS audit.etl_control;
CREATE TABLE audit.etl_control (
    id_control BIGSERIAL PRIMARY KEY,
    proceso VARCHAR(80),
    etapa VARCHAR(80),
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    registros_leidos INTEGER DEFAULT 0,
    registros_insertados INTEGER DEFAULT 0,
    registros_rechazados INTEGER DEFAULT 0,
    estado VARCHAR(30) DEFAULT 'INICIADO',
    mensaje TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4.3 etl_log
DROP TABLE IF EXISTS audit.etl_log;
CREATE TABLE audit.etl_log (
    id_log BIGSERIAL PRIMARY KEY,
    id_control INTEGER,
    paso VARCHAR(80),
    mensaje TEXT,
    nivel VARCHAR(20) DEFAULT 'INFO',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 5. ÍNDICES PARA AUDITORÍA
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_etl_rechazo_fuente ON audit.etl_rechazo(fuente);
CREATE INDEX IF NOT EXISTS idx_etl_rechazo_entidad ON audit.etl_rechazo(entidad);
CREATE INDEX IF NOT EXISTS idx_etl_rechazo_fecha ON audit.etl_rechazo(fecha_registro);

CREATE INDEX IF NOT EXISTS idx_etl_control_proceso ON audit.etl_control(proceso);
CREATE INDEX IF NOT EXISTS idx_etl_control_estado ON audit.etl_control(estado);

CREATE INDEX IF NOT EXISTS idx_etl_log_control ON audit.etl_log(id_control);

-- =====================================================
-- 6. MENSAJE DE CONFIRMACIÓN
-- =====================================================

DO $$
DECLARE
    total_staging INTEGER;
    total_audit INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_staging 
    FROM information_schema.tables 
    WHERE table_schema = 'staging';
    
    SELECT COUNT(*) INTO total_audit 
    FROM information_schema.tables 
    WHERE table_schema = 'audit';
    
    RAISE NOTICE '✅ Tablas creadas exitosamente!';
    RAISE NOTICE '📊 Resumen:';
    RAISE NOTICE '   - EXCEL: 5';
    RAISE NOTICE '   - MYSQL: 7';
    RAISE NOTICE '   - POSTGRESQL: 6';
    RAISE NOTICE '   - AUDIT (ETL): 3';
    RAISE NOTICE '   - TOTAL: % tablas', total_staging + total_audit;
    RAISE NOTICE ' ';
    RAISE NOTICE '📋 Tablas de auditoría:';
    RAISE NOTICE '   - etl_rechazo (registro de errores)';
    RAISE NOTICE '   - etl_control (control de ejecución)';
    RAISE NOTICE '   - etl_log (bitácora de eventos)';
END $$;