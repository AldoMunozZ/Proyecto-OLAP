DROP DATABASE casadecambio_008;

CREATE DATABASE casadecambio_008;

\c casadecambio_008;

CREATE TABLE CLIENTE(

cliente_id     varchar(10)   not null,
nombre_c       varchar(30)   not null,
app_c          varchar(30)   not null,
apm_c          varchar(30)   not null,

CONSTRAINT pk_cliente PRIMARY KEY (cliente_id)

);

CREATE INDEX index_cl_nombre 
ON  CLIENTE(nombre_c);

CREATE TABLE VENDEDOR(

vendedor_id        varchar(10)  not null,
nombre_v           varchar(30)  not null,
app_v              varchar(30)  not null,
apm_v              varchar(30)  not null,

CONSTRAINT pk_vendedor PRIMARY KEY (vendedor_id)

);

CREATE INDEX index_cl_nombre 
ON  VENDEDOR(nombre_v);

CREATE TABLE PROMOCION(
    
promocion_id       varchar(10)  not null,
nombre_promo      varchar(30)  not null,
promocion_desc     varchar(200) not null,

CONSTRAINT pk_promocion PRIMARY KEY (promocion_id)

);

CREATE TABLE TIEMPO(

tiempo_id          varchar(20)  not null,
tiempo_desc        timestamp    not null,
hora_id            int          not null,
dia_id             int          not null,
mes_id             int          not null,
anio_id            int          not null,

CONSTRAINT pk_tiempo PRIMARY KEY (tiempo_id),
CONSTRAINT hora_range CHECK(0 < hora_id),
CONSTRAINT dia_range CHECK(0 < dia_id),
CONSTRAINT mes_range CHECK(0 < mes_id),
CONSTRAINT anio_range CHECK(1900 < anio_id)

);

CREATE TABLE HECHOS_VENTAS(

tiempo_id          varchar(20)     not null,
cliente_id         varchar(10)     not null,
vendedor_id        varchar(10)     not null,
promocion_id       varchar(10)         null,
cantidad           numeric(19,2)   DEFAULT 0.01,
costo              numeric(19,2)   DEFAULT 0.10,

CONSTRAINT pk_hechos_ventas PRIMARY KEY (tiempo_id, cliente_id, vendedor_id),
CONSTRAINT cantidad_range CHECK(0 < cantidad),
CONSTRAINT costo_range CHECK(0 <= costo)

);

CREATE INDEX index_ventas_cantidad 
ON  HECHOS_VENTAS(cantidad);

CREATE INDEX index_ventas_costo
ON  HECHOS_VENTAS(costo);

ALTER TABLE HECHOS_VENTAS
ADD CONSTRAINT fk_hechos_ventas_promo FOREIGN KEY (promocion_id)
    REFERENCES PROMOCION (promocion_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE HECHOS_VENTAS
    ADD CONSTRAINT fk_hechos_ventas_vendedor FOREIGN KEY (vendedor_id)
    REFERENCES VENDEDOR (vendedor_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE HECHOS_VENTAS
    ADD CONSTRAINT fk_hechos_ventas_cliente FOREIGN KEY (cliente_id)
    REFERENCES CLIENTE (cliente_id)
        ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE HECHOS_VENTAS
    ADD CONSTRAINT fk_hechos_ventas_tiempo FOREIGN KEY (tiempo_id)
    REFERENCES TIEMPO (tiempo_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;

CREATE TABLE HECHOS_DOLAR(

tiempo_id          varchar(20)     not null,
promocion          int             not null,
precio_compra      numeric(7,4)    DEFAULT 10.0000,
precio_venta       numeric(7,4)    DEFAULT 10.0000,

CONSTRAINT promocion_range CHECK(promocion IN (0,1)),
CONSTRAINT precio_compra_range CHECK(0 < precio_compra),
CONSTRAINT precio_venta_range CHECK(0 < precio_venta)

);

CREATE INDEX index_precio_compra
ON  HECHOS_DOLAR(precio_compra);

CREATE INDEX index_precio_venta
ON  HECHOS_DOLAR(precio_venta);

ALTER TABLE HECHOS_DOLAR
    ADD CONSTRAINT fk_hechos_dolar_tiempo FOREIGN KEY (tiempo_id)
    REFERENCES TIEMPO (tiempo_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;

\copy vendedor from 'vendedores.csv' delimiter ',' CSV HEADER;
\copy cliente from 'clientes.csv' delimiter ',' CSV HEADER;
\copy tiempo from 'tiempo.csv' delimiter ',' CSV HEADER;
\copy promocion from 'promocion.csv' delimiter ',' CSV HEADER;
\copy hechos_dolar from 'hdolar.csv' delimiter ',' CSV HEADER;
\copy hechos_ventas from 'ventas.csv' delimiter ',' CSV HEADER;