/*
11. Diseña un procedimiento centroVector que reciba como parámetro un vector V y nos
devuelva dos valores como parámetros: el primero indica si existe o no el centro del vector, y el
segundo, indica el índice en el que se encuentra el centro en caso de existir. Diseña la función
principal (main) para probar el funcionamiento del procedimiento.
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
#include <array>
using namespace std;
// Vamos a suponer que nuestra constante N es igual a 5.
const int MAX = 5;
typedef array <int, MAX> TVector;

void leerVector (TVector& v)
{

    cout << "El contenido del vector es: ";
    for (int i = 0; i<MAX; i++)
    {
        cin>>v[i];
    }

}

void centroVector (const TVector& v, bool& existe, int& indice)
{

    existe=false;
    indice=1;

    while(indice<=MAX-2&&!existe)
    {
        int sumaIzq=0;
        int sumaDer=0;
        for (int i=0; i<=indice-1; i++)
        {
            sumaIzq=((indice-i)*v[i])+sumaIzq;
        }

        for (int j=indice+1; j<=MAX-1; j++)
        {
            sumaDer=((j-indice)*v[j])+sumaDer;
        }

        if(sumaIzq==sumaDer)
        {
            existe=true;
        }
        else
        {
            indice++;
        }
    }
}


void impDatos (const TVector& v, bool existe, int indice)
{
    if (existe)
    {
        cout << "El centro de este vector es el indice "<<indice<<" (casilla donde esta el "<<v[indice]<<") ya que al calcular los sumatorios: "<<endl;
        cout << "- Sumatorio izquierda: ";
        int suma=0;
        for (int i=0; i<=indice-1; i++)
        {
            cout <<"("<<indice<<"-"<<i<<")*v["<<i<<"]";
            suma=(indice-i)*v[i]+suma;
            if(i<indice-1)
            {
                cout<< " + ";
            }
        }
        cout<<" = ";
        for (int i=0; i<=indice-1; i++)
        {
            cout <<indice-i<<"*"<<v[i];
            if(i<indice-1)
            {
                cout<< " + ";
            }
        }
        cout<<" = "<<suma<<endl;
        suma=0;
        cout << "- Sumatorio derecha: ";
        for (int j=indice+1; j<=MAX-1; j++)
        {
            cout << "("<<j<<"-"<<indice<<")*v["<<j<<"]";
            suma=((j-indice)*v[j])+suma;
            if(j<MAX-1)
            {
                cout<< " + ";
            }

        }
        cout<<" = ";
        for (int j=indice+1; j<=MAX-1; j++)
        {
            cout <<j-indice<<"*"<<v[j];
            if(j<MAX-1)
            {
                cout<< " + ";
            }
        }
        cout<<" = "<<suma<<endl;
    }
    else
    {
        cout << "Este vector no tiene centro."<<endl;
    }
}


int main()
{
    TVector v;
    bool existe;
    int indice;

    leerVector (v);
    centroVector (v, existe, indice);
    impDatos (v, existe, indice);

    return 0;
}
