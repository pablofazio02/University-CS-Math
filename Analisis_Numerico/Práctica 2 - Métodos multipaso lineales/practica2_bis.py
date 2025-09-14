# -*- coding: utf-8 -*-
"""
Created on Sat May 25 18:22:16 2024

@author: Pablo Fazio Arrabal

Práctica 2 Bis - Métodos multipaso lineales

"""

from pylab import *
from time import perf_counter

print('Ejercicio 1\n')

def f1(t,y):
    return -y + 2*sin(t)

def exacta(t):
    return (pi + 1)*exp(-t) + sin(t) - cos(t)

# Datos del problema

a = 0
b = 10
y0 = pi
N = 50

# Método de Adams-Bashforth de 3 pasos

def AB3(a,b,fun, N,y0):
    
    y = zeros(N+1)
    t = zeros(N+1)
    f = zeros(N+1)
    
    t[0] = a
    h = (b-a)/float(N)
    
    y[0] = y0
    f[0] = fun(a,y[0])
    
    # Se usa el método de RK4 (podría ser otro cualquiera de orden 3) para arrancar
    
    k = 0
    
    K1 = fun(t[k], y[k])
    K2 = fun(t[k] + (h/2), y[k] + (h/2)*K1)
    K3 = fun(t[k] + (h/2), y[k] + (h/2)*K2)
    K4 = fun(t[k] + h, y[k] + h*K3)
    
    y[1] = y[k] + (h/6)*(K1 + 2*K2 + 2*K3 + K4)
    t[1] = a+h
    f[1] = fun(t[1], y[1])
    
    k = 1
    
    K1 = fun(t[k], y[k])
    K2 = fun(t[k] + (h/2), y[k] + (h/2)*K1)
    K3 = fun(t[k] + (h/2), y[k] + (h/2)*K2)
    K4 = fun(t[k] + h, y[k] + h*K3)
    
    y[2] = y[k] + (h/6)*(K1 + 2*K2 + 2*K3 + K4)
    t[2] = a +2*h
    f[2] = fun(t[2], y[2])
    
    for k in range(2,N):
    
        y[k+1] = y[k] + (h/12)*(23*f[k] - 16*f[k-1] + 5*f[k-2])
        t[k+1] = t[k] + h
        f[k+1] = fun(t[k+1], y[k+1])
        
    return (t,y)

def AM3General_AB3(a,b,fun,N,y0):
    
    y = zeros(N+1)
    t = zeros(N+1)
    f = zeros(N+1)
    
    t[0] = a
    h = (b-a)/float(N)
    
    y[0] = y0
    f[0] = fun(a,y[0])
    
    # Se usa el método de RK4 (podría ser otro cualquiera de orden 3) para arrancar
    
    k = 0
    
    K1 = fun(t[k], y[k])
    K2 = fun(t[k] + (h/2), y[k] + (h/2)*K1)
    K3 = fun(t[k] + (h/2), y[k] + (h/2)*K2)
    K4 = fun(t[k] + h, y[k] + h*K3)
    
    y[1] = y[k] + (h/6)*(K1 + 2*K2 + 2*K3 + K4)
    t[1] = a+h
    f[1] = fun(t[1], y[1])
    
    k = 1
    
    K1 = fun(t[k], y[k])
    K2 = fun(t[k] + (h/2), y[k] + (h/2)*K1)
    K3 = fun(t[k] + (h/2), y[k] + (h/2)*K2)
    K4 = fun(t[k] + h, y[k] + h*K3)
    
    y[2] = y[k] + (h/6)*(K1 + 2*K2 + 2*K3 + K4)
    t[2] = a +2*h
    f[2] = fun(t[2], y[2])
    maxiter = 0
    
    for k in range(2,N):
    
        t[k+1] = t[k] + h
        Ck = y[k] + (h/24)*(19*f[k] - 5*f[k-1] + f[k-2])
        
        #Punto fijo
        zAntiguo = y[k] + (h/12)*(23*f[k] - 16*f[k-1] + 5*f[k-2]) 
        zNuevo = y[k]
        error = 1
        cont = 0
        
        while error >= 1e-12 and cont != 200:
            
            zNuevo = h*(9/24)*fun(t[k+1], zAntiguo) + Ck
            error = abs(zNuevo-zAntiguo)
            zAntiguo = zNuevo
            cont = cont + 1
        
        if(cont == 200):
            print("El método de punto fijo no ha convergido")
        
        maxiter = max(cont, maxiter)
        
        y[k+1] = zNuevo
        f[k+1] = fun(t[k+1], y[k+1])
        
    return (t,y, maxiter)

# Método predictor-corrector Adams-Bashforth-Moulton ABM3

def ABM3 (a, b, fun, N, y0):
    
    h = (b-a)/float(N)
    y = zeros(N+1)
    t = zeros(N+1)
    f = zeros(N+1)
    
    t[0] = a 
    y[0] = y0
    f[0] = fun(a,y[0])
    
    # Se usa el método de RK4 (podría ser otro cualquiera de orden 3) para arrancar
    
    k = 0
    
    K1 = fun(t[k], y[k])
    K2 = fun(t[k] + (h/2), y[k] + (h/2)*K1)
    K3 = fun(t[k] + (h/2), y[k] + (h/2)*K2)
    K4 = fun(t[k] + h, y[k] + h*K3)
    
    y[1] = y[k] + (h/6)*(K1 + 2*K2 + 2*K3 + K4)
    t[1] = a+h
    f[1] = fun(t[1], y[1])
    
    k = 1
    
    K1 = fun(t[k], y[k])
    K2 = fun(t[k] + (h/2), y[k] + (h/2)*K1)
    K3 = fun(t[k] + (h/2), y[k] + (h/2)*K2)
    K4 = fun(t[k] + h, y[k] + h*K3)
    
    y[2] = y[k] + (h/6)*(K1 + 2*K2 + 2*K3 + K4)
    t[2] = a +2*h
    f[2] = fun(t[2], y[2])

    
    for k in range(2,N):
    
        t[k+1] = t[k] + h
        ykmas1p = y[k]+h/12*(23*f[k]-16*f[k-1]+5*f[k-2])
        fkmas1p = fun(t[k+1], ykmas1p)
        y[k+1] = y[k]+h/24*(9*fkmas1p+19*f[k]-5*f[k-1]+f[k-2])
        f[k+1] = fun(t[k+1], y[k+1])
        
    return (t,y)

# Ejecución del método AB3

tini = perf_counter()
(t,y) = AB3(a,b, f1, N,y0)
tfin = perf_counter()
ye = exacta(t)
h = (b - a)/float(N)
err = max(abs(y-ye))

print('Prueba para N = 50 de AB3')
print('---------------')
print('h = '+ str(h))
print('Error = ' + str(err))
print('Tiempo CPU = '+ str(tfin-tini))
print('---------------\n')

# Ejecución del método AM3 General para la aprox de AB3

tini = perf_counter()
(t,y, maxiter) = AM3General_AB3(a,b, f1, N,y0)
tfin = perf_counter()
ye = exacta(t)
h = (b - a)/float(N)
err = max(abs(y-ye))

print('Prueba para N = 50 de AM3')
print('---------------')
print('h = '+ str(h))
print('Error = ' + str(err))
print('Tiempo CPU = '+ str(tfin-tini))
print('Número máximo de iteraciones = '+ str(maxiter))
print('---------------\n')

# Ejecución del método predictor-corrector ABM3

tini = perf_counter()
(t,y) = ABM3(a,b, f1, N,y0)
tfin = perf_counter()
ye = exacta(t)
h = (b - a)/float(N)
err = max(abs(y-ye))

print('Prueba para N = 50 de ABM3')
print('---------------')
print('h = '+ str(h))
print('Error = ' + str(err))
print('Tiempo CPU = '+ str(tfin-tini))
print('---------------\n')

print('Ejercicio 2\n')

def f2(t,y):
    dx = 3*y[0] - 2*y[1]
    dy = -y[0] + 3*y[1] - 2*y[2]
    dz = -y[1] + 3*y[2]    
    return array([dx,dy,dz])

def exacta2(t):
    x = (-1/4)*exp(5*t)+(3/2)*exp(3*t)-(1/4)*exp(t)
    y = (1/4)*exp(5*t)-(1/4)*exp(t)
    z = (-1/8)*exp(5*t)-(3/4)*exp(3*t)-(1/8)*exp(t)
    return array([x,y,z])

# Datos del problema
a = 0
b = 1
y0 = array([1,0,-1])
N = 100

# Método de Adams-Bashforth de 3 pasos para sistemas lineales

def AB3Sis(a,b,fun, N,y0):
    
    y = zeros([len(y0), N+1])
    t = zeros(N+1)
    f = zeros([len(y0), N+1])
    
    t[0] = a
    h = (b-a)/float(N)
    
    y[:, 0] = y0
    f[:, 0] = fun(a,y[:, 0])
    
    # Se usa el método de RK4 (podría ser otro cualquiera de orden 3) para arrancar
    
    k = 0
    
    K1 = fun(t[k], y[:, k])
    K2 = fun(t[k] + (h/2), y[:, k] + (h/2)*K1)
    K3 = fun(t[k] + (h/2), y[:, k] + (h/2)*K2)
    K4 = fun(t[k] + h, y[:, k] + h*K3)
    
    y[:, 1] = y[:, k] + (h/6)*(K1 + 2*K2 + 2*K3 + K4)
    t[1] = a+h
    f[:, 1] = fun(t[1], y[:, 1])
    
    k = 1
    
    K1 = fun(t[k], y[:, k])
    K2 = fun(t[k] + (h/2), y[:, k] + (h/2)*K1)
    K3 = fun(t[k] + (h/2), y[:, k] + (h/2)*K2)
    K4 = fun(t[k] + h, y[:, k] + h*K3)
    
    y[:, 2] = y[:, k] + (h/6)*(K1 + 2*K2 + 2*K3 + K4)
    t[2] = a +2*h
    f[:, 2] = fun(t[2], y[:, 2])
    
    for k in range(2,N):
    
        y[:, k+1] = y[:, k] + (h/12)*(23*f[:, k] - 16*f[:, k-1] + 5*f[:, k-2])
        t[k+1] = t[k] + h
        f[:, k+1] = fun(t[k+1], y[:, k+1])
        
    return (t,y)

# Método de Adams-Moulton de 3 pasos (iter. punto fijo) para una funcion en sistemas lineales

def AM3pfSis(a,b,fun, N,y0):
    
    y = zeros([len(y0),N+1])
    t = zeros(N+1)
    f = zeros([len(y0),N+1])
    
    t[0] = a
    h = (b-a)/float(N)
    
    y[:, 0] = y0
    f[:, 0] = fun(t[0],y[:, 0])
    
    # Se usa el método de RK4 (podría ser otro cualquiera de orden 3) para arrancar
    
    k = 0
    
    K1 = fun(t[k], y[:, k])
    K2 = fun(t[k] + (h/2), y[:, k] + (h/2)*K1)
    K3 = fun(t[k] + (h/2), y[:, k] + (h/2)*K2)
    K4 = fun(t[k] + h, y[:, k] + h*K3)
    
    y[:, 1] = y[:, k] + (h/6)*(K1 + 2*K2 + 2*K3 + K4)
    t[1] = a+h
    f[:, 1] = fun(t[1], y[:, 1])
    
    k = 1
    
    K1 = fun(t[k], y[:, k])
    K2 = fun(t[k] + (h/2), y[:, k] + (h/2)*K1)
    K3 = fun(t[k] + (h/2), y[:, k] + (h/2)*K2)
    K4 = fun(t[k] + h, y[:, k] + h*K3)
    
    y[:, 2] = y[:, k] + (h/6)*(K1 + 2*K2 + 2*K3 + K4)
    t[2] = a +2*h
    f[:, 2] = fun(t[2], y[:, 2])
    
    maxiter = 0
    
    for k in range(2,N):
    
        t[k+1] = t[k] + h
        Ck = y[:, k] + (h/24)*(19*f[:, k] - 5*f[:, k-1] + f[:, k-2])
        
        #Punto fijo
        zAntiguo = y[:, k]
        zNuevo = y[:, k]
        error = 1
        cont = 0
        
        while error >= 1e-12 and cont < 200:
            
            zNuevo = h*(9/24)*fun(t[k+1], zAntiguo) + Ck
            error = max(abs(zNuevo-zAntiguo))
            zAntiguo = zNuevo
            cont = cont + 1
        
        if(cont >= 200):
            print("El método de punto fijo no ha convergido")
        
        maxiter = max(cont, maxiter)
        
        y[:, k+1] = zNuevo
        
        f[:, k+1] = fun(t[k+1], y[:, k+1])
        
    return (t,y, maxiter)

# Método de ABM de tipo PECE que usa como predictor el método de Adams-Bashforth 
# de 3 pasos y como corrector el de AdamsMoulton de 3 pasos para una funcion 
# en sistemas lineales

def ABM3Sis(a, b, fun, N, y0):
    
    h = (b-a)/float(N)
    y = zeros([len(y0),N+1])
    t = zeros(N+1)
    f = zeros([len(y0),N+1])
    
    t[0] = a 
    y[:, 0] = y0
    f[:, 0] = fun(a,y[:, 0])
    
    # Se usa el método de RK4 (podría ser otro cualquiera de orden 3) para arrancar
    
    k = 0
    
    K1 = fun(t[k], y[:, k])
    K2 = fun(t[k] + (h/2), y[:, k] + (h/2)*K1)
    K3 = fun(t[k] + (h/2), y[:, k] + (h/2)*K2)
    K4 = fun(t[k] + h, y[:, k] + h*K3)
    
    y[:, 1] = y[:, k] + (h/6)*(K1 + 2*K2 + 2*K3 + K4)
    t[1] = a+h
    f[:, 1] = fun(t[1], y[:, 1])
    
    k = 1
    
    K1 = fun(t[k], y[:, k])
    K2 = fun(t[k] + (h/2), y[:, k] + (h/2)*K1)
    K3 = fun(t[k] + (h/2), y[:, k] + (h/2)*K2)
    K4 = fun(t[k] + h, y[:, k] + h*K3)
    
    y[:, 2] = y[:, k] + (h/6)*(K1 + 2*K2 + 2*K3 + K4)
    t[2] = a +2*h
    f[:, 2] = fun(t[2], y[:, 2])

    
    for k in range(2,N):
    
        t[k+1] = t[k] + h
        ykmas1p = y[:, k]+h/12*(23*f[:, k]-16*f[:, k-1]+5*f[:, k-2])
        fkmas1p = fun(t[k+1], ykmas1p)
        y[:, k+1] = y[:, k]+h/24*(9*fkmas1p+19*f[:, k]-5*f[:, k-1]+f[:, k-2])
        f[:, k+1] = fun(t[k+1], y[:, k+1])
        
    return (t,y)

# Ejecución del método AB3Sis

tini = perf_counter()
(t,y) = AB3Sis(a,b, f2, N,y0)
tfin = perf_counter()
ye = exacta2(t)
h = (b - a)/float(N)
errX = max(abs(y[0]-ye[0]))
errY = max(abs(y[1]-ye[1]))
errZ = max(abs(y[2]-ye[2]))

print('Prueba para N = 100 de AB3Sis')
print('---------------')
print('h = '+ str(h))
print('Error en x = ' + str(errX))
print('Error en y = ' + str(errY))
print('Error en z = ' + str(errZ))
print('Tiempo CPU = '+ str(tfin-tini))
print('---------------\n')

# Ejecución del método AM3Sis

tini = perf_counter()
(t,y, maxiter) = AM3pfSis(a,b, f2, N,y0)
tfin = perf_counter()
ye = exacta2(t)
h = (b - a)/float(N)
errX = max(abs(y[0]-ye[0]))
errY = max(abs(y[1]-ye[1]))
errZ = max(abs(y[2]-ye[2]))

print('Prueba para N = 100 de AM3pfSis')
print('---------------')
print('h = '+ str(h))
print('Error en x = ' + str(errX))
print('Error en y = ' + str(errY))
print('Error en z = ' + str(errZ))
print('Tiempo CPU = '+ str(tfin-tini))
print('Número máximo de iteraciones = '+ str(maxiter))
print('---------------\n')

# Ejecución del método ABM3Sis

tini = perf_counter()
(t,y) = ABM3Sis(a,b, f2, N,y0)
tfin = perf_counter()
ye = exacta2(t)
h = (b - a)/float(N)
errX = max(abs(y[0]-ye[0]))
errY = max(abs(y[1]-ye[1]))
errZ = max(abs(y[2]-ye[2]))

print('Prueba para N = 100 de ABM3Sis')
print('---------------')
print('h = '+ str(h))
print('Error en x = ' + str(errX))
print('Error en y = ' + str(errY))
print('Error en z = ' + str(errZ))
print('Tiempo CPU = '+ str(tfin-tini))
print('---------------\n')
