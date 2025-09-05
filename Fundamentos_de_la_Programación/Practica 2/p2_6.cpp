/* 6. Programa para emitir el recibo de la electricidad.
Alumno: Pablo Fazio Arrabal*/

#include <iostream>
using namespace std;
const float PKW = 0.5;
const float SKW = 0.35;
const float RKW = 0.25;
const int FIJO = 1;
int main()
{
    int contador;
    float precio;
    precio = 0;

    cout << "Introduzca el consumo del contador: ";
    cin >> contador;

    if (contador <= 100){
        precio = FIJO + contador * PKW;
    }else if (contador <= 250){
        precio = FIJO + 100 * PKW + ((contador - 100) * SKW);
    }else{
        precio = FIJO + 100 * PKW + 150 * SKW + (contador - 250) * RKW;
    }

    cout << "El importe a pagar es: " << precio << " euros." << endl;

    return 0;
}
