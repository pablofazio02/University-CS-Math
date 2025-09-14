
/*
Grupo: DBGang
Integrantes: Pablo Fazio Arrabal, Emilio Gómez Esteban, Nuria Pedrosa Ortigosa y Lázaro Vargas García
*/

--------- INICIALIZACIÓN ADMINISTRACIÓN LIFEFIT ------------------------------------------------

-- Desde system

-- Creamos el tablespace TS_LIFEFIT
create tablespace TS_LIFEFIT datafile 'ts_lifefit.dbf' 
size 100M 
autoextend on next 50M;

--Creamos un rol Administrador para dárselo al usuario LIFEFIT
create role r_administrador;
grant connect to r_administrador;
grant create table, create view, create materialized view, 
      create sequence, create procedure to r_administrador;
grant create any index to r_administrador;
grant create user to r_administrador;
grant create public synonym to r_administrador;

--Creamos un usuario LIFEFIT con la contraseña lifefit y tablespace TS_LIFEFIT
create user LIFEFIT identified by lifefit
quota 100M on TS_LIFEFIT
default tablespace TS_LIFEFIT;

grant drop user to lifefit;
grant alter user to lifefit;
grant create user to lifefit; --para el execute immediate

--Y le asignamos el rol Administrador
grant r_administrador to LIFEFIT;

--Creamos el tablespace ts_indices con 50M
create tablespace TS_INDICES datafile 'ts_indices.dbf' size 50M;

--Asignamos quota a lifefit 
alter user LIFEFIT quota 50M on TS_INDICES;


--NOTA: el script genera una serie de triggers que desconocemos
--Tenemos entonces que hacer grant create trigger a administrador
grant create trigger to r_administrador;


--Ahora ejecutamos el script en una conexión LIFEFIT para crear las tablas

-- Generado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   en:        2024-03-16 10:42:52 CET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE centro (
    id        NUMBER NOT NULL,
    nombre    VARCHAR2(30) NOT NULL,
    direccion VARCHAR2(70),
    cpostal   NUMBER
);

ALTER TABLE centro ADD CONSTRAINT centro_pk PRIMARY KEY ( id );

CREATE TABLE cita (
    fechayhora DATE NOT NULL,
    entrenador_id         NUMBER NOT NULL,
    modalidad  VARCHAR2(30),
    cliente_id NUMBER NOT NULL
);

ALTER TABLE cita ADD CONSTRAINT cita_pk PRIMARY KEY ( fechayhora,
                                                      entrenador_id );

CREATE TABLE cliente (
    id           NUMBER NOT NULL,
    objetivo     VARCHAR2(50) NOT NULL,
    preferencias VARCHAR2(50),
    dieta_id     NUMBER,
    centro_id    NUMBER NOT NULL
);

ALTER TABLE cliente ADD CONSTRAINT cliente_pk PRIMARY KEY ( id );

CREATE TABLE conforman (
    series       NUMBER,
    repeticiones NUMBER,
    duracion     DATE,
    rutina_id    NUMBER NOT NULL,
    ejercicio_id NUMBER NOT NULL
);

ALTER TABLE conforman ADD CONSTRAINT conforman_pk PRIMARY KEY ( rutina_id,
                                                                ejercicio_id );

CREATE TABLE dieta (
    id          NUMBER NOT NULL,
    nombre      VARCHAR2(20) NOT NULL,
    descripción VARCHAR2(100),
    tipo        VARCHAR2(20)
);

ALTER TABLE dieta ADD CONSTRAINT dieta_pk PRIMARY KEY ( id );

ALTER TABLE dieta ADD CONSTRAINT dieta_nombre_un UNIQUE ( nombre );

CREATE TABLE ejercicio (
    id          NUMBER NOT NULL,
    nombre      VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(500),
    video       VARCHAR2(500),
    imagen      VARCHAR2(500)
);

ALTER TABLE ejercicio ADD CONSTRAINT ejercicio_pk PRIMARY KEY ( id );

CREATE TABLE elemento_calendario (
    fechayhora    DATE NOT NULL,
    entrenador_id NUMBER NOT NULL
);

ALTER TABLE elemento_calendario ADD CONSTRAINT elemento_calendario_pk PRIMARY KEY ( fechayhora,
                                                                                    entrenador_id );

CREATE TABLE entrena (
    especialidad  VARCHAR2(30),
    cliente_id    NUMBER NOT NULL,
    entrenador_id NUMBER NOT NULL
);

ALTER TABLE entrena ADD CONSTRAINT entrena_pk PRIMARY KEY ( cliente_id,
                                                            entrenador_id );

CREATE TABLE entrenador (
    id             NUMBER NOT NULL,
    disponibilidad VARCHAR2(70),
    centro_id      NUMBER NOT NULL
);

ALTER TABLE entrenador ADD CONSTRAINT entrenador_pk PRIMARY KEY ( id );

CREATE TABLE gerente (
    id        NUMBER NOT NULL,
    despacho  VARCHAR2(20),
    horario   VARCHAR2(50),
    centro_id NUMBER NOT NULL
);

CREATE UNIQUE INDEX gerente__idx ON
    gerente (
        centro_id
    ASC );

ALTER TABLE gerente ADD CONSTRAINT gerente_pk PRIMARY KEY ( id );

CREATE TABLE plan (
    inicio                DATE NOT NULL,
    fin                   DATE,
    entrena_cliente_id    NUMBER NOT NULL,
    entrena_entrenador_id NUMBER NOT NULL,
    rutina_id             NUMBER NOT NULL
);

ALTER TABLE plan
    ADD CONSTRAINT plan_pk PRIMARY KEY ( inicio,
                                         entrena_cliente_id,
                                         entrena_entrenador_id,
                                         rutina_id );

CREATE TABLE rutina (
    id          NUMBER NOT NULL,
    nombre      VARCHAR2(20) NOT NULL,
    descripción VARCHAR2(100)
);

ALTER TABLE rutina ADD CONSTRAINT rutina_pk PRIMARY KEY ( id );

CREATE TABLE sesion (
    inicio                     DATE NOT NULL,
    fin                        DATE,
    presencial                 CHAR(1),
    descripcion                VARCHAR2(100),
    video                      VARCHAR2(500),
    datos_salud                VARCHAR2(100),
    plan_inicio                DATE NOT NULL,
    plan_entrena_cliente_id    NUMBER NOT NULL,
    plan_entrena_entrenador_id NUMBER NOT NULL,
    plan_rutina_id             NUMBER NOT NULL
);

ALTER TABLE sesion
    ADD CONSTRAINT sesion_pk PRIMARY KEY ( inicio,
                                           plan_inicio,
                                           plan_entrena_cliente_id,
                                           plan_entrena_entrenador_id,
                                           plan_rutina_id );

CREATE TABLE usuario (
    id            NUMBER NOT NULL,
    nombre        VARCHAR2(40) NOT NULL,
    apellidos     VARCHAR2(60) NOT NULL,
    telefono      NUMBER NOT NULL,
    direccion     VARCHAR2(70),
    correoe       VARCHAR2(30),
    usuariooracle VARCHAR2(20),
    tipo          VARCHAR2(15)
);

ALTER TABLE usuario ADD CONSTRAINT usuario_pk PRIMARY KEY ( id );

ALTER TABLE cita
    ADD CONSTRAINT cita_cliente_fk FOREIGN KEY ( cliente_id )
        REFERENCES cliente ( id );

ALTER TABLE cita
    ADD CONSTRAINT cita_elem_calendario_fk FOREIGN KEY ( fechayhora,
                                                         entrenador_id )
        REFERENCES elemento_calendario ( fechayhora,
                                         entrenador_id );

ALTER TABLE cliente
    ADD CONSTRAINT cliente_centro_fk FOREIGN KEY ( centro_id )
        REFERENCES centro ( id );

ALTER TABLE cliente
    ADD CONSTRAINT cliente_dieta_fk FOREIGN KEY ( dieta_id )
        REFERENCES dieta ( id );

ALTER TABLE cliente
    ADD CONSTRAINT cliente_usuario_fk FOREIGN KEY ( id )
        REFERENCES usuario ( id );

ALTER TABLE conforman
    ADD CONSTRAINT conforman_ejercicio_fk FOREIGN KEY ( ejercicio_id )
        REFERENCES ejercicio ( id );

ALTER TABLE conforman
    ADD CONSTRAINT conforman_rutina_fk FOREIGN KEY ( rutina_id )
        REFERENCES rutina ( id );

ALTER TABLE elemento_calendario
    ADD CONSTRAINT elem_calendario_entrenador_fk FOREIGN KEY ( entrenador_id )
        REFERENCES entrenador ( id );

ALTER TABLE entrena
    ADD CONSTRAINT entrena_cliente_fk FOREIGN KEY ( cliente_id )
        REFERENCES cliente ( id );

ALTER TABLE entrena
    ADD CONSTRAINT entrena_entrenador_fk FOREIGN KEY ( entrenador_id )
        REFERENCES entrenador ( id );

ALTER TABLE entrenador
    ADD CONSTRAINT entrenador_centro_fk FOREIGN KEY ( centro_id )
        REFERENCES centro ( id );

ALTER TABLE entrenador
    ADD CONSTRAINT entrenador_usuario_fk FOREIGN KEY ( id )
        REFERENCES usuario ( id );

ALTER TABLE gerente
    ADD CONSTRAINT gerente_centro_fk FOREIGN KEY ( centro_id )
        REFERENCES centro ( id );

ALTER TABLE gerente
    ADD CONSTRAINT gerente_usuario_fk FOREIGN KEY ( id )
        REFERENCES usuario ( id );

ALTER TABLE plan
    ADD CONSTRAINT plan_entrena_fk FOREIGN KEY ( entrena_cliente_id,
                                                 entrena_entrenador_id )
        REFERENCES entrena ( cliente_id,
                             entrenador_id );

ALTER TABLE plan
    ADD CONSTRAINT plan_rutina_fk FOREIGN KEY ( rutina_id )
        REFERENCES rutina ( id );

ALTER TABLE sesion
    ADD CONSTRAINT sesion_plan_fk FOREIGN KEY ( plan_inicio,
                                                plan_entrena_cliente_id,
                                                plan_entrena_entrenador_id,
                                                plan_rutina_id )
        REFERENCES plan ( inicio,
                          entrena_cliente_id,
                          entrena_entrenador_id,
                          rutina_id );

CREATE OR REPLACE TRIGGER arc_fkarc_1_gerente BEFORE
    INSERT OR UPDATE OF id ON gerente
    FOR EACH ROW
DECLARE
    d VARCHAR2(15);
BEGIN
    SELECT
        a.tipo
    INTO d
    FROM
        usuario a
    WHERE
        a.id = :new.id;

    IF ( d IS NULL OR d <> 'gerente' ) THEN
        raise_application_error(-20223, 'FK GERENTE_USUARIO_FK in Table GERENTE violates Arc constraint on Table USUARIO - discriminator column Tipo doesn''t have value ''gerente'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER arc_fkarc_1_entrenador BEFORE
    INSERT OR UPDATE OF id ON entrenador
    FOR EACH ROW
DECLARE
    d VARCHAR2(15);
BEGIN
    SELECT
        a.tipo
    INTO d
    FROM
        usuario a
    WHERE
        a.id = :new.id;

    IF ( d IS NULL OR d <> 'entrenador' ) THEN
        raise_application_error(-20223, 'FK ENTRENADOR_USUARIO_FK in Table ENTRENADOR violates Arc constraint on Table USUARIO - discriminator column Tipo doesn''t have value ''entrenador'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER arc_fkarc_1_cliente BEFORE
    INSERT OR UPDATE OF id ON cliente
    FOR EACH ROW
DECLARE
    d VARCHAR2(15);
BEGIN
    SELECT
        a.tipo
    INTO d
    FROM
        usuario a
    WHERE
        a.id = :new.id;

    IF ( d IS NULL OR d <> 'cliente' ) THEN
        raise_application_error(-20223, 'FK CLIENTE_USUARIO_FK in Table CLIENTE violates Arc constraint on Table USUARIO - discriminator column Tipo doesn''t have value ''cliente'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            14
-- CREATE INDEX                             1
-- ALTER TABLE                             33
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           3
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

-- Desde LIFEFIT
--Cambiamos el tablespace de los índices para llevarlos a TS_INDICES

ALTER INDEX CENTRO_PK REBUILD TABLESPACE TS_INDICES;
ALTER INDEX CITA_PK REBUILD TABLESPACE TS_INDICES;
ALTER INDEX CLIENTE_PK REBUILD TABLESPACE TS_INDICES;
ALTER INDEX CONFORMAN_PK REBUILD TABLESPACE TS_INDICES;
ALTER INDEX DIETA_PK REBUILD TABLESPACE TS_INDICES;
ALTER INDEX DIETA_NOMBRE_UN REBUILD TABLESPACE TS_INDICES;
ALTER INDEX EJERCICIO_PK REBUILD TABLESPACE TS_INDICES;
ALTER INDEX ELEMENTO_CALENDARIO_PK REBUILD TABLESPACE TS_INDICES;
ALTER INDEX ENTRENA_PK REBUILD TABLESPACE TS_INDICES;
ALTER INDEX ENTRENADOR_PK REBUILD TABLESPACE TS_INDICES;
ALTER INDEX GERENTE__IDX REBUILD TABLESPACE TS_INDICES;
ALTER INDEX GERENTE_PK REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PLAN_PK REBUILD TABLESPACE TS_INDICES;
ALTER INDEX RUTINA_PK REBUILD TABLESPACE TS_INDICES;
ALTER INDEX SESION_PK REBUILD TABLESPACE TS_INDICES;
ALTER INDEX USUARIO_PK REBUILD TABLESPACE TS_INDICES;

---------------TABLAS EXTERNA EJERCICIO----------------------------------

--Tenemos que traernos los datos de las tablas externas
--Usuarios y Centros lo hacemos manualmente importando datos
--Para Ejercicios, creamos la tabla externa:

--En system
create or replace directory directorio_ext as 'C:\app\alumnos\admin\orcl\dpdump';
grant read, write on directory directorio_ext to r_administrador;

--En LIFEFIT
CREATE TABLE ejercicios_ext
(
    ejercicio VARCHAR2(100),
    descripcion VARCHAR2(500),
    video VARCHAR2(200)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY directorio_ext
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        CHARACTERSET UTF8
        FIELDS TERMINATED BY ';'
        OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
        (ejercicio CHAR(100), descripcion CHAR(500), video CHAR(200))
    )

LOCATION ('Ejercicios.csv'));


-----------------------------INDICES----------------------------------

--Los ID de los centros en la tabla cliente se repiten a menudo -> bitmap
create bitmap index idx_codigo_centro on cliente(centro_id) tablespace TS_INDICES;

--Los apellidos de los usuarios se repiten -> bitmap
create bitmap index idx_upper_apellidos on usuario(upper(apellidos)) tablespace TS_INDICES;

--Los correos electrónicos son únicos -> btree
create index idx_email on usuario(correoe) tablespace TS_INDICES;

--Un bitmap para indice tipos porque se repite mucho
create bitmap index idx_tipo on usuario(tipo) tablespace TS_INDICES;

-- Uno para que el usuario oracle sea único
create unique index idx_usuariooracle on usuario(usuariooracle) tablespace TS_INDICES;

-----------------CONSTRAINTS-----------------------

ALTER TABLE USUARIO ADD CONSTRAINT TIPO_CK CHECK (tipo in ('cliente','gerente','entrenador')) ENABLE;
ALTER TABLE SESION  ADD CONSTRAINT TIEMPO_CK CHECK  (fin >= inicio or fin is null) ENABLE;
ALTER TABLE SESION ADD CONSTRAINT PRESENCIAL_CK CHECK (presencial in ('S','N')) ENABLE;
ALTER TABLE PLAN  ADD CONSTRAINT TIEMPOPLAN_CK CHECK  (fin >= inicio or fin is null) ENABLE;
ALTER TABLE CONFORMAN ADD CONSTRAINT SERIES_CK CHECK  (series>0 or series is null) ENABLE;
ALTER TABLE CONFORMAN ADD CONSTRAINT REPES_CK CHECK  (repeticiones>0 or repeticiones is null) ENABLE


-----------------------VISTA MATERIALIZADA EJERCICIOS----------------------------------

--creamos una vista que se refresque todos los días a las 00:00
create materialized view VM_EJERCICIOS refresh force on demand 
start with trunc(sysdate)     
next trunc(sysdate) + 1       
as select * from ejercicios_ext;


--------------------------SINÓNIMOS---------------------------------------------------

create public synonym s_ejercicios for vm_ejercicios;


-----------------------RELLENAR TABLA EJERCICIOS CON LA VM------------

--Para dar IDs a los ejercicios que se inserten
create sequence seq_ejercicios start with 1 increment by 1;

--Trigger para dar ID a los ejercicios que lleguen a EJERCICIOS
create or replace trigger TR_EJERCICIOS
before insert on EJERCICIO for each row
begin
if :new.ID is null then
   :new.ID := SEQ_EJERCICIOS.NEXTVAL;
end if;
END tr_EJERCICIOS;
/

--Migramos la MV en la tabla EJERCICIO
insert into EJERCICIO (nombre, descripcion, video)
select  ejercicio as nombre, descripcion as descripcion, video as video
from VM_EJERCICIOS;

------------------SECUENCIAS para los ID de USUARIOS----------------

--Para dar IDs a los usuarios que se inserten
create sequence seq_id start with 1010 increment by 1;



-----------------------ENCRIPTACIÓN DE UNA COLUMNA---------------------

-- alter system set "WALLET_ROOT"='C:\app\alumnos\admin\orcl\xdb_wallet' scope=SPFILE;
-- --Ahora vamos a servicios, buscamos OracleServiceORCL y reiniciamos
-- alter system set TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE" scope=both;

-- Desde LIFEFIT ejecutamos
alter table usuario modify (nombre ENCRYPT);

-- Comprobamos desde lifefit
select * from user_encrypted_columns;

-----------------------ROLES Y SUS PRIVILEGIOS --------------------------

-- DESDE SYSTEM--
create role r_gerente;
create role r_entrenador_deporte;
create role r_entrenador_nutricion;
create role r_cliente;

--para los immediate execute
grant r_cliente to lifefit with admin option;
grant r_entrenador_deporte to lifefit with admin option;
grant r_entrenador_nutricion to lifefit with admin option;
grant r_gerente to lifefit with admin option;

--Permisos de conexión
grant connect to r_gerente, r_entrenador_deporte, r_entrenador_nutricion, r_cliente;

-----------------------VPD--------------------------

--Para que cada usuario solo pueda ver sus datos de USUARIO,
--desde LIFEFIT ejecutamos
create or replace view v_usuario as select * from usuario with check option;

create public synonym v_usuario for v_usuario;
grant select on v_usuario to public;


create or replace function vpd_function(p_schema varchar2, p_obj varchar2)
  Return varchar2
is
  Vusuario VARCHAR2(100);
Begin
  Vusuario := SYS_CONTEXT('userenv', 'SESSION_USER');
  RETURN  '''' || Vusuario || ''' = ''LIFEFIT'' OR UPPER(USUARIOORACLE) = ''' || Vusuario || '''';
End;
/

--desde system
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'LIFEFIT',
        object_name => 'V_USUARIO',
        policy_name => 'POLITICA_USUARIO',
        function_schema => 'LIFEFIT',
        policy_function => 'vpd_function'
    );
END;
/

-- Desde lifefit

--Pero un gerente puede ver la información de todos usuarios de su centro
create or replace view v_usuario_gerente as
    select  c.id, nombre, apellidos, telefono, direccion, correoe from usuario join cliente c
    on usuario.id=c.id where centro_id = (select centro_id from gerente join usuario using(id) where upper(usuariooracle) = user)
        union
    select  e.id, nombre, apellidos, telefono, direccion, correoe from usuario join entrenador e
    on usuario.id=e.id where centro_id =  (select centro_id from gerente join usuario using(id) where upper(usuariooracle) = user) with check option;

grant select on v_usuario_gerente to r_gerente;


-----------------------REQUISITOS FUNCIONALES----------------------------------

        -------------RF1-----------------

--CRUD a entrenadores de deporte en Ejercicio
grant select, update, insert, delete on EJERCICIO to r_entrenador_deporte;

--Campo PÚBLICO en los ejercicios (por defecto será público)
alter table EJERCICIO add (PUBLICO CHAR(1) default 'S');
update EJERCICIO set PUBLICO='S';
--Y añadimos una restricción check para que solo pueda ser S o N
alter table EJERCICIO add constraint EJERCICIO_CK1 check (PUBLICO in ('S', 'N'));


--Creamos vista de ejercicios públicos
create view VEJERCICIO as select * from EJERCICIO where PUBLICO='S';
--NOTA: Al ser públicos, hemos decidido que sean accesibles por PUBLIC
grant select on VEJERCICIO to public;
--NOTA: para que el resto de usuarios no tenga que hacer LIFEFIT.VEJERCICIO
create public synonym S_VEJERCICIO for VEJERCICIO; 

        -------------RF3-----------------

--CRUD a entrenador deporte en Rutinas
grant select, update, delete, insert on RUTINA to r_entrenador_deporte;

--CRUD a entrenador deporte en la tabla que relaciona rutinas y ejercicios ("series", "repeticiones", "duración")
grant select, update, delete, insert on CONFORMAN to r_entrenador_deporte;

        -------------RF2-----------------

--CRUD a Gerente en la tabla que relaciona entrenadores y clientes
  --tenemos que hacer una vista para que los gerentes manipulen 
  --la información de los entrenadores de su centro
create or replace view V_ENTRENA_GERENTE as select * from ENTRENA where ENTRENADOR_ID in
(select id from entrenador where centro_id = (select centro_id from gerente join usuario using(id) where upper(usuariooracle) = user)) with check option;

grant select, update, delete, insert on V_ENTRENA_GERENTE to r_gerente;


        -------------RF4-----------------

--CRUD a entrenadores en planes, rutinas y sesiones de clientes
grant select, delete, insert on RUTINA to r_entrenador_nutricion;

           --los entrenadores pueden manejar los planes que tengan su ID solo
create or replace view V_PLANES_ENTRENADOR as select inicio,fin,entrena_cliente_id, rutina_id from PLAN 
where entrena_ENTRENADOR_ID = (select id from usuario where upper(usuariooracle) = user) with check option;

grant select, delete, insert on V_PLANES_ENTRENADOR to r_entrenador_deporte, r_entrenador_nutricion;
grant update(fin) on V_PLANES_ENTRENADOR to r_entrenador_deporte, r_entrenador_nutricion;
create or replace trigger tr_planes_entrenador
instead of insert on V_PLANES_ENTRENADOR
begin
    insert into PLAN values (:new.inicio, :new.fin, :new.entrena_cliente_id, (select id from usuario where upper(usuariooracle) = user), :new.rutina_id);
end;
/

-------

--NOTA: hemos decidido añadir un campo "estado" a la tabla sesión
--que solo sea "hecho" o "parcial" o "saltado"
alter table SESION add (ESTADO VARCHAR2(10));
alter table SESION add constraint SESION_CK1 check (ESTADO in ('HECHO', 'PARCIAL', 'SALTADO'));

              --los entrenadores manejar ver las sesiones que tengan su ID solo
create or replace view V_SESION_ENTRENADOR as select inicio,plan_inicio,fin, plan_entrena_cliente_id, plan_rutina_id, presencial, descripcion,video,datos_salud,estado from SESION 
where PLAN_ENTRENA_entrenador_ID = (select id from usuario where upper(usuariooracle) = USER) with check option;

grant select, delete, insert on V_SESION_ENTRENADOR to r_entrenador_deporte, r_entrenador_nutricion;
grant update(fin,presencial,descripcion,video,datos_salud,estado) on V_SESION_ENTRENADOR to r_entrenador_deporte, r_entrenador_nutricion;


create or replace trigger tr_SESION_entrenador
instead of insert on V_SESION_ENTRENADOR
begin
    insert into SESION values (:new.inicio, :new.fin, :new.presencial, :new.descripcion, :new.video, :new.datos_salud, :new.plan_inicio, :new.plan_entrena_cliente_id, (select id from usuario where upper(usuariooracle) = user), :new.plan_rutina_id, :new.estado);
end;
/

        -------------RFEXTRA-----------------


--NOTA: los siguientes permisos NO están explícitamente pedidos en el enunciado
--Están en el comienzo de la página

     --los gerentes pueden ver la info de su centro
create or replace view v_centro_gerente as 
select * from centro where id = (select centro_id from gerente join usuario using(id) where upper(usuariooracle) = user) with check option;

grant select on v_centro_gerente to r_gerente;

        --los entrenadores de nutricion pueden ver las dietas de sus clientes
create or replace view v_dieta_entrenador as 
select c.id, d.nombre, d.descripción, d.tipo from dieta d join cliente c on d.id = c.dieta_id where d.id in (
    select dieta_id from cliente where id in (
        select cliente_id from entrena where entrenador_id = (
            select id from usuario where upper(usuariooracle) = user))) with check option;

grant select on v_dieta_entrenador to r_entrenador_nutricion;


----------------MÁS PERMISOS (nivel físico parte 3)-----------------


      -----------RF5 CLIENTES------------

--Gestión del estado personal del cliente
--Visualización de sus sesiones 
create view V_CLIENTE_SESIONES as select 
inicio, fin, plan_entrena_entrenador_id, presencial, descripcion, video, datos_salud, estado
from SESION where PLAN_ENTRENA_CLIENTE_ID = (select id from usuario where upper(usuariooracle) = user) with check option;

grant select on V_CLIENTE_SESIONES to r_cliente;
--Subir multimedia e informar sobre sus entrenamientos
grant update (estado, video) on v_cliente_sesiones to r_cliente;

--Datos de salud: añadimos IMC(>0) y enfermedades
alter table CLIENTE add (IMC NUMBER);
alter table CLIENTE add (ENFERMEDADES VARCHAR2(200));
alter table CLIENTE add constraint CLIENTE_CK1 check (IMC > 0 and IMC<150);

--y creamos una vista para que el cliente pueda ver y actualizar sus datos
create view V_CLIENTE_INFO as select objetivo, preferencias, imc, enfermedades
from cliente where id = (select id from usuario where upper(usuariooracle) = user) with check option;

grant select, update on V_CLIENTE_INFO to r_cliente;


  -----------RF6 ENTRENADOR ------------

--Para el trabajo realizado,videos y demás, ya le hicimos CRUD en sesiones a los entrenadores (V_SESION_ENTRENADOR)
-- Función que extrae el ID de sesión
CREATE OR REPLACE FUNCTION EXTRAER_ID_USUARIO (
    P_USUARIO IN VARCHAR2
)
RETURN NUMBER
IS
    V_ID NUMBER;
BEGIN
    SELECT ID INTO V_ID FROM USUARIO WHERE UPPER(USUARIOORACLE)=P_USUARIO;
    RETURN V_ID;
EXCEPTION
    WHEN others THEN
        -- Manejo de excepciones
        RETURN NULL;
END EXTRAER_ID_USUARIO;
/

--Para otros datos físicos y comprobación de objetivos, creamos una vista
create or replace view v_cliente_entrenador_info
    as select id, objetivo, preferencias, IMC, enfermedades from cliente
    where id in (select cliente_id from entrena
    where entrenador_id=extraer_id_usuario(UPPER(USER))) with check option;

grant select on v_cliente_entrenador_info to r_entrenador_deporte, r_entrenador_nutricion;



    -----------RF7 CITAS------------


--Añadimos un nuevo atributo ESTADO a las citas que puede ser "pendiente", o "confirmada"
alter table CITA add (ESTADO VARCHAR2(10));
alter table CITA add constraint CITA_CK1 check (ESTADO in ('PENDIENTE', 'CONFIRMADA'));

-- Un cliente puede anular, pedir o cambiar cita con su entrenador (ENTENDEMOS QUE TAMBIÉN PUEDE VERLAS)
CREATE OR REPLACE VIEW V_CITAS_CLIENTES AS
SELECT entrenador_id , FECHAYHORA, MODALIDAD, ESTADO FROM CITA 
where cliente_id=(SELECT ID FROM USUARIO WHERE UPPER(USUARIOORACLE)=USER) WITH CHECK OPTION;

GRANT SELECT, DELETE, INSERT ON V_CITAS_CLIENTES TO R_CLIENTE;
GRANT UPDATE (FECHAYHORA, MODALIDAD, ESTADO) ON V_CITAS_CLIENTES TO R_CLIENTE;

CREATE OR REPLACE TRIGGER TR_CITAS_CLIENTES
INSTEAD OF INSERT OR UPDATE OR DELETE ON V_CITAS_CLIENTES
BEGIN


    IF INSERTING THEN
        INSERT INTO ELEMENTO_CALENDARIO (FECHAYHORA, ENTRENADOR_ID)
        VALUES (:new.FECHAYHORA, :new.ENTRENADOR_ID);

        INSERT INTO CITA (FECHAYHORA, ENTRENADOR_ID, MODALIDAD, CLIENTE_ID, ESTADO)
        VALUES (:new.FECHAYHORA, :new.ENTRENADOR_ID, :new.MODALIDAD, EXTRAER_ID_USUARIO(UPPER(USER)), :new.ESTADO);

    ELSIF DELETING THEN
        DELETE CITA WHERE fechayhora=:old.fechayhora AND entrenador_id=:old.entrenador_id AND cliente_id=extraer_id_usuario(upper(user));

        DELETE ELEMENTO_CALENDARIO WHERE fechayhora=:old.fechayhora AND entrenador_id=:old.entrenador_id;

    ELSE


        delete from cita where fechayhora=:old.fechayhora and entrenador_id=:old.entrenador_id and cliente_id=extraer_id_usuario(upper(user));

        delete from elemento_calendario where fechayhora=:old.fechayhora and entrenador_id=:old.entrenador_id;
        insert into elemento_calendario values(:new.fechayhora,:new.entrenador_id);

        insert into cita (fechayhora, entrenador_id, modalidad, cliente_id, estado)
        values (:new.fechayhora, :new.entrenador_id, :new.modalidad, extraer_id_usuario(upper(user)), :new.estado);


    END IF;
END TR_CITAS_CLIENTES;
/

-- Entrenador puede ver lista de citas y cambiar estado de estas

CREATE OR REPLACE VIEW V_CITAS_ENTRENADORES AS
SELECT CLIENTE_ID, FECHAYHORA, MODALIDAD,ESTADO FROM CITA 
WHERE ENTRENADOR_ID=(SELECT ID FROM USUARIO WHERE UPPER(USUARIOORACLE)=USER) WITH CHECK OPTION;

GRANT SELECT ON V_CITAS_ENTRENADORES TO R_ENTRENADOR_DEPORTE;
GRANT SELECT ON V_CITAS_ENTRENADORES TO R_ENTRENADOR_NUTRICION;

GRANT UPDATE (FECHAYHORA, ESTADO) ON V_CITAS_ENTRENADORES TO R_ENTRENADOR_DEPORTE;
GRANT UPDATE (FECHAYHORA, ESTADO) ON V_CITAS_ENTRENADORES TO R_ENTRENADOR_NUTRICION;

-- Gestión de la vista

CREATE OR REPLACE TRIGGER TR_CITAS_ENTRENADORES
INSTEAD OF UPDATE ON V_CITAS_ENTRENADORES
BEGIN

        delete from cita where fechayhora=:old.fechayhora and entrenador_id=extraer_id_usuario(upper(user)) and cliente_id=:old.cliente_id;

        delete from elemento_calendario where fechayhora=:old.fechayhora and entrenador_id=extraer_id_usuario(upper(user));
        insert into elemento_calendario values(:new.fechayhora,extraer_id_usuario(upper(user)));

        insert into cita (fechayhora, entrenador_id, modalidad, cliente_id, estado)
        values (:new.fechayhora, extraer_id_usuario(upper(user)), :new.modalidad, :new.cliente_id, :new.estado);

END TR_CITAS_ENTRENADORES;
/

-------------CREACIÓN DE LA TABLA TEMPORAL DE CITAS------------

CREATE GLOBAL TEMPORARY TABLE TABLATEMP (
    ENTRENADOR_ID NUMBER,
    FECHAYHORA DATE
) ON COMMIT DELETE ROWS;

----------------PROCEDIMIENTOS-------------------


create or replace package BASE as

    --las excepciones
    EXCEPCION_CREACION EXCEPTION;
    EXCEPCION_MODIFICACION EXCEPTION;
    EXCEPCION_ELIMINACION EXCEPTION;
    EXCEPCION_LECTURA EXCEPTION;

    --los tipos 
    TYPE TCLIENTE IS RECORD (
        NOMBRE USUARIO.NOMBRE%TYPE,
        APELLIDOS USUARIO.APELLIDOS%TYPE,
        TELEFONO USUARIO.TELEFONO%TYPE,
        DIRECCION USUARIO.DIRECCION%TYPE,
        CORREOE USUARIO.CORREOE%TYPE,
        OBJETIVO CLIENTE.OBJETIVO%TYPE,
        DIETA_ID CLIENTE.DIETA_ID%TYPE,
        PREFERENCIAS CLIENTE.PREFERENCIAS%TYPE,
        CENTRO_ID CLIENTE.CENTRO_ID%TYPE,
        IMC CLIENTE.IMC%TYPE,
        ENFERMEDADES CLIENTE.ENFERMEDADES%TYPE
        );


    TYPE TGERENTE IS RECORD (
        NOMBRE USUARIO.NOMBRE%TYPE,
        APELLIDOS USUARIO.APELLIDOS%TYPE,
        TELEFONO USUARIO.TELEFONO%TYPE,
        DIRECCION USUARIO.DIRECCION%TYPE,
        CORREOE USUARIO.CORREOE%TYPE,
        DESPACHO GERENTE.DESPACHO%TYPE,
        HORARIO GERENTE.HORARIO%TYPE,
        CENTRO_ID GERENTE.CENTRO_ID%TYPE
        );

    TYPE TENTRENADOR IS RECORD (
        NOMBRE USUARIO.NOMBRE%TYPE,
        APELLIDOS USUARIO.APELLIDOS%TYPE,
        TELEFONO USUARIO.TELEFONO%TYPE,
        DIRECCION USUARIO.DIRECCION%TYPE,
        CORREOE USUARIO.CORREOE%TYPE,
        DISPONIBILIDAD ENTRENADOR.DISPONIBILIDAD%TYPE,
        CENTRO_ID ENTRENADOR.CENTRO_ID%TYPE,
        TIPOENTRENADOR VARCHAR2(20)
        );


    --los procedimientos
    PROCEDURE CREA_CLIENTE(
        P_DATOS IN TCLIENTE,
        P_USERPASS IN VARCHAR2,
        P_USUARIO OUT USUARIO%ROWTYPE,
        P_CLIENTE OUT CLIENTE%ROWTYPE
        );

    PROCEDURE CREA_ENTRENADOR(
        P_DATOS IN TENTRENADOR,
        P_USERPASS IN VARCHAR2,
        P_USUARIO OUT USUARIO%ROWTYPE,
        P_ENTRENADOR OUT ENTRENADOR%ROWTYPE
        );

    PROCEDURE CREA_GERENTE(
    P_DATOS IN TGERENTE,
    P_USERPASS IN VARCHAR2,
    P_USUARIO OUT USUARIO%ROWTYPE,
    P_GERENTE OUT GERENTE%ROWTYPE
    );

    PROCEDURE EDITA_USER(
    P_ID IN USUARIO.ID%TYPE,
    P_NUEVONOMBRE IN USUARIO.USUARIOORACLE%TYPE,
    P_CONTRASENA IN VARCHAR2
    );

    PROCEDURE ELIMINA_USER(P_ID USUARIO.ID%TYPE);

    PROCEDURE ELIMINA_CLIENTE(P_ID USUARIO.ID%TYPE);
    PROCEDURE ELIMINA_GERENTE(P_ID USUARIO.ID%TYPE);
    PROCEDURE ELIMINA_ENTRENADOR(P_ID USUARIO.ID%TYPE);

    PROCEDURE ELIMINA_CENTRO(P_ID CENTRO.ID%TYPE);


end ;
/


create or replace PACKAGE BODY BASE AS

    PROCEDURE PROCAUXCREAUSUARIO(
        P_SENTENCIA_CREAR_USUARIO IN VARCHAR2,
        P_SENTENCIA_ROLE IN VARCHAR2,
        V_EXITO OUT NUMBER
        
    ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
    EXECUTE IMMEDIATE P_SENTENCIA_CREAR_USUARIO;
    EXECUTE IMMEDIATE P_SENTENCIA_ROLE;
    V_EXITO:=1;
    EXCEPTION
    WHEN OTHERS THEN
    V_EXITO:=0;
    END PROCAUXCREAUSUARIO;

 PROCEDURE CREA_CLIENTE(
        P_DATOS IN TCLIENTE,
        P_USERPASS IN VARCHAR2,
        P_USUARIO OUT USUARIO%ROWTYPE,
        P_CLIENTE OUT CLIENTE%ROWTYPE
        ) AS
    V_USUARIOORACLE VARCHAR2(100);
    V_SENTENCIA_CREAR_USUARIO VARCHAR2(1000);
    V_SENTENCIA_ROLE VARCHAR2(1000);
    v_exito NUMBER;
    v_id NUMBER;
    BEGIN

    SAVEPOINT INICIO_CREA_CLIENTE;
     v_id := seq_id.nextval;
     v_usuariooracle := p_datos.nombre || v_id;
    INSERT INTO USUARIO (ID, NOMBRE, APELLIDOS, TELEFONO, DIRECCION, CORREOE,USUARIOORACLE,TIPO)
    values (v_id, p_datos.nombre, p_datos.apellidos, p_datos.telefono, p_datos.direccion, p_datos.correoe, v_usuariooracle, 'cliente');
    INSERT INTO CLIENTE (ID, OBJETIVO, PREFERENCIAS, DIETA_ID, CENTRO_ID, IMC, ENFERMEDADES) 
    values (v_id, p_datos.OBJETIVO, p_datos.PREFERENCIAS, p_datos.DIETA_ID, p_datos.CENTRO_ID, p_datos.IMC, p_datos.ENFERMEDADES);
    V_SENTENCIA_CREAR_USUARIO := 'create user '|| v_usuariooracle ||' identified by ' || p_userpass;
    V_SENTENCIA_ROLE := 'grant R_CLIENTE to ' || v_usuariooracle;
    
    --DMBS_OUTPUT.PUT_LINE(V_SENTENCIA_CREAR_USUARIO);
    
    procAuxCreaUsuario(V_SENTENCIA_CREAR_USUARIO, V_SENTENCIA_ROLE, v_exito);

    if v_exito = 0 then
        rollback to INICIO_CREA_CLIENTE;
        RAISE BASE.EXCEPCION_CREACION;
    end if;
    
    select * into p_usuario from usuario where id=v_id;
    select * into p_cliente from cliente where id=v_id;
    
    commit;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT INICIO_CREA_CLIENTE;
        RAISE BASE.EXCEPCION_CREACION;

  END CREA_CLIENTE;

  PROCEDURE CREA_ENTRENADOR(
        P_DATOS IN TENTRENADOR,
        P_USERPASS IN VARCHAR2,
        P_USUARIO OUT USUARIO%ROWTYPE,
        P_ENTRENADOR OUT ENTRENADOR%ROWTYPE
        ) AS
    V_SENTENCIA_CREAR_USUARIO VARCHAR2(1000);
    V_SENTENCIA_ROLE VARCHAR2(1000);
    v_exito NUMBER;
    v_id NUMBER;
    V_USUARIOORACLE VARCHAR2(100);

  BEGIN

    SAVEPOINT INICIO_CREA_ENTRENADOR;

    v_id := seq_id.nextval;
    v_usuariooracle := p_datos.nombre || v_id;

    INSERT INTO USUARIO (ID, NOMBRE, APELLIDOS, TELEFONO, DIRECCION, CORREOE,USUARIOORACLE,TIPO)
    values (v_id, p_datos.nombre, p_datos.apellidos, p_datos.telefono, p_datos.direccion, p_datos.correoe, v_usuariooracle, 'entrenador');
      
    INSERT INTO ENTRENADOR (ID, DISPONIBILIDAD, CENTRO_ID) 
    values (v_id, p_datos.DISPONIBILIDAD, p_datos.CENTRO_ID);
     
    V_SENTENCIA_CREAR_USUARIO := 'create user '|| v_usuariooracle ||' identified by ' || p_userpass;
    V_SENTENCIA_ROLE := 'grant R_ENTRENADOR_NUTRICION, R_ENTRENADOR_DEPORTE to ' || v_usuariooracle;
        
    procAuxCreaUsuario(V_SENTENCIA_CREAR_USUARIO, V_SENTENCIA_ROLE, v_exito);

    if v_exito = 0 then
        rollback to INICIO_CREA_ENTRENADOR;
        RAISE BASE.EXCEPCION_CREACION;
    end if;

    select * into p_usuario from usuario where id=v_id;
    select * into p_entrenador from entrenador where id=v_id;

    commit;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO SAVEPOINT INICIO_CREA_ENTRENADOR;
            RAISE BASE.EXCEPCION_CREACION;

END CREA_ENTRENADOR;

  PROCEDURE CREA_GERENTE(
        P_DATOS IN TGERENTE,
        P_USERPASS IN VARCHAR2,
        P_USUARIO OUT USUARIO%ROWTYPE,
        P_GERENTE OUT GERENTE%ROWTYPE
        ) AS
    V_SENTENCIA_CREAR_USUARIO VARCHAR2(1000);
    V_SENTENCIA_ROLE VARCHAR2(1000);
    v_exito NUMBER;
    v_id NUMBER;
    V_USUARIOORACLE VARCHAR2(100);

  BEGIN

    SAVEPOINT INICIO_CREA_GERENTE;

    v_id := seq_id.nextval;
    v_usuariooracle := p_datos.nombre || v_id;

    INSERT INTO USUARIO (ID, NOMBRE, APELLIDOS, TELEFONO, DIRECCION, CORREOE,USUARIOORACLE,TIPO)
    values (v_id, p_datos.nombre, p_datos.apellidos, p_datos.telefono, p_datos.direccion, p_datos.correoe, v_usuariooracle, 'gerente');
      
    INSERT INTO GERENTE (ID, DESPACHO, HORARIO, CENTRO_ID) 
    values (v_id, p_datos.DESPACHO, p_datos.horario, p_datos.CENTRO_ID);
     
    V_SENTENCIA_CREAR_USUARIO := 'create user '|| v_usuariooracle ||' identified by ' || p_userpass;
    V_SENTENCIA_ROLE := 'grant R_GERENTE to ' || v_usuariooracle;
        
    procAuxCreaUsuario(V_SENTENCIA_CREAR_USUARIO, V_SENTENCIA_ROLE, v_exito);

    if v_exito = 0 then
        rollback to INICIO_CREA_GERENTE;
        RAISE BASE.EXCEPCION_CREACION;
    end if;
    
    select * into p_usuario from usuario where id=v_id;
    select * into p_gerente from gerente where id=v_id;
    
    commit;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO SAVEPOINT INICIO_CREA_GERENTE;
            RAISE BASE.EXCEPCION_CREACION;
END CREA_GERENTE;

  procedure drop_user(
    p_sentencia_drop in varchar2,
    v_exito out number) as

    pragma autonomous_transaction;

    begin
        execute immediate p_sentencia_drop;
        v_exito := 1;
    exception
        when others then
            v_exito := 0;
            raise base.excepcion_eliminacion;
end;


PROCEDURE ELIMINA_USER(P_ID USUARIO.ID%TYPE) AS

   v_sentencia_drop VARCHAR2(1000);
   v_usuariooracle usuario.usuariooracle%type;
   v_exito number;

    BEGIN
        SAVEPOINT INICIO_ELIMINA_USER;

        select usuariooracle into v_usuariooracle from usuario where id=p_id;

        v_sentencia_drop := 'drop user '|| v_usuariooracle || ' cascade';

        drop_user(v_sentencia_drop, v_exito);

        if v_exito = 0 then
            rollback to INICIO_ELIMINA_USER;
            RAISE BASE.EXCEPCION_ELIMINACION;
        end if;

        update usuario set usuariooracle = null where id = p_id;

    commit;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT INICIO_ELIMINA_USER;
        RAISE BASE.EXCEPCION_ELIMINACION;
END ELIMINA_USER;

 PROCEDURE ELIMINA_CLIENTE(P_ID USUARIO.ID%TYPE) AS
    BEGIN

        SAVEPOINT INICIO_ELIMINA_CLIENTE;

        elimina_user(p_id);

        delete from tablatemp;
        insert into tablatemp (select entrenador_id, fechayhora from cita where cliente_id = p_id);
        delete from cita where cliente_id = p_id;
        delete from elemento_calendario where (entrenador_id, fechayhora)  in (select * from tablatemp);
        delete from tablatemp;
        
        delete from sesion where plan_entrena_cliente_id = p_id;
        delete from plan where entrena_cliente_id = p_id;
        delete from entrena where cliente_id = p_id;
        delete from cliente where id = p_id;
        delete from usuario where id = p_id;

        commit;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO SAVEPOINT INICIO_ELIMINA_CLIENTE;
            RAISE BASE.EXCEPCION_ELIMINACION;

  END ELIMINA_CLIENTE;

  PROCEDURE ELIMINA_GERENTE(P_ID USUARIO.ID%TYPE) AS
    BEGIN
        savepoint INICIO_ELIMINA_GERENTE;

            elimina_user(p_id);
            delete from gerente where id = p_id;
            delete from usuario where id=p_id;

            commit;

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK TO SAVEPOINT INICIO_ELIMINA_GERENTE;
                RAISE BASE.EXCEPCION_ELIMINACION;
    END ELIMINA_GERENTE;

  PROCEDURE ELIMINA_ENTRENADOR(P_ID USUARIO.ID%TYPE) AS
    BEGIN
        savepoint INICIO_ELIMINA_ENTRENADOR;

        elimina_user(p_id);
        delete from cita where entrenador_id = p_id;
        delete from elemento_calendario where entrenador_id = p_id;
        delete from sesion where plan_entrena_entrenador_id = p_id;
        delete from plan where entrena_entrenador_id = p_id;
        delete from entrena where entrenador_id = p_id;
        delete from entrenador where id = p_id;
        delete from usuario where id=p_id;


        commit;

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK TO SAVEPOINT INICIO_ELIMINA_ENTRENADOR;
                RAISE BASE.EXCEPCION_ELIMINACION;

  END ELIMINA_ENTRENADOR;

  PROCEDURE ELIMINA_CENTRO(P_ID CENTRO.ID%TYPE) AS

    cursor c_entrenadores is select id from entrenador where centro_id = p_id;
    cursor c_gerentes is select id from gerente where centro_id = p_id;
    cursor c_clientes is select id from cliente where centro_id = p_id;
    
    BEGIN
        savepoint INICIO_ELIMINA_CENTRO;

        for r in c_entrenadores loop
            elimina_entrenador(r.id);
        end loop;

        for r in c_gerentes loop
            elimina_gerente(r.id);
        end loop;

        for r in c_clientes loop
            elimina_cliente(r.id);
        end loop;

    delete from centro where id = p_id;
    commit;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO SAVEPOINT INICIO_ELIMINA_CENTRO;
            RAISE BASE.EXCEPCION_ELIMINACION;
    END elimina_centro;
    

   procedure alter_user(
    p_oldnombre in usuario.usuariooracle%type,
    p_nuevonombre in usuario.usuariooracle%type,
    p_tipo in usuario.tipo%type,
    p_contrasena in varchar2,
    p_exito out number) as

    v_sentencia varchar2(1000);

    pragma autonomous_transaction;

    begin
        execute immediate 'drop user ' || p_oldnombre || ' cascade';
        execute immediate 'create user ' || p_nuevonombre || ' identified by ' || p_contrasena;

        if p_tipo = 'cliente' then
            v_sentencia := 'grant r_cliente to ' || p_nuevonombre;
        elsif p_tipo = 'entrenador' then
            v_sentencia := 'grant r_entrenador_deporte,  r_entrenador_nutricion to ' || p_nuevonombre;
        elsif p_tipo = 'gerente' then
            v_sentencia := 'grant r_gerente to ' || p_nuevonombre;
        end if;

        execute immediate v_sentencia;

        p_exito := 1;

    exception
        when others then
            p_exito := 0;
            raise base.excepcion_modificacion;
end alter_user;


PROCEDURE EDITA_USER(
        P_ID IN USUARIO.ID%TYPE,
        P_NUEVONOMBRE IN USUARIO.USUARIOORACLE%TYPE,
        P_CONTRASENA IN VARCHAR2
    ) AS
        v_oldnombre usuario.nombre%type;
        v_nuevonombre usuario.nombre%type;
        v_tipo usuario.tipo%type;
        v_exito number;
    BEGIN

        SAVEPOINT INICIO_EDITA_USER;

        select usuariooracle into v_oldnombre from usuario where id = p_id;
        select tipo into v_tipo from usuario where id = p_id;
        v_nuevonombre := p_nuevonombre||p_id;

        alter_user(v_oldnombre, v_nuevonombre,v_tipo,p_contrasena, v_exito);

        if v_exito = 0 then
            rollback to INICIO_EDITA_USER;
            RAISE BASE.EXCEPCION_MODIFICACION;
        end if;

        UPDATE USUARIO SET USUARIOORACLE = V_NUEVONOMBRE  WHERE ID = P_ID;

        commit;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO SAVEPOINT INICIO_EDITA_USER;
            RAISE BASE.EXCEPCION_MODIFICACION;
END EDITA_USER;
END BASE;
/

-----------------POLÍTICA DE AUDITORÍA SOBRE CITAS-------------

--debemos asegurarnos de que system tenga los permisos necesarios
--no lo hemos hecho en lifefit porque debiéramos darle el role dba
--pero podría hacerse sin problema

--desde sys
grant audit system, audit_admin, audit_viewer to system;

--desde system 
create audit policy cita_audit
actions
    update on lifefit.cita, 
    delete on lifefit.cita,
    insert on lifefit.cita;
    
    
audit policy cita_audit by users with granted roles r_cliente, r_entrenador_nutricion,r_entrenador_deporte;

--Ahora cuando clientes o entrenadores alteren la tabla
--de citas, quedará reflejado en la unified_audit_trail

--Cada vez que queramos consultar las acciones auditadas:
select event_timestamp, dbusername, action_name from unified_audit_trail 
where object_name = 'CITA';


--Ahora supongamos que tenemos un cliente de id 1072 y un entrenador de id 1071

--desde la conexión del cliente 
    --insert into lifefit.v_citas_clientes values (1071,'07/08/2029', 'mod3', 'PENDIENTE');
    --select * from lifefit.v_citas_clientes;

    --update lifefit.v_citas_clientes set modalidad = 'mod2' where modalidad='mod3';
    --select * from lifefit.v_citas_clientes;

    --commit

--desde la conexión del entrenador 
    --select * from lifefit.v_citas_entrenadores;
    --update lifefit.v_citas_entrenadores set estado = 'CONFIRMADA' where modalidad='mod2';
    --commit;

--desde la conexión del cliente 
    --delete from v_citas_clientes where modalidad='mod2';
    --commit;

-- Desde system

--Podemos ver que, tras estas acciones, el resultado al ejecutar 
select event_timestamp, dbusername, action_name from unified_audit_trail 
where object_name = 'CITA';

--contiene información como : 

    --18/05/24 22:26:47,089000000	CLIENTE11072	INSERT
    --18/05/24 22:28:46,179000000	CLIENTE11072	UPDATE
    --18/05/24 22:32:47,192000000	ENTRENADOR11071	UPDATE
    --18/05/24 22:34:51,159000000	CLIENTE11072	DELETE


------------------- PRUEBAS --------------------------------

    --DESDE LIFEFIT 

--creamos dos dietas
insert into dieta values (
    1, 'mediterranea','','hipocalorica');
    
insert into dieta values (
    2, 'americana', '', 'hipercalorica');

--creamos 2 centros 
insert into centro values (
    1000,'gymPrueba', 'calle agua 1', 29313);

insert into centro values (
    1001,'gymPrueba2', 'calle agua 2', 29313);


--creamos un gerente para cada centro 

DECLARE

    v_datos BASE.TGERENTE;
    v_userpass VARCHAR2(100);
    v_usuario USUARIO%ROWTYPE;
    v_gerente GERENTE%ROWTYPE;
BEGIN
 
    v_datos.NOMBRE := 'gerente1';
    v_datos.APELLIDOS := 'mata';
    v_datos.TELEFONO := 987654321;
    v_datos.DIRECCION := 'Avenida Principal 456';
    v_datos.CORREOE := 'carlos.lopez@example.com';
    v_datos.DESPACHO := '101';
    v_datos.HORARIO := '09:00-17:00';
    v_datos.CENTRO_ID := 1000;

    v_userpass := 'password';

    BASE.CREA_GERENTE(v_datos, v_userpass, v_usuario, v_gerente);

END;
/

DECLARE

    v_datos BASE.TGERENTE;
    v_userpass VARCHAR2(100);
    v_usuario USUARIO%ROWTYPE;
    v_gerente GERENTE%ROWTYPE;
BEGIN
 
    v_datos.NOMBRE := 'gerente2';
    v_datos.APELLIDOS := 'mata';
    v_datos.TELEFONO := 987654321;
    v_datos.DIRECCION := 'Avenida Principal 456';
    v_datos.CORREOE := 'carlos.lopez@example.com';
    v_datos.DESPACHO := '101';
    v_datos.HORARIO := '09:00-17:00';
    v_datos.CENTRO_ID := 1001;

    v_userpass := 'password';

    BASE.CREA_GERENTE(v_datos, v_userpass, v_usuario, v_gerente);
   
END;
/


--creamos dos entrenadores en cada centro

DECLARE
    
    v_datos BASE.TENTRENADOR;
    v_userpass VARCHAR2(100);
    v_usuario USUARIO%ROWTYPE;
    v_entrenador ENTRENADOR%ROWTYPE;
BEGIN
    
    v_datos.NOMBRE := 'entrenador1';
    v_datos.APELLIDOS := 'garcia';
    v_datos.TELEFONO := 123456789;
    v_datos.DIRECCION := 'Calle Falsa 123';
    v_datos.CORREOE := 'juan.perez@example.com';
    v_datos.DISPONIBILIDAD := 'Full-time';
    v_datos.CENTRO_ID := 1000;
    v_datos.TIPOENTRENADOR := 'nutricion';

    v_userpass := 'password';

    BASE.CREA_ENTRENADOR(v_datos, v_userpass, v_usuario, v_entrenador);

END;
/


DECLARE
    
    v_datos BASE.TENTRENADOR;
    v_userpass VARCHAR2(100);
    v_usuario USUARIO%ROWTYPE;
    v_entrenador ENTRENADOR%ROWTYPE;
BEGIN
    
    v_datos.NOMBRE := 'entrenador2';
    v_datos.APELLIDOS := 'garcia';
    v_datos.TELEFONO := 123456789;
    v_datos.DIRECCION := 'Calle Falsa';
    v_datos.CORREOE := 'entr2@example.com';
    v_datos.DISPONIBILIDAD := 'Full-time';
    v_datos.CENTRO_ID := 1000;
    v_datos.TIPOENTRENADOR := 'nutricion';

    v_userpass := 'password';

    BASE.CREA_ENTRENADOR(v_datos, v_userpass, v_usuario, v_entrenador);

END;
/



DECLARE
    
    v_datos BASE.TENTRENADOR;
    v_userpass VARCHAR2(100);
    v_usuario USUARIO%ROWTYPE;
    v_entrenador ENTRENADOR%ROWTYPE;
BEGIN
    
    v_datos.NOMBRE := 'entrenador3';
    v_datos.APELLIDOS := 'garcia';
    v_datos.TELEFONO := 123456789;
    v_datos.DIRECCION := 'Calle Falsa';
    v_datos.CORREOE := 'entr3@example.com';
    v_datos.DISPONIBILIDAD := 'Full-time';
    v_datos.CENTRO_ID := 1001;
    v_datos.TIPOENTRENADOR := 'nutricion';

    v_userpass := 'password';

    BASE.CREA_ENTRENADOR(v_datos, v_userpass, v_usuario, v_entrenador);

END;
/


DECLARE
    
    v_datos BASE.TENTRENADOR;
    v_userpass VARCHAR2(100);
    v_usuario USUARIO%ROWTYPE;
    v_entrenador ENTRENADOR%ROWTYPE;
BEGIN
    
    v_datos.NOMBRE := 'entrenador4';
    v_datos.APELLIDOS := 'garcia';
    v_datos.TELEFONO := 123456789;
    v_datos.DIRECCION := 'Calle Falsa';
    v_datos.CORREOE := 'entr4@example.com';
    v_datos.DISPONIBILIDAD := 'Full-time';
    v_datos.CENTRO_ID := 1001;
    v_datos.TIPOENTRENADOR := 'nutricion';

    v_userpass := 'password';

    BASE.CREA_ENTRENADOR(v_datos, v_userpass, v_usuario, v_entrenador);

END;
/

--creamos dos clientes en cada centro

DECLARE
    
    cliente_datos BASE.TCLIENTE;
    user_pass VARCHAR2(100); 
    usuario_resultado USUARIO%ROWTYPE;
    cliente_resultado CLIENTE%ROWTYPE;
BEGIN

    cliente_datos.NOMBRE := 'cliente1';
    cliente_datos.APELLIDOS := 'vargas';
    cliente_datos.TELEFONO := 123456789;
    cliente_datos.DIRECCION := 'Direccion';
    cliente_datos.CORREOE := 'c1@ejemplo.com';
    cliente_datos.OBJETIVO := 'Objetivo';
    cliente_datos.DIETA_ID := 1; 
    cliente_datos.PREFERENCIAS := 'Preferencias';
    cliente_datos.CENTRO_ID :=  1000; 
    cliente_datos.IMC := 25; 
    cliente_datos.ENFERMEDADES := 'Enfermedades';

    user_pass := 'password'; 
    
    BASE.CREA_CLIENTE(cliente_datos, user_pass, usuario_resultado, cliente_resultado);

    
END;
/


DECLARE
    
    cliente_datos BASE.TCLIENTE;
    user_pass VARCHAR2(100); 
    usuario_resultado USUARIO%ROWTYPE;
    cliente_resultado CLIENTE%ROWTYPE;
BEGIN

    cliente_datos.NOMBRE := 'cliente2';
    cliente_datos.APELLIDOS := 'vargas';
    cliente_datos.TELEFONO := 123456789;
    cliente_datos.DIRECCION := 'Direccion';
    cliente_datos.CORREOE := 'c2@ejemplo.com';
    cliente_datos.OBJETIVO := 'Objetivo';
    cliente_datos.DIETA_ID := 2; 
    cliente_datos.PREFERENCIAS := 'Preferencias';
    cliente_datos.CENTRO_ID :=  1000; 
    cliente_datos.IMC := 25; 
    cliente_datos.ENFERMEDADES := 'Enfermedades';

    user_pass := 'password'; 
    
    BASE.CREA_CLIENTE(cliente_datos, user_pass, usuario_resultado, cliente_resultado);
  
END;
/


DECLARE
    
    cliente_datos BASE.TCLIENTE;
    user_pass VARCHAR2(100); 
    usuario_resultado USUARIO%ROWTYPE;
    cliente_resultado CLIENTE%ROWTYPE;
BEGIN

    cliente_datos.NOMBRE := 'cliente3';
    cliente_datos.APELLIDOS := 'vargas';
    cliente_datos.TELEFONO := 123456789;
    cliente_datos.DIRECCION := 'Direccion';
    cliente_datos.CORREOE := 'c3@ejemplo.com';
    cliente_datos.OBJETIVO := 'Objetivo';
    cliente_datos.DIETA_ID := 1; 
    cliente_datos.PREFERENCIAS := 'Preferencias';
    cliente_datos.CENTRO_ID :=  1001; 
    cliente_datos.IMC := 25; 
    cliente_datos.ENFERMEDADES := 'Enfermedades';

    user_pass := 'password'; 
    
    BASE.CREA_CLIENTE(cliente_datos, user_pass, usuario_resultado, cliente_resultado);
  
END;
/


DECLARE
    
    cliente_datos BASE.TCLIENTE;
    user_pass VARCHAR2(100); 
    usuario_resultado USUARIO%ROWTYPE;
    cliente_resultado CLIENTE%ROWTYPE;
BEGIN

    cliente_datos.NOMBRE := 'cliente4';
    cliente_datos.APELLIDOS := 'vargas';
    cliente_datos.TELEFONO := 123456789;
    cliente_datos.DIRECCION := 'Direccion';
    cliente_datos.CORREOE := 'c4@ejemplo.com';
    cliente_datos.OBJETIVO := 'Objetivo';
    cliente_datos.DIETA_ID := 2; 
    cliente_datos.PREFERENCIAS := 'Preferencias';
    cliente_datos.CENTRO_ID :=  1001; 
    cliente_datos.IMC := 25; 
    cliente_datos.ENFERMEDADES := 'Enfermedades';

    user_pass := 'password'; 
    
    BASE.CREA_CLIENTE(cliente_datos, user_pass, usuario_resultado, cliente_resultado);
  
END;
/


--creamos una rutina
insert into rutina values ( 1, 'rutina1', '');


--hacemos que el entrenador entrenador1 (1012) entrene al cliente1 (1019)
insert into entrena values('zumba', 1019,1012);
--y que tengan un plan para hacer la rutina 1
insert into plan values ('17/05/24', null, 1019,1012,1);
--y que tengan dos sesiones para el plan 
insert into sesion values ('18/05/24','','S','descripcion','video','datos','17/05/24',1019,1012,1,'PARCIAL');
insert into sesion values ('19/05/24','','N','descripcion','video','datos','17/05/24',1019,1012,1,'SALTADO');

--ese mismo entrenador, entrena al cliente2 (1020)
insert into entrena values('tenis', 1020,1012);
--y que tengan un plan para hacer la rutina 1
insert into plan values ('20/05/24', null, 1020,1012,1);
--y que tengan una sesiones para el plan 
insert into sesion values ('21/05/24','','S','descripcion','video','datos','20/05/24',1020,1012,1,'PARCIAL');


--el cliente1 tiene una cita  el dia 28/05/24  con el entrenador1
insert into elemento_calendario values(to_date('28/05/2024 11:00:00', 'DD/MM/YYYY HH24:MI:SS'), 1012);
insert into cita values(to_date('28/05/2024 11:00:00', 'DD/MM/YYYY HH24:MI:SS'), 1012, 'Modalidad 1', 1019, 'CONFIRMADA');
--el cliente2 tiene una cita el mismo d�a a las 10 con el mismo entrenador
insert into elemento_calendario values(to_date('28/05/2024 10:00:00', 'DD/MM/YYYY HH24:MI:SS'), 1012);
insert into cita values(to_date('28/05/2024 10:00:00', 'DD/MM/YYYY HH24:MI:SS'), 1012, 'Modalidad 2', 1020, 'PENDIENTE');

commit;

--ahora ya tenemos algunos datos, podemos empezar a hacer pruebas:

--ASIGNACI�N DE ROLES Y CREACI�N DE USUARIOS CORRECTA 
    --ahora nos hemos conectado desde cliente, entrenador, y gerentes 1 y 2
    --observamos que si hacemos select * from user_role_privs tienen asignado su rol correctamente
    --Adem�s si hacemos all_users aqu�, vemos que est�n todos ellos
    --Esto quiere decir que los procedimientos de creaci�n han funcionado
    --Y si consultamos las tablas, vemos que todo se ha creado correctamente (la inserci�n de datos ha sido correcta)


--VISTA V_USUARIO 
    --Si ejecutamos select * from v_usuario; en todos ellos, solo les aparece su informaci�n de la tabla USUARIO
    --Si lo ejecutamos aqu�, se ve la de todos
    select * from v_usuario;
    

--VISTA lifefit.V_USUARIO_GERENTE para gerentes
    --si ejecutamos en los gerentes select * from lifefit.v_usuario_gerente; pueden ver los 
    --entrenadores y clientes SOLO de su centro correctamente


--VISTA S_V_EJERCICIO de ejercicios p�blicos
    --insertamos un ejercicio privado 
    insert into ejercicio values (20,'ej de zumba','zumba','','','N');
    select * from ejercicio;
    --cualquier usuario puede ver los ejercicios PUBLICOS, no los privados 
    
--CRUD EJERCICIO A ENTRENADOR_DEPORTE
--CRUD DE RUTINA A ENTRENADOR_DEPORTE
--CRUD DE CONFORMAN A ENTRENADOR_DEPORTE
    --en entrenador 1
        --select * from lifefit.ejercicio;
        --select * from lifefit.rutina;
        --select * from lifefit.conforman;
        
        --insert into lifefit.ejercicio values(22,'bachata','baile','','','S');
        --insert into lifefit.rutina values (5,'rutina5','');
        --insert into lifefit.conforman values (2,2,'20/04/24',5,22);
        
        --update lifefit.ejercicio set descripcion='bailar' where nombre='bachata';
        --update lifefit.rutina set descripci�n='desc rutina' where id=5;
        --update lifefit.conforman set series=3 where rutina_id=5;
        
        --delete lifefit.conforman where rutina_id=5;
        --delete lifefit.ejercicio where id=22;
        --delete lifefit.rutina where id=5;
    
--VISTA lifefit.V_ENTRENA_GERENTE 
    --para que los gerentes gestionen la relacion entre sus clientes y entrenadores
    --vemos que funciona, y podemos hacer update, deletes e insert (en gerente1)
        --insert into lifefit.v_entrena_gerente values ('laBorramosAhora', 1020, 1013);
        --select * from lifefit.v_entrena_gerente;
        --update lifefit.v_entrena_gerente set especialidad='borraremos' where entrenador_id=1013;
        --select * from lifefit.v_entrena_gerente;
        --delete from lifefit.v_entrena_gerente where entrenador_id=1013;
        --select * from lifefit.v_entrena_gerente;
        
        
--VISTA lifefit.V_PLANES_ENTRENADOR
    --para que un entrenador maneje los planes que lo tengan como entrenador_id
    --en entrenador1, todo funciona correctamente: 
        --insert into lifefit.v_planes_entrenador values ('29/05/24','30/05/24',1019,1);
        --select * from lifefit.v_planes_entrenador;
        --update lifefit.v_planes_entrenador set fin='01/06/24' where inicio='29/05/24';
        --select * from lifefit.v_planes_entrenador;
        --insert into lifefit.v_planes_entrenador values ('29/05/24','30/05/24',1019,1);
        --select * from lifefit.v_planes_entrenador;
        --delete lifefit.v_planes_entrenador where inicio='29/05/24';
        --select * from lifefit.v_planes_entrenador;
        
        
--VISTA lifefit.V_SESION_ENTRENADOR
    --para que un entrenador maneje las sesiones que lo tengan como entrenador_id
        --select * from lifefit.v_sesion_entrenador;
        --insert into lifefit.v_sesion_entrenador values ('29/05/24','17/05/24','30/05/24',1019,1,'N','','','','SALTADO');
        --select * from lifefit.v_sesion_entrenador;
        --update lifefit.v_sesion_entrenador set fin='01/06/24' where fin='30/05/24';
        --select * from lifefit.v_sesion_entrenador;
        --delete from lifefit.v_sesion_entrenador where fin = '01/06/24';
        --select * from lifefit.v_sesion_entrenador;

    
--VISTA V_CENTRO_GERENTE
    --los gerentes pueden ver la informaci�n de su centro
            --si hacemos select * from lifefit.v_centro_gerente; 
            --en gerente1 y gerente2 vemos que solo ven la info de sus respectivos centros
         
            
--VISTA V_DIETA_ENTRENADOR
    --los entrenadores de nutrici�n pueden ver las dietas que siguen sus clientes
        --en entrenador1, select * from lifefit.v_dieta_entrenador; dice las dietas que siguen cliente1 y cliente2
        
        

--VISTA V_CLIENTE_SESIONES 
    --el cliente ve las sesiones que tiene. En cliente 1:
        --select * from lifefit.v_cliente_sesiones;
        --update lifefit.v_cliente_sesiones set estado='SALTADO' where plan_entrena_entrenador_id=1012;
        --update lifefit.v_cliente_sesiones set video='http' where plan_entrena_entrenador_id=1012;


--VISTA V_CLIENTE_INFO 
    --el cliente ve y actualiza sus datos. En cliente1 :
       --select * from cliente;
       --update lifefit.v_cliente_info set preferencias='tarde-noche' ;
       
       
       
--VISTA V_CLIENTE_ENTRENADOR_INFO
    --entrenadores ven la info de sus clientes. En entrenador1:
        --select * from lifefit.v_cliente_entrenador_info;


--VISTA V_CITAS_CLIENTES
    --cliente puede anular, pedir, cambiar cita con su entrenador (y verla)
        
        --select * from lifefit.v_citas_clientes;
        --insert into lifefit.v_citas_clientes values (1012, '02/06/24', 'mod 1', 'PENDIENTE');
        --update lifefit.v_citas_clientes set fechayhora='03/06/24' where modalidad='mod 1';
        --delete lifefit.v_citas_clientes where fechayhora='03/06/24';


--VISTA V_CITAS_ENTRENADORES
    --entrenador puede ver la lista de citas con sus clientes y update estado y fecha. en entrenador 1:
         --select * from lifefit.v_citas_entrenadores;
        --update lifefit.v_citas_entrenadores set estado='PENDIENTE' where modalidad='Modalidad 1';
        --update lifefit.v_citas_entrenadores set FECHAYHORA='05/06/24' where modalidad='Modalidad 1';
 
    

--el cliente2 quiere cambiar su nombre de usuario a 'SOYCLIENTE2'
--As� que aqu� (sin que cliente2 est� conectado) ejecutamos:
DECLARE
    v_id USUARIO.ID%TYPE;
    v_nombre USUARIO.USUARIOORACLE%TYPE;
    v_contrasena varchar2(1000);
BEGIN

    v_id := 1020; 
    v_nombre:= 'SOYCLIENTE2';
    v_contrasena := 'password';
    BASE.EDITA_USER(v_id, v_nombre, v_contrasena);
END;
/

--vemos que su usuariooracle es 'SOYCLIENTE21020'
select * from usuario;
--y efectivamente su nombre de usuario es ese
select * from all_users;



select * from all_users;
select * from usuario;
select * from cliente;

--ahora vamos a eliminar el cliente 2
DECLARE
    v_id USUARIO.ID%TYPE;
BEGIN

    v_id := 1021; 
    BASE.ELIMINA_CLIENTE(v_id);
 
    DBMS_OUTPUT.PUT_LINE('Cliente con ID ' || v_id || ' eliminado.');

END;
/


DECLARE
    v_id USUARIO.ID%TYPE;
BEGIN

    v_id := 1024; 
    BASE.ELIMINA_GERENTE(v_id);

END;
/

DROP USER gerente21024 cascade;


