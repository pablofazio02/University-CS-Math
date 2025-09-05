/*
5. Escribe un programa que lea una sucesión de 10 números naturales, encuentre el valor máximo
y lo imprima junto con el número de veces que aparece y las posiciones en que esto ocurre.
El proceso se repite con el resto de la sucesión hasta que no quede ningún elemento por tratar.
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
#include <array>
using namespace std;
const int TAM = 10;
typedef array <int,TAM> TVector;
typedef array <bool,TAM> TVerdad;

struct TReg
{
    int num;
    TVector datos1;
    TVerdad datos2;
};

typedef array <int,TAM> TPosicion;

struct TApar
{
    TPosicion pos;
    int num;
};

void leerDatos(TReg& a)
{
    cout << "Ejemplo de entrada:       ";

    a.num=0;
    for (int i = 0; i < TAM; i++)
    {
        cin >> a.datos1[i];
        a.datos2[i] = false;
    }

cout <<endl;
}

int numMax(const TReg& a)
{
    int mayor=0;

    for (int i = 1; i<TAM; i++)
    {
        if((a.datos1[i]>mayor)&&(!a.datos2[i]))
        {
            mayor=a.datos1[i];
        }
    }

    return mayor;
}

void repeticiones (const TReg& a, int mayor, TApar& b)
{
    b.num=0;
    for (int i=0; i<TAM; i++)
    {
        if((mayor==a.datos1[i])&&(!a.datos2[i]))
        {
            b.pos[b.num]=i+1;
            b.num++;
        }
    }
}

void impDatos(int mayor, const TApar& a)
{

    cout << "El numero "<<mayor<<" aparece "<<a.num;
    if (a.num> 1)
    {
        cout << " veces, en las posiciones ";
    }
    else
    {
        cout << " vez, en la posicion ";
    }
    for(int i =0; i<a.num; i++)
    {
        cout << a.pos[i]<<" ";
    }
    cout <<endl;

}

void actualizar (TReg& a, TApar& b)
{
    a.num+=b.num;
    for (int i =0; i<b.num; i++)
    {
        a.datos2[b.pos[i]-1]=true;
    }

}

int main()
{
    TReg a;
    TApar b;
    int maximo;

    leerDatos(a);
    cout << "Salida generada:          ";
    while(a.num<TAM)
    {
        if(a.num!=0){
            cout<<"                          ";
        }
        maximo=numMax(a);
        repeticiones(a,maximo,b);
        impDatos(maximo,b);
        actualizar(a,b);
    }


    return 0;
}
