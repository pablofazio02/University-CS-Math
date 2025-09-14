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
