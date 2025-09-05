/* 5. Programa para emitir la factura a una compra de un determinado numero de unidades.
Alumno: Pablo Fazio Arrabal*/

#include <iostream>
using namespace std;
const float IVA = 0.12;
const float DESC = 0.05;
const int PRECIO_UN = 100;
const int UMBRAL = 300;
int main()
{
    int unidad;
    float precioTotal;

    cout << "Numero de unidades adquiridas: ";
    cin >> unidad;

    precioTotal = (unidad*PRECIO_UN)+IVA*(unidad*PRECIO_UN);

    if(precioTotal > UMBRAL){
        precioTotal = precioTotal - DESC*precioTotal;
        cout << "Se aplica un descuento del 5%" << endl;
    }

    cout << "El precio total a pagar es: " << precioTotal << " euros" <<endl;

    return 0;
}
