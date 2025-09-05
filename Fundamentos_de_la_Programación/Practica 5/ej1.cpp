/*

Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
#include <array>
using namespace std;
const int MAX = 10;
typedef array <float, MAX> TVector;

float mayor (const TVector& v)
{
    float may=v[0];
    for (int i=1; i<MAX; i++)
    {
        if(v[i]>may)
        {
            may = v[i];
        }
    }

    return may;
}

int main()
{
    TVector v = {1,4,7,5,9,10,-3,5,100,345};
    float mayorNum;

    mayorNum=mayor(v);

    cout << "El numero mayor del array es: "<<mayorNum<<endl;

    return 0;
}
