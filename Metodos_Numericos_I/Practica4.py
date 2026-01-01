# -*- coding: utf-8 -*-
"""
Created on Wed Dec 14 20:13:39 2022

@author: pablo

Práctica 4 - Integración numérica -  Métodos Numéricos I
"""

from numpy import *
from matplotlib.pyplot import *
from scipy.integrate import quad

def fexp(x):
    return exp(-x**2)

# Función predefinida quad que devuelve el valor real de la integral y el error calculado.
# Se pasan como parametros la expresión de la integral y sus intervalos

sol_exacta, err = quad(fexp, 0, 1)
print("La aproximación obtenida con quad es ", sol_exacta, "y la cota de error es ", err)

print('\nEjercicio 1\n')

def puntomedio(f,a,b):
    return (b-a)*f((a+b)/2)

print('Aproximación punto medio=', puntomedio(fexp,0,1))
print('Error punto medio=', abs(puntomedio(fexp,0,1)-sol_exacta))

print('\nEjercicio 2\n')

def trapecio(f,a,b):
    return ((b-a)/2)*(f(a)+f(b))

print('Aproximación trapecio=', trapecio(fexp,0,1))
print('Error trapecio=', abs(trapecio(fexp,0,1)-sol_exacta))


print('\nEjercicio 3\n')

def simpson(f,a,b):
    return ((b-a)/6)*(f(a)+4*f((a+b)/2)+f(b))

print('Aproximación Simpson=', simpson(fexp,0,1))
print('Error Simpson=', abs(simpson(fexp,0,1)-sol_exacta))

print('\nEjercicio 4\n')

def puntomediocompuesta(f,a,b,N):
    x = linspace(a, b, N+1)
    c = x[0:N] + (b-a)/(2*N)
    aprox = ((b-a)/N)*sum(f(c))
    return aprox


N = 10
result = puntomediocompuesta(fexp,0,1,N)
error10=abs(puntomediocompuesta(fexp,0,1,10)-sol_exacta)

print("La aproximación obtenida con la fórmula del punto medio compuesta con N =", N, "es: ", result)
print("El error es de ", abs(result-sol_exacta))

N = 20
result = puntomediocompuesta(fexp,0,1,N)
error20=abs(puntomediocompuesta(fexp,0,1,20)-sol_exacta)

print("La aproximación obtenida con la fórmula del punto medio compuesta con N =", N, "es: ", result)
print("El error es de ", abs(result-sol_exacta))

N = 40
result = puntomediocompuesta(fexp,0,1,N)
error40=abs(puntomediocompuesta(fexp,0,1,40)-sol_exacta)

print("La aproximación obtenida con la fórmula del punto medio compuesta con N =", N, "es: ", result)
print("El error es de ", abs(result-sol_exacta))

N = 80
result = puntomediocompuesta(fexp,0,1,N)
error80=abs(puntomediocompuesta(fexp,0,1,80)-sol_exacta)

print("La aproximación obtenida con la fórmula del punto medio compuesta con N =", N, "es: ", result)
print("El error es de ", abs(result-sol_exacta))

print("Cociente de errores entre 20 y 10: ", error20/error10)
print("Cociente de errores entre 40 y 20: ", error40/error20)
print("Cociente de errores entre 80 y 40: ", error80/error40)

print("El cociente de errores obtenidos al dividir (b-a)/N por 2 es aproximadamente 1/4")
print("Esto ocurre por ser un método de orden 2")

print('\nEjercicio 5\n')

def trapeciocompuesta(f,a,b,N):
    indices = linspace(a,b,N+1)
    fa=f(indices[0:N])
    fb=f(indices[1:N+1])
    vect=(fa+fb)
    return ((b-a)/(2*N))*sum(vect)

N = 10
result = trapeciocompuesta(fexp,0,1,N)
error10=abs(trapeciocompuesta(fexp,0,1,10)-sol_exacta)

print("La aproximación obtenida con la fórmula del trapecio compuesta con N =", N, "es: ", result)
print("El error es de ", abs(result-sol_exacta))

N = 20
result = trapeciocompuesta(fexp,0,1,N)
error20=abs(trapeciocompuesta(fexp,0,1,20)-sol_exacta)

print("La aproximación obtenida con la fórmula del trapecio compuesta con N =", N, "es: ", result)
print("El error es de ", abs(result-sol_exacta))

N = 40
result = trapeciocompuesta(fexp,0,1,N)
error40=abs(trapeciocompuesta(fexp,0,1,40)-sol_exacta)

print("La aproximación obtenida con la fórmula del trapecio compuesta con N =", N, "es: ", result)
print("El error es de ", abs(result-sol_exacta))

N = 80
result = trapeciocompuesta(fexp,0,1,N)
error80=abs(trapeciocompuesta(fexp,0,1,80)-sol_exacta)

print("La aproximación obtenida con la fórmula del trapecio compuesta con N =", N, "es: ", result)
print("El error es de ", abs(result-sol_exacta))

print("Cociente de errores entre 20 y 10: ", error20/error10)
print("Cociente de errores entre 40 y 20: ", error40/error20)
print("Cociente de errores entre 80 y 40: ", error80/error40)
print("El cociente de errores obtenidos al dividir (b-a)/N por 2 es aproximadamente 1/4")
print("Esto ocurre por ser un método de orden 2")


print('Ejercicio 6\n')

def simpsoncompuesta(f,a,b,N):
    indices = linspace(a,b,N+1)
    c = indices[0:N] + (b-a)/(2*N)
    fa=f(indices[0:N])
    fb=f(indices[1:N+1])
    vect=(fa + 4*f(c) + fb)
    return ((b-a)/(6*N))*sum(vect)

N = 10
result = simpsoncompuesta(fexp,0,1,N)
error10=abs(simpsoncompuesta(fexp,0,1,10)-sol_exacta)

print("La aproximación obtenida con la fórmula de Simpson compuesta con N =", N, "es: ", result)
print("El error es de ", abs(result-sol_exacta))

N = 20
result = simpsoncompuesta(fexp,0,1,N)
error20=abs(simpsoncompuesta(fexp,0,1,20)-sol_exacta)

print("La aproximación obtenida con la fórmula de Simpson compuesta con N =", N, "es: ", result)
print("El error es de ", abs(result-sol_exacta))

N = 40
result = simpsoncompuesta(fexp,0,1,N)
error40=abs(simpsoncompuesta(fexp,0,1,40)-sol_exacta)

print("La aproximación obtenida con la fórmula de Simpson compuesta con N =", N, "es: ", result)
print("El error es de ", abs(result-sol_exacta))

N = 80
result = simpsoncompuesta(fexp,0,1,N)
error80=abs(simpsoncompuesta(fexp,0,1,80)-sol_exacta)

print("La aproximación obtenida con la fórmula de Simpson compuesta con N =", N, "es: ", result)
print("El error es de ", abs(result-sol_exacta))

print("Cociente de errores entre 20 y 10: ", error20/error10)
print("Cociente de errores entre 40 y 20: ", error40/error20)
print("Cociente de errores entre 80 y 40: ", error80/error40)
print("El cociente de errores obtenidos al dividir (b-a)/N por 2 es aproximadamente 1/16")
print("Esto ocurre por ser un método de orden 4")

print('Ejercicio 7\n')

def gauss(f,a,b):
    # Nodos y pesos en [-1, 1]
    nodos = array([-sqrt(3/5), 0, sqrt(3/5)])
    pesos = array([5/9, 8/9, 5/9])
    
    #Cambio de intervalo: x vive en [a,b] y t en [-1,1]
    #Cambio de intervalo: x(t) = a + ((b-a)/2)*(t+1))
    nodosab =  a + ((b-a)/2)*(nodos+1) #Puntos en los que tengo que evaluar la f
    alfa=((b-a)/2)*pesos
    aprox=sum(alfa*f(nodosab))
    return aprox

print('Aproximación Gauss=', gauss(fexp,0,1))
print('Error Gauss=', abs(gauss(fexp,0,1)-sol_exacta))
