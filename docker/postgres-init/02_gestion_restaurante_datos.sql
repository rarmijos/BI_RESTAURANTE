-- =====================================================
-- SCRIPT: 02_gestion_restaurante_datos.sql
-- DESCRIPCIÓN: Carga masiva de datos en PostgreSQL
-- =====================================================

-- =====================================================
-- 1. PROVEEDORES_OFICIALES (150 registros)
-- =====================================================
INSERT INTO proveedores_oficiales (codigo_proveedor, ruc, razon_social, nombre_comercial, contacto_principal, email_contacto, telefono, direccion, ciudad, id_zona, id_categoria, fecha_registro, calificacion_promedio, estado)
SELECT 
    'PROV-' || LPAD(generate_series::TEXT, 4, '0') as codigo_proveedor,
    LPAD(FLOOR(1000000000 + RANDOM() * 9000000000)::TEXT, 10, '0') || LPAD(FLOOR(100 + RANDOM() * 900)::TEXT, 3, '0') || '1' as ruc,
    CASE (FLOOR(RANDOM() * 6))::INT
        WHEN 0 THEN 'Distribuidora Alimenticia Andina'
        WHEN 1 THEN 'Frigorifico Nacional C.A.'
        WHEN 2 THEN 'Agroindustria del Sur'
        WHEN 3 THEN 'Comercializadora de Carnes Premium'
        WHEN 4 THEN 'Proveedora de Insumos Gourmet'
        ELSE 'Logistica de Alimentos S.A.'
    END || ' ' || LPAD(generate_series::TEXT, 3, '0') as razon_social,
    CASE (FLOOR(RANDOM() * 4))::INT
        WHEN 0 THEN 'Carnes Premium'
        WHEN 1 THEN 'Distribuciones del Norte'
        WHEN 2 THEN 'Productos Selectos'
        ELSE 'Abastecimiento Total'
    END || ' ' || LPAD(generate_series::TEXT, 2, '0') as nombre_comercial,
    CASE (FLOOR(RANDOM() * 10))::INT
        WHEN 0 THEN 'Carlos Gonzalez'
        WHEN 1 THEN 'Maria Perez'
        WHEN 2 THEN 'Jose Rodriguez'
        WHEN 3 THEN 'Ana Fernandez'
        WHEN 4 THEN 'Luis Martinez'
        WHEN 5 THEN 'Carmen Garcia'
        WHEN 6 THEN 'Pedro Lopez'
        WHEN 7 THEN 'Isabel Torres'
        WHEN 8 THEN 'Miguel Diaz'
        ELSE 'Sofia Romero'
    END as contacto_principal,
    'contacto' || generate_series || '@' || CASE (FLOOR(RANDOM() * 4))::INT
        WHEN 0 THEN 'gmail.com'
        WHEN 1 THEN 'hotmail.com'
        WHEN 2 THEN 'empresa.com'
        ELSE 'comercial.com'
    END as email_contacto,
    '09' || FLOOR(100000000 + RANDOM() * 900000000)::TEXT as telefono,
    'Calle ' || FLOOR(1 + RANDOM() * 100)::TEXT || ' #' || FLOOR(100 + RANDOM() * 900)::TEXT as direccion,
    CASE (FLOOR(RANDOM() * 8))::INT
        WHEN 0 THEN 'Quito'
        WHEN 1 THEN 'Guayaquil'
        WHEN 2 THEN 'Cuenca'
        WHEN 3 THEN 'Ambato'
        WHEN 4 THEN 'Manta'
        WHEN 5 THEN 'Loja'
        WHEN 6 THEN 'Ibarra'
        ELSE 'Riobamba'
    END as ciudad,
    FLOOR(1 + RANDOM() * 10) as id_zona,
    FLOOR(1 + RANDOM() * 15) as id_categoria,
    CURRENT_DATE - (FLOOR(1 + RANDOM() * 730)::INT || ' days')::INTERVAL as fecha_registro,
    ROUND((2.5 + RANDOM() * 2.5)::NUMERIC, 2) as calificacion_promedio,
    CASE WHEN RANDOM() > 0.15 THEN 'Activo' ELSE 'Inactivo' END as estado
FROM generate_series(1, 150);

-- =====================================================
-- 2. SUCURSALES_OFICIALES (200 registros)
-- =====================================================
INSERT INTO sucursales_oficiales (codigo_sucursal, nombre_oficial, nombre_comercial, id_zona, direccion, ciudad, telefono, capacidad_almacenamiento, responsable, fecha_apertura, estado)
SELECT 
    'SUC-' || LPAD(generate_series::TEXT, 4, '0') as codigo_sucursal,
    'Restaurante ' || CASE (FLOOR(RANDOM() * 10))::INT
        WHEN 0 THEN 'El Buen Sabor'
        WHEN 1 THEN 'La Casona'
        WHEN 2 THEN 'Delicias'
        WHEN 3 THEN 'Sazon'
        WHEN 4 THEN 'Tradicion'
        WHEN 5 THEN 'Campestre'
        WHEN 6 THEN 'Maritimo'
        WHEN 7 THEN 'Carnivoro'
        WHEN 8 THEN 'Verde'
        ELSE 'Gourmet'
    END || ' ' || generate_series as nombre_oficial,
    CASE (FLOOR(RANDOM() * 5))::INT
        WHEN 0 THEN 'Buen Sabor'
        WHEN 1 THEN 'Casona'
        WHEN 2 THEN 'Delicias'
        WHEN 3 THEN 'Sazon'
        ELSE 'Tradicion'
    END || ' ' || generate_series as nombre_comercial,
    FLOOR(1 + RANDOM() * 10) as id_zona,
    'Av. ' || CASE (FLOOR(RANDOM() * 10))::INT
        WHEN 0 THEN 'Amazonas'
        WHEN 1 THEN 'Eloy Alfaro'
        WHEN 2 THEN '6 de Diciembre'
        WHEN 3 THEN 'Republica'
        WHEN 4 THEN 'Naciones Unidas'
        WHEN 5 THEN 'Gran Colombia'
        WHEN 6 THEN 'Simon Bolivar'
        WHEN 7 THEN 'Manuela Saenz'
        WHEN 8 THEN 'Mariscal Sucre'
        ELSE '10 de Agosto'
    END || ' #' || FLOOR(100 + RANDOM() * 900)::TEXT as direccion,
    CASE (FLOOR(RANDOM() * 8))::INT
        WHEN 0 THEN 'Quito'
        WHEN 1 THEN 'Guayaquil'
        WHEN 2 THEN 'Cuenca'
        WHEN 3 THEN 'Ambato'
        WHEN 4 THEN 'Manta'
        WHEN 5 THEN 'Loja'
        WHEN 6 THEN 'Ibarra'
        ELSE 'Riobamba'
    END as ciudad,
    '09' || FLOOR(100000000 + RANDOM() * 900000000)::TEXT as telefono,
    FLOOR(500 + RANDOM() * 2000) as capacidad_almacenamiento,
    CASE (FLOOR(RANDOM() * 10))::INT
        WHEN 0 THEN 'Ana Gonzalez'
        WHEN 1 THEN 'Carlos Perez'
        WHEN 2 THEN 'Maria Rodriguez'
        WHEN 3 THEN 'Jose Fernandez'
        WHEN 4 THEN 'Luis Martinez'
        WHEN 5 THEN 'Carmen Garcia'
        WHEN 6 THEN 'Pedro Lopez'
        WHEN 7 THEN 'Isabel Torres'
        WHEN 8 THEN 'Miguel Diaz'
        ELSE 'Sofia Romero'
    END as responsable,
    CURRENT_DATE - (FLOOR(365 + RANDOM() * 1095)::INT || ' days')::INTERVAL as fecha_apertura,
    CASE WHEN RANDOM() > 0.1 THEN 'Activo' ELSE 'Inactivo' END as estado
FROM generate_series(1, 200);

-- =====================================================
-- 3. METAS_ABASTECIMIENTO (200 registros)
-- =====================================================
INSERT INTO metas_abastecimiento (id_proveedor, id_sucursal, anio, mes, meta_kg, meta_pedidos, calidad_objetivo, cumplimiento_refrigeracion_objetivo, puntualidad_objetivo)
SELECT 
    p.id_proveedor,
    s.id_sucursal,
    anios.anio,
    m.mes,
    ROUND((500 + RANDOM() * 4000)::NUMERIC, 2) as meta_kg,
    FLOOR(5 + RANDOM() * 25) as meta_pedidos,
    ROUND((3.0 + RANDOM() * 2.0)::NUMERIC, 2) as calidad_objetivo,
    ROUND((65 + RANDOM() * 35)::NUMERIC, 2) as cumplimiento_refrigeracion_objetivo,
    ROUND((65 + RANDOM() * 35)::NUMERIC, 2) as puntualidad_objetivo
FROM 
    (SELECT id_proveedor FROM proveedores_oficiales WHERE estado = 'Activo' ORDER BY RANDOM() LIMIT 20) p
    CROSS JOIN
    (SELECT id_sucursal FROM sucursales_oficiales WHERE estado = 'Activo' ORDER BY RANDOM() LIMIT 5) s
    CROSS JOIN
    (SELECT generate_series(1, 12) AS mes) m
    CROSS JOIN
    (SELECT generate_series(2024, 2025) AS anio) anios
WHERE RANDOM() < 0.3
LIMIT 200;

-- =====================================================
-- 4. EVALUACIONES_CALIDAD (200 registros)
-- =====================================================
INSERT INTO evaluaciones_calidad (id_proveedor, id_sucursal, fecha_evaluacion, calidad_general, temperatura_cumple, tiempo_cumple, calidad_carnes, calidad_verduras, calidad_pollos, observaciones, evaluador)
SELECT 
    p.id_proveedor,
    s.id_sucursal,
    CURRENT_DATE - (FLOOR(1 + RANDOM() * 180)::INT || ' days')::INTERVAL as fecha_evaluacion,
    FLOOR(2 + RANDOM() * 4) as calidad_general,
    RANDOM() > 0.15 as temperatura_cumple,
    RANDOM() > 0.20 as tiempo_cumple,
    FLOOR(2 + RANDOM() * 4) as calidad_carnes,
    FLOOR(2 + RANDOM() * 4) as calidad_verduras,
    FLOOR(2 + RANDOM() * 4) as calidad_pollos,
    CASE (FLOOR(RANDOM() * 5))::INT
        WHEN 0 THEN 'Excelente calidad general'
        WHEN 1 THEN 'Buen desempeno'
        WHEN 2 THEN 'Regular, necesita mejorar'
        WHEN 3 THEN 'Cumple con los estandares'
        ELSE 'Observaciones menores'
    END as observaciones,
    CASE (FLOOR(RANDOM() * 10))::INT
        WHEN 0 THEN 'Ing. Perez'
        WHEN 1 THEN 'Dr. Gonzalez'
        WHEN 2 THEN 'Lic. Rodriguez'
        WHEN 3 THEN 'Tec. Fernandez'
        WHEN 4 THEN 'QC Martinez'
        WHEN 5 THEN 'Ing. Garcia'
        WHEN 6 THEN 'Dr. Torres'
        WHEN 7 THEN 'Lic. Diaz'
        WHEN 8 THEN 'Tec. Romero'
        ELSE 'QC Castillo'
    END as evaluador
FROM 
    (SELECT id_proveedor FROM proveedores_oficiales WHERE estado = 'Activo' ORDER BY RANDOM() LIMIT 25) p
    CROSS JOIN
    (SELECT id_sucursal FROM sucursales_oficiales WHERE estado = 'Activo' ORDER BY RANDOM() LIMIT 8) s
WHERE RANDOM() < 0.25
LIMIT 200;

-- =====================================================
-- MENSAJE DE CONFIRMACIÓN
-- =====================================================
DO $$
BEGIN
    RAISE NOTICE '✅ DATOS CARGADOS EN POSTGRESQL';
    RAISE NOTICE '📊 Resumen:';
    RAISE NOTICE '   - Zonas: %', (SELECT COUNT(*) FROM zonas);
    RAISE NOTICE '   - Categorias Insumos: %', (SELECT COUNT(*) FROM categorias_insumos);
    RAISE NOTICE '   - Proveedores Oficiales: %', (SELECT COUNT(*) FROM proveedores_oficiales);
    RAISE NOTICE '   - Sucursales Oficiales: %', (SELECT COUNT(*) FROM sucursales_oficiales);
    RAISE NOTICE '   - Metas Abastecimiento: %', (SELECT COUNT(*) FROM metas_abastecimiento);
    RAISE NOTICE '   - Evaluaciones Calidad: %', (SELECT COUNT(*) FROM evaluaciones_calidad);
END $$;