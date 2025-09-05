/* 2. Programa que nos dice cual es el mayor estricto
de tres numeros enteros.
Alumno: Pablo Fazio Arrabal*/

#include <iostream>
using namespace std;

int main()
{
    int num1, num2, num3;

    cout << "Introduzca tres numeros enteros: ";
    cin >> num1 >> num2 >> num3;

    if ((num1>num3)&&(num1>num2)){
        cout << "El numero mayor es el "<<num1<<endl;
    }else if ((num2>num3)&&(num2>num1)){
        cout << "El numero mayor es el "<<num2<<endl;
    }else if((num3>num1)&&(num3>num2)){
        cout << "El numero mayor es el "<<num3<<endl;
    }else{
        cout << "No existe mayor estricto entre los tres enteros."<<endl;
    }

    return 0;
}
