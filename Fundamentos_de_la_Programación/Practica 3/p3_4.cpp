#include <iostream>
using namespace std;

int main()
{
 char c;
 int cont=0;

 cout <<"Introduzca el texto terminado en un punto: "<<endl;
 cin.get(c);

 while(c!='.'){
    cout<<int(c)<<" ";
    cont++;
    cin.get(c);
 }
 cout<<endl<<"Numero de caracteres leidos: "<<cont<<endl;
 return 0;
}
