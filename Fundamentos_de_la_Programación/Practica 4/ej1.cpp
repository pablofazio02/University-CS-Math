#include <iostream>
using namespace std;

int leerDatos(){
int numero;
 do{
    cout << "Introduzca numero de filas: ";
    cin>>numero;
 }while(numero<0&&numero>10);

 return numero;
}

void espaciosBlanco (int fila, int num){
for(int i = 1; i<=2*(num-fila); i++){
    cout << " ";
}
}

void numeroPrim (int num){
for (int x=1; x<=num; x++){
    cout << x << " ";
}
}

void numeroUlt (int num){
for (int z=num-1; z>=1; z--){
    cout << z <<" ";
}
}

int main(){
int num, fila=1;

num=leerDatos();
while(fila<=num){
    espaciosBlanco(fila,num);
    numeroPrim (fila);
    numeroUlt (fila);
    cout <<endl;
    fila++;
}
return 0;
}
