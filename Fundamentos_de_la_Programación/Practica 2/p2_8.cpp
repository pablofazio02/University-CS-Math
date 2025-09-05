/* 8. Programa que lee un codigo de cuatro digitos y
presente su significado.
Alumno: Pablo Fazio Arrabal*/

#include <iostream>
using namespace std;

int main()
{
    int num;
cout << "Introduzca un numero de 4 digitos (el primero distinto de cero): ";
cin>>num;

if ((num<=999) || (num >= 9999)){
    cout << "ERROR: CODIGO INVALIDO (no tiene 4 digitos)" << endl;
}else if (((num%1000)%10)!=((num%1000)/10)%(num/1000)) {
    cout << "ERROR: CODIGO INVALIDO (digito de control erroneo)" <<endl;
}else{
cout << "PROVINCIA              " << num/1000 << endl;
cout << "NUMERO DE OPERACION   " << (num%1000)/10 << endl;
cout << "DIGITO DE CONTROL      " << ((num%1000)%10) << endl;
}

 return 0;
}
