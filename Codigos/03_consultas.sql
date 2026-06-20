-- ============================================================
-- Verificación de conteos
-- ============================================================
SELECT 'HOTEL'              AS tabla, COUNT(*) AS registros FROM "HOTEL"
UNION ALL SELECT 'TIPO_HABITACION',   COUNT(*) FROM "TIPO_HABITACION"
UNION ALL SELECT 'HABITACION',        COUNT(*) FROM "HABITACION"
UNION ALL SELECT 'HUESPED',           COUNT(*) FROM "HUESPED"
UNION ALL SELECT 'EMPLEADO',          COUNT(*) FROM "EMPLEADO"
UNION ALL SELECT 'SERVICIO',          COUNT(*) FROM "SERVICIO"
UNION ALL SELECT 'RESERVACION',       COUNT(*) FROM "RESERVACION"
UNION ALL SELECT 'CHECKIN_CHECKOUT',  COUNT(*) FROM "CHECKIN_CHECKOUT"
UNION ALL SELECT 'CONSUMO_SERVICIO',  COUNT(*) FROM "CONSUMO_SERVICIO"
UNION ALL SELECT 'FACTURA',           COUNT(*) FROM "FACTURA";


SELECT h.id_habitacion,
       CONCAT('Piso ', h.piso, ' - Hab. ', h.numero) AS ubicacion,
       UPPER(t.nombre)  AS tipo,
       t.capacidad_max  AS capacidad,
       CONCAT('$', t.precio_noche) AS precio_por_noche
FROM "HABITACION" h
JOIN "TIPO_HABITACION" t ON h.id_tipo = t.id_tipo
WHERE h.estado = 'disponible'
  AND h.id_habitacion NOT IN (
    SELECT id_habitacion FROM "RESERVACION"
    WHERE estado IN ('pendiente','activa')
      AND fecha_inicio < '2026-07-15'
      AND fecha_fin    > '2026-07-10'
  )
ORDER BY t.precio_noche ASC;


SELECT h.id_huesped,
       UPPER(CONCAT(h.nombre, ' (', h.nacionalidad, ')')) AS huesped,
       h.email,
       COUNT(r.id_reservacion)  AS total_reservaciones,
       SUM(f.total)             AS gasto_total,
       ROUND(AVG(f.total)::numeric, 2)   AS promedio_por_estancia
FROM "HUESPED" h
JOIN "RESERVACION" r ON h.id_huesped    = r.id_huesped
JOIN "FACTURA" f     ON r.id_reservacion = f.id_reservacion
GROUP BY h.id_huesped, h.nombre, h.nacionalidad, h.email
ORDER BY gasto_total DESC
LIMIT 10;



SELECT UPPER(t.nombre)    AS tipo_habitacion,
       UPPER(s.nombre)    AS servicio,
       s.categoria,
       SUM(cs.cantidad)   AS total_consumido,
       ROUND(SUM(cs.cantidad * cs.precio_unit)::numeric, 2) AS ingreso_generado
FROM "CONSUMO_SERVICIO" cs
JOIN "SERVICIO" s         ON cs.id_servicio    = s.id_servicio
JOIN "RESERVACION" r      ON cs.id_reservacion = r.id_reservacion
JOIN "HABITACION" h       ON r.id_habitacion   = h.id_habitacion
JOIN "TIPO_HABITACION" t  ON h.id_tipo         = t.id_tipo
GROUP BY t.nombre, s.nombre, s.categoria
ORDER BY t.nombre, total_consumido DESC;


SELECT UPPER(t.nombre) AS tipo,
       TO_CHAR(r.fecha_inicio, 'Month YYYY') AS mes,
       EXTRACT(YEAR  FROM r.fecha_inicio)    AS anio,
       EXTRACT(MONTH FROM r.fecha_inicio)    AS nro_mes,
       COUNT(r.id_reservacion)               AS reservaciones_mes,
       (SELECT COUNT(*) FROM "HABITACION" WHERE id_tipo = t.id_tipo) AS total_habitaciones,
       ROUND(
         COUNT(r.id_reservacion) * 100.0 /
         NULLIF((SELECT COUNT(*) FROM "HABITACION" WHERE id_tipo = t.id_tipo), 0)::numeric,
       2) AS tasa_ocupacion_pct
FROM "RESERVACION" r
JOIN "HABITACION" h      ON r.id_habitacion = h.id_habitacion
JOIN "TIPO_HABITACION" t ON h.id_tipo = t.id_tipo
WHERE r.estado IN ('activa','completada')
GROUP BY t.nombre, t.id_tipo, mes, anio, nro_mes
ORDER BY anio, nro_mes, t.nombre;


SELECT TO_CHAR(f.fecha_emision, 'Month')          AS mes,
       EXTRACT(MONTH FROM f.fecha_emision)         AS nro_mes,
       COUNT(f.id_factura)                         AS facturas_emitidas,
       SUM(f.total)                                AS ingresos_brutos,
       SUM(f.descuento)                            AS total_descuentos,
       ROUND((SUM(f.total) - SUM(f.descuento))::numeric, 2) AS ingresos_netos,
       MAX(f.total)                                AS factura_mas_alta,
       ROUND(AVG(f.total)::numeric, 2)                      AS ticket_promedio
FROM "FACTURA" f
WHERE EXTRACT(YEAR FROM f.fecha_emision) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY mes, nro_mes
ORDER BY nro_mes;


