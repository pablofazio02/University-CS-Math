/*
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
#include <string>
using namespace std;

int busqueda(char c, string& cadena){
unsigned i =0;
bool stop=false;
while((i<cadena.size())&&!stop){
    if(cadena[i]==c){
        stop=true;
        cadena[i]= ' ';
    }else{
    i++;
    }
}

return i;

}

bool mismasLetras(const string& primera, const string& cadena){

int i,j;
bool verdad=true;
string aux=primera;
i=0;

while(verdad&&(i<int(cadena.size()))){
    j=busqueda(cadena[i], aux);
    if(j==int(aux.size())){
        verdad=false;
    }
    i++;
}

return verdad;
}

bool buscar (const string& primera, const string& cadena)
{
    bool verdad = true;
    if(cadena.size()==primera.size())
    {
        verdad=mismasLetras(primera,cadena);
    }
    else
    {
        verdad=false;
    }

    return verdad;
}



int main()
{
    string primera, cadena;
    int numAnagrama=0;
    cout << "Introduzca un texto terminado con la palabra FIN:"<<endl<<endl;
    cin>>primera;
    if(primera!="FIN")
    {
        cin>>cadena;
        while(cadena!="FIN")
        {
            if(buscar(primera,cadena))
            {
                numAnagrama++;
            }
            cin>>cadena;
        }
    }
    cout << endl<< "El numero de palabras anagramas de la primera es: "<<numAnagrama<<endl;
}
