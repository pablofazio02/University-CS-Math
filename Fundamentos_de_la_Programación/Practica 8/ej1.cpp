/*
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
#include <string>
using namespace std;


void leerDatos(string& numero){
cout << "Entrada: ";
cin>>numero;
}


int num(const string& numero){
int res=0;
for (unsigned i=0; i<numero.size(); i++){
    res = res*10 + (int (numero[i]-'0'));
}
return res;
}

int main(){
string a;
leerDatos(a);
cout << "Salida: "<<num(a)<<endl;


return 0;
}
