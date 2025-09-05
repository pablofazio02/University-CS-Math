/*
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
#include <array>
using namespace std;
const int N = 4;
typedef array <int,N> TFila;
typedef array<TFila,N> TMatriz;

void leerDatos(TMatriz& a){
cout << "Introduzca por filas una matriz "<<N<<" x "<<N<<":"<<endl<<endl;

for (int i = 0; i<N; i++){
    for (int j = 0; j<N; j++){
        cin>> a[i][j];
    }
}

cout <<endl;

}

bool simetrica (const TMatriz& a){
bool verdad = true;
for (int i = 0; i<N; i++){
    for (int j=0; j<N; j++){
        if(a[i][j]!=a[j][i]){
                verdad = false;
        }
    }
}
return verdad;
}

int main()
{

TMatriz a;
leerDatos(a);
if(simetrica(a)){
    cout << "Si es simetrica"<<endl;
}else{
cout << " No es simetrica"<<endl;
}

return 0;
}
