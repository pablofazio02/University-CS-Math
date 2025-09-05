/*
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
#include <array>
using namespace std;
const int N=4;
const int M=5;
typedef array<int,M>TFila;
typedef array<TFila,N>TMatriz;

void leerDatos(TMatriz& a){
cout << " Introduzca por filas una matriz "<<N<<"x"<<M<<":"<<endl;

for (int i =0; i<N; i++){
    for(int j = 0; j<M; j++){
        cin>> a[i][j];
    }
}

}

void mayor (const TMatriz& a){
int numero= a[0][0];
int posicionF= 0;
int posicionC= 0;

for (int i = 0; i<N; i++){
    for (int j = 0; j<N; j++){
        if(numero<a[i][j]){
            numero=a[i][j];
            posicionF=i;
            posicionC=j;
        }
    }
}

cout << "El mayor de la matriz es: "<<numero<<" que aparece en la posicion: ["<<posicionF<<"] ["<<posicionC<<"]"<<endl;

}

int main()
{
TMatriz a;
leerDatos(a);
mayor(a);


return 0;
}
