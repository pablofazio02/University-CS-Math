/*
4. Se empieza poniendo un 1 en la casilla situada en la mitad de la primera fila. A partir de
ese momento se inicia un proceso que visitará las diferentes casillas subiendo a la
izquierda diagonalmente para ir poniendo en ellas los siguientes números de forma
consecutiva hasta poner el número final N^2. Si en este proceso se pasa el borde superior
o izquierdo del cuadrado, se continúa por el extremo opuesto (ejemplos: en la figura los
pasos marcados desde 1 a 2 y desde 3 a 4). Por otro lado, si en este proceso se alcanza
una casilla ya rellena, se baja una posición desde el último valor depositado (ejemplo:
en la figura el paso desde 5 a 6).
Implementa un programa que construya un cuadrado mágico para una constante N impar dada
(por ejemplo, N = 5) y lo visualice por pantalla.
Alumno: Pablo Fazio Arrabal
*/

#include <iostream>
#include <array>
using namespace std;

const int N = 5;
typedef array <int,N> TFila;
typedef array <TFila,N> TMatriz;

void inicio (TMatriz& a)
{
    for (int i = 0; i<N; i++)
    {
        for (int j = 0; j<N; j++)
        {
            a[i][j]=0;
        }
    }
}

void mas(int& v)
{
    if (v == N-1)
    {
        v = 0;
    }
    else
    {
        v++;
    }

}

void menos(int& v)
{
    if (v == 0)
    {
        v = N-1;
    }
    else
    {
        v--;
    }

}

void siguienteCoordenada(const TMatriz& a, int& x, int& y)
{
    menos(x);
    menos(y);
    if (a[x][y] != 0)
    {
        mas(y);
        mas(x);
        mas(x);
    }
}


void rellenarMatriz(TMatriz& a)
{
    inicio (a);

    int x= 0;
    int y= N/2;
    for (int i =1; i<=N*N; i++)
    {
        a[x][y] = i;
        siguienteCoordenada(a,x,y);

    }


}

void impDatos (const TMatriz& a)
{
    cout << "El cuadrado magico para N = "<<N<<" es: "<<endl;

    for (int i =0; i<N; i++)
    {
        for (int j = 0; j<N; j++)
        {
            if(a[i][j]<10)
            {
                cout << " "<<a[i][j]<<"  ";
            }
            else
            {
                cout <<a[i][j]<<"  ";
            }
        }
        cout <<endl;
    }

}

int main()
{
    TMatriz a;
    rellenarMatriz(a);
    impDatos(a);

    return 0;
}
