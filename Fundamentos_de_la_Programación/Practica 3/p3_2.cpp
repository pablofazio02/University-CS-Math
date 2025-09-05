#include <iostream>
using namespace std;

int main()
{
   int numero, suma=0, precio;

   cout << "Introduzca numero de modelos de coche: ";
   cin>>numero;

   for(int i=1; numero>=i; i++){
    cout << "Precio modelo "<<i<<": ";
    cin>>precio;

    suma=suma+precio;
   }

   float media= float(suma)/float(numero);

   cout << "El valor medio de los "<<numero<<" modelos de coches asciende a: "<<media<<" euros."<<endl;

    return 0;
}
