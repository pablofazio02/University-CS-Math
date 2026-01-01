# -*- coding: utf-8 -*-
"""
Created on Thu Oct 6 14:57:22 2022

@author: Pablo Fazio Arrabal

Métodos Numéricos I: Introducción a Python y aritmética de la máquina

"""

from numpy import *
from matplotlib.pyplot import *

print('Ejercicio 1\n')

def sumanveces (a,n):
    b = 0
    for i in range(n):
        b+=a
    return b;

def sumanveces_ (a,n):
    b = 0
    c = 0
    while (b < n):
        c+=a
        b+=1
    return c

"""
    sumanveces(0.1,5)
    Out[4]: 0.5

    sumanveces(0.1,10)
    Out[5]: 0.9999999999999999

    sumanveces(0.1,20)
    Out[6]: 2.0000000000000004
    
    sumanveces_(0.1,5)
    Out[8]: 0.5

    sumanveces_(0.1,10)
    Out[9]: 0.9999999999999999
    
    sumanveces_(0.1,20)
    Out[11]: 2.0000000000000004
    
    El error de la suma se acumula después de una gran cantidad de ellas.

"""

print('Ejercicio 2\n')

# Obtener el x más pequeño que consigue aún satisfacer que x + 1 > 1.

def epsilon():
    e = 1
    while(1+e>1):
        e = e/2
    return e*2

"""

In[2]: epsilon()
Out[2]: 2.220446049250313e-16

"""

print('Ejercicio 3\n')

x = linspace(-2,2,100)
y = x - exp(-x)
plot (x,y)
plot(x,0*x,'k')
plot(0*y,y,'k')
show()

# IMPORTANTE: Pintar con colores / puntos plot (x,y,'caracteres') 

print('Ejercicio 4\n')

def aproxe (n):
    a = (1+(1/n))**n
    err = abs(exp(1) - a)
    print('n = ',n, ', aproxe = ',a, ', error = ', err)
    return a, err

# Comentario: Disminuye el error absoluto cometido cuanto mayor es n.
# Pero, si tenemos un número tan pequeño que al sumarselo al 1 me da 1, vuelvo a 1**n

"""
aproxe(10)
n =  10 , aproxe =  2.5937424601000023 , error =  0.12453936835904278
Out[3]: (2.5937424601000023, 0.12453936835904278)

aproxe(100)
n =  100 , aproxe =  2.7048138294215285 , error =  0.01346799903751661
Out[4]: (2.7048138294215285, 0.01346799903751661)

aproxe(100000)
n =  100000 , aproxe =  2.7182682371922975 , error =  1.359126674760347e-05
Out[5]: (2.7182682371922975, 1.359126674760347e-05)

"""

print('Ejercicio 5\n')

def sumaparcial (n):
    
    b = 0
    
    for i in range (1,n+1):
        
        b += 1/sqrt(i)
        
    # print ('n=' , n,', Sn=', b)
        
    return b

# La serie es divergente por cada n que probamos nos da valores diferentes crecientemente

n = 1
while(sumaparcial(n)<50):
 n+=1
print('La suma parcial es mayor que 50 para n=', n)    

# Comentario: A partir de n = 662, la suma parcial es mayor que 50 en nuestro programa.

print('Ejercicio 6\n')

ns = zeros(100)

Sns = zeros(100)

for n in range (1,101):
    ns[n-1] = n
    Sns[n-1] = sumaparcial(n)
plot(ns,Sns)
show()


for n in range (1,101):
    plot(n,sumaparcial(n),'bo')
show()
    
print('Ejercicio 7\n')

def sumaparcial_ (n):
    
    b = 0
    
    for i in range (1,n+1):
        
        b += 1/(i*(i+1))
        
    err = abs(1-b)
        
    print('n=',n,'Sn=',b, 'error=', err)
        
    return n, b, err


def sumaparcial_2 (n):
    
    c = 1 - (1/(n+1))
    
    return n, c, abs(1-c)

""" Comentario: 
    
    sumaparcial_ (1000)
    Out[39]: (1000, 0.9990009990009997, 0.000999000999000299)
    sumaparcial_2 (1000)
    Out[38]: (1000, 0.999000999000999, 0.0009990009990009652)

    sumaparcial_ (10**5)
    Out[4]: (100000, 0.9999900001000122, 9.999899987844785e-06)
    sumaparcial_2 (10**5)
    Out[5]: (100000, 0.999990000099999, 9.999900000945416e-06)
    
    sumaparcial_(10**7)
    Out[6]: (10000000, 0.9999998999998153, 1.0000018468847571e-07)
    sumaparcial_2(10**7)
    Out[7]: (10000000, 0.99999990000001, 9.99999899553572e-08)
    
    sumaparcial_2(10**20)
    Out[8]: (100000000000000000000, 1.0, 0.0)

"""
    
print('Ejercicio 8\n')

def factorial(n):
    
    if (n==0):
        fact = 1
    else:
        fact = factorial(n-1)*n
        
    return fact

def taylor (n):
    
    suma = 0
    
    for i in range (n+1):
        
        suma+= 1/factorial(i)
        
    return suma

# Comentario: Las apoximaciones crecen a mayor n, pero a partir de n = 17 se mantienen constantes en el valor 2.7182818284590455

print('Ejercicio 9\n')

def aproxtaylor (n,x):
    
    suma = 0
    
    for i in range (n+1):
        suma += (x**i)/factorial(i)
    return suma, abs(exp(x)-suma)

""" Comentario:
    
    aproxtaylor(5,0)
    Out[29]: (1.0, 0.0)

    aproxtaylor(10,1)
    Out[30]: (2.7182818011463845, 2.7312660577649694e-08)

    aproxtaylor(10,5)
    Out[31]: (146.38060102513225, 2.0325580774443495)

    aproxtaylor(10,10)
    Out[32]: (12842.305114638448, 9184.16068016827)

    aproxtaylor(10,-1)
    Out[33]: (0.3678794642857144, 2.3114272051927287e-08)

    aproxtaylor(10,-5)
    Out[34]: (0.8640390762786612, 0.8573011292795757)

    aproxtaylor(10,-10)
    Out[35]: (1342.5873015873017, 1342.5872561873718)
    
"""

print('Ejercicio 10\n')

def sumaMedia (a):
    suma = 0
    if(size(a) > 0):
      for i in range(size(a)):
            suma+= a[i]
      return suma, (suma/size(a))
    else:
      return 0,0
    
"""
sumaMedia([3,7,9])
Out[7]: (19, 6.333333333333333)

sumaMedia([3,7,9,29,18,28])
Out[8]: (94, 15.666666666666666)
"""

