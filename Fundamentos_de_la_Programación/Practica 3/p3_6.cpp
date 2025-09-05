#include <iostream>
using namespace std;

int main()
{
 int a, b;
 char operacion;
 float resultado;

 do{
 cout <<"Operacion: ";
 cin>>operacion;

 cout << "Operando 1: ";
 cin>>a;

 cout << "Operando 2: ";
 cin>>b;


 switch(operacion){
 case('+'): resultado=a+b;
 break;
 case('-'): resultado=a-b;
 break;
 case('*'): resultado=a*b;
 break;
 case('/'): resultado=a/b;
 break;
 default: cout << "ERROR!!!"<<endl;}

 cout <<"Resultado: "<<resultado<<endl;
 }while(operacion!='&');
 return 0;
}
