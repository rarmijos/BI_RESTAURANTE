-- Crear el esquema dw si no existe
CREATE SCHEMA IF NOT EXISTS dw;

-- Verificar que se creó
SELECT schema_name 
FROM information_schema.schemata 
WHERE schema_name = 'dw';


-- ============================================================
-- 2. TABLA CALENDARIO (en staging) - ESTRUCTURA CORRECTA
-- ============================================================

-- Crear la tabla calendario en staging con la estructura correcta
CREATE TABLE IF NOT EXISTS staging.calendario (
    id_calendario SERIAL PRIMARY KEY,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    numero_mes INTEGER,
    anio INTEGER,
    mes_anio VARCHAR(7),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- DIMENSIÓN TIEMPO
-- =========================================================

CREATE TABLE IF NOT EXISTS dw.dim_tiempo (
    fecha_key INTEGER PRIMARY KEY,
    fecha DATE NOT NULL UNIQUE,
    anio INTEGER NOT NULL,
    semestre SMALLINT NOT NULL,
    trimestre SMALLINT NOT NULL,
    numero_mes SMALLINT NOT NULL,
    nombre_mes VARCHAR(15) NOT NULL,
    anio_mes VARCHAR(7) NOT NULL,
    numero_semana SMALLINT NOT NULL,
    dia_mes SMALLINT NOT NULL,
    numero_dia_semana SMALLINT NOT NULL,
    nombre_dia VARCHAR(15) NOT NULL,
    es_fin_semana BOOLEAN NOT NULL,

    CONSTRAINT ck_dim_tiempo_semestre
        CHECK (semestre BETWEEN 1 AND 2),

    CONSTRAINT ck_dim_tiempo_trimestre
        CHECK (trimestre BETWEEN 1 AND 4),

    CONSTRAINT ck_dim_tiempo_mes
        CHECK (numero_mes BETWEEN 1 AND 12),

    CONSTRAINT ck_dim_tiempo_dia_semana
        CHECK (numero_dia_semana BETWEEN 1 AND 7)
);

-- =========================================================
-- DIMENSIÓN PROVEEDOR
-- =========================================================

CREATE TABLE IF NOT EXISTS dw.dim_proveedor (
    proveedor_key BIGSERIAL PRIMARY KEY,
    codigo_proveedor VARCHAR(30) NOT NULL,
    nombre_proveedor VARCHAR(200) NOT NULL,
    ciudad VARCHAR(100),
    contacto_ventas VARCHAR(150),
    telefono_contacto VARCHAR(50),
    correo_contacto VARCHAR(200),
    condicion_pago VARCHAR(50),
    fecha_carga_dw TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_dim_proveedor_codigo
        UNIQUE (codigo_proveedor)
);

-- =========================================================
-- DIMENSIÓN INSUMO
-- =========================================================

CREATE TABLE IF NOT EXISTS dw.dim_insumo (
    insumo_key BIGSERIAL PRIMARY KEY,
    codigo_insumo VARCHAR(30) NOT NULL,
    nombre_insumo VARCHAR(200) NOT NULL,
    categoria VARCHAR(100),
    tipo VARCHAR(50),
    unidad_medida VARCHAR(20),
    temperatura_requerida NUMERIC(8,2),
    vida_util_dias INTEGER,
    origen VARCHAR(100),
    fecha_carga_dw TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_dim_insumo_codigo
        UNIQUE (codigo_insumo),
    
    CONSTRAINT ck_dim_insumo_vida_util
        CHECK (vida_util_dias IS NULL OR vida_util_dias > 0),

    CONSTRAINT ck_dim_insumo_temperatura
        CHECK (temperatura_requerida IS NULL OR temperatura_requerida >= 0)
);

-- =========================================================
-- TABLA DE HECHOS COMPRAS
-- =========================================================

CREATE TABLE IF NOT EXISTS dw.fact_compras (
    compra_key BIGSERIAL PRIMARY KEY,

    -- Claves foráneas a dimensiones
    fecha_compra_key INTEGER NOT NULL,
    proveedor_key BIGINT NOT NULL,
    insumo_key BIGINT NOT NULL,
    
    -- Campos de negocio
    id_compra VARCHAR(30) NOT NULL,
    cantidad_comprada INTEGER NOT NULL,
    costo_unitario NUMERIC(14,4) NOT NULL,
    descuento_porcentaje NUMERIC(8,4) NOT NULL DEFAULT 0,
    valor_neto NUMERIC(14,2) NOT NULL,
    
    -- Fechas adicionales (opcionales)
    fecha_estimada_entrega_key INTEGER,
    fecha_vencimiento_key INTEGER,
    estado_recepcion VARCHAR(30),
    
    -- Metadatos
    fecha_carga_dw TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Restricciones UNIQUE
    CONSTRAINT uq_fact_compras_id_origen
        UNIQUE (id_compra),

    -- Claves foráneas
    CONSTRAINT fk_fact_compras_fecha_compra
        FOREIGN KEY (fecha_compra_key)
        REFERENCES dw.dim_tiempo(fecha_key),

    CONSTRAINT fk_fact_compras_proveedor
        FOREIGN KEY (proveedor_key)
        REFERENCES dw.dim_proveedor(proveedor_key),

    CONSTRAINT fk_fact_compras_insumo
        FOREIGN KEY (insumo_key)
        REFERENCES dw.dim_insumo(insumo_key),

    CONSTRAINT fk_fact_compras_fecha_entrega
        FOREIGN KEY (fecha_estimada_entrega_key)
        REFERENCES dw.dim_tiempo(fecha_key),

    CONSTRAINT fk_fact_compras_fecha_vencimiento
        FOREIGN KEY (fecha_vencimiento_key)
        REFERENCES dw.dim_tiempo(fecha_key),

    -- Restricciones de datos
    CONSTRAINT ck_fact_compras_cantidad
        CHECK (cantidad_comprada > 0),

    CONSTRAINT ck_fact_compras_costo
        CHECK (costo_unitario >= 0),

    CONSTRAINT ck_fact_compras_descuento
        CHECK (descuento_porcentaje BETWEEN 0 AND 100),

    CONSTRAINT ck_fact_compras_valor_neto
        CHECK (valor_neto >= 0)
);

-- =========================================================
-- ÍNDICES PARA LA TABLA DE HECHOS
-- =========================================================

CREATE INDEX IF NOT EXISTS idx_fact_compras_fecha_compra
    ON dw.fact_compras(fecha_compra_key);

CREATE INDEX IF NOT EXISTS idx_fact_compras_proveedor
    ON dw.fact_compras(proveedor_key);

CREATE INDEX IF NOT EXISTS idx_fact_compras_insumo
    ON dw.fact_compras(insumo_key);

CREATE INDEX IF NOT EXISTS idx_fact_compras_fecha_entrega
    ON dw.fact_compras(fecha_estimada_entrega_key);

CREATE INDEX IF NOT EXISTS idx_fact_compras_fecha_vencimiento
    ON dw.fact_compras(fecha_vencimiento_key);