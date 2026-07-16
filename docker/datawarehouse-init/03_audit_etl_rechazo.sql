-- =====================================================
-- SCRIPT: 03_staging_carga.sql
-- DESCRIPCIÓN: Procedimientos para cargar datos en staging
-- =====================================================

-- =====================================================
-- 1. FUNCIÓN: cargar_excel_compras()
-- =====================================================

CREATE OR REPLACE FUNCTION staging.cargar_excel_compras()
RETURNS TEXT AS $$
DECLARE
    registros INTEGER;
BEGIN
    -- Insertar datos desde la tabla temporal (si existe)
    INSERT INTO staging.excel_compras (
        id_compra, fecha_compra, orden_compra, factura_distribuidor,
        codigo_distribuidor, distribuidor, contacto_ventas, telefono_contacto,
        correo_contacto, codigo_insumo, insumo, categoria, presentacion,
        lote, fecha_vencimiento, cantidad_comprada, costo_unitario_lista,
        descuento_pct, costo_unitario_descuento, subtotal_bruto,
        valor_descuento, valor_neto, codigo_sucursal_entrega,
        sucursal_entrega, bodega_entrega, fecha_estimada_entrega,
        estado_recepcion, observacion
    )
    SELECT 
        id_compra, fecha_compra, orden_compra, factura_distribuidor,
        codigo_distribuidor, distribuidor, contacto_ventas, telefono_contacto,
        correo_contacto, codigo_insumo, insumo, categoria, presentacion,
        lote, fecha_vencimiento, cantidad_comprada, costo_unitario_lista,
        descuento_pct, costo_unitario_descuento, subtotal_bruto,
        valor_descuento, valor_neto, codigo_sucursal_entrega,
        sucursal_entrega, bodega_entrega, fecha_estimada_entrega,
        estado_recepcion, observacion
    FROM staging.temp_excel_compras
    ON CONFLICT (id_compra) DO NOTHING;
    
    GET DIAGNOSTICS registros = ROW_COUNT;
    
    RETURN '✅ ' || registros || ' registros cargados en excel_compras';
    
EXCEPTION WHEN OTHERS THEN
    RETURN '❌ Error: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 2. FUNCIÓN: contar_registros_staging()
-- =====================================================

CREATE OR REPLACE FUNCTION staging.contar_registros_staging()
RETURNS TABLE(tabla VARCHAR(80), cantidad BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT 'excel_compras'::VARCHAR, COUNT(*) FROM staging.excel_compras
    UNION ALL
    SELECT 'excel_distribuidores', COUNT(*) FROM staging.excel_distribuidores
    UNION ALL
    SELECT 'excel_insumos', COUNT(*) FROM staging.excel_insumos
    UNION ALL
    SELECT 'excel_puntos_entrega', COUNT(*) FROM staging.excel_puntos_entrega
    UNION ALL
    SELECT 'excel_resumen_mensual', COUNT(*) FROM staging.excel_resumen_mensual
    UNION ALL
    SELECT 'mysql_proveedores', COUNT(*) FROM staging.mysql_proveedores
    UNION ALL
    SELECT 'mysql_sucursales', COUNT(*) FROM staging.mysql_sucursales
    UNION ALL
    SELECT 'mysql_tipo_insumo', COUNT(*) FROM staging.mysql_tipo_insumo
    UNION ALL
    SELECT 'mysql_insumos', COUNT(*) FROM staging.mysql_insumos
    UNION ALL
    SELECT 'mysql_entregas', COUNT(*) FROM staging.mysql_entregas
    UNION ALL
    SELECT 'mysql_detalle_entrega', COUNT(*) FROM staging.mysql_detalle_entrega
    UNION ALL
    SELECT 'mysql_control_recepcion', COUNT(*) FROM staging.mysql_control_recepcion
    UNION ALL
    SELECT 'pg_zonas', COUNT(*) FROM staging.pg_zonas
    UNION ALL
    SELECT 'pg_categorias_insumos', COUNT(*) FROM staging.pg_categorias_insumos
    UNION ALL
    SELECT 'pg_proveedores_oficiales', COUNT(*) FROM staging.pg_proveedores_oficiales
    UNION ALL
    SELECT 'pg_sucursales_oficiales', COUNT(*) FROM staging.pg_sucursales_oficiales
    UNION ALL
    SELECT 'pg_metas_abastecimiento', COUNT(*) FROM staging.pg_metas_abastecimiento
    UNION ALL
    SELECT 'pg_evaluaciones_calidad', COUNT(*) FROM staging.pg_evaluaciones_calidad;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- MENSAJE DE CONFIRMACIÓN
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE '✅ Funciones creadas exitosamente!';
    RAISE NOTICE '   - staging.cargar_excel_compras()';
    RAISE NOTICE '   - staging.contar_registros_staging()';
END $$;