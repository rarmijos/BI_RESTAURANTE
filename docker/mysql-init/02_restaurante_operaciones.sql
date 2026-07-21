-- =====================================================
-- SCRIPT: 02_restaurante_operaciones.sql (CORREGIDO)
-- DESCRIPCIÓN: Carga masiva de datos en MySQL
-- =====================================================

USE restaurante_db;

-- =====================================================
-- 1. PROVEEDORES (150 registros)
-- =====================================================
INSERT INTO proveedores (id_proveedor, nombre_empresa, contacto_principal, telefono, email, direccion, ciudad, pais, tipo_proveedor, fecha_registro, calificacion_general, estado_registro, observaciones)
WITH RECURSIVE numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 150
)
SELECT 
    n as id_proveedor,
    CONCAT(
        ELT(FLOOR(1 + RAND() * 8),
            'Distribuidora', 'Proveedora', 'Comercial', 'Frigorifico', 
            'Agroindustria', 'Carnica', 'Pesquera', 'Lacteos'
        ),
        ' ',
        ELT(FLOOR(1 + RAND() * 10),
            'Andina', 'Nacional', 'Internacional', 'Premium', 'Selecta',
            'Del Sur', 'Del Norte', 'Central', 'Occidental', 'Oriental'
        ),
        ' ',
        ELT(FLOOR(1 + RAND() * 6),
            'S.A.', 'C.A.', 'Cia. Ltda.', 'S.R.L.', 'E.P.', 'C.L.'
        )
    ) as nombre_empresa,
    CONCAT(
        ELT(FLOOR(1 + RAND() * 10),
            'Carlos', 'Maria', 'Jose', 'Ana', 'Luis', 
            'Carmen', 'Pedro', 'Isabel', 'Miguel', 'Sofia'
        ),
        ' ',
        ELT(FLOOR(1 + RAND() * 8),
            'Gonzalez', 'Perez', 'Rodriguez', 'Fernandez', 'Lopez',
            'Martinez', 'Garcia', 'Torres'
        )
    ) as contacto_principal,
    CONCAT('09', FLOOR(100000000 + RAND() * 900000000)) as telefono,
    CONCAT(
        LOWER(ELT(FLOOR(1 + RAND() * 5), 'contacto', 'info', 'ventas', 'compras', 'proveedores')),
        '@',
        ELT(FLOOR(1 + RAND() * 6), 'gmail.com', 'hotmail.com', 'yahoo.com', 'outlook.com', 'empresa.com', 'comercial.com')
    ) as email,
    CONCAT('Calle ', FLOOR(1 + RAND() * 100), ' #', FLOOR(100 + RAND() * 900)) as direccion,
    ELT(FLOOR(1 + RAND() * 8), 'Quito', 'Guayaquil', 'Cuenca', 'Ambato', 'Manta', 'Loja', 'Ibarra', 'Riobamba') as ciudad,
    'Ecuador' as pais,
    ELT(FLOOR(1 + RAND() * 6), 'CA', 'PO', 'VE', 'PE', 'LA', 'GE') as tipo_proveedor,
    DATE_SUB(CURDATE(), INTERVAL FLOOR(1 + RAND() * 730) DAY) as fecha_registro,
    ROUND(2.5 + RAND() * 2.5, 2) as calificacion_general,
    ELT(FLOOR(1 + RAND() * 3), 'A', 'I', 'A') as estado_registro,
    CONCAT('Proveedor ', ELT(FLOOR(1 + RAND() * 5), 'confiable', 'regular', 'excelente', 'nuevo', 'estrategico'))
FROM numbers;

-- =====================================================
-- 2. TIPO_INSUMO (50 registros)
-- =====================================================
INSERT INTO tipo_insumo (id_tipo, nombre_tipo, categoria, descripcion, temperatura_minima, temperatura_maxima, requiere_refrigeracion)
WITH RECURSIVE numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 50
)
SELECT 
    n as id_tipo,
    CONCAT(
        ELT(FLOOR(1 + RAND() * 10),
            'Carne', 'Pollo', 'Pescado', 'Verdura', 'Fruta',
            'Lacteo', 'Huevo', 'Cereal', 'Legumbre', 'Especia'
        ),
        ' ',
        ELT(FLOOR(1 + RAND() * 5), 'Fresco', 'Congelado', 'Seco', 'Enlatado', 'Procesado')
    ) as nombre_tipo,
    ELT(FLOOR(1 + RAND() * 6), 'Carnicos', 'Aves', 'Pescados', 'Verduras', 'Frutas', 'Lacteos') as categoria,
    CONCAT('Insumo de ', ELT(FLOOR(1 + RAND() * 4), 'alta', 'media', 'estandar', 'premium'), ' calidad') as descripcion,
    ROUND(-10 + RAND() * 10, 1) as temperatura_minima,
    ROUND(10 + RAND() * 20, 1) as temperatura_maxima,
    ELT(FLOOR(1 + RAND() * 2), 'S', 'N') as requiere_refrigeracion
FROM numbers;

-- =====================================================
-- 3. SUCURSALES (200 registros)
-- =====================================================
INSERT INTO sucursales (id_sucursal, codigo_sucursal, nombre_sucursal, direccion, ciudad, estado, telefono, responsable, capacidad_almacenamiento, fecha_apertura, horario_atencion)
WITH RECURSIVE numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 200
)
SELECT 
    n as id_sucursal,
    CONCAT('SUC-', LPAD(n, 4, '0')) as codigo_sucursal,
    CONCAT('Restaurante ', ELT(FLOOR(1 + RAND() * 10),
        'El Buen Sabor', 'La Casona', 'Delicias', 'Sazon', 'Tradicion',
        'Campestre', 'Maritimo', 'Carnivoro', 'Verde', 'Gourmet'
    )) as nombre_sucursal,
    CONCAT('Av. ', ELT(FLOOR(1 + RAND() * 10),
        'Amazonas', 'Eloy Alfaro', '6 de Diciembre', 'Republica', 'Naciones Unidas',
        'Gran Colombia', 'Simon Bolivar', 'Manuela Saenz', 'Mariscal Sucre', '10 de Agosto'
    ), ' #', FLOOR(100 + RAND() * 900)) as direccion,
    ELT(FLOOR(1 + RAND() * 8), 'Quito', 'Guayaquil', 'Cuenca', 'Ambato', 'Manta', 'Loja', 'Ibarra', 'Riobamba') as ciudad,
    'Activo' as estado,
    CONCAT('09', FLOOR(100000000 + RAND() * 900000000)) as telefono,
    CONCAT(
        ELT(FLOOR(1 + RAND() * 10),
            'Ana', 'Carlos', 'Maria', 'Jose', 'Luis',
            'Carmen', 'Pedro', 'Isabel', 'Miguel', 'Sofia'
        ),
        ' ',
        ELT(FLOOR(1 + RAND() * 8),
            'Gonzalez', 'Perez', 'Rodriguez', 'Fernandez', 'Lopez',
            'Martinez', 'Garcia', 'Torres'
        )
    ) as responsable,
    FLOOR(500 + RAND() * 2000) as capacidad_almacenamiento,
    DATE_SUB(CURDATE(), INTERVAL FLOOR(365 + RAND() * 1095) DAY) as fecha_apertura,
    CONCAT(FLOOR(8 + RAND() * 4), ':00 - ', FLOOR(18 + RAND() * 4), ':00') as horario_atencion
FROM numbers;

-- =====================================================
-- 4. INSUMOS (300 registros)
-- =====================================================
INSERT INTO insumos (id_insumo, id_tipo, nombre_insumo, nombre_cientifico, variedad, unidad_medida, peso_aproximado, vida_util_dias, temporada, origen, calidad_estandar)
WITH RECURSIVE numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 300
)
SELECT 
    n as id_insumo,
    FLOOR(1 + RAND() * 50) as id_tipo,
    CONCAT(
        ELT(FLOOR(1 + RAND() * 15),
            'Lomo', 'Pechuga', 'Filete', 'Molleja', 'Higado',
            'Pata', 'Ala', 'Costilla', 'Churrasco', 'Milanesa',
            'Trucha', 'Salmon', 'Atun', 'Corvina', 'Langostino'
        ),
        ' ',
        ELT(FLOOR(1 + RAND() * 8),
            'Premium', 'Selecto', 'Extra', 'Supremo', 'Gourmet',
            'Fresco', 'Natural', 'Organico'
        )
    ) as nombre_insumo,
    CONCAT(
        ELT(FLOOR(1 + RAND() * 5), 'Bos', 'Gallus', 'Salmo', 'Solanum', 'Lactuca'),
        ' ',
        ELT(FLOOR(1 + RAND() * 5), 'sapiens', 'domesticus', 'salar', 'lycopersicum', 'sativa')
    ) as nombre_cientifico,
    ELT(FLOOR(1 + RAND() * 5), 'Angus', 'Broiler', 'Atlantico', 'Roma', 'Criolla') as variedad,
    ELT(FLOOR(1 + RAND() * 4), 'Kg', 'g', 'Lb', 'Unidad') as unidad_medida,
    ROUND(0.5 + RAND() * 9.5, 2) as peso_aproximado,
    FLOOR(5 + RAND() * 25) as vida_util_dias,
    ELT(FLOOR(1 + RAND() * 4), 'Todo el ano', 'Verano', 'Invierno', 'Primavera') as temporada,
    ELT(FLOOR(1 + RAND() * 5), 'Nacional', 'Importado', 'Local', 'Regional', 'Internacional') as origen,
    ELT(FLOOR(1 + RAND() * 5), 'Premium', 'Primera', 'Segunda', 'Estandar', 'Economica') as calidad_estandar
FROM numbers;

-- =====================================================
-- 5. ENTREGAS (500 registros)
-- =====================================================
INSERT INTO entregas (id_entrega, id_proveedor, id_sucursal, fecha_pedido, fecha_entrega_programada, fecha_entrega_real, tipo_entrega, prioridad, numero_guia, transportista, observaciones)
WITH RECURSIVE numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 500
)
SELECT 
    n as id_entrega,
    FLOOR(1 + RAND() * 150) as id_proveedor,
    FLOOR(1 + RAND() * 200) as id_sucursal,
    DATE_SUB(CURDATE(), INTERVAL FLOOR(30 + RAND() * 180) DAY) as fecha_pedido,
    DATE_SUB(CURDATE(), INTERVAL FLOOR(20 + RAND() * 150) DAY) as fecha_entrega_programada,
    DATE_SUB(CURDATE(), INTERVAL FLOOR(15 + RAND() * 140) DAY) as fecha_entrega_real,
    ELT(FLOOR(1 + RAND() * 4), 'Ordinaria', 'Urgente', 'Programada', 'Express') as tipo_entrega,
    ELT(FLOOR(1 + RAND() * 4), 'Baja', 'Media', 'Alta', 'Urgente') as prioridad,
    CONCAT('GUI-', LPAD(n, 6, '0')) as numero_guia,
    ELT(FLOOR(1 + RAND() * 8),
        'Transportes Andinos', 'Logistica Nacional', 'Distribuidora Rapida',
        'Fletes y Cargas', 'Transporte Ejecutivo', 'Megaflete',
        'Camiones del Sur', 'Distribuciones del Norte'
    ) as transportista,
    ELT(FLOOR(1 + RAND() * 5),
        'Entrega normal', 'Requerimiento especial', 'Mercancia perecedera',
        'Fragilidad alta', 'Sin novedades'
    ) as observaciones
FROM numbers;

-- =====================================================
-- 6. DETALLE_ENTREGA (500 registros)
-- =====================================================
INSERT INTO detalle_entrega (id_detalle, id_entrega, id_insumo, cantidad_solicitada, cantidad_recibida, precio_unitario, subtotal, estado_calidad, lote, fecha_caducidad, observaciones)
WITH RECURSIVE numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 500
)
SELECT 
    n as id_detalle,
    FLOOR(1 + RAND() * 500) as id_entrega,
    FLOOR(1 + RAND() * 300) as id_insumo,
    ROUND(10 + RAND() * 1000, 2) as cantidad_solicitada,
    ROUND(10 + RAND() * 1000, 2) as cantidad_recibida,
    ROUND(1 + RAND() * 50, 2) as precio_unitario,
    ROUND((10 + RAND() * 1000) * (1 + RAND() * 50), 2) as subtotal,
    ELT(FLOOR(1 + RAND() * 5), 'Excelente', 'Bueno', 'Regular', 'Aceptable', 'Necesita revision') as estado_calidad,
    CONCAT('LOTE-', LPAD(FLOOR(1000 + RAND() * 9000), 4, '0')) as lote,
    DATE_ADD(CURDATE(), INTERVAL FLOOR(30 + RAND() * 300) DAY) as fecha_caducidad,
    ELT(FLOOR(1 + RAND() * 4),
        'Producto verificado', 'Revision pendiente', 'Aprobado', 'Condicionado'
    ) as observaciones
FROM numbers;

-- =====================================================
-- 7. CONTROL_RECEPCION (300 registros)
-- =====================================================
INSERT INTO control_recepcion (
    id_control, id_entrega, id_proveedor, id_sucursal, fecha_recepcion, hora_llegada,
    temperatura_ambiente, temperatura_producto, temperatura_esperada, cumple_refrigeracion,
    humedad_relativa, estado_empaque, condiciones_vehiculo, distancia_recorrida,
    tiempo_transporte, tiempo_descarga, cumple_plazo, minutos_retraso,
    inspector, calificacion_control, observaciones
)
WITH RECURSIVE numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 300
)
SELECT 
    n as id_control,
    FLOOR(1 + RAND() * 500) as id_entrega,
    FLOOR(1 + RAND() * 150) as id_proveedor,
    FLOOR(1 + RAND() * 200) as id_sucursal,
    DATE_SUB(CURDATE(), INTERVAL FLOOR(10 + RAND() * 100) DAY) as fecha_recepcion,
    CONCAT(
        LPAD(FLOOR(8 + RAND() * 10), 2, '0'), ':',
        LPAD(FLOOR(0 + RAND() * 59), 2, '0')
    ) as hora_llegada,
    ROUND(18 + RAND() * 10, 1) as temperatura_ambiente,
    ROUND(0 + RAND() * 15, 1) as temperatura_producto,
    ROUND(2 + RAND() * 8, 1) as temperatura_esperada,
    ELT(FLOOR(1 + RAND() * 2), 'S', 'N') as cumple_refrigeracion,
    ROUND(60 + RAND() * 30, 2) as humedad_relativa,
    ELT(FLOOR(1 + RAND() * 4), 'Bueno', 'Regular', 'Excelente', 'Danado') as estado_empaque,
    ELT(FLOOR(1 + RAND() * 4), 'Limpio', 'Aceptable', 'Sucio', 'Excelente') as condiciones_vehiculo,
    ROUND(10 + RAND() * 150, 2) as distancia_recorrida,
    ROUND(0.5 + RAND() * 8, 2) as tiempo_transporte,
    ROUND(0.5 + RAND() * 3, 2) as tiempo_descarga,
    ELT(FLOOR(1 + RAND() * 2), 'S', 'N') as cumple_plazo,
    CASE WHEN RAND() > 0.7 THEN FLOOR(5 + RAND() * 60) ELSE 0 END as minutos_retraso,
    CONCAT(
        ELT(FLOOR(1 + RAND() * 5), 'Ing. ', 'Dr. ', 'Lic. ', 'Tec. ', 'QC '),
        ELT(FLOOR(1 + RAND() * 10), 'Perez', 'Gonzalez', 'Rodriguez', 'Fernandez', 'Lopez', 'Martinez', 'Garcia', 'Torres', 'Diaz', 'Romero')
    ) as inspector,
    ROUND(1 + RAND() * 4, 2) as calificacion_control,
    ELT(FLOOR(1 + RAND() * 6),
        'Recepcion OK', 'Revision necesaria', 'Producto aceptado', 'Observaciones menores',
        'Rechazo parcial', 'Aprobado con condiciones'
    ) as observaciones
FROM numbers;

-- =====================================================
-- MENSAJE DE CONFIRMACIÓN
-- =====================================================
SELECT '✅ DATOS CARGADOS EN MYSQL' as Mensaje;

SELECT 
    'proveedores' as Tabla, COUNT(*) as Registros FROM proveedores
UNION ALL
SELECT 'tipo_insumo', COUNT(*) FROM tipo_insumo
UNION ALL
SELECT 'sucursales', COUNT(*) FROM sucursales
UNION ALL
SELECT 'insumos', COUNT(*) FROM insumos
UNION ALL
SELECT 'entregas', COUNT(*) FROM entregas
UNION ALL
SELECT 'detalle_entrega', COUNT(*) FROM detalle_entrega
UNION ALL
SELECT 'control_recepcion', COUNT(*) FROM control_recepcion;