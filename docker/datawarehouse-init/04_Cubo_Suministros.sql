-- ============================================================
-- 1. CREAR TABLA CALENDARIO EN STAGING
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.calendario_mysql (
    id_calendario SERIAL PRIMARY KEY,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    numero_mes INTEGER,
    anio INTEGER,
    mes_anio VARCHAR(7),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 2. DIMENSIÓN TIEMPO (dim_mysql_tiempo)
-- ============================================================

CREATE TABLE IF NOT EXISTS dw.dim_mysql_tiempo (
    fecha_key INTEGER PRIMARY KEY,
    fecha DATE NOT NULL,
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
    es_fin_semana BOOLEAN NOT NULL
);

-- ============================================================
-- 3. DIMENSIÓN PROVEEDOR (dim_mysql_proveedor)
-- ============================================================

CREATE TABLE IF NOT EXISTS dw.dim_mysql_proveedor (
    proveedor_key BIGSERIAL PRIMARY KEY,
    id_proveedor_original INTEGER NOT NULL,
    nombre_empresa VARCHAR(200) NOT NULL,
    contacto_principal VARCHAR(150),
    telefono VARCHAR(50),
    email VARCHAR(200),
    ciudad VARCHAR(100),
    tipo_proveedor VARCHAR(10),
    calificacion_general DECIMAL(3,2),
    estado_registro VARCHAR(5),
    fecha_carga_dw TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uq_dim_mysql_proveedor_id_original UNIQUE (id_proveedor_original)
);

-- ============================================================
-- 4. DIMENSIÓN INSUMO (dim_mysql_insumo)
-- ============================================================

CREATE TABLE IF NOT EXISTS dw.dim_mysql_insumo (
    insumo_key BIGSERIAL PRIMARY KEY,
    id_insumo_original INTEGER NOT NULL,
    id_tipo_original INTEGER,
    nombre_insumo VARCHAR(150) NOT NULL,
    unidad_medida VARCHAR(20),
    vida_util_dias INTEGER,
    origen VARCHAR(60),
    calidad_estandar VARCHAR(30),
    fecha_carga_dw TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uq_dim_mysql_insumo_id_original UNIQUE (id_insumo_original)
);

-- ============================================================
-- 5. DIMENSIÓN SUCURSAL (dim_mysql_sucursal)
-- ============================================================

CREATE TABLE IF NOT EXISTS dw.dim_mysql_sucursal (
    sucursal_key BIGSERIAL PRIMARY KEY,
    id_sucursal_original INTEGER NOT NULL,
    codigo_sucursal VARCHAR(20),
    nombre_sucursal VARCHAR(150) NOT NULL,
    ciudad VARCHAR(100),
    telefono VARCHAR(50),
    responsable VARCHAR(150),
    capacidad_almacenamiento INTEGER,
    fecha_apertura DATE,
    fecha_carga_dw TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uq_dim_mysql_sucursal_id_original UNIQUE (id_sucursal_original)
);

-- ============================================================
-- 6. DIMENSIÓN TIPO_INSUMO (dim_mysql_tipo_insumo)
-- ============================================================

CREATE TABLE IF NOT EXISTS dw.dim_mysql_tipo_insumo (
    tipo_insumo_key BIGSERIAL PRIMARY KEY,
    id_tipo_original INTEGER NOT NULL,
    nombre_tipo VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    temperatura_minima DECIMAL(8,2),
    temperatura_maxima DECIMAL(8,2),
    requiere_refrigeracion VARCHAR(5),
    fecha_carga_dw TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uq_dim_mysql_tipo_insumo_id_original UNIQUE (id_tipo_original)
);

-- ============================================================
-- 7. TABLA DE HECHOS FACT_ENTREGAS (fact_mysql_entregas)
-- ============================================================

CREATE TABLE IF NOT EXISTS dw.fact_mysql_entregas (
    entrega_key BIGSERIAL PRIMARY KEY,
    
    -- 🔗 CLAVES FORÁNEAS (5 dimensiones)
    fecha_entrega_key INTEGER NOT NULL,
    proveedor_key BIGINT NOT NULL,
    insumo_key BIGINT NOT NULL,
    sucursal_key BIGINT NOT NULL,
    tipo_insumo_key BIGINT NOT NULL,
    
    -- 📊 MÉTRICAS DE VOLUMEN
    id_entrega_original INTEGER NOT NULL,
    id_detalle_original INTEGER NOT NULL,
    cantidad_solicitada DECIMAL(14,2) NOT NULL,
    cantidad_recibida DECIMAL(14,2) NOT NULL,
    precio_unitario DECIMAL(14,4) NOT NULL,
    subtotal DECIMAL(14,2) NOT NULL,
    
    -- 📊 MÉTRICAS DE LOGÍSTICA
    tiempo_transporte DECIMAL(8,2),
    minutos_retraso INTEGER,
    distancia_recorrida DECIMAL(10,2),
    cumple_plazo VARCHAR(5),
    
    -- 📊 MÉTRICAS DE CALIDAD
    estado_calidad VARCHAR(30),
    temperatura_producto DECIMAL(8,2),
    temperatura_esperada DECIMAL(8,2),
    cumple_refrigeracion VARCHAR(5),
    calificacion_control DECIMAL(3,2),
    
    -- 📋 METADATOS
    fecha_carga_dw TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 🔒 CONSTRAINTS
    CONSTRAINT fk_fact_mysql_entregas_tiempo 
        FOREIGN KEY (fecha_entrega_key) REFERENCES dw.dim_mysql_tiempo(fecha_key),
    CONSTRAINT fk_fact_mysql_entregas_proveedor 
        FOREIGN KEY (proveedor_key) REFERENCES dw.dim_mysql_proveedor(proveedor_key),
    CONSTRAINT fk_fact_mysql_entregas_insumo 
        FOREIGN KEY (insumo_key) REFERENCES dw.dim_mysql_insumo(insumo_key),
    CONSTRAINT fk_fact_mysql_entregas_sucursal 
        FOREIGN KEY (sucursal_key) REFERENCES dw.dim_mysql_sucursal(sucursal_key),
    CONSTRAINT fk_fact_mysql_entregas_tipo_insumo 
        FOREIGN KEY (tipo_insumo_key) REFERENCES dw.dim_mysql_tipo_insumo(tipo_insumo_key)
);

-- ============================================================
-- 11. VERIFICACIÓN FINAL
-- ============================================================

SELECT 'dim_mysql_tiempo' AS tabla, COUNT(*) AS registros FROM dw.dim_mysql_tiempo
UNION ALL
SELECT 'dim_mysql_proveedor', COUNT(*) FROM dw.dim_mysql_proveedor
UNION ALL
SELECT 'dim_mysql_insumo', COUNT(*) FROM dw.dim_mysql_insumo
UNION ALL
SELECT 'dim_mysql_sucursal', COUNT(*) FROM dw.dim_mysql_sucursal
UNION ALL
SELECT 'dim_mysql_tipo_insumo', COUNT(*) FROM dw.dim_mysql_tipo_insumo
UNION ALL
SELECT 'fact_mysql_entregas', COUNT(*) FROM dw.fact_mysql_entregas;