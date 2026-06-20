-- ============================================
-- TRIGGER: Verificar disponibilidad de habitación
-- Se ejecuta BEFORE INSERT OR UPDATE en RESERVACION
-- ============================================

CREATE OR REPLACE FUNCTION verificar_disponibilidad()
RETURNS TRIGGER AS $$
BEGIN
  -- Verificar solapamiento con reservaciones activas/pendientes
  IF EXISTS (
    SELECT 1 FROM "RESERVACION"
    WHERE id_habitacion = NEW.id_habitacion
      AND estado IN ('pendiente', 'activa')
      AND id_reservacion <> NEW.id_reservacion  -- excluir la propia fila en UPDATE
      AND fecha_inicio < NEW.fecha_fin
      AND fecha_fin    > NEW.fecha_inicio
  ) THEN
    RAISE EXCEPTION
      'Conflicto: la habitación % ya está reservada entre % y %.',
      NEW.id_habitacion,
      TO_CHAR(NEW.fecha_inicio, 'DD/MM/YYYY'),
      TO_CHAR(NEW.fecha_fin,    'DD/MM/YYYY');
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_disponibilidad
BEFORE INSERT OR UPDATE ON "RESERVACION"
FOR EACH ROW EXECUTE FUNCTION verificar_disponibilidad();

-- ============================================
-- PRUEBA DEL TRIGGER
-- ============================================

-- Caso exitoso (no hay conflicto):
INSERT INTO "RESERVACION"(id_reservacion, id_habitacion, id_huesped, id_empleado,
  estado, fecha_inicio, fecha_fin, num_huespedes)
VALUES (101, 1, 1, 1, 'pendiente', '2026-07-01', '2026-07-05', 2);
-- → Se inserta correctamente

-- Caso de error (fechas que chocan):
INSERT INTO "RESERVACION"(id_reservacion, id_habitacion, id_huesped, id_empleado,
  estado, fecha_inicio, fecha_fin, num_huespedes)
VALUES (102, 1, 2, 1, 'pendiente', '2026-07-03', '2026-07-08', 1);
-- → ERROR: Conflicto: la habitación 1 ya está reservada entre 01/07/2026 y 05/07/2026





