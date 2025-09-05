/* 3. Programa para leer un caracter y decir si es letra, punto u otro tipo de caracter.
Alumno: Pablo Fazio Arrabal*/

#include <iostream>
using namespace std;

int main()
{
    char caracter;

    cout << "Introduzca un caracter de teclado de letra o punto: ";
    cin >> caracter;

    if ((caracter>='a' && caracter<='z')||(caracter>= 'A' && caracter<= 'Z')){
    cout << "Es letra."<<endl;
    }else if (caracter=='.'){
    cout << "Es punto."<<endl;
    }else{
    cout << "Error."<<endl;
    }

return 0;
}
