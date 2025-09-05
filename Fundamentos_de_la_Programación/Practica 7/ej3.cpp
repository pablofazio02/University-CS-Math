/*
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
#include <array>
using namespace std;
const int N = 5;
typedef array <int,N> TFila;
typedef array <TFila,N> TMatriz;

void leerDatos(TMatriz& a){
cout << "Introduzca matriz "<<N<<"x"<<N<<" fila a fila: "<<endl;

for (int i =0; i<N; i++){
    for (int j=0; j<N; j++){
        cin>>a[i][j];
    }
}
}

bool magico(const TMatriz& a){
bool verdad = true;

int suma=0;
for(int i=0; i<N; i++){
    suma=suma+a[i][0];
}

int sumaDiagonal=0;
int sumaDiagonal2=0;

for (int i = 0; i<N; i++){
    int sumaCol=0;
    int sumaFil=0;

    for (int j=0; j<N; j++){
        sumaCol=sumaCol+a[i][j];
        sumaFil=sumaFil+a[j][i];
        if(i==j){
        sumaDiagonal=sumaDiagonal+a[i][j];
        }
        if(i+j==N-1){
        sumaDiagonal2=sumaDiagonal2+a[i][j];
        }
    }

    if((sumaCol!=suma)||(sumaCol!=suma)){
        verdad=false;
    }
}

if((sumaDiagonal!=suma)||(sumaDiagonal2!=suma)){
    verdad=false;
}

return verdad;
}


int main()
{
TMatriz a;
leerDatos(a);

if(magico(a)){
cout << "La matriz SI es un cuadrado magico."<<endl;
}else{
cout << "La matriz NO es un cuadrado magico."<<endl;
}

return 0;
}
