# -*- coding: utf-8 -*-
"""
MÉTODOS (BASE)

@author: Pablo Fazio Arrabal

"""

from pylab import *
from time import perf_counter

''' ------------ MÉTODOS PARA ECUACIONES SIMPLES ----------------------------'''


'''Método Euler para una ecuacion simple'''

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


'''Método de Taylor de orden 2 (simple)'''

def taylorOrden2(a, b, fun, dfun, N, y0):
    """Implementacion del metodo de Taylor de orden 2 en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros(N+1)   # inicializacion del vector de resultados
    t[0] = a         # nodo inicial
    y[0] = y0        # valor inicial

    # Metodo de Taylor de orden 2
    for k in range(N):
        y[k+1] = y[k] + h*fun(t[k], y[k]) + ((h**2)/2)*dfun(t[k],y[k]) 
        t[k+1] = t[k]+h
    
    return (t, y)


'''Método de Taylor de orden 3 (simple)'''

def taylorOrden3(a, b, fun, dfun, ddfun, N, y0):
    """Implementacion del metodo de Taylor de orden 3 en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros(N+1)   # inicializacion del vector de resultados
    t[0] = a         # nodo inicial
    y[0] = y0        # valor inicial

    # Metodo de Taylor de orden 3
    for k in range(N):
        y[k+1] = y[k] + h*fun(t[k], y[k]) + ((h**2)/2)*dfun(t[k],y[k]) + ((h**3)/6)*ddfun(t[k],y[k]) 
        t[k+1] = t[k]+h
    
    return (t, y)


'''Método de Heun para una ecuación simple'''

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


'''Método del Punto Medio para una ecuación simple'''

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


'''Método de RK4 para una ecuación simple'''

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


''' ------------------- MÉTODOS PARA SISTEMAS ----------------------------'''

''' Método de Euler para sistemas'''

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


''' Método de Heun para sistemas'''

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


''' Método del Punto Medio para sistemas'''

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


''' Método de RK4 para sistemas'''

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
