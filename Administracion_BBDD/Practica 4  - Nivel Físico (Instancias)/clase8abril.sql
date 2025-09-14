/*

Sobre SGA:
Database buffers: Caché de la base de datos
Log writer: proceso secundario que guarda los datos del redo buffer en los archivos de redo 

Para acceder a la información de sga 

cmd -> sqlplus / as sysdba 
       startup
       show sga


Diferencia entre pfile y spfile -> pfile fichero de texto modificable, spfile fichero binario no modificable

cmd -> create pfile from spfile;    #crea un fichero

Para ver en qué directorio se ha creado: 

Nos vamos a Editro de Registro --> HKEY_LOCAL_MACHINE --> SOFTWARE --> ORACLE --> KEY_OraDB19Home1

Nos dice que está en C:\V982656-01 y nos vamos a esta ruta dentro de (C:) y --> database

IMPORTANTE: Aquí, de INITORCL.ORA hacemos una copia (INITORCL_copia.ORA)

Lo abrimos, borramos todos los .orcl, hasta los *.
Sale información del nombre de la instacia de la bbdd, el blocksize, protocolos...
Si cambiamos *.open_cursors a 250 (tenía 300), reducimos las conexiones simultáneas? (no sé si es eso exactamente porque lo que controla eso es el sessions_per_user) 
Si cambiamos *.processes a 200 (tenía 300), reducimos el número de procesos simultáneos.
Si cambiamos *.sga_target a 500m (tenía 600mb), reducimos la memoria reservada para la bbdd, útil para cuando nuestro ordenador necesita liberar memoria



Hacemos cmd -> shutdown immediate, se cierra y desmonta la base de datos
Si queremos volver a abrirla, no hacemos como al comienzo, pues los datos modificados no se tendrían,
así que hacemos

cmd -> startup pfile='C:\V982656-01\database\INITORCL.ORA'


Ahora creamos el archivo binario a partir de nuestro archivo modificado:

cmd -> create spfile from pfile='C:\V982656-01\database\INITORCL.ORA';

Por lo tanto, ahora si hacemos cmd ->shutdown immediate de nuevo, 

no tenemos que especificar el pfile otra vez al abrir la base de datos otra vez, ya que el spfile
ha sido sobreescrito con la información actualizada.

cmd -> startup nomount (solo crea la instacia pero no abre siquiera los ficheros, es decir, la instancia está 
                        en memoria pero no está asociada la base de datos a ella. Los ficheros a los que no 
			accede son los de control y datos (redo, ...), sí que accede a spfile, y por eso sabe
			cuánta memoria reserva (sga), etc)


Hasta ahora únicamente se inicia la instancia (mirar la escalera de las diapos)
Con esto montamos la base de datos (ahora solo puede conectarse sys):

cmd -> alter database mount; 

Finalmente, abrimos la base de datos para que pueda haber más conexiones del resto de usuarios:

cmd -> alter database open;

------------------


Nos metemos en https://localhost:5500/em/login

usuario: system
contraseñ: bd.lcc.2024

*/
