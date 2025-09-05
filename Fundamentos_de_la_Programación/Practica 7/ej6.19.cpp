/*
19. Un importante vulcanólogo, con objeto de estudiar las consecuencias destructoras de un volcán
en una determinada área, pretende desarrollar un sistema informático que le ayude en su tarea
Alumno: Pablo Fazio Arrabal
*/


#include <array>
#include <iostream>
using namespace std;

const int FILAS = 5;
const int COLUMNAS = 5;

typedef array<int, COLUMNAS> TFilaSup;
typedef array<TFilaSup, FILAS> Superficie;

typedef array<char, COLUMNAS> TFilaLav;
typedef array<TFilaLav, FILAS> Lava;

void inicio (Lava& a)
{
    for (int i = 0; i<FILAS; i++)
    {
        for (int j = 0; j<COLUMNAS; j++)
        {
            a[i][j]= ' ';
        }
    }
}

bool valida(int f, int c)
{
    return (0 <= f) && (f < FILAS) && (0 <= c) && (c < COLUMNAS);
}

void desplazar(int fOrig, int cOrig, int fDest, int cDest, const Superficie&
               sup, Lava& lava)
{
    if (valida(fDest,cDest) && (sup[fDest][cDest] < sup[fOrig][cOrig]))
    {
        lava[fDest][cDest] = 'P';
    }
}

void encontrar(int f, int c, const Superficie& sup, Lava& lava)
{
    desplazar(f,c,f,c-1,sup,lava);
    desplazar(f,c,f,c+1,sup,lava);
    desplazar(f,c,f-1,c,sup,lava);
    desplazar(f,c,f+1,c,sup,lava);
}

void posicion(const Lava& lava, int& f, int& c, bool& terminar)
{
    int i,j;
    terminar = true;
    i = 0;
    while ((i < FILAS) && terminar)
    {
        j = 0;
        while ((j < COLUMNAS) && terminar)
        {
            if (lava[i][j] == 'P')
            {
                f = i;
                c = j;
                terminar = false;
            }
            j++;
        }
        i++;
    }
}

void flujoDeLava(const Superficie& sup, int fil, int col, Lava& lava)
{
    inicio (lava);
    int i = fil;
    int j = col;
    bool terminar;
    lava[i][j]='P';
    do
    {
        encontrar(i,j,sup,lava);
        lava[i][j]='*';
        posicion (lava,i,j,terminar);
    }
    while(!terminar);
}

int main()
{
    Superficie sup;
    Lava lava;
    int fil,col;
    cout << "Introduzca superficie (matriz de naturales " << FILAS
         << "x" << COLUMNAS << "):\n";
    for (int i = 0; i < FILAS; i++)
    {
        for (int j = 0; j < COLUMNAS; j++)
        {
            cin >> sup[i][j];
        }
    }
    cout << "Introduzca punto de crater (fila y columna):\n";
    cin >> fil >> col;
    flujoDeLava(sup,fil,col,lava);
    cout << "El recorrido de la lava es:\n";
    for (int i = 0; i < FILAS; i++)
    {
        for (int j = 0; j < COLUMNAS; j++)
        {
            cout << lava[i][j]<< " ";
        }

        cout << endl;
    }
    return 0;
}

