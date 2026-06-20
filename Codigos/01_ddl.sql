CREATE TABLE "HOTEL" (
  "id_hotel" int PRIMARY KEY,
  "nombre" varchar,
  "estrellas" int,
  "telefono" varchar,
  "ciudad" varchar
);

CREATE TABLE "TIPO_HABITACION" (
  "id_tipo" int PRIMARY KEY,
  "id_hotel" int,
  "nombre" varchar,
  "descripcion" varchar,
  "capacidad_max" int,
  "precio_noche" float
);

CREATE TABLE "HABITACION" (
  "id_habitacion" int PRIMARY KEY,
  "id_tipo" int,
  "numero" int,
  "piso" int,
  "estado" varchar
);

CREATE TABLE "HUESPED" (
  "id_huesped" int PRIMARY KEY,
  "nombre" varchar,
  "dui" varchar,
  "email" varchar,
  "nacionalidad" varchar
);

CREATE TABLE "EMPLEADO" (
  "id_empleado" int PRIMARY KEY,
  "nombre" varchar,
  "apellido" varchar,
  "puesto" varchar
);

CREATE TABLE "RESERVACION" (
  "id_reservacion" int PRIMARY KEY,
  "id_habitacion" int,
  "id_huesped" int,
  "id_empleado" int,
  "estado" varchar,
  "fecha_inicio" date,
  "fecha_fin" date,
  "num_huespedes" int
);

CREATE TABLE "FACTURA" (
  "id_factura" int PRIMARY KEY,
  "id_reservacion" int UNIQUE,
  "total" float,
  "pago" float,
  "descuento" float,
  "fecha_emision" date,
  "metodo_pago" varchar
);

CREATE TABLE "CHECKIN_CHECKOUT" (
  "id_movimiento" int PRIMARY KEY,
  "id_reservacion" int,
  "id_empleado" int,
  "tipo" varchar,
  "fecha_hora" timestamp
);

CREATE TABLE "SERVICIO" (
  "id_servicio" int PRIMARY KEY,
  "nombre" varchar,
  "precio" float,
  "categoria" varchar
);

CREATE TABLE "CONSUMO_SERVICIO" (
  "id_consumo" int PRIMARY KEY,
  "id_reservacion" int,
  "id_servicio" int,
  "id_empleado" int,
  "fecha_consumo" date,
  "cantidad" int,
  "precio_unit" float
);

ALTER TABLE "TIPO_HABITACION" ADD FOREIGN KEY ("id_hotel") REFERENCES "HOTEL" ("id_hotel") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "HABITACION" ADD FOREIGN KEY ("id_tipo") REFERENCES "TIPO_HABITACION" ("id_tipo") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "RESERVACION" ADD FOREIGN KEY ("id_habitacion") REFERENCES "HABITACION" ("id_habitacion") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "RESERVACION" ADD FOREIGN KEY ("id_huesped") REFERENCES "HUESPED" ("id_huesped") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "RESERVACION" ADD FOREIGN KEY ("id_empleado") REFERENCES "EMPLEADO" ("id_empleado") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "FACTURA" ADD FOREIGN KEY ("id_reservacion") REFERENCES "RESERVACION" ("id_reservacion") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "CHECKIN_CHECKOUT" ADD FOREIGN KEY ("id_reservacion") REFERENCES "RESERVACION" ("id_reservacion") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "CHECKIN_CHECKOUT" ADD FOREIGN KEY ("id_empleado") REFERENCES "EMPLEADO" ("id_empleado") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "CONSUMO_SERVICIO" ADD FOREIGN KEY ("id_reservacion") REFERENCES "RESERVACION" ("id_reservacion") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "CONSUMO_SERVICIO" ADD FOREIGN KEY ("id_empleado") REFERENCES "EMPLEADO" ("id_empleado") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "CONSUMO_SERVICIO" ADD FOREIGN KEY ("id_servicio") REFERENCES "SERVICIO" ("id_servicio") DEFERRABLE INITIALLY IMMEDIATE;
