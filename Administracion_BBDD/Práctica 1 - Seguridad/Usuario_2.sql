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

