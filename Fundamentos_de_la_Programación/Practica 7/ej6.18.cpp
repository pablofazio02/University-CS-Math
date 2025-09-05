/*
18. Se desea crear una aplicación que permita asignar cargos electos a diversos partidos en unas
elecciones, considerando el sistema conocido como ley de D’Hondt. El sistema de D'Hondt es
una fórmula electoral, creada por Victor d'Hondt, que permite obtener el número de cargos
electos asignados a las candidaturas, en proporción a los votos conseguidos
Alumno: Pablo Fazio Arrabal
*/


#include <iostream>
#include <array>
using namespace std;
const int MAXC=15,MAXP=10;
typedef array<int,MAXP>TVoto;
typedef array<char,MAXP>TArrayP;
typedef array<int,MAXC>TFila;
typedef array<TFila,MAXP>TMatriz;
typedef array<bool,MAXC>TFilaB;
typedef array<TFilaB,MAXP>TMatrizB;
struct TCargos
{
    int num;
    TFila carg;
};
struct TVotos
{
    int num;
    TVoto votos;
};
struct TNombres
{
    int num;
    TArrayP part;
};
struct TCargoElecto
{
    TArrayP nom;
    TVoto num;
};

void Leerdatos (TCargos& c, TNombres& p, TVotos& v)
{
    cout << "Introduzca el Numero de Cargos: ";
    cin >> c.num;
    cout << "Introduzca el Numero de Partidos: ";
    cin >> p.num;
    v.num = p.num;
    cout << "Introduzca el Nombre y Numero de Votos por Partido:" << endl;
    for (int i=0; i<p.num; i++)
    {
        cout << "Partido " << i+1 << ": ";
        cin >> p.part[i];
        cin >> v.votos[i];
    }

}

void Rellenar (TMatrizB& b, TNombres& p, TCargos& c, TCargoElecto& ce)
{
    for (int i=0; i<p.num; i++)
    {
        for (int j=0; j<c.num; j++)
        {
            b[i][j]=true;
        }
    }
    for (int i=0; i<p.num; i++)
    {
        ce.num[i]=0;
        ce.nom[i]=p.part[i];
    }
}

int SaberMayor (const TMatriz& a,  TMatrizB& b, const TNombres& p, const TCargos& c, TCargoElecto& ce)
{
    int mayor=a[0][c.num-1];
    for (int i=0; i<p.num; i++)
    {
        for (int j=0; j<c.num; j++)
        {
            if ((mayor<=a[i][j])&&(b[i][j]==true))
            {
                mayor=a[i][j];
            }
        }
    }
    for (int i=0; i<p.num; i++)
    {
        for (int j=0; j<c.num; j++)
        {
            if (a[i][j]==mayor)
            {
                b[i][j]=false;
                ce.num[i]++;
            }
        }
    }

    return mayor;
}

void Secuencia1 (const TCargos& c, const TNombres& p, TMatriz& a, const TVotos& v, TCargoElecto& ce, TMatrizB& b)
{
    int mayor;
    int k=0;
    for (int i=0; i<p.num; i++)
    {
        for (int j=1; j<c.num; j++)
        {
            a[i][0]=v.votos[i];
            a[i][j]=(a[i][0]/(j+1));
        }
    }

    while (k<c.num)
    {
        mayor=SaberMayor(a,b,p,c,ce);
        mayor++;
        k++;
    }

}

void Salida (const TCargoElecto& ce, const TCargos& c)
{
    cout << "Los Cargos Electos son: " << endl;
    for (int i=0; i<c.num; i++)
    {
        if (ce.num[i]>0)
        {
            cout << ce.nom[i] << " " << ce.num[i] << endl;
        }
    }
}


int main()
{
    TCargos c;
    TVotos v;
    TMatriz a;
    TNombres p;
    TMatrizB b;
    TCargoElecto ce;
    Leerdatos (c,p,v);
    Rellenar(b,p,c,ce);
    Secuencia1 (c,p,a,v,ce,b);
    Salida(ce,c);

    return 0;
}
