/*
1. Con�ctate a la base de datos como system.

Me conecto en la base de datos de system.

2. Si tienes un problema de caducidad del password, utiliza el comando password  (Se aconseja actualizar la contrase�a sin cambiarla, para no tener problemas posteriormente de olvido. Por supuesto, esta recomendaci�n solo es v�lida en un sistema de pruebas, NUNCA EN PRODUCCI�N).

No he tenido ning�n problema de password.

3. Comprueba que existe un tablespace denominado TS_LIFEFIT. Si no es as�, cr�alo donde quieras. Que sea de 10M con el nombre de fichero de datos que quieras y autoextensible.

Comprobamos usando la sentencia select * from dba_tablespaces, no la tengo creaado as� que uso la sentencia:
*/

CREATE TABLESPACE TS_LIFEFIT DATAFILE 'TS_LIFEFIT.dbf' SIZE 10M AUTOEXTEND ON;

/* 4. Crea un perfil denominado PERF_ADMINISTRATIVO con 3 intentos para bloquear la cuenta y que se desconecte despu�s de 5 minutos de inactividad. */

CREATE PROFILE PERF_ADMINISTRATIVO LIMIT FAILED_LOGIN_ATTEMPTS 3 IDLE_TIME 5;

/* 5. Crea un perfil denominado PERF_USUARIO con 4 sesiones por usuario y con una password que caduca cada 30 d�as. */

CREATE PROFILE PERF_USUARIO LIMIT SESSIONS_PER_USER 4 PASSWORD_LIFE_TIME 30;

/* 6. Aseg�rate de que las limitaciones de recursos ser�n efectivas sin problemas. Y por supuesto, contesta a esta pregunta en tu script comentando c�mo te has asegurado.*/

SHOW PARAMETER RESOURCE_LIMIT;
ALTER SYSTEM SET RESOURCE_LIMIT = TRUE;

/* Me he asegurado modificando el resource_limit a true. */

/* 7. Crea un role R_ADMINISTRADOR_SUPER con permiso para conectarse y crear tablas. */

CREATE ROLE  R_ADMINISTRADOR_SUPER;
GRANT CONNECT, CREATE TABLE TO  R_ADMINISTRADOR_SUPER;

/* 8. Crea dos usuarios denominados USUARIO1 y USUARIO2 con perfil PERF_ADMINISTRATIVO y contrase�a usuario. Ot�rgales el ROLE R_ADMINISTRADOR_SUPER. As�gneles Quota de 1 MB en el tablespace TS_LIFEFIT. Haz que �ste sea un tablespace por defecto.. */

CREATE USER USUARIO_1 IDENTIFIED BY USUARIO PROFILE PERF_ADMINISTRATIVO
QUOTA 1M ON TS_LIFEFIT DEFAULT TABLESPACE TS_LIFEFIT;

GRANT R_ADMINISTRADOR_SUPER TO USUARIO_1;

CREATE USER USUARIO_2 IDENTIFIED BY USUARIO PROFILE PERF_ADMINISTRATIVO
QUOTA 1M ON TS_LIFEFIT DEFAULT TABLESPACE TS_LIFEFIT;

GRANT R_ADMINISTRADOR_SUPER TO USUARIO_2;

/* Veo que estén bien creados. */

SELECT * FROM ALL_USERS;

/* 9. En ambos usuarios crear la tabla TABLA2:
CREATE TABLE TABLA2
 (  CODIGO NUMBER   ) ; */
 
CREATE TABLE Usuario_1.TABLA2 (CODIGO NUMBER);

CREATE TABLE Usuario_2.TABLA2 (CODIGO NUMBER);

/* 10. Crea el procedimiento USUARIO1.PR_INSERTA_TABLA2. Como a�n no hemos visto procedimientos en ORACLE, simplemente haz un copia y pega de lo siguiente (la barra final debe escribirse tambi�n):
 CREATE OR REPLACE PROCEDURE USUARIO1.PR_INSERTA_TABLA2 (
                                P_CODIGO IN NUMBER) AS
 BEGIN
      INSERT INTO TABLA2 VALUES (P_CODIGO);
 END PR_INSERTA_TABLA2;
/ 

Esto es importante que se realice en system y se borra del script y se maneja através de Otros Usuarios > Usuario_1 > Procedimientos
*/

/*
15. Cambiar el procedimiento para que el INSERT lo haga desde un EXECUTE IMMEDIATE. Es decir, vuelve a crear el procedimiento seg�n vimos en el punto anterior pero sustituyendo la linea correspondiente al INSERT por 
execute immediate 'INSERT INTO TABLA2 VALUES ('||P_CODIGO||')';
*/

/* 18. Crear otro procedimiento en USUARIO1:
CREATE OR REPLACE PROCEDURE PR_CREA_TABLA (
  P_TABLA IN VARCHAR2, P_ATRIBUTO IN VARCHAR2) AS
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE '||P_TABLA||'('||P_ATRIBUTO||' NUMBER(9))';
 END PR_CREA_TABLA;
/

De nuevo, esto es importante que se realice en system y se borra del script y se maneja através de Otros Usuarios > Usuario_1 > Procedimientos

*/

/* 20. Asignemos permisos expl�citos (y no a trav�s de un rol como est� ahora) de creaci�n de tablas al USUARIO1. Asignar permisos de ejecuci�n sobre el procedimiento anterior al USUARIO2. */
GRANT CREATE ANY TABLE TO USUARIO_1;

/* 22. Vamos ahora a comprobar c�mo est� la instalaci�n de ORACLE que tenemos delante. En primer lugar, en una configuraci�n �ptima deber�amos conocer cuales son las cuentas que a�n tienen su password por defecto (lo cual es una mala pr�ctica desde el punto de vista de seguridad). Consulta para ello la vista de diccionario DBA_USERS_WITH_DEFPWD. Ahora, responde: �por qu� hay tantas cuentas? �tan insegura es ORACLE tras la instalaci�n? PISTA: Utiliza esa vista en combinaci�n con otras que te permita estudiar el estado (si se pueden conectar, si est�n abiertas o bloqueadas, etc.) de esas cuentas. */

SELECT * FROM DBA_USERS_WITH_DEFPWD;

/* HAY UNA �NICA CUENTA CON DEFAULT PASSWORD. Esto es debido a que Oracle se ha vuelto con sus actualizaciones más seguro a la hora de almacenar estas cuentas. */

/* Sabemos que existe un profile por defecto para la creación usuarios. Vamos a modificarlo de manera que todos los usuarios cumplan una política mínima para la gestión de contraseñas al ser creados por defecto. 
- En primer lugar consulta cuales son los parámetros existentes del profile por defecto (la vista DBA_PROFILES puede ayudarte). Cuales son?
*/

SELECT RESOURCE_NAME FROM DBA_PROFILES WHERE PROFILE = 'DEFAULT';

/* Usando esta consulta los parámetros son: 
COMPOSITE_LIMIT
SESSIONS_PER_USER
CPU_PER_SESSION
CPU_PER_CALL
LOGICAL_READS_PER_SESSION
LOGICAL_READS_PER_CALL
IDLE_TIME
CONNECT_TIME
PRIVATE_SGA
FAILED_LOGIN_ATTEMPTS
PASSWORD_LIFE_TIME
PASSWORD_REUSE_TIME
PASSWORD_REUSE_MAX
PASSWORD_VERIFY_FUNCTION
PASSWORD_LOCK_TIME
PASSWORD_GRACE_TIME
INACTIVE_ACCOUNT_TIME
*/

/* Cambia el número de logins fallidos a 4 y el tiempo de gracia a 5 días. */

ALTER PROFILE default LIMIT FAILED_LOGIN_ATTEMPTS 4 PASSWORD_GRACE_TIME 3;

/* - Cambia el perfil del usuario1 al perfil por defecto y haz 5 logins fallidos. ¿Que ocurre la quinta vez? Para responder interpreta bien los mensajes que recibes. */

ALTER USER Usuario_1 PROFILE DEFAULT;
commit;

/* En los primeros 4 logins me aparece que la contraseña/cuenta es errónea y en la quinta vez se bloquea la cuenta Usuario_1. */

/* - Desbloquea la cuenta (alter user...) */

ALTER USER USUARIO_1 ACCOUNT UNLOCK;

/* - A pesar de que hayamos cambiado el parámetro de failed_login_attempts, como habrás visto, es posible que antes, aunque el usuario no se bloquee, si nos eche de la sesión. Si consultamos el parámetro de inicialización sec_max_failed_login_attempts (show parameter...) aparece un valor menor (si no lo has cambiado antes). Significan por tanto diferentes cosas. ¿Para qué es útil cada uno? */

/* sec_max_failed_login_attempts es un parámetro de inicialización que controla el número máximo de intentos de inicio de sesión fallidos permitidos antes de que Oracle cierre automáticamente la sesión. Es útil para prevenir ataques de fuerza bruta.

failed_login_attempts, por otro lado, es un límite configurado en el perfil del usuario que define cuántos intentos de inicio de sesión fallidos puede tener un usuario antes de que su cuenta se bloquee temporalmente.*/

/* - Investiga si existe una forma de "quitar" los perfiles que hemos creado al principio. ¿Se puede hacer con todos los perfiles de oracle? */

/* Puedes eliminar un perfil específico utilizando el comando DROP PROFILE. Por ejemplo:
DROP PROFILE nombre_perfil;
Esto eliminará el perfil especificado. Sin embargo, si hay usuarios asignados a este perfil, tendrás que cambiar sus perfiles primero o eliminar esos usuarios si ya no son necesarios. No se pueden eliminar todos los perfiles de Oracle, ya que algunos son internos y necesarios para el funcionamiento del sistema. */

/* 
Una última pregunta. Algunos parámetros de inicialización son dinámicos, y otros estáticos. ¿Cual es la diferencia entre ellos?
Parámetros dinámicos: Estos parámetros pueden ser modificados mientras la base de datos está en funcionamiento, es decir, en tiempo de ejecución. Los cambios surten efecto inmediatamente después de su modificación y no requieren reiniciar la base de datos. Esto proporciona flexibilidad para ajustar la configuración de la base de datos según las necesidades cambiantes del sistema sin detener los servicios.

Parámetros estáticos: Estos parámetros requieren que la base de datos se reinicie para aplicar los cambios. No se pueden modificar en tiempo de ejecución, lo que significa que cualquier modificación requiere detener y luego reiniciar la instancia de la base de datos para que los cambios surtan efecto
*/



/* ---- SQL USUARIO_1 ---- */

/*
/* 11. Con�ctate como USUARIO1 y Ejec�talo. �Funciona?. Utiliza la instrucci�n exec nombre_procedimiento(param); */

exec PR_INSERTA_TABLA2 (123);

/* Sí, funciona. */

/* 12. Ot�rgale permisos a USUARIO2 para ejecutarlo. */

grant execute ON PR_INSERTA_TABLA2  to Usuario_2;

/* 16. Ejecutar el nuevo procedimiento desde USUARIO_1. S�, funciona. */

exec PR_INSERTA_TABLA2 (1);
commit;

/* 19. Ejecutar desde USUARIO1. �Funciona?�Por qu�? NO FUNCIONA, NO TENGO PRIVILIEGIOS PARA CREAR LA TABLA. */

EXEC PR_CREA_TABLA ('TABLA1', 'ATRIB1');

GRANT execute ON pr_crea_tabla to usuario_2;

*/

/* ---- SQL USUARIO_2 ---- */

/*
/* 13. Con�ctate como USUARIO2 y Ejec�talo. �Funciona?  No olvides confirmar los cambios (commit)*/

EXEC USUARIO_1.PR_INSERTA_TABLA2 (12345);

COMMIT;

/* Sí, funciona */

/* 14. En este �ltimo caso �d�nde se inserta el dato en la tabla de USUARIO1 o en la de USUARIO2? �Por qu�? */
/* Se inserta en la tabla2 del USUARIO1. Esto es porque el procedimiento se realiza en usuario1 y all� se inserta en su TABLA2 ya que no especificamos una concretamente. */

/* 17. Ejecutar el nuevo procedimiento desde USUARIO_2. S� funciona como antes. */

EXEC USUARIO_1.PR_INSERTA_TABLA2 (2);
commit;

/* 21. Ejecutar desde USUARIO2. �Funciona?�Por qu�? Piensa en los par�metros con los que se invoca. S�, FUNCIONA. */

EXEC USUARIO_1.PR_CREA_TABLA('TAB1', 'AT1');
COMMIT;

*/
 
 