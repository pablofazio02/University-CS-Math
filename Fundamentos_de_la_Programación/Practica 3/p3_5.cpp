#include <iostream>
using namespace std;

int main()
{
 int n;
 float sigNumerador=2, sigDenominador=3, pi=4;

 cout << "Introduce un valor n determinado: ";
 cin>>n;

 for(int i=1; n>=i; i++){
    pi=pi*(sigNumerador/sigDenominador);
    if(i%2==0){
        sigDenominador+=2;
    }else{
    sigNumerador+=2;
    }

 }
  cout << "Resultado: " <<pi<<endl;
 return 0;
}
