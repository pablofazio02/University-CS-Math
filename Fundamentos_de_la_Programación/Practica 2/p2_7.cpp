/* 7. Programa que lea el ordinal de un mes y deduzca el número de días que tiene
dicho mes.
Alumno: Pablo Fazio Arrabal*/

#include <iostream>
using namespace std;

int main()
{
 int mes;

 cout << "Introduzca numero de mes: ";
 cin >> mes;

 switch (mes){
 case 1:
 case 3:
 case 5:
 case 7:
 case 8:
 case 10:
 case 12:
    cout << "Ese mes tiene 31 dias." << endl;
    break;

 case 4:
 case 6:
 case 9:
 case 11:
    cout << "Ese mes tiene 30 dias." << endl;
    break;

 case 2:
    cout << "Ese mes tiene 28 dias." << endl;
    break;

 default:
    cout << "Mes incorrecto." << endl;
    break;
 }

 return 0;
}
