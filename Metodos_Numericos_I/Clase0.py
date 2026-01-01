# -*- coding: utf-8 -*-
"""
Created on Fri Sep 30 18:31:46 2022

@author: Pablo Fazio

Clase Introdución Phyton - Métodos Numéricos

"""

from numpy import *
from matplotlib.pyplot import *

# Notas:  
#     Crtl + 1 -> Comenta lo señalado
#     Para comentar strings, comillas simples!!!
#     Potencias en Phyon es ** NO ^.
#     Si quiero hacer un valor flotante, lo definimos como 'x.'

a = 3+4
print (a)

b = 3-4
print (b)

c = 3*4
print (c)

d = 3/4
print (d)

print(type(a), type(b), type(c), type(d))

print(1/3)

print('El valor de 1/3 es', 1/3, 'y el de 1/4', 1/4)

e = 3**4

print(e)

print(pi)

print('El numero e vale', exp(1))

a=4.
print (a)

a+=2
print (a)

a*=-1
print (a)

b=a

print(a,b)

a=15

print(a,b)

# Para el ordenador 0 es semejante a 10 ^ -16

print(cos(0), sin(0), cos(pi), sin(pi))

# Definimos una función (Usamos dos puntos después de definir variables)
# Si devuelve un NONE significa que no hay return

def f(x):
    return x**2+4

print(f(0), f(1))

y0 = f(0)

# Definimos otra función

def sumaProducto(x,y):
    return x+y, x*y

z = sumaProducto(4,5)

# Se obtiene un valor concreto de la tupla como array

sumaz = z[0]
prodz = z[1]

# Otra manera de obtener los valores

(s,p) = sumaProducto(4,5)

# BUCLES FOR

for i in range(10): # for int i = 0 ; i<10; i++
    print(i)
    
    
for i in range(1,11): # for int i = 1 ; i<11; i++
    print(i)

for i in range (15,1,-2): # for int i = 15; i>1; i-=2
    print (i)

# Definición de funciones con bucles

def sumanVeces(a,n):
    b=0
    for i in range(n):
        b+=a
    
    return b

# Definiciones de funciones compuestas

def ecuacion2grado(a,b,c):
    if a==0:
        r = -c/b
        print ('raíz: ', r)
        return r
    elif ((b*b)-(4*a*c) < 0):
        print("Raíces complejas")
        # TERMINAR COMO EJERCICIO 
    else:
        r1 = (-b + sqrt((b*b)-(4*a*c)))/(2*a)
        r2 = (-b - sqrt((b*b)-(4*a*c)))/(2*a) 
        print('raíces=',r1,r2)
        return r1, r2
    
print(ecuacion2grado(1,-1,-1))

# GRÁFICAS

x = linspace(0,1,10) # Inicio del intervalo, Fin del Intervalo, Nº puntos que toma
y=x**2

# 'color o -'
plot(x,y,'bo-')

# Cierra el plot mostrado y abre uno nuevo
show()

x = linspace(0,pi)
y = sin(x)

plot (x,y)

show()

x = linspace(0,pi,1000)
y = exp(x)*sin(10*x)
plot(x,y)

# Dibujar el eje

plot(x,0*x, 'm')
xlabel('Eje X')
ylabel('Eje Y')
title('Funcionaa') 





