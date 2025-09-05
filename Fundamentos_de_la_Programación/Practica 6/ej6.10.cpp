/*
10. Define el tipo de datos TLista para ello y diseña un procedimiento
criba que recibe como parámetros de entrada una lista de números enteros lista1 de tipo
TLista y un número natural x. El procedimiento devolverá como parámetro de salida otra
lista lista2 de tipo TLista que contendrá sólo aquellos números de lista1 que están
repetidos x veces.
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
#include <array>
using namespace std;
const int MAX=10;
typedef array <int,MAX> TVector;
struct TLista
{
    int num;
    int x;
    TVector lista1;
};

void leerDatos (TLista& lista)
{

    do
    {
        cout << "Cuantos numeros desea introducir (maximo 10): ";
        cin>>lista.num;
    }
    while (lista.num>MAX||lista.num<=0);

    cout << "Introduzca "<<lista.num<<" numeros: ";

    for (int i = 0; i < lista.num; i++)
    {
        cin>>lista.lista1[i];
    }

    do
    {
        cout << "Introduzca el numero de repeticiones para realizar la criba: ";
        cin>>lista.x;
    }
    while(lista.x<=0);

}

void criba(const TLista& lista,TLista& lista2)
{

    lista2.x=0;
    for (int x=0; x<lista.num; x++)
    {
        int cont=0;

        for (int i=0; i<lista.num; i++)
        {
            if(lista.lista1[x]==lista.lista1[i])
            {
                cont++;
            }
        }


        bool found;



        if(cont==lista.x)
        {
            found=false;
            ;

            for (int y=lista2.x; y>=0; y--){
                if(lista.lista1[x]==lista2.lista1[y])
                {
                    found=true;
                }
            }

            if(!found){
                lista2.lista1[lista2.x]=lista.lista1[x];
                lista2.x++;
            }
        }
    }
}

void imprimirLista (const TLista lista2)
{
    cout << "La lista cribada es: ";

    for (int i=0; i<lista2.x; i++ )
    {
        cout<< lista2.lista1[i] << " ";
    }

}

int main()
{

    TLista lista1, lista2;

    leerDatos(lista1);

    criba(lista1, lista2);

    imprimirLista(lista2);

    return 0;
}
