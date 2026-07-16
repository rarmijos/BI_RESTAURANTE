-- =====================================================
-- SCRIPT: 02_audit_etl_rechazo.sql
-- DESCRIPCIÓN: Tabla de auditoría para ETL
-- ESQUEMA: audit (independiente)
-- =====================================================

-- Crear esquema audit
CREATE SCHEMA IF NOT EXISTS audit;

-- =====================================================
-- 1. TABLA: etl_rechazo (registra errores de ETL)
-- =====================================================

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

-- Índices para consultas rápidas
CREATE INDEX IF NOT EXISTS idx_etl_rechazo_fuente ON audit.etl_rechazo(fuente);
CREATE INDEX IF NOT EXISTS idx_etl_rechazo_entidad ON audit.etl_rechazo(entidad);
CREATE INDEX IF NOT EXISTS idx_etl_rechazo_fecha ON audit.etl_rechazo(fecha_registro);

-- =====================================================
-- 2. TABLA: etl_control (control de ejecución ETL)
-- =====================================================

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

-- Índices para control ETL
CREATE INDEX IF NOT EXISTS idx_etl_control_proceso ON audit.etl_control(proceso);
CREATE INDEX IF NOT EXISTS idx_etl_control_estado ON audit.etl_control(estado);

-- =====================================================
-- 3. TABLA: etl_log (bitácora de ejecución)
-- =====================================================

CREATE TABLE IF NOT EXISTS audit.etl_log (
    id_log BIGSERIAL PRIMARY KEY,
    id_control INTEGER,
    paso VARCHAR(80),
    mensaje TEXT,
    nivel VARCHAR(20) DEFAULT 'INFO',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_etl_log_control ON audit.etl_log(id_control);

-- =====================================================
-- MENSAJE DE CONFIRMACIÓN
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE '✅ Tablas de auditoría creadas exitosamente!';
    RAISE NOTICE '📊 Tablas creadas:';
    RAISE NOTICE '   - audit.etl_rechazo';
    RAISE NOTICE '   - audit.etl_control';
    RAISE NOTICE '   - audit.etl_log';
END $$;