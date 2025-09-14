-- 1. Creamos un usuario con permisos de DBA desde el usuario system
-- create user PracticaIndices identified by bd;
-- grant DBA to PracticaIndices;

-- 2. Accedemos con el usuario PracticaIndices
-- 2. Creamos una tabla Prueba2 y la rellenamos
create table Prueba2 (
    CLAVE NUMBER(16, 0), 
    DISPERSO NUMBER(16, 0), 
    CONCENTRADO NUMBER(16, 0), 
    IDISPERSO NUMBER(16, 0), 
    ICONCENTRADO NUMBER(16, 0), 
    BCONCENTRADO NUMBER(16, 0),
    primary key (CLAVE)
);

DECLARE
I NUMBER(16,0);
R NUMBER(16,0);
BEGIN
FOR I IN 1..100000 LOOP
 R := DBMS_RANDOM.VALUE(1,1000000000);
 INSERT INTO PRUEBA2 VALUES(I, R, MOD(R,11), 1000000000-R, MOD(1000000000-R, 11),
MOD(2000000000-R, 11));
END LOOP;
END;
/
commit;

-- 3. Creamos los indices indicados
create index PID on Prueba2(idisperso);
create index PIC on Prueba2(iconcentrado);
create bitmap index PBC on Prueba2(bconcentrado);

set autotrace on;

-- 4. Antes de cada consulta ejecuta las 2 sentencias alter
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SYSTEM FLUSH BUFFER_CACHE;
SELECT COUNT(*) FROM PRUEBA2 WHERE CLAVE = 50000;
SELECT COUNT(*) FROM PRUEBA2 WHERE DISPERSO = 50000;
SELECT COUNT(*) FROM PRUEBA2 WHERE CONCENTRADO = 5;
SELECT COUNT(*) FROM PRUEBA2 WHERE IDISPERSO = 50000;
SELECT COUNT(*) FROM PRUEBA2 WHERE ICONCENTRADO = 5;
SELECT COUNT(*) FROM PRUEBA2 WHERE BCONCENTRADO = 5;

-- 5. Comparamos los campos de las diferentes consultas
-- consisten gets 107 physical read total bytes 327680
-- consisten gets 684 physical read total bytes 4349952
-- consisten gets 805 physical read total bytes 4399104
-- consisten gets 200 physical read total bytes 3137536
-- consisten gets 223 physical read total bytes 3473408
-- consisten gets 373 physical read total bytes 3588096

-- Las consultas que tienen un indice asociado realizan menos lecturas de bloque
-- La cantidad de bytes totales leída varía en todas las consultas y es menor en la primera consulta

-- La consulta mas rapida es la primera ya que hace menos lecturas de bloque y menos cantidad de bytes totales leída
-- La consulta mas lenta es la tercera ya que hace mas lecturas de bloque y mas cantidad de bytes totales leída

-- 6. Observamos la penalización en operaciones de escritura
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SYSTEM FLUSH BUFFER_CACHE;
UPDATE PRUEBA2 SET DISPERSO = DISPERSO + 7;
-- consisten gets 1416 
-- physical read total bytes 4841472 
-- cell physical IO interconnect bytes 4841472

ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SYSTEM FLUSH BUFFER_CACHE;
UPDATE PRUEBA2 SET IDISPERSO = IDISPERSO + 7;
-- consisten gets 3165 
-- physical read total bytes 9207808 
-- cell physical IO interconnect bytes 12042240

-- La segunda operacion es mas costosa pues realiza un mayor numero de lecturas de bloque y la cantidad de bytes totales leída y escrita es mayor.

-- 7. Creamos un Indice de funcion
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SYSTEM FLUSH BUFFER_CACHE;
SELECT COUNT(*) FROM PRUEBA2 WHERE IDISPERSO BETWEEN 10000 AND 20000;

-- 8. 
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SYSTEM FLUSH BUFFER_CACHE;
SELECT COUNT(*) FROM PRUEBA2 WHERE IDISPERSO+ICONCENTRADO BETWEEN 10000 AND 20000;

-- El numero de lecturas de bloque aumenta considerablemente en la segunda instruccion y por tanto aumenta el coste de esta.

-- 9. Creamos un indice FIX sobre la funcion idisperso+iconcentrado
create index FIX on Prueba2(idisperso+iconcentrado);

-- 10. Volvemos a ejecutar el paso 8
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SYSTEM FLUSH BUFFER_CACHE;
SELECT COUNT(*) FROM PRUEBA2 WHERE IDISPERSO+ICONCENTRADO BETWEEN 10000 AND 20000;

-- 11. Ahora el coste se reduce de forma considerable ya que se realiza la operación INDEX RANGE SCAN y no un TABLE ACCESS FULL, haciendo que el numero de lecturas de bloque se reduzca.

-- 12. Volvemos a ejecutar la operación de actualización
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SYSTEM FLUSH BUFFER_CACHE;
UPDATE PRUEBA2 SET IDISPERSO = IDISPERSO + 7;

-- 13. No hay ninguna diferencia significativa
-- consisten gets 3552 
-- physical read total bytes 16285696 
-- cell physical IO interconnect bytes 61915136
