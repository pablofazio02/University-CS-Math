#include <iostream>
using namespace std;


int leerDatos(){
int num;
do{
cout << "Introduzca un numero natural N: ";
cin>>num;
}while(num<=0);
return num;
}

bool esPrimo(int num) {
 int divisor = 2;
 while ((divisor <num) && (num % divisor != 0)) {
 divisor++;
 }
 return (divisor >= num);
}

int main()
{
    int num, start = 2;
    bool primo;
    num=leerDatos();

    while(start<=num){
        primo=esPrimo(start);
        if(primo){
            cout <<start<<" ";
        }
        start++;
    }

return 0;

}
