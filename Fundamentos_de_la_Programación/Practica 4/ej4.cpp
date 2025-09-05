/* 4. Algoritmo que lea un número natural N por teclado y dibuje un rombo de
asteriscos como el de la figura
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
using namespace std;
const char SIMBOLO = '*';

int leerFilas (){

int num;

do{
cout << "Introduzca el numero de filas: ";
cin>>num;
}while(num<0);
return num;
}

void imprimeBlanco (int num, int filas){
for (int i=filas-num; i>=0; i--){
cout << "  ";
}
}

void imprimeNum (int num){
for (int x=1; x<=num; x++){
cout<<SIMBOLO<<"   ";
}
}


int main (){
int filas,num=1;
cout << "Practica 4. Rombo de asteriscos." << endl;
filas=leerFilas()-1;

while(filas>=num){
imprimeBlanco(num, filas);
imprimeNum(num);
cout<<endl;
num++;
}

while(1<=num){
imprimeBlanco(num, filas);
imprimeNum(num);
cout<<endl;
num--;
}
return 0;
}
