-- =====================================================
-- SCRIPT: 01_staging_restaurante.sql
-- DESCRIPCIÓN: Creación de tablas STAGING para RESTAURANTES
-- ESQUEMA: staging (el que ya tienes)
-- =====================================================

SET client_encoding = 'UTF8';

-- =====================================================
-- 1. STAGING EXCEL - COMPRAS
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.excel_compras (
    id_compra VARCHAR(30),
    fecha_compra DATE,
    orden_compra VARCHAR(50),
    factura_distribuidor VARCHAR(50),
    codigo_distribuidor VARCHAR(30),
    distribuidor VARCHAR(200),
    contacto_ventas VARCHAR(150),
    telefono_contacto VARCHAR(50),
    correo_contacto VARCHAR(200),
    codigo_insumo VARCHAR(30),
    insumo VARCHAR(200),
    categoria VARCHAR(100),
    presentacion VARCHAR(150),
    lote VARCHAR(50),
    fecha_vencimiento DATE,
    cantidad_comprada INTEGER,
    costo_unitario_lista NUMERIC(14,4),
    descuento_pct NUMERIC(8,4),
    costo_unitario_descuento NUMERIC(14,4),
    subtotal_bruto NUMERIC(14,2),
    valor_descuento NUMERIC(14,2),
    valor_neto NUMERIC(14,2),
    codigo_sucursal_entrega VARCHAR(20),
    sucursal_entrega VARCHAR(150),
    bodega_entrega VARCHAR(100),
    fecha_estimada_entrega DATE,
    estado_recepcion VARCHAR(30),
    observacion TEXT,
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 2. STAGING EXCEL - DISTRIBUIDORES
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.excel_distribuidores (
    codigo_distribuidor VARCHAR(30),
    nombre_distribuidor VARCHAR(200),
    ruc VARCHAR(30),
    ciudad VARCHAR(100),
    contacto_ventas VARCHAR(150),
    telefono_contacto VARCHAR(50),
    correo_contacto VARCHAR(200),
    condicion_pago VARCHAR(50),
    descuento_base_pct NUMERIC(8,4),
    dias_entrega_promedio INTEGER,
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 3. STAGING EXCEL - INSUMOS
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.excel_insumos (
    codigo_insumo VARCHAR(30),
    nombre_insumo VARCHAR(200),
    categoria VARCHAR(100),
    tipo VARCHAR(50),
    unidad_medida VARCHAR(20),
    temperatura_requerida NUMERIC(8,2),
    vida_util_dias INTEGER,
    origen VARCHAR(60),
    calidad_estandar VARCHAR(30),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 4. STAGING EXCEL - PUNTOS_ENTREGA
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.excel_puntos_entrega (
    codigo_sucursal VARCHAR(20),
    nombre_sucursal VARCHAR(150),
    zona VARCHAR(50),
    ciudad VARCHAR(100),
    direccion VARCHAR(250),
    bodega_principal VARCHAR(100),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 5. STAGING EXCEL - RESUMEN_MENSUAL
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.excel_resumen_mensual (
    anio INTEGER,
    mes INTEGER,
    compras INTEGER,
    unidades NUMERIC(14,2),
    valor_neto NUMERIC(14,2),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 6. STAGING MYSQL - PROVEEDORES
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.mysql_proveedores (
    id_proveedor INTEGER,
    nombre_empresa VARCHAR(200),
    contacto_principal VARCHAR(150),
    telefono VARCHAR(50),
    email VARCHAR(200),
    ciudad VARCHAR(100),
    pais VARCHAR(50),
    tipo_proveedor VARCHAR(10),
    calificacion_general NUMERIC(3,2),
    estado_registro VARCHAR(5),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 7. STAGING MYSQL - SUCURSALES
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.mysql_sucursales (
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

-- =====================================================
-- 8. STAGING MYSQL - TIPO_INSUMO
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.mysql_tipo_insumo (
    id_tipo INTEGER,
    nombre_tipo VARCHAR(100),
    categoria VARCHAR(50),
    temperatura_minima NUMERIC(8,2),
    temperatura_maxima NUMERIC(8,2),
    requiere_refrigeracion VARCHAR(5),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 9. STAGING MYSQL - INSUMOS
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.mysql_insumos (
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
-- 10. STAGING MYSQL - ENTREGAS
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.mysql_entregas (
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

-- =====================================================
-- 11. STAGING MYSQL - DETALLE_ENTREGA
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.mysql_detalle_entrega (
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

-- =====================================================
-- 12. STAGING MYSQL - CONTROL_RECEPCION
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.mysql_control_recepcion (
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
-- 13. STAGING POSTGRESQL - ZONAS
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.pg_zonas (
    id_zona INTEGER,
    codigo_zona VARCHAR(20),
    nombre_zona VARCHAR(100),
    region VARCHAR(50),
    activo BOOLEAN,
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 14. STAGING POSTGRESQL - CATEGORIAS_INSUMOS
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.pg_categorias_insumos (
    id_categoria INTEGER,
    codigo_categoria VARCHAR(20),
    nombre_categoria VARCHAR(100),
    requiere_refrigeracion BOOLEAN,
    temperatura_minima NUMERIC(8,2),
    temperatura_maxima NUMERIC(8,2),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 15. STAGING POSTGRESQL - PROVEEDORES_OFICIALES
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.pg_proveedores_oficiales (
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

-- =====================================================
-- 16. STAGING POSTGRESQL - SUCURSALES_OFICIALES
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.pg_sucursales_oficiales (
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
-- 17. STAGING POSTGRESQL - METAS_ABASTECIMIENTO
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.pg_metas_abastecimiento (
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

-- =====================================================
-- 18. STAGING POSTGRESQL - EVALUACIONES_CALIDAD
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.pg_evaluaciones_calidad (
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
-- 19. STAGING - DIMENSIONES PARA BI
-- =====================================================

CREATE TABLE IF NOT EXISTS staging.dim_compras (
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

CREATE TABLE IF NOT EXISTS staging.dim_proveedores (
    id_proveedor VARCHAR(30),
    nombre_proveedor VARCHAR(200),
    ciudad VARCHAR(100),
    contacto_ventas VARCHAR(150),
    telefono VARCHAR(50),
    correo VARCHAR(200),
    condicion_pago VARCHAR(50),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS staging.dim_insumos (
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

CREATE TABLE IF NOT EXISTS staging.dim_sucursales (
    id_sucursal VARCHAR(20),
    nombre_sucursal VARCHAR(150),
    zona VARCHAR(50),
    ciudad VARCHAR(100),
    direccion VARCHAR(250),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS staging.fact_resumen_mensual (
    anio INTEGER,
    mes INTEGER,
    compras INTEGER,
    unidades NUMERIC(14,2),
    valor_neto NUMERIC(14,2),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 20. AUDITORÍA
-- =====================================================

CREATE SCHEMA IF NOT EXISTS audit;

CREATE TABLE IF NOT EXISTS audit.etl_rechazo (
    id_rechazo BIGSERIAL PRIMARY KEY,
    fuente VARCHAR(80),
    entidad VARCHAR(80),
    clave_origen VARCHAR(150),
    tipo_error VARCHAR(80),
    descripcion_error TEXT,
    registro_json JSONB,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS audit.etl_control (
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

-- =====================================================
-- MENSAJE DE CONFIRMACIÓN
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE '✅ Tablas creadas exitosamente en el esquema staging!';
    RAISE NOTICE '📊 Total de tablas: 24';
END $$;