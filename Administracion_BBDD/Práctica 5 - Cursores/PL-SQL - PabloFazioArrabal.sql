-- Ejercicio 1. Te pido escribir un script de PL/SQL que recorre todas las tablas que hay en tu PROPIO esquema usando un cursor sobre la tabla USER_TABLES. El script produce una salida al buffer de E/S (usando la librería DBMS_OUTPUT) y para cada tabla se escribe una fila con el formato: La tabla ... pertenece al esquema ....

-- No hay que olvidar de escribir serveroutput a on para poder usar la función DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON;

DECLARE
    CURSOR tab IS SELECT table_name FROM user_tables;
BEGIN
    
    for var_cursor in tab LOOP
        DBMS_OUTPUT.PUT_LINE('La tabla ' || var_cursor.table_name || ' pertenece al esquema ' || USER);
    END LOOP;
END;
/

-- Como en este caso se nos pide nuestras tablas, simplemente debemos escribir como propietario del esquema USER. 

-- Ejercicio 2. Modifica el script anterior para que salgan las tablas a las que tienes permiso en otros esquemas de usuario.

DECLARE
    CURSOR tab IS SELECT table_name, owner FROM all_tables;
BEGIN
    for var_cursor in tab LOOP
        DBMS_OUTPUT.PUT_LINE('La tabla ' || var_cursor.table_name || ' pertenece al esquema ' || var_cursor.owner);
    END LOOP;
END;
/

-- Ejercicio 3. Has tenido que modificar algo más además de la vista del diccionario?.
-- Sí, además de cambiar la vista a all_tables, he tenido que añadir al cursor el atributo owner y sustituirlo en PUT_LINE por USER.


-- Ejercicio 4. El segundo script cubre ambos casos si limitamos en el primer caso a que el OWNER de la vista ALL_TABLES coincide con el usuario que ejecuta el script. Compara ambas sentencias y extrae conclusiones.

DECLARE
    CURSOR tab IS SELECT table_name, owner FROM all_tables where owner = USER;
BEGIN
    for var_cursor in tab LOOP
        DBMS_OUTPUT.PUT_LINE('La tabla ' || var_cursor.table_name || ' pertenece al esquema ' || var_cursor.owner);
    END LOOP;
END;
/

-- Se tiene un mayor componente de complejidad temporal ya que debe comparar con cada vista del diccionario all_tables si el owner es usuario, que tiene muchas más tablas.

-- Ejercicio 5. Crea un procedimiento llamado RECORRE_TABLAS(P_MODE IN NUMBER) que recorre las tablas y produce la salida antes mencionada. Si llamamos al procedimiento con valor 0 en P_MODE lista todas las tablas a las que tenemos permiso y si le damos un valor distinto de cero, lista las propias del usuario. Si no recibe valor en el parámetro, sale un mensaje a modo de manual del propio procedimiento explicando lo que hace y los posibles valores de P_MODE.
-- Para crear el procedimiento, puedes usar un solo cursor sobre la vista ALL_TABLES con un parámetro que permite limitar la búsqueda sobre la vista. Es decir si el parámetro tiene valor, entonces el atributo OWNER se compara con el nombre de usuario. Para mejorar la definición del cursor, recuerda el uso de las funciones NVL y DECODE.

CREATE OR REPLACE PROCEDURE RECORRE_TABLAS(P_MODE IN NUMBER DEFAULT NULL) AS
    CURSOR tab IS SELECT table_name, owner FROM all_tables WHERE owner = nvl(decode(p_mode, 0, owner, USER), 1);
BEGIN
    if p_mode is null then
        DBMS_OUTPUT.PUT_LINE('Este procedimiento recorre las tablas en la base de datos.');
        DBMS_OUTPUT.PUT_LINE('Si se llama con valor 0 en P_MODE, lista todas las tablas a las que tienes permiso.');
        DBMS_OUTPUT.PUT_LINE('Si se le da un valor distinto de cero, lista las tablas de tu propio esquema.');
        DBMS_OUTPUT.PUT_LINE('Si p_mode es null se comenta que realiza el procedimiento.');
    else
        for var_cursor in tab LOOP
            DBMS_OUTPUT.PUT_LINE('La tabla ' || var_cursor.table_name || ' pertenece al esquema ' || var_cursor.owner);
        END LOOP;
    end if;
END;
/

-- Ejemplos:

-- Sin argumento:
exec RECORRE_TABLAS();

-- Salida:
-- Este procedimiento recorre las tablas en la base de datos.
-- Si se llama con valor 0 en P_MODE, lista todas las tablas a las que tienes permiso.
-- Si se le da un valor distinto de cero, lista las tablas de tu propio esquema.
-- Si no se recibe un valor en el parámetro p_mode se comenta qué realiza el procedimiento.

-- P_MODE = 0
exec RECORRE_TABLAS(0);
-- Salida:
-- [...] Muchas Tablas Más
-- La tabla USERS pertenece al esquema UBD4341
-- La tabla VIDEO pertenece al esquema UBD4341
-- La tabla WORKOUT pertenece al esquema UBD4341
-- La tabla ESTUDIANTES pertenece al esquema UBD5223
-- La tabla TABLE1 pertenece al esquema UBD5223


-- PMODE != 0
exec RECORRE_TABLAS(100);
-- Salida:
-- La tabla ESTUDIANTES pertenece al esquema UBD5223
-- La tabla TABLE1 pertenece al esquema UBD5223