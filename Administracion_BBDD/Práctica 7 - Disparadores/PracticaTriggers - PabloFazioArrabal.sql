/*
1. Cree las dos tablas siguientes:

MENSAJES	 
Codigo	Clave primaria	NUMBER(20)
Texto	Texto del mensaje	VARCHAR2(200)

AUDITA_MENSAJES	 
Quien	usuario que opera	VARCHAR2(20)
Como	Tipo de operacion	VARCHAR2(20)
Cuando	Fecha de operacion	DATE

Mantenga en la tabla AUDITA_MENSAJES tabla todas las operaciones que se han realizado en el esquema de un cierto usuario sobre la tabla MENSAJES. Así, si ONIEVA lanza
INSERT INTO MENSAJES VALUES (12345,'No tiene permiso para operar en este formulario');
se debe guardar una tupla (ONIEVA,INSERT,FECHA) en AUDITA_MENSAJES. Cree un trigger para mantener automáticamente dicha información.
Si la operación resultase en la modificación de varias tuplas, sólo precisaremos guardar la anotación una sola vez por sentencia (no serán triggers de fila).
*/

-- Creamos las dos tablas

CREATE TABLE MENSAJES (
CODIGO NUMBER(20),
TEXTO VARCHAR2(200),
CONSTRAINT MENSAJES_PK PRIMARY KEY (CODIGO)
);

CREATE TABLE AUDITA_MENSAJES (
QUIEN VARCHAR2(20),
COMO VARCHAR2(20),
CUANDO DATE
);

-- Creamos el trigger 

CREATE OR REPLACE TRIGGER TRIGGER_MENSAJES
    AFTER INSERT OR UPDATE OR DELETE ON MENSAJES
BEGIN
IF INSERTING THEN
    INSERT INTO AUDITA_MENSAJES VALUES(SYS_CONTEXT('USERENV','SESSION_USER'), 'INSERT', SYSDATE);
ELSIF UPDATING THEN
    INSERT INTO AUDITA_MENSAJES VALUES(SYS_CONTEXT('USERENV','SESSION_USER'), 'UPDATE', SYSDATE);
ELSE
    INSERT INTO AUDITA_MENSAJES VALUES(SYS_CONTEXT('USERENV','SESSION_USER'), 'DELETE', SYSDATE);
END IF;
END TRIGGER_MENSAJES;
/

-- Ahora veamos un ejemplo de inserción para ver que funciona, ejecutamos:
INSERT INTO MENSAJES VALUES (7494, 'HOLA');

-- Ahora en AUDITA_MENSAJES se describe una fila como
-- UBD5223  INSERT  29/04/2024

/*
2. Añada a MENSAJES un atributo TIPO con dominio VARCHAR2
Los posibles valores de TIPO son: INFORMACION, RESTRICCION, ERROR, AVISO, AYUDA. 
Realice inserciones en la tabla MENSAJES. Al menos introduzca dos tuplas de cada tipo. 
Cree la siguiente tabla:

MENSAJES_Info	 
Tipo	Clave primaria	VARCHAR2(30)
Cuantos_Mensajes	Número de mensajes de ese tipo	NUMBER(2)
Ultimo	Último mensaje de ese tipo	VARCHAR2(200)

Cargue en esta tabla nueva la información a partir de la tabla MENSAJES. 
Deje nulo el campo ULTIMO para cada tipo. Cada vez que se inserta un nuevo mensaje en la tabla MENSAJES
se debe actualiza la tabla MENSAJES_Info sumando uno a Cuantos_Mensajes y guardando el texto 
del mensaje en ULTIMO. Si se borra un mensaje se decrementa en uno Cuantos_Mensajes y se pone a NULL
ULTIMO. Si se cambia un mensaje de tipo entonces se hacen las operaciones antes descritas en inserción
para el tipo nuevo y las de borrado para el tipo antiguo. Cree disparadores para hacer esta tarea de forma
automática.
*/

-- Modificamos la tabla mensajes para añadir el atributo TIPO con las restricciones correspondientes
ALTER TABLE MENSAJES
ADD TIPO VARCHAR2(30) CONSTRAINT ck_tipo CHECK (TIPO IN ('INFORMACION', 'RESTRICCION', 'ERROR', 'AVISO', 'AYUDA'));

-- Añadimos a la tabla MENSAJES varios valores distintos

INSERT INTO MENSAJES VALUES (1, 'Mensaje de información 1', 'INFORMACION');
INSERT INTO MENSAJES VALUES (2, 'Mensaje de información 2', 'INFORMACION');
INSERT INTO MENSAJES VALUES (3, 'Mensaje de restricción 1', 'RESTRICCION');
INSERT INTO MENSAJES VALUES (4, 'Mensaje de restricción 2', 'RESTRICCION');
INSERT INTO MENSAJES VALUES (5, 'Mensaje de error 1', 'ERROR');
INSERT INTO MENSAJES VALUES (6, 'Mensaje de error 2', 'ERROR');
INSERT INTO MENSAJES VALUES (7, 'Mensaje de aviso 1', 'AVISO');
INSERT INTO MENSAJES VALUES (8, 'Mensaje de aviso 2', 'AVISO');
INSERT INTO MENSAJES VALUES (9, 'Mensaje de ayuda 1', 'AYUDA');
INSERT INTO MENSAJES VALUES (10, 'Mensaje de ayuda 2', 'AYUDA');

-- Creamos la tabla MENSAJES_Info

CREATE TABLE MENSAJES_INFO (
TIPO VARCHAR2(30),
CUANTOS_MENSAJES NUMBER(2),
ULTIMO VARCHAR2(200),
CONSTRAINT MEN_INFO_PK PRIMARY KEY (TIPO)
);

-- Ahora creamos un procedimiento para rellenar la tabla MENSAJES_INFO con los datos que ya teniamos.

CREATE OR REPLACE PROCEDURE PROC_FILL_MENSAJES
IS
    CURSOR C_ALL_TYPES IS SELECT TIPO FROM MENSAJES GROUP BY TIPO;
    TI VARCHAR2(30);
    CM NUMBER(2);
BEGIN
    FOR V_TYPE IN C_ALL_TYPES LOOP
        SELECT COUNT(*) INTO CM FROM MENSAJES WHERE TIPO = V_TYPE.TIPO;
        INSERT INTO MENSAJES_INFO(TIPO, CUANTOS_MENSAJES) VALUES(V_TYPE.TIPO, CM);
    END LOOP;
END PROC_FILL_MENSAJES;
/

-- Lo ejecutamos
exec proc_fill_mensajes;

-- Cada vez que se inserta un nuevo mensaje en la tabla MENSAJES se debe actualiza 
-- la tabla MENSAJES_Info sumando uno a Cuantos_Mensajes y guardando el texto del mensaje en ULTIMO.
-- Creemos dicho trigger

CREATE OR REPLACE TRIGGER TRIG_INS_MENSAJES
BEFORE INSERT ON MENSAJES FOR EACH ROW
DECLARE
    CM NUMBER(2);
    EM NUMBER(2);
BEGIN
    SELECT COUNT(*) INTO CM FROM MENSAJES WHERE TIPO = :new.TIPO;
    SELECT COUNT(*) INTO EM FROM MENSAJES_INFO WHERE TIPO = :new.TIPO;
    CM := CM + 1;
    IF EM = 0 THEN
        INSERT INTO MENSAJES_INFO
        VALUES(:new.TIPO, 1, null);
    ELSE
        UPDATE MENSAJES_INFO
        SET CUANTOS_MENSAJES = CM, ULTIMO = :new.TEXTO
        WHERE TIPO = :new.TIPO;
    END IF;
END;
/

-- Ahora insertamos una nueva fila 
INSERT INTO MENSAJES VALUES(12,'Ayuda 12', 'AYUDA');
-- Esto hará que la tabla Mensajes_info se actualice el valor de AYUDA a 3 y ULTIMO a 'Ayuda 12' en la fila de Ayudas

-- Si se borra un mensaje se decrementa en uno Cuantos_Mensajes y se pone a NULL ULTIMO.
-- Creemos el trigger de delete.

CREATE OR REPLACE TRIGGER TRIG_DEL_MENSAJES
BEFORE DELETE ON MENSAJES FOR EACH ROW
DECLARE
CM NUMBER(2);
BEGIN
    SELECT CUANTOS_MENSAJES INTO CM FROM MENSAJES_INFO WHERE TIPO = :old.TIPO;
    IF CM = 0 THEN
        CM := 0;
    ELSE
        CM := CM - 1;
    END IF;
    UPDATE MENSAJES_INFO
    SET CUANTOS_MENSAJES = CM, ULTIMO = NULL WHERE TIPO = :old.TIPO;
END;
/

-- Ahora borremos la fila anteriormente insertada
delete from mensajes where codigo = 12;

-- Como vemos en mensajes_info, reducimos en uno el numero de ayudas y pones a null la columna ultimo

-- Si se cambia un mensaje de tipo entonces se hacen las operaciones antes 
-- descritas en inserción para el tipo nuevo y las de borrado para el tipo antiguo. 
-- Creemos el trigger de update

CREATE OR REPLACE TRIGGER TRIG_UPD_MENSAJES
AFTER UPDATE ON MENSAJES FOR EACH ROW
DECLARE
CM NUMBER(2);
UL VARCHAR2(200);
BEGIN
    IF :new.TIPO != :old.TIPO THEN
            UPDATE MENSAJES_INFO SET CUANTOS_MENSAJES = CUANTOS_MENSAJES - 1, ULTIMO = NULL WHERE TIPO = :old.TIPO;
            SELECT NVL(CUANTOS_MENSAJES, 0) + 1 INTO CM FROM MENSAJES_INFO WHERE TIPO = :new.TIPO;
            UL := :new.TEXTO;
            UPDATE MENSAJES_INFO SET CUANTOS_MENSAJES = CM, ULTIMO = UL WHERE TIPO = :new.TIPO;
    END IF;
END;
/

-- Veamos ahora un ejemplo modificando una de las filas de la tabla mensajes
INSERT INTO MENSAJES VALUES(11,'Ayuda 11', 'AYUDA');
update mensajes set tipo = 'ERROR' where codigo = 11;
update mensajes set tipo = 'ERROR' where codigo = 2;

/*
3. Separe la tabla mensajes en dos tablas: MENSAJES_TEXTO (codigo, texto) y MENSAJES_TIPO (codigo, tipo).
Borre la tabla mensajes original y cree una vista MENSAJES reuniendo las dos tablas que acaba de crear. 
Compruebe si puede hacer SELECT sobre la vista nueva. ¿Sale lo mismo que antes? 
Compruebe si puede hacer inserciones sobre la vista MENSAJES. ¿Porqué? ¿Se puede arreglar mediante un 
disparador de sustitución sobre la vista? ¿Cómo?
*/

-- Creamos dos nuevas tablas
CREATE TABLE MENSAJES_TEXTO (
 CODIGO NUMBER(20),
 TEXTO VARCHAR2(200),
 CONSTRAINT MENSAJES_TEXTO_PK PRIMARY KEY (CODIGO));
 
CREATE TABLE MENSAJES_TIPO (
 CODIGO NUMBER(20),
 TIPO VARCHAR2(30),
 CONSTRAINT MENSAJES_TIPO_PK PRIMARY KEY (CODIGO));
 
 -- Borramos la tabla MENSAJES original
 drop table mensajes;
 
 -- Creamos una nueva vista MENSAJES que reuna las dos tablas
 create or replace view V_MENSAJES as ( select codigo, texto, tipo from mensajes_texto natural
 join mensajes_tipo);
 
 -- Compruebe si puede hacer SELECT sobre la vista nueva
 select * from v_mensajes;
 -- Es posible hacerlo.
 
 -- Comprobemos ahora el INSERT en la vista nueva
INSERT INTO V_Mensajes VALUES(11,'Ayuda 11', 'AYUDA');

/*
Informe de error -
Error SQL: ORA-01776: no se puede modificar más de una tabla base a través de una vista de unión
01776. 00000 -  "cannot modify more than one base table through a join view"
*Cause:    Columns belonging to more than one underlying table were either
           inserted into or updated.
*Action:   Phrase the statement as two or more separate statements.
*/

-- No se puede realizar ya que es una vista de unión y modificariamos varias tablas
-- Para solucionarlo, crearé un trigger

CREATE OR REPLACE TRIGGER TRIG_VIEW_MENSAJES INSTEAD OF INSERT ON V_MENSAJES
FOR EACH ROW
BEGIN
 INSERT INTO MENSAJES_TEXTO VALUES(:new.CODIGO, :new.TEXTO);
 INSERT INTO MENSAJES_TIPO VALUES(:new.CODIGO, :new.TIPO);
END; 
/

-- Si ahora hago otra vez el INSERT, será válido
INSERT INTO V_Mensajes VALUES(11,'Ayuda 11', 'AYUDA');

/*
4. Cree una tabla llamada MENSAJES_BORRADOS con el mismo esquema que MENSAJES_TEXTO. 
Cree un trigger sobre MENSAJES_TEXTO que permita almacenar en MENSAJES_BORRADOS 
los mensajes que se borren de MENSAJES_TEXTO.
*/

-- Creamos la tabla
CREATE TABLE MENSAJES_BORRADOS (
 CODIGO NUMBER(20),
 TEXTO VARCHAR2(200),
 CONSTRAINT MENSAJES_BORR_PK PRIMARY KEY (CODIGO));

-- Creamos el trigger
CREATE OR REPLACE TRIGGER TRIG_BORR_MENSAJES BEFORE DELETE ON MENSAJES_TEXTO
FOR EACH ROW
BEGIN
 INSERT INTO MENSAJES_BORRADOS VALUES(:old.CODIGO, :old.TEXTO);
END;
/

-- Veamos si funciona
delete from mensajes_texto where codigo = 11;

/*
5. Los mensajes borrados sólo se deben almacenar durante un tiempo.
Cree un trabajo que borre los mensajes borrados cada 2 minutos. 
*/

begin
    dbms_scheduler.create_job(
    job_name=> 'DEL_MENSAJES_BORRADOS',
    job_type=> 'PLSQL_BLOCK',
    job_action=> 'BEGIN DELETE FROM MENSAJES_BORRADOS; COMMIT; END;',
    start_date=> sysdate,
    repeat_interval=> 'FREQ=MINUTELY;INTERVAL=2',
    enabled=>TRUE,
    comments=> 'Borra los mensajes borrados cada 2 minutos.');
end;
/

