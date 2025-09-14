
"""
PRACTICA 1 BIS: Métodos unipaso para problemas de valor inicial 

@author: Pablo Fazio Arrabal

"""
from pylab import *
from time import perf_counter
import numpy as np


print('\nEjercicio 1\n')

def f(t, y):
    """Funcion que define la ecuacion diferencial"""
    return -y+2*sin(t)

def exacta(t):
    """Solucion exacta del problema de valor inicial"""
    return (pi+1)*exp(-t)+sin(t)-cos(t)

print('Método de Euler:')

def euler(a, b, fun, N, y0):
    """Implementacion del metodo de Euler en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros(N+1)   # inicializacion del vector de resultados
    t[0] = a         # nodo inicial
    y[0] = y0        # valor inicial

    # Metodo de Euler
    for k in range(N):
        y[k+1] = y[k]+h*fun(t[k], y[k])
        t[k+1] = t[k]+h
    
    return (t, y)

'''
print('Método de Euler Implícito:')

def eulerImplicito(a, b, fun, N, y0):
    """Implementacion del metodo de Euler en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros(N+1)   # inicializacion del vector de resultados
    t[0] = a         # nodo inicial
    y[0] = y0        # valor inicial

    # Metodo de Euler Implicito
    for k in range(N):
        t[k+1] = t[k]+h
        y[k+1] = y[k]+h*fun(t[k+1], y[k+1])
    
    return (t, y)


# OTRA FORMA CON ITERACION DE PUNTO FIJO

def eulerImplicito(a, b, fun, N, y0):
    """Implementacion del metodo de Euler en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros(N+1)   # inicializacion del vector de resultados
    t[0] = a         # nodo inicial
    y[0] = y0        # valor inicial

    # Metodo de Euler Implicito
    for k in range(N):
        z0 = y[k]
        error = 1
        while(error > 1e-8):
            z = y[k]+h*fun(t[k] + h, z0)
            error = abs(z-z0)
            z0 = z  
    
    return (t, y)


'''

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 10.  # extremo superior del intervalo
N = 50   # numero de particiones
y0 = pi  # condicion inicial

tini = perf_counter()

(t, y) = euler(a, b, f, N, y0) # llamada al metodo de Euler

tfin=perf_counter()

ye = exacta(t) # calculo de la solucion exacta
# Calculo del error cometido
error = max(abs(y-ye))

# Resultados
print('-----')
print('Tiempo CPU: ' + str(tfin-tini)) #print('Tiempo CPU: ', tfin-tini)
print('Error: ' + str(error))
print('Paso de malla: ' + str((b-a)/N))
print('-----')

print('\nMétodo de Heun: ')

def heun(a, b, fun, N, y0):
    """Implementacion del metodo de Heun en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros(N+1)   # inicializacion del vector de resultados
    t[0] = a         # nodo inicial
    y[0] = y0        # valor inicial

    # Metodo de Heun
    for k in range(N):
        t[k+1] = t[k]+h
        y[k+1] = y[k]+h/2*(fun(t[k], y[k]) + fun(t[k+1], y[k] + h*fun(t[k], y[k])))
       
        # Otra forma más eficiente: 
        # fk = fun(t[k], y[k])
        # ykmas1p = y[k] + h*fk
        # y[k+1] = y[k]+h/2*(fk + fun(t[k+1], y[k] + ykmas1p))   
        
    return (t, y)

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 10.  # extremo superior del intervalo
N = 50   # numero de particiones
y0 = pi  # condicion inicial

tini = perf_counter()

(t, y) = heun(a, b, f, N, y0) # llamada al metodo de Heun

tfin=perf_counter()

ye = exacta(t) # calculo de la solucion exacta
# Calculo del error cometido
error = max(abs(y-ye))

# Resultados
print('-----')
print('Tiempo CPU: ' + str(tfin-tini)) #print('Tiempo CPU: ', tfin-tini)
print('Error: ' + str(error))
print('Paso de malla: ' + str((b-a)/N))
print('-----')

print('\nMétodo del punto medio:')

def puntomedio(a, b, fun, N, y0):
    """Implementacion del metodo de Punto Medio en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros(N+1)   # inicializacion del vector de resultados
    t[0] = a         # nodo inicial
    y[0] = y0        # valor inicial

    # Metodo de Punto Medio
    for k in range(N):
        t[k+1] = t[k]+h
        y[k+1] = y[k]+h*fun(t[k] + h/2, y[k] + h/2*fun(t[k],y[k]))
        
    return (t, y)

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 10.  # extremo superior del intervalo
N = 50   # numero de particiones
y0 = pi  # condicion inicial

tini = perf_counter()

(t, y) = puntomedio(a, b, f, N, y0) # llamada al metodo del punto medio

tfin=perf_counter()

ye = exacta(t) # calculo de la solucion exacta
# Calculo del error cometido
error = max(abs(y-ye))

# Resultados
print('-----')
print('Tiempo CPU: ' + str(tfin-tini)) #print('Tiempo CPU: ', tfin-tini)
print('Error: ' + str(error))
print('Paso de malla: ' + str((b-a)/N))
print('-----')

print('\nMétodo de RK4:')

def RK4(a, b, fun, N, y0):
    """Implementacion del metodo de RK4 en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros(N+1)   # inicializacion del vector de resultados
    t[0] = a         # nodo inicial
    y[0] = y0        # valor inicial

    # Metodo de RK4
    for k in range(N):
        
        t[k+1] = t[k]+h 
        K1 = fun(t[k],y[k])
        K2 = fun(t[k]+h/2, y[k]+h/2*K1)
        K3 = fun(t[k]+h/2, y[k]+h/2*K2)
        K4 = fun(t[k+1], y[k]+h*K3)
        
        y[k+1] = y[k] + h/6*(K1+2*K2+2*K3+K4)
        
    return (t, y)

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 10.  # extremo superior del intervalo
N = 50   # numero de particiones
y0 = pi  # condicion inicial

tini = perf_counter()

(t, y) = RK4(a, b, f, N, y0) # llamada al metodo de RK4

tfin=perf_counter()

ye = exacta(t) # calculo de la solucion exacta
# Calculo del error cometido
error = max(abs(y-ye))

# Resultados
print('-----')
print('Tiempo CPU: ' + str(tfin-tini)) #print('Tiempo CPU: ', tfin-tini)
print('Error: ' + str(error))
print('Paso de malla: ' + str((b-a)/N))
print('-----')


print('\nEjercicio 2\n')

def f2(t,y): # x = y[0] , y = y[1] y z = y[2]
    '''Función que define el sistema diferencial'''
    dx = 3*y[0]-2*y[1]
    dy = -y[0]+3*y[1]-2*y[2]
    dz = -y[1]+3*y[2]
    return array([dx, dy, dz])
    
def exactaSis(t):
    """Solucion exacta del problema de valor inicial"""
    x = (-1/4)*exp(5*t)+(3/2)*exp(3*t)-(1/4)*exp(t)
    y = (1/4)*exp(5*t)-(1/4)*exp(t)
    z = (-1/8)*exp(5*t)-(3/4)*exp(3*t)-(1/8)*exp(t)
    return array([x, y, z])

print('Método de Euler para sistemas:')

def eulerSis(a, b, fun, N, y0):
    """Implementacion del metodo de Euler para sistemas en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros((len(y0), N+1))   # inicializacion del vector de resultados
                                # tantas filas como condiciones iniciales 
                                # tantas columnas como "puntos"
    t[0] = a         # nodo inicial
    y[:, 0] = y0     # valor inicial: mete y0 en la primera columna hacia abajo

    # Metodo de Euler
    for k in range(N):
        y[:, k+1] = y[:, k]+h*fun(t[k], y[:, k])
        t[k+1] = t[k]+h
    
    return (t, y)

'''
print('Método de Euler implicito para sistemas:')
def eulerSisImplicito(a, b, fun, N, y0):
    """Implementacion del metodo de Euler implicito para sistemas en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros((len(y0), N+1))   # inicializacion del vector de resultados
                                # tantas filas como condiciones iniciales 
                                # tantas columnas como "puntos"
    t[0] = a         # nodo inicial
    y[:, 0] = y0     # valor inicial: mete y0 en la primera columna hacia abajo

    # Metodo de Euler
    for k in range(N):
        t[k+1] = t[k]+h
        y[:, k+1] = y[:, k]+h*fun(t[k+1], y[:, k+1])
    
    return (t, y)


'''

a = 0.   # extremo inferior del intervalo
b = 1.  # extremo superior del intervalo
N = 50  # numero de particiones
y0 = array([1,0,-1])  # condiciones iniciales

tini = perf_counter()

(t, y) = eulerSis(a, b, f2, N, y0) # llamada al metodo de EulerSis

tfin=perf_counter()

errorX = max(abs(y[0,:]-exactaSis(t)[0,:]))
errorY = max(abs(y[1,:]-exactaSis(t)[1,:]))
errorZ = max(abs(y[2,:]-exactaSis(t)[2,:]))

# Resultados
print('-----')
print('Tiempo CPU: ' + str(tfin-tini)) #print('Tiempo CPU: ', tfin-tini)
print('Error x: ' + str(errorX))
print('Error y: ' + str(errorY))
print('Error z: ' + str(errorZ))
print('Paso de malla: ' + str((b-a)/N))
print('-----')

print ('Método de Heun para sistemas:')

def heunSis(a, b, fun, N, y0):
    """Implementacion del metodo de Heun para sistemas en 
    el intervalo [a, b] usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros((len(y0), N+1))   # inicializacion de la matriz de resultados
                                # tantas filas como condiciones iniciales 
                                # tantas columnas como "puntos"
    t[0] = a         # nodo inicial
    y[:,0] = y0      # valor inicial: mete y0 en la primera columna hacia abajo

    # Metodo de Heun
    for k in range(N):
        t[k+1] = t[k]+h
        y[:, k+1] = y[:, k]+h/2*(fun(t[k], y[:, k]) + fun(t[k+1], y[:, k] + h*fun(t[k], y[:, k]))) 
        
    return (t, y)

a = 0.   # extremo inferior del intervalo
b = 1.  # extremo superior del intervalo
N = 50  # numero de particiones
y0 = array([1,0,-1])  # condiciones iniciales

tini = perf_counter()

(t, y) = heunSis(a, b, f2, N, y0) # llamada al metodo de heun

tfin=perf_counter()

errorX = max(abs(y[0,:]-exactaSis(t)[0,:]))
errorY = max(abs(y[1,:]-exactaSis(t)[1,:]))
errorZ = max(abs(y[2,:]-exactaSis(t)[2,:]))

# Resultados
print('-----')
print('Tiempo CPU: ' + str(tfin-tini)) #print('Tiempo CPU: ', tfin-tini)
print('Error x: ' + str(errorX))
print('Error y: ' + str(errorY))
print('Error z: ' + str(errorZ))
print('Paso de malla: ' + str((b-a)/N))
print('-----')

print('\nMétodo del punto medio para sistemas:')

def puntomedioSis(a, b, fun, N, y0):
    """Implementacion del metodo de punto medio para sistemas en 
    el intervalo [a, b] usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros((len(y0), N+1))   # inicializacion de la matriz de resultados
                                # tantas filas como condiciones iniciales 
                                # tantas columnas como "puntos"
    t[0] = a         # nodo inicial
    y[:,0] = y0      # valor inicial: mete y0 en la primera columna hacia abajo

    # Metodo de Punto Medio
    for k in range(N):
        t[k+1] = t[k]+h
        y[:, k+1] = y[:, k]+h*fun(t[k] + h/2, y[:, k] + h/2*fun(t[k],y[:, k]))
    return (t, y)

a = 0.   # extremo inferior del intervalo
b = 1.  # extremo superior del intervalo
N = 50  # numero de particiones
y0 = array([1,0,-1])  # condiciones iniciales

tini = perf_counter()

(t, y) = puntomedioSis(a, b, f2, N, y0) # llamada al metodo de heun

tfin=perf_counter()

errorX = max(abs(y[0,:]-exactaSis(t)[0,:]))
errorY = max(abs(y[1,:]-exactaSis(t)[1,:]))
errorZ = max(abs(y[2,:]-exactaSis(t)[2,:]))

# Resultados
print('-----')
print('Tiempo CPU: ' + str(tfin-tini)) #print('Tiempo CPU: ', tfin-tini)
print('Error x: ' + str(errorX))
print('Error y: ' + str(errorY))
print('Error z: ' + str(errorZ))
print('Paso de malla: ' + str((b-a)/N))
print('-----')

print('\nMétodo de RK4 para sistemas:')


def RK4Sis(a, b, fun, N, y0):
    """Implementacion del metodo de RK4 para sistemas en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros((len(y0), N+1))   # inicializacion de la matriz de resultados
                                # tantas filas como condiciones iniciales 
                                # tantas columnas como "puntos"
    t[0] = a         # nodo inicial
    y[:,0] = y0      # valor inicial: mete y0 en la primera columna hacia abajo

    # Metodo de RK4
    for k in range(N):
        
        t[k+1] = t[k]+h 
        K1 = fun(t[k],y[:, k])
        K2 = fun(t[k]+h/2, y[:, k]+h/2*K1)
        K3 = fun(t[k]+h/2, y[:, k]+h/2*K2)
        K4 = fun(t[k+1], y[:, k]+h*K3)
        
        y[:, k+1] = y[:, k] + h/6*(K1+2*K2+2*K3+K4)
        
        
    return (t, y)

a = 0.   # extremo inferior del intervalo
b = 1.  # extremo superior del intervalo
N = 50  # numero de particiones
y0 = array([1,0,-1])  # condiciones iniciales

tini = perf_counter()

(t, y) = RK4Sis(a, b, f2, N, y0) # llamada al metodo de heun

tfin=perf_counter()

errorX = max(abs(y[0,:]-exactaSis(t)[0,:]))
errorY = max(abs(y[1,:]-exactaSis(t)[1,:]))
errorZ = max(abs(y[2,:]-exactaSis(t)[2,:]))

# Resultados
print('-----')
print('Tiempo CPU: ' + str(tfin-tini)) #print('Tiempo CPU: ', tfin-tini)
print('Error x: ' + str(errorX))
print('Error y: ' + str(errorY))
print('Error z: ' + str(errorZ))
print('Paso de malla: ' + str((b-a)/N))
print('-----')
