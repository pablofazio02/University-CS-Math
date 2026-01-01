@echo off
cls

:: Compilar los ficheros necesarios:
call compilar.bat

:: Ejecutar el compilador PLC con los argumentos:
:: $1: Fichero .pl a compilar, que genera código intermedio
:: $2: Fichero .ctd donde guardar el código generado
java PLC %1 %2

:: Mostrar el contenido de los ficheros
echo "---------------------------- .pl --"
type %1
echo ""
echo "--------------------------- .ctd --"
type %2
echo ""

:: Ejecutar el programa "ctd" con el argumento:
:: $2: Fichero .ctd que simula un código ensamblador
echo "-------------------------- final --"
call ctd %2
echo ""
echo "-----------------------------------"
