/*
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
#include <array>
#include <string>
using namespace std;
const int N_EVALUACIONES=3;
const int MAX_ALUMNOS=20;
typedef array <double,N_EVALUACIONES> TArray;
struct TDatos{
TArray notas;
string nombre;
};

void leerDatos(TDatos& a){
cout <<"Introduce el nombre y "<<N_EVALUACIONES<<" notas: ";
cin>>a.nombre;

for(int i =0; i<N_EVALUACIONES; i++){
    cin>>a.notas[i];
}

}



int main()
{
  int num;
do{
    cout << "Introduce el numero de alumnos: ";
    cin>>num;
}while(num>MAX_ALUMNOS&&num<=0)

for(int i = 1; i<=num; i++){
    leerDatos(a);
}

return 0;
}
