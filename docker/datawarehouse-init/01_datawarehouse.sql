CREATE SCHEMA IF NOT EXISTS dw;

SET search_path TO dw;

---------------------------------------------------
-- DIMENSION PROVEEDOR
---------------------------------------------------

CREATE TABLE dim_proveedor (
    id_proveedor INTEGER PRIMARY KEY,
    codigo_proveedor VARCHAR(50),
    razon_social VARCHAR(150),
    ciudad VARCHAR(100),
    zona VARCHAR(100),
    categoria VARCHAR(100),
    estado VARCHAR(50)
);

---------------------------------------------------
-- DIMENSION SUCURSAL
---------------------------------------------------

CREATE TABLE dim_sucursal (
    id_sucursal INTEGER PRIMARY KEY,
    codigo_sucursal VARCHAR(50),
    nombre_sucursal VARCHAR(150),
    ciudad VARCHAR(100),
    zona VARCHAR(100),
    responsable VARCHAR(150)
);

---------------------------------------------------
-- DIMENSION INSUMO
---------------------------------------------------

CREATE TABLE dim_insumo (
    id_insumo INTEGER PRIMARY KEY,
    nombre_insumo VARCHAR(150),
    tipo_insumo VARCHAR(100),
    categoria VARCHAR(100),
    requiere_refrigeracion BOOLEAN
);

---------------------------------------------------
-- DIMENSION FECHA
---------------------------------------------------

CREATE TABLE dim_fecha (
    id_fecha SERIAL PRIMARY KEY,
    fecha DATE,
    anio INTEGER,
    trimestre INTEGER,
    mes INTEGER,
    dia INTEGER
);

---------------------------------------------------
-- TABLA DE HECHOS ABASTECIMIENTO
---------------------------------------------------

CREATE TABLE fact_abastecimiento (
    id_abastecimiento SERIAL PRIMARY KEY,

    id_proveedor INTEGER,
    id_sucursal INTEGER,
    id_insumo INTEGER,

    fecha_entrega DATE,

    cantidad_recibida NUMERIC(12,2),

    temperatura_producto NUMERIC(5,2),

    cumple_refrigeracion BOOLEAN,

    minutos_retraso INTEGER,

    distancia_recorrida NUMERIC(10,2),

    calificacion_control NUMERIC(5,2),

    estado_empaque VARCHAR(50),

    condiciones_vehiculo VARCHAR(50)
);

---------------------------------------------------
-- TABLA DE HECHOS CALIDAD
---------------------------------------------------

CREATE TABLE fact_evaluacion_calidad (
    id_evaluacion SERIAL PRIMARY KEY,

    id_proveedor INTEGER,

    id_sucursal INTEGER,

    fecha_evaluacion DATE,

    calidad_general NUMERIC(5,2),

    calidad_carnes NUMERIC(5,2),

    calidad_verduras NUMERIC(5,2),

    calidad_pollos NUMERIC(5,2),

    temperatura_cumple BOOLEAN,

    tiempo_cumple BOOLEAN
);

---------------------------------------------------
-- TABLA DE HECHOS METAS
---------------------------------------------------

CREATE TABLE fact_metas_abastecimiento (
    id_meta SERIAL PRIMARY KEY,

    id_proveedor INTEGER,

    id_sucursal INTEGER,

    anio INTEGER,

    mes INTEGER,

    meta_kg NUMERIC(12,2),

    meta_pedidos INTEGER,

    calidad_objetivo NUMERIC(5,2),

    puntualidad_objetivo NUMERIC(5,2),

    cumplimiento_refrigeracion_objetivo NUMERIC(5,2)
);