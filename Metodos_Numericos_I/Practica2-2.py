# -*- coding: utf-8 -*-
"""
Created on Fri Nov  4 18:18:05 2022

@author: pablo

Práctica 2.2 - Resolución numérica de ecuaciones escalares no lineales II
 -  Métodos Numéricos I

"""

from numpy import *
from matplotlib.pyplot import *

print('Ejercicio 1\n')

def puntofijo (g, x0, e, nmax):
    k = 0
    error = e + 1 
    while(e < error and k < nmax):
        x1 = g(x0)
        error = abs(x1-x0)
        k+=1
        x0=x1
    if(k<nmax):
        print("El programa se ha detenido por alcanzar el criterio de parada")
        print ("La aproximación de la raíz es ", x1, " tras ", k, " iteraciones")
    else:
        print("El programa se ha detenido por alcanzar el máximo de iteraciones")
        print("La aproximación de la raíz es ", x1)
    return x1

print('Ejercicio 2\n')

def g1(x):
    return exp(-x)

def g2(x):
    return x-(x-exp(-x))/(1+exp(-x))

print('Apartado a)\n')

puntofijo(g1, 0.5, 1e-7, 100)

print('Apartado b)\n')

puntofijo(g2, 0.5, 1e-7, 100)

print('Ejercicio 3\n')

def k1(x):
    return (2/3) + 0.093*sin(x)

def k2(x):
    return x-(x-0.093*sin(x)-(2/3))/(1-0.093*cos(x))

print('Apartado a)\n')

puntofijo(k1, 0.5, 1e-7, 100)

print('Apartado b)\n')

puntofijo(k2, 0.5, 1e-7, 100)

print('Ejercicio 4\n')

def t1(x):
    return cos(x)

def t2(x):
    return x-(cos(x)-x)/(-sin(x)-1)

print('Apartado a)\n')

puntofijo(t1, 0.5, 1e-7, 100)

print('Apartado b)\n')

puntofijo(t2, 0.5, 1e-7, 100)

print('Ejercicio 5')

def r1(x):
    return x - ((x**5-5*x**3 + 1)/(5*x**4 - 15*x**2))

def r2(x):
    return (5*x**3 - 1)**(1/5) # Sí funciona!

def r3(x):
    return x + 0.2*(x**5-5*x**3 + 1) # Sí funciona!

def r4(x):
    return x + x**5-5*x**3 + 1 # No sale la convergencia OverFlow!!

print('Apartado a)\n')

puntofijo(r1, 0.5, 1e-7, 100)
       
print('Apartado b)\n')

puntofijo(r2, 0, 1e-7, 100)

x = linspace (0,1,100)
y = r3(x)

plot(x,y,x,x)
show()

x = linspace (0,1,100)
y = r4(x)

plot(x,y,x,x)
show()

print('Ejercicio 6\n')

print('Apartado a)\n')

def puntofijo_bis (f, g, x0, e, nmax):
    k = 0
    error = e + 1
    while(e < error and k < nmax):
        x1 = g(x0)
        error = abs(f(x1))
        k+=1
        x0=x1
    if(k<nmax):
        print("El programa se ha detenido por alcanzar el criterio de parada")
        print ("La aproximación de la raíz es ", x1, " tras ", k, " iteraciones")
    else:
        print("El programa se ha detenido por alcanzar el máximo de iteraciones")
        print("La aproximación de la raíz es ", x1)
    return x1

print('Apartado b)\n')

def z1(x):
    return x + (x - 1)*exp(x)

x = linspace(0,1,100)
y = z1(x)
plot(x,y)
plot(x,0*x)

show()

print('Apartado c)\n')

def z2(x):
    return x - (x + (x - 1)*exp(x))/(1 + exp(x) + (x-1)*exp(x))

puntofijo(z2, 0.6, 1e-8, 100)

print('Apartado d)\n')

def z3(x):
    return -(x-1)*exp(x)

puntofijo(z3, 0.6, 1e-8, 100)

