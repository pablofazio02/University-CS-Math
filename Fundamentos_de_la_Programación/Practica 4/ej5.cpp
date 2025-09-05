/* 5.Algoritmo que lea de teclado un número natural N mayor que cero y muestre las N
primeras filas del siguiente triángulo.
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
using namespace std;

leerDatos(){
int filas;

do{
    cout << "Introduzca numero de filas: ";
    cin>>filas;
}while(filas<=0);

return filas;

}

void imprimeBlanco (int num, int filas){
for (int i=filas-num; i>0; i--){
    cout <<" ";
}
}

void imprimeNum (int num, int filas){
for (int x=filas; x<=num; x++){
    cout <<x-(10*(x/10));


}
}

void imprimeNumInv (int num, int filas){
for(int z=num-1; z>=filas ; z--){
    cout <<z-(10*(z/10));
}
}

int main()
{
int filas, num=1, cont=1;
cout << "Practica 4. Piramide de digitos" << endl;
filas=leerDatos();
while(2*filas>=num){
imprimeBlanco(cont, filas);
imprimeNum(num, cont);
imprimeNumInv(num, cont);
cout<<endl;
num=num+2;
cont++;
}
}
