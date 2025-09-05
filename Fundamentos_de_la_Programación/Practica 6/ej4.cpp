/*
4. Escribe un programa que lea una lista de números comprendidos entre 0 y 9
separados por espacios (la lista acabará cuando se lea un número negativo y a priori no se
puede determinar cuántos números contiene) e imprima por pantalla un histograma como el
anterior.
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
#include <array>
const int TAM = 10;
const char SIMBOLO = '*';
using namespace std;
typedef array <int,TAM> TVector;

void inicio (TVector& v)
{
    for (int i=0; i<TAM; i++)
    {
        v[i]=0;
    }
}

void leerDatos(TVector& v)
{
    int num;
    inicio (v);

    cout << "Introduzca una secuencia de digitos: ";
    cout<<endl;
    cin>>num;

    while (num>=0)
    {
        v[num]++;
        cin>>num;
    }
}

int mayor (const TVector& v){
int may=v[0];
for (int i=1; i<TAM; i++){
    if(may<v[i]){
        may=v[i];
    }
}
return may;
}

void impDatos (){
for (int i = 0; i<TAM; i++){
    cout << i << " ";
}
}

int main(){
    TVector v;
    int may;
    leerDatos (v);
    may=mayor (v);
    while (0<=may){
        for (int i = 0; i<TAM; i++){
            if (v[i]>may){
                cout << SIMBOLO<<" ";
            }else{
            cout <<"  ";
            }
        }
        may--;
        cout <<endl;
    }

    impDatos ();

	return 0;
}
