/* 1. Programa que lee de teclado un numero entero y
nos dice si es positivo o negativo.
Alumno: Pablo Fazio Arrabal*/

#include <iostream>
using namespace std;

int main()
{
    int num;

    cout << "Introduzca un numero entero: ";
    cin >> num;

    if (num>=0){ //Suponemos 0 como positivo
        cout << "El numero "<<num<< " es positivo."<<endl;
    }else{
        cout << "El numero "<<num<< " es negativo."<<endl;
    }

    return 0;
}
