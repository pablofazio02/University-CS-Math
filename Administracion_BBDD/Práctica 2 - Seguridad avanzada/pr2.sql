/*1. Conéctate a la base de datos como system. */

/*2. Ejecuta todos los pasos necesarios para crear un wallet de tipo FILE, 
tal y como hemos visto en clase y en los videos, para permitir implementar TDE 
(Transparent Data Encryption) sobre columnas de las tablas que seleccionemos después. 

Hay que tener en cuenta que en el proceso de creación del wallet se ha de elegir un 
directorio en el que Oracle tenga permisos en tu máquina concreta. 
Por ejm, en el directorio 'C:\app\alumnos\admin\orcl\xdb_wallet' o cualquier otro directorio 
de Windows en el que aparezca el usuario de Oracle en el SO (el nombre de este usuario suele empezar con ‘ORA_”). 
Si no sabes cómo comprobarlo, pregunta al profesor antes de continuar.

Es necesario que entiendas bien TDE y todos los pasos que realizas. 
De lo contrario, te resultará muy difícil avanzar en la práctica. 
Para ello ve a la parte correspondiente de la documentación proporcionada en clase y estudiála antes de empezar. 
Encontrarás los pasos descritos en secuencia y explicados. */

-- Primero buscamos la carpeta xdb_wallet y borramos lo q hay dentro.

alter system set "WALLET_ROOT"='C:\app\alumnos\admin\orcl\xdb_wallet' scope=SPFILE;

--Ahora vamos a Servicios en Windows, buscamos OracleServiceORCL y reiniciamos el servicio.

alter system set TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE" scope=both;

--abrimos una terminal en Windows y ejecutamos 
-- Sqlplus / as syskm
-- ADMINISTER KEY MANAGEMENT CREATE KEYSTORE IDENTIFIED BY password;
-- ADMINISTER KEY MANAGEMENT CREATE AUTO_LOGIN KEYSTORE FROM KEYSTORE IDENTIFIED BY password;
-- ADMINISTER KEY MANAGEMENT SET KEY force keystore identified by password with backup;

-- Para ver que se ha creado el wallet lo vemos con esta vista.

select * from v$encryption_wallet;

/* 
3. Todo el trabajo de tu proyecto LIFEFIT debería estar o estará en un espacio de tablas 
aparte. En el peor de los casos puede estar en el tablespace USERS. 
Asumiremos en adelante que usamos el esquema en el que estás desarrollando tu trabajo en 
grupo. Si no, no pasa nada, utiliza un esquema (usuario que tendrás que crear) de ejemplo, 
el que quieras. Más adelante, se volcará lo aquí aprendido al esquema final de LIFEFIT .*/


-- Usaremos el esquema TS_LIFEFIT de la Práctica 1.
select OWNER,TABLE_NAME,TABLESPACE_NAME from dba_tables where tablespace_name = 'TS_LIFEFIT';

/*
4. Usar una o varias tablas de tu trabajo en grupo susceptible de precisar que sus datos 
estén cifrados. Si no tuvieras nada creado en el momento de la realización de esta práctica,
puedes crearte un par de tablas donde una de ellas fueran, por ejemplo, los estudiantes. 
Y, por supuesto, introducir algunos datos de ejemplo. Si tienes que crear estas tablas para
la práctica, lee el paso siguiente ANTES de hacerlo.


5. Parece obvio que en esas tablas habrá una serie de columnas que almacenan información 
sensible. Identifícalas y haz que estén siempre cifradas en disco. 
PARA ESTA PRÁCTICA, ASEGURATE QUE HAYA AL MENOS UNA COLUMNA DE TEXTO NO CIFRADA 
Y AL MENOS OTRA CIFRADA con objeto de poder hacer comprobaciones en los siguientes pasos.
*/


-- Creamos una tabla en el tablespace TS_LIFEFIT donde uno de los atributos requiera ir encriptado.

create TABLE USUARIO_1.Estudiantes (
    nombre            VARCHAR2(20 CHAR) NOT NULL,
    apellido          VARCHAR2(20 CHAR) NOT NULL,
    titulacion        VARCHAR2(20 CHAR) NOT NULL,
    dni               VARCHAR2(20 CHAR) encrypt   --no se puede encriptar si es UNIQUE, etc!!
);

select * from USUARIO_1.Estudiantes;

/*
6. Una vez le has ordenado a Oracle que columnas deben de ir cifradas, 
comprueba que los cambios son efectivos mediante la consulta de la vista del diccionario 
de datos adecuada.
*/
select * from dba_encrypted_columns;

/*
7. Prueba a insertar varias filas en una de esas tablas (y en todas aquellas tablas que sea necesario). 
A continuación, puedes forzar a Oracle a que haga un flush de todos los buffers a disco 
mediante la instrucción:

alter system flush buffer_cache;

Comprueba a continuación el contenido del fichero que contiene el tablespace con estos 
datos. Ese fichero lo podremos encontrar en el directorio en el que hayamos creado el 
tablespace en el que se encuentra la tabla que estamos utilizando.

No es necesario conocer el formato de dicho fichero. 
Simplemente tener en cuenta que los datos no cifrados aparecerán en claro.  
Y podemos hacer un buscar y los encontraríamos. Pero, ¿y si hacemos lo mismo con los que
hemos decidido que se almacenen cifrados?

La manera más cómoda es utilizar una herramienta que extraiga los strings legibles. 
E.g.: https://docs.microsoft.com/en-us/sysinternals/downloads/strings

Si el fichero no es muy grande también se puede utilizar un editor (e.g. notepad) de
texto para abrirlo y realizar búsquedas. Responde a las siguientes preguntas:

- ¿Se pueden apreciar en el fichero los datos escritos? ¿Por qué?
*/

--primero metemos varios datos en la tabla 
insert INTO USUARIO_1.Estudiantes (nombre, apellido, titulacion, dni) VALUES ('Pablo', 'Fazio', 'Informática', '68893939X');
insert INTO USUARIO_1.Estudiantes (nombre, apellido, titulacion, dni) VALUES ('Eleonora', 'Cuñado', 'Medicina', '63787438S');
insert INTO USUARIO_1.Estudiantes (nombre, apellido, titulacion, dni) VALUES ('Elena', 'Morales', 'Derecho', '1683839X');

--ejecutamos esto:
alter system flush buffer_cache;

--ahora buscamos el archivo que contiene el datafile del tablespace ts_lifetime
--para ello podemos ejecutar:

select * from  v$datafile;
--podremos ver todos los datafiles de la bbdd, y en NAME podemos consultar la ruta:
--C:\V982656-01\DATABASE\TS_LIFEFIT.DBF

/* Lo abrimos en bloc de notas, podemos dar a Edicion-->Buscar
  y buscar un dato que hayamos metido, por ejemplo el nombre de un estudiante
  vemos que este aparece, así como todos los atributos que no estaban encriptados 
  y seguidamente el atributo encriptado, que es ilegible
  Notese que esto se debe a la encriptación transparente: en sqldeveloper puede verse
  el valor en claro, pero en los archivos está encriptado.
*/

/*
8. Vamos ahora a aplicar políticas de autorización más concretas mediante VPD. 
Quizás quieras consultar previamente la documentación de seguridad para refrescar los 
conceptos de VPD. 
Supongamos que vamos a permitir a los clientes acceder a la BD y consultar sus datos. 
Si un cliente accede, sólo tendrá disponibles sus datos. Para ello, vamos a asumir que una 
de las columnas de la tabla cliente almacena su usuario de conexión a la BD (añade esta 
columna a la tabla si no la tiene ya). En el ejemplo a continuación asumimos que esta 
columna se denomina usuario, pero puede denominarse como desees.

Para ello, necesitaremos primero una función que forme los predicados de la cláusula WHERE. 
La crearemos en el esquema (con copiar y pegar, por ejemplo) en el que se encuentran las 
tablas:

create or replace function vpd_function(p_schema varchar2, p_obj varchar2)
  Return varchar2
is
  Vusuario VARCHAR2(100);
Begin
  Vusuario := SYS_CONTEXT('userenv', 'SESSION_USER');
  return 'UPPER(usuario) = ''' || Vusuario || '''';
End;
/


-- userenv = El contexto de aplicación

-- p_obj = nombre de la tabla o vista al cual se le aplicará la política

-- p_schema = schema en el que se encuentra dicha tabla o vista.

*/

-- Metemos una columna nueva en la tabla Estudiantes que sea 'conection_user'.

alter table USUARIO_1.Estudiantes add CONECTION_USER VARCHAR2(20 CHAR);

-- Definimos la siguiente función para USUARIO_1.

create or replace function USUARIO_1.vpd_function(p_schema varchar2, p_obj varchar2)
  Return varchar2
is
  Vusuario VARCHAR2(100);
Begin
  Vusuario := SYS_CONTEXT('userenv', 'SESSION_USER');
  return 'UPPER(CONECTION_USER) = ''' || Vusuario || '''';
End;
/

/* esta función devuelve la cadena 'UPPER(CONECTION_USER) = ''' || Vusuario || '''';
  que, por como ha sido definido Vusuario, es conection_user = usuarioQueEstáHaciendoLaQuery
  y despues la política que vamos a definir despues, la usará para hacer un where
  con esa condicion, de forma que el usuario conectado, al hacer una query, solo
  podrá ver la información relativa a él mismo

  en system --> otros usuarios --> usuario_1 --> funciones: podemos ver que se ha creado correctamente
*/

/*
9. Crearemos un usuario (cuyo nombre debe estar previamente presente en el campo user_name 
de alguna fila, esto lo hacemos de forma manual en sqldev) de forma que podamos probar la política. 
Comprobaremos, que ese usuario, al conectarse, puede ver todos los datos de la tabla
estudiante (si no puede inicialmente, piensa por qué y soluciónalo).
*/

create user user_Pablo identified by usuario;
grant connect to user_Pablo;

--nos conectamos en user_Pablo y ejecutamos allí:
--select * from usuario_1.Estudiantes;
--evidentemente no tiene ahí Estudiantes porque no tiene permiso

grant select on usuario_1.Estudiantes to user_Pablo;

/*
A partir de ahora, además, ten en cuenta con que usuario vas a hacer cada cosa. 
Para crear, cancelar o borrar políticas se hará desde un usuario con permisos de DBA 
(lo haremos así por facilidad). Para probarlas se hará con el nuevo usuario que hemos 
creado precisamente para eso. En resumen, cada vez que se solicite llevar a cabo una acción,
incluso si el enunciado no lo especifica, no debes dudar acerca de cual es el usuario que 
ha de hacerlo. Si dudas, pregunta al profesor.

Recordar también que siempre que creemos usuarios de prueba será asignándole los permisos
MINIMOS necesarios para lo que queremos hacer (ni uno más).

Añadiremos la política (consulta las transparencias) a la tabla CLIENTES
(desde un usuario con el role de DBA).  Y después comprobaremos que ocurre después de añadir
la política. Una aclaración, al añadir una política, ésta se encuentra activa por defecto.

Si en algún momento necesitas desactivar la política puedes usar:

begin

 DBMS_RLS.ENABLE_POLICY (        
 object_schema=>'el_nombre_del_esquema_en_el_que_está_la_tabla',    
 object_name=>'el_nombre_de_tu_tabla',
policy_name=>'nombre_politica', enable=>false);

end;

Si te has equivocado y quieres borrar y volver a crear la política:

begin

dbms_rls.drop_policy (

  object_schema=>'el_esquema',

  object_name=>'la_tabla',

  policy_name=>'el_nombre_de_la_politica' );

end;
*/

-- Vamos a crear la política (pag 34 diapos - tema 2. seguridad)
begin dbms_rls.add_policy (object_schema =>'USUARIO_1',
object_name =>'ESTUDIANTES',
policy_name =>'POL_PRACTICA',
function_schema =>'USUARIO_1',
policy_function => 'VPD_FUNCTION', --NOMBRE DE LA FUNCIÓN CREADA ANTES
statement_types => 'SELECT, UPDATE, DELETE' ); 
end;
/

/*
10.  ¿Qué ocurre cuando nos conectamos con ese usuario existente en la tabla CLIENTES y 
realizamos un select de todo? ¿Y cuando lo hace el propietario de la tabla?
*/
/* Ahora si en user_Pablo hacemos 
select * from usuario_1.estudiantes; solo salen los datos correspondientes a su persona (pablo). 
El resto de usuariosmar no aparecen. De hecho, aunque la tabla sea de USUARIO_1, si ejecutamos lo mismo en su hoja, 
no aparece nada porque no aparece ningún dato correspondiente a él mismo, en system tampoco aparece nada.
*/

select * from usuario_1.Estudiantes;

/*
11. Utilizando VPD, también podemos aplicar políticas sobre columnas, en lugar de 
sobre vistas o tablas enteras. Continuando con nuestro ejemplo, imaginemos que queremos 
permitir a estos clientes consultar todos los datos de la tabla excepto cuando también se 
solicita una columna determinada (ej. Telefono), en cuyo caso queremos que se muestren sólo
los datos del usuario. Investiga en la documentación la función que ya hemos utilizado del 
paquete dbms_rls para añadir una política nueva (dbms_rls.add_policy). 
¿Qué cambios deberíamos hacer para lograr nuestro objetivo? Tip: Desactiva previamente la
política anterior para no tener conflictos en los resultados. 
*/

-- En primer lugar, desactivamos la política anterior.
begin
dbms_rls.enable_policy (

  object_schema=>'USUARIO_1',

  object_name=>'ESTUDIANTES',

  policy_name=>'POL_PRACTICA',
  
  enable=>false );

end;
/

-- En mi caso, lo voy a hacer con la columna DNI.
-- Modificamos nuestra función para que detecte si hemos añadido el contexto de la columna 'DNI'

create or replace function USUARIO_1.vpd_function(p_schema varchar2, p_obj varchar2)
  Return varchar2
is
  Vusuario VARCHAR2(100);
  v_policy VARCHAR2(100);
Begin
  Vusuario := SYS_CONTEXT('userenv', 'SESSION_USER');
  -- Aquí está el problema, realmente lo que hago abajo no está bien ya que DNI podría aparecer
  -- en otra parte de la consulta y no en el SELECT pero apaña el hecho de que si seleccionamos la columna DNI,
  -- solo se vera la columna o columnas de este usuario.
  IF (UPPER(SYS_CONTEXT('USERENV', 'CURRENT_SQL')) LIKE '%DNI%') THEN
    -- Si la columna solicitada es 'DNI', aplicar política para mostrar solo los datos del usuario actual
    v_policy := 'UPPER(CONECTION_USER) = ''' || Vusuario || '''';
  ELSE
    -- Si la columna solicitada no es 'DNI', permitir acceso completo a los datos
    v_policy := '1=1';
  END IF;
  return v_policy;
End;
/

-- Creamos ahora una nueva política añadiendo el parámetro SEC_RELEVANT_COLS para p.e nuestro parámetro DNI

begin dbms_rls.add_policy (
   object_schema => 'USUARIO_1', 
   object_name => 'ESTUDIANTES', 
   policy_name => 'POL_PRACTICA_2', 
   function_schema => 'USUARIO_1', 
   policy_function => 'VPD_FUNCTION',
   statement_types  => 'SELECT',
   sec_relevant_cols => 'DNI');
end;
/

-- Ejecutando como User_Pablo
-- select * from usuario_1.Estudiantes; (Me da toda la tabla)
-- select dni, titulacion from usuario_1.Estudiantes; (Únicamente dni y titulación de user_pablo)

/*12. ¿Qué desventajas pueden llegar a tener este tipo de control de acceso 
más específico? Si no encuentras la respuesta discútelo con el profesor. */

/* Pues la verdad, lo hace bastante complejo a la vista del usuario que a veces no puede entender el fondo interno
de las políticas. Además, tiene un mayor coste de complejidad por evaluar cada sentencia en este caso. */




