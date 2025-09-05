/*
5. Se pide crear un procedimiento denominado eratostenes que, mediante la criba descrita
y haciendo uso de arrays, debe tomar como parámetro un natural N (mayor que 0 y menor o
igual que una constante dada MAX) e imprimir por pantalla todos los números primos del 1 al
N. Crea también una función main para comprobar que el procedimiento se ha codificado
correctamente.
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
#include <array>
using namespace std;
const int MAX = 100;
typedef array <int, MAX> TVector;
struct TEratostenes
{
    TVector datos1;
    TVector datos2;
    int numero;
};

void leerDatos(TEratostenes& v)
{
    do
    {
        cout << "Introduzca el limite para calcular los primos (> 0 y <= 100): ";
        cin>>v.numero;
    }
    while (v.numero<=0 || v.numero>MAX);

    for (int i = 0; i<v.numero; i++)
    {
        v.datos1[i]=i+1;
    }

}

void eratostenes (TEratostenes& v)
{
    int cont=1;

    while (cont*cont<v.numero)
    {
        v.datos1[0]=0;
        for (int i=1; i<v.numero; i++)
        {
            if((v.datos1[i]!=0)&&(v.datos1[i]%(cont+1)==0)&&(v.datos1[i]!=cont+1))
            {
                v.datos1[i]=0;
            }
        }
        cont++;
    }
}

void intercambiar (TEratostenes& v, int& cont)
{
    cont=0;
    for (int i=0; i<v.numero; i++)
    {
        if(v.datos1[i]!=0)
        {
            v.datos2[cont]=v.datos1[i];
            cont++;
        }
    }
}

void imprimirDatos (const TEratostenes& v, int cont)
{
    cout << "Los numeros primos menores o iguales que "<<v.numero<<" son: "<<endl;

    for (int i=0; i<cont; i++)
    {
        cout << v.datos2[i]<<" ";
    }

}

int main()
{
    TEratostenes v;
    int cont;

    leerDatos (v);
    eratostenes (v);
    intercambiar (v, cont);
    imprimirDatos (v, cont);

    return 0;
}
