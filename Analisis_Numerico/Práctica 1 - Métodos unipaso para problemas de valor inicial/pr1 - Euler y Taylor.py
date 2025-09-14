# -*- coding: utf-8 -*-
"""
PRACTICA 1: Métodos unipaso para problemas de valor inicial

@author: Pablo Fazio Arrabal

"""

from pylab import *
from time import perf_counter
import numpy as np


def f(t, y):
    """Funcion que define la ecuacion diferencial"""
    return 0.5*(t**2 - y)

def exacta(t):
    """Solucion exacta del problema de valor inicial"""
    return t**2 - 4*t + 8 - 7*exp(-0.5*t)

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

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 10.  # extremo superior del intervalo
N = 20   # numero de particiones
y0 = 1.  # condicion inicial

tini = perf_counter()

(t, y) = euler(a, b, f, N, y0) # llamada al metodo de Euler

tfin=perf_counter()

ye = exacta(t) # calculo de la solucion exacta

# Dibujamos las soluciones
figure('Figura 0 - Prueba método de Euler')
plot(t, y, '-*') # dibuja la solucion aproximada
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
legend(['Euler', 'exacta'])
grid(True)
show()

# Calculo del error cometido
error = max(abs(y-ye))

# Resultados
print('-----')
print('Tiempo CPU: ' + str(tfin-tini)) #print('Tiempo CPU: ', tfin-tini)
print('Error: ' + str(error))
print('Paso de malla: ' + str((b-a)/N))
print('-----')

show() # muestra la grafica


#############################


print('\n PRÁCTICA 1 \n')


print('\n EJERCICIO 1 \n')


print('\n Apartado a) \n')

# si el método es de orden 2, como la malla se va doblando, en/en+1 se debe aproximar a 2
# (e_n+1 = e_2N en el enunciado)

ns = array([10,20,40,80,160])

a = 0   # extremo inferior del intervalo
b = 10  # extremo superior del intervalo
y0 = 1  # condicion inicial
i=0


for N in ns :    #N = numero de particiones

    (t, y) = euler(a, b, f, N, y0) # llamada al metodo de Euler
    
    ye = exacta(t) # calculo de la solucion exacta
    #hay que calcularla cada vez que usemos el método porque estamos usando 
    #un número distinto de puntos/particiones (aunque bastaría con representarla una vez)

    # Calculo del error cometido
    error2N = max(abs(y-ye))
    
    # Resultados
    print('-----')
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)
    print('Error: ' + str(error2N))
    if(i>0):
        print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    #otra forma:
    # if(N!=ns[0]):
    #   print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    print('-----')
    
    # Dibujamos las soluciones
    figure('Figura 1a')
    plot(t, y, '-*') # dibuja la solucion aproximada
    
    errorN = error2N
    i=i+1
    
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
leyenda=['N = ' + str(N) for N in ns]
leyenda.append('exacta')
legend(leyenda)
grid(True)
show()

'''
NOTA 

e(h/n) aproxima a e(h)/n^p donde p es el orden del método

'''

print('\n\n Apartado b \n')

def f(t, y):
    """Funcion que define la ecuacion diferencial"""
    return 6 - y/10

def exacta(t):
    """Solucion exacta del problema de valor inicial"""
    return 60*(1-exp(-t/10))

a = 0.   
b = 20  
y0 = 0  #en t=0 todo el agua era dulce
ns = array([10,20,40,80,160])
i=0


for N in ns :    #N = numero de particiones

    (t, y) = euler(a, b, f, N, y0) # llamada al metodo de Euler
    
    ye = exacta(t) # calculo de la solucion exacta
    #hay que calcularla cada vez que usemos el método porque estamos usando 
    #un número distinto de puntos/particiones (aunque bastaría con representarla una vez)

    # Calculo del error cometido
    error2N = max(abs(y-ye))
    
    # Resultados
    print('-----')
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)
    print('Error: ' + str(error2N))
    if(i>0):
        print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    #otra forma:
    # if(N!=ns[0]):
    #   print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    print('-----')
    
    # Dibujamos las soluciones
    figure('Figura 1b - Depósito con salida 2L/s')
    plot(t, y, '-*') # dibuja la solucion aproximada
    
    errorN = error2N
    i=i+1
    
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
leyenda=['N = ' + str(N) for N in ns]
leyenda.append('exacta')
legend(leyenda)
grid(True)
show()


print('\n\n Apartado c \n')

def f(t, y):
    return 6 - y*3/20
    #ahora no son 2/20=1/10 sino 3/20 porque sale más

a = 0.   
b = 100  
N=2000
y0 = 0  #en t=0 todo el agua era dulce

(t, y) = euler(a, b, f, N, y0) # llamada al metodo de Euler
    
# Resultados
print('-----')
print('Numero de particiones ', N)
print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)
print('-----')

# Dibujamos la aproximación de la solución
figure('Figura 1c - Depósito con salida 3L/s')
plot(t, y, '-*') # dibuja la solucion aproximada
xlabel('tiempo (t)')
ylabel('cantidad sal (y)')
grid(True)
show()


print('La cantidad máxima de sal en el depósito parecer ser 40g, aproximadamente')
print('El instante cuando se alcanza?')


print('\n\n EJERCICIO 2 : \n')


def f(t, y):
    """Funcion que define la ecuacion diferencial"""
    return 0.5*(t**2 - y)

def exacta(t):
    """Solucion exacta del problema de valor inicial"""
    return t**2 - 4*t + 8 - 7*exp(-0.5*t)


def df(t, y):
    return 0.5*(2*t - f(t,y))  #f=y'

def ddf(t, y):
    return 0.5*(2 - df(t,y)) #f' = y''

print('\n\n Taylor de orden 2\n')

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


ns = array([10,20,40,80,160])

a = 0   # extremo inferior del intervalo
b = 10  # extremo superior del intervalo
y0 = 1  # condicion inicial
i=0


for N in ns :    #N = numero de particiones

    (t, y) = taylorOrden2(a, b, f, df, N, y0) # llamada al metodo de Euler
    
    ye = exacta(t) # calculo de la solucion exacta
    #hay que calcularla cada vez que usemos el método porque estamos usando 
    #un número distinto de puntos/particiones (aunque bastaría con representarla una vez)

    # Calculo del error cometido
    error2N = max(abs(y-ye))
    
    # Resultados
    print('-----')
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)
    print('Error: ' + str(error2N))
    if(i>0):
        print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    #otra forma:
    # if(N!=ns[0]):
    #   print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    print('-----')
    
    # Dibujamos las soluciones
    figure('Figura 2a')
    plot(t, y, '-*') # dibuja la solucion aproximada
    
    errorN = error2N
    i=i+1
    
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
leyenda=['N = ' + str(N) for N in ns]
leyenda.append('exacta')
legend(leyenda)
grid(True)
show()


print('Como el método es de orden 2 y estamos dividiendo el paso (h) en 2 en cada iteración, el ratio entre erorres aproxima a 2^2=4 ')

print('\n\n Taylor de orden 3\n')

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



ns = array([10,20,40,80,160])

a = 0   # extremo inferior del intervalo
b = 10  # extremo superior del intervalo
y0 = 1  # condicion inicial
i=0


for N in ns :    #N = numero de particiones

    (t, y) = taylorOrden3(a, b, f, df, ddf, N, y0) # llamada al metodo de Taylor de orden 3
    
    ye = exacta(t) # calculo de la solucion exacta
    #hay que calcularla cada vez que usemos el método porque estamos usando 
    #un número distinto de puntos/particiones (aunque bastaría con representarla una vez)

    # Calculo del error cometido
    error2N = max(abs(y-ye))
    
    # Resultados
    print('-----')
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)
    print('Error: ' + str(error2N))
    if(i>0):
        print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    #otra forma:
    # if(N!=ns[0]):
    #   print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    print('-----')
    
    # Dibujamos las soluciones
    figure('Figura 3a')
    plot(t, y, '-*') # dibuja la solucion aproximada
    
    errorN = error2N
    i=i+1
    
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
leyenda=['N = ' + str(N) for N in ns]
leyenda.append('exacta')
legend(leyenda)
grid(True)
show()


print('Como el método es de orden 3 y estamos dividiendo el paso (h) en 2 en cada iteración, el ratio entre erorres aproxima a 2^3=8 ')


print('Ejercicio 3 \n')

def f(t, y):
    """Funcion que define la ecuacion diferencial"""
    return 0.5*(t**2 - y)

def exacta(t):
    """Solucion exacta del problema de valor inicial"""
    return t**2 - 4*t + 8 - 7*exp(-0.5*t)



print('Método de Heun: \n')

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

a = 0   # extremo inferior del intervalo
b = 10  # extremo superior del intervalo
y0 = 1  # condicion inicial
i=0


for N in ns :    #N = numero de particiones

    (t, y) = heun(a, b, f, N, y0) # llamada al metodo de Heun
    
    ye = exacta(t) # calculo de la solucion exacta
    #hay que calcularla cada vez que usemos el método porque estamos usando 
    #un número distinto de puntos/particiones (aunque bastaría con representarla una vez)

    # Calculo del error cometido
    error2N = max(abs(y-ye))
    
    # Resultados
    print('-----')
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)
    print('Error: ' + str(error2N))
    if(i>0):
        print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    #otra forma:
    # if(N!=ns[0]):
    #   print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    print('-----')
    
    # Dibujamos las soluciones
    figure('Figura 3a Heun')
    plot(t, y, '-*') # dibuja la solucion aproximada
    
    errorN = error2N
    i=i+1
    
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
leyenda=['N = ' + str(N) for N in ns]
leyenda.append('exacta')
legend(leyenda)
grid(True)
show()

# Al dividir h por 2, el error se divide aprox a 4.
# Esto corresponde al comportamiento de un metodo de orden 2.

print('\nMétodo del punto medio: \n')

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

a = 0   # extremo inferior del intervalo
b = 10  # extremo superior del intervalo
y0 = 1  # condicion inicial
i=0


for N in ns :    #N = numero de particiones

    (t, y) = puntomedio(a, b, f, N, y0) # llamada al metodo del punto medio
    
    ye = exacta(t) # calculo de la solucion exacta
    #hay que calcularla cada vez que usemos el método porque estamos usando 
    #un número distinto de puntos/particiones (aunque bastaría con representarla una vez)

    # Calculo del error cometido
    error2N = max(abs(y-ye))
    
    # Resultados
    print('-----')
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)
    print('Error: ' + str(error2N))
    if(i>0):
        print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    #otra forma:
    # if(N!=ns[0]):
    #   print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    print('-----')
    
    # Dibujamos las soluciones
    figure('Figura 3a Punto Medio')
    plot(t, y, '-*') # dibuja la solucion aproximada
    
    errorN = error2N
    i=i+1
    
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
leyenda=['N = ' + str(N) for N in ns]
leyenda.append('exacta')
legend(leyenda)
grid(True)
show()

print('\nMétodo de RK4: \n')

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


a = 0   # extremo inferior del intervalo
b = 10  # extremo superior del intervalo
y0 = 1  # condicion inicial
i=0


for N in ns :    #N = numero de particiones

    (t, y) = RK4(a, b, f, N, y0) # llamada al metodo de RK4
    
    ye = exacta(t) # calculo de la solucion exacta
    #hay que calcularla cada vez que usemos el método porque estamos usando 
    #un número distinto de puntos/particiones (aunque bastaría con representarla una vez)

    # Calculo del error cometido
    error2N = max(abs(y-ye))
    
    # Resultados
    print('-----')
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)
    print('Error: ' + str(error2N))
    if(i>0):
        print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    #otra forma:
    # if(N!=ns[0]):
    #   print('Cociente de errores e_N / e_2N : ', errorN/error2N)
        
    print('-----')
    
    # Dibujamos las soluciones
    figure('Figura 3a RK4')
    plot(t, y, '-*') # dibuja la solucion aproximada
    
    errorN = error2N
    i=i+1
    
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
leyenda=['N = ' + str(N) for N in ns]
leyenda.append('exacta')
legend(leyenda)
grid(True)
show()

# Al dividir h por 2, el error se divide aprox a 16.
# Esto corresponde al comportamiento de un metodo de orden 4.

# Pruebas con arrays

# Lo primero son listas, los segundos son arrays ( el + del primero concatena ambas listas, el + del segundo suma elemento a elemento)

x = [1,2,3]
y = [4,5,6]
x+y

xx = array([1,2,3])
yy = array([4,5,6])
xx+yy

# Como crear una función que devuelva un array, siempre es bueno escribirlo en nombres aux

def fsis(t,y):
    fsis1 = y[0]*cos(t)
    fsis2 = y[1]*sin(t)
    return array([fsis1,fsis2]) 

fsis(pi,array([1,1]))

A = array([[1,2,3], [4,5,6]])
print(A[0,0])
print(A[:,1])
print(A[0,:])

print('\nEjercicio 4\n')

def eulerSis(a, b, fun, N, y0):
    """Implementacion del metodo de Euler para sistemas en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros((len(y0), N+1))   # inicializacion del vector de resultados
    t[0] = a         # nodo inicial
    y[:, 0] = y0        # valor inicial

    # Metodo de Euler
    for k in range(N):
        y[:, k+1] = y[:, k]+h*fun(t[k], y[:, k])
        t[k+1] = t[k]+h
    
    return (t, y)

def f4(t,y): # x = y[0] e y = y[1]
    '''Función que define el sistema diferencial'''
    dx = 0.25*y[0]-0.01*y[0]*y[1]
    dy = -y[1]+0.01*y[0]*y[1]
    return array([dx, dy])


# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 20.  # extremo superior del intervalo
N = 20  # numero de particiones
y0 = array([80,30])  # condiciones iniciales

tini = perf_counter()

(t, y) = eulerSis(a, b, f4, N, y0) # llamada al metodo de EulerSis

tfin=perf_counter()

# Dibujamos las soluciones
figure('Ejercicio 4 - Prueba método de EulerSis')

subplot(121)
plot(t, y[0, :], t, y[1, :]) # dibuja la solucion aproximada
xlabel('t')
ylabel('x,y')
legend(['Presa', 'Depredador'])

subplot(122)
plot(y[0, :], y[1, :])
xlabel('x')
ylabel('y')
legend(['Trayectoria'])


# Resultados
print('-----')
print('Tiempo CPU: ' + str(tfin-tini)) #print('Tiempo CPU: ', tfin-tini)
print('Paso de malla: ' + str((b-a)/N))
print('-----')

show() # muestra la grafica


# Apartado a)
print('\nApartado a)\n')

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 20.  # extremo superior del intervalo
y0 = array([80,30])  # condiciones iniciales
malla = [20,40,80,160,320,640]

figure ('Ejercicio 4a')

for N in malla :    #N = numero de particiones

    t_ini = perf_counter()

    (t, y) = eulerSis(a, b, f4, N, y0) # llamada al metodo de Euler para sistemas
    
    t_fin = perf_counter()
    
    plot(y[0, :], y[1,:], ) # dibuja la trayectoria aproximada
    
    # Resultados
    print('-----')
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)        
    print('-----')

xlabel('x')
ylabel('y')
legend(['N = ' + str(N) for N in malla])
grid(False)
show()

print ('Ejercicio 4 - RK4')

def RK4Sis(a, b, fun, N, y0):
    """Implementacion del metodo de RK4 en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros((len(y0), N+1)) # inicializacion del vector de resultados
    t[0] = a         # nodo inicial
    y[:, 0] = y0        # valor inicial

    # Metodo de RK4
    for k in range(N):
        
        t[k+1] = t[k]+h 
        K1 = fun(t[k],y[:, k])
        K2 = fun(t[k]+h/2, y[:, k]+h/2*K1)
        K3 = fun(t[k]+h/2, y[:, k]+h/2*K2)
        K4 = fun(t[k+1], y[:, k]+h*K3)
        
        y[:, k+1] = y[:, k] + h/6*(K1+2*K2+2*K3+K4)
        
        
    return (t, y)

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 20.  # extremo superior del intervalo
N = 20  # numero de particiones
y0 = array([80,30])  # condiciones iniciales

tini = perf_counter()

(t, y) = RK4Sis(a, b, f4, N, y0) # llamada al metodo de RK4Sis

tfin=perf_counter()

# Dibujamos las soluciones
figure('Ejercicio 4 - Prueba método de RK4Sis')

subplot(121)
plot(t, y[0, :], t, y[1, :]) # dibuja la solucion aproximada
xlabel('t')
ylabel('x,y')
legend(['Presa', 'Depredador'])

subplot(122)
plot(y[0, :], y[1, :])
xlabel('x')
ylabel('y')
legend(['Trayectoria'])


# Resultados
print('-----')
print('Tiempo CPU: ' + str(tfin-tini)) #print('Tiempo CPU: ', tfin-tini)
print('Paso de malla: ' + str((b-a)/N))
print('-----')

show() # muestra la grafica

print('\nApartado b)\n')

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 20.  # extremo superior del intervalo
y0 = array([80,30])  # condiciones iniciales
malla = [20,40,80,160,320,640]

figure ('Ejercicio 4b- RK4')

for N in malla :    #N = numero de particiones

    t_ini = perf_counter()

    (t, y) = RK4Sis(a, b, f4, N, y0) # llamada al metodo de RK4 para sistemas
    
    t_fin = perf_counter()
    
    plot(y[0, :], y[1,:]) # dibuja la trayectoria aproximada
    
    # Resultados
    print('-----')
    print('Tiempo CPU:', t_fin-t_ini)
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)        
    print('-----')

xlabel('x')
ylabel('y')
legend(['N = ' + str(N) for N in malla])
grid(False)
show()

print ('Ejercicio 4 - Heun')

def heunSis(a, b, fun, N, y0):
    """Implementacion del metodo de Heun en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros((len(y0), N+1)) # inicializacion del vector de resultados
    t[0] = a         # nodo inicial
    y[:, 0] = y0        # valor inicial

    # Metodo de Heun
    for k in range(N):
        t[k+1] = t[k]+h
        y[:, k+1] = y[:, k]+h/2*(fun(t[k], y[:, k]) + fun(t[k+1], y[:, k] + h*fun(t[k], y[:, k]))) 
        
    return (t, y)

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 20.  # extremo superior del intervalo
N = 20  # numero de particiones
y0 = array([80,30])  # condiciones iniciales

tini = perf_counter()

(t, y) = heunSis(a, b, f4, N, y0) # llamada al metodo de HeunSis

tfin=perf_counter()

# Dibujamos las soluciones
figure('Ejercicio 4 - Prueba método de HeunSis')

subplot(121)
plot(t, y[0, :], t, y[1, :]) # dibuja la solucion aproximada
xlabel('t')
ylabel('x,y')
legend(['Presa', 'Depredador'])

subplot(122)
plot(y[0, :], y[1, :])
xlabel('x')
ylabel('y')
legend(['Trayectoria'])


# Resultados
print('-----')
print('Tiempo CPU: ' + str(tfin-tini)) #print('Tiempo CPU: ', tfin-tini)
print('Paso de malla: ' + str((b-a)/N))
print('-----')

show() # muestra la grafica

print('\nApartado b)\n')

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 20.  # extremo superior del intervalo
y0 = array([80,30])  # condiciones iniciales
malla = [20,40,80,160,320,640]

figure ('Ejercicio 4b - Heun')

for N in malla :    #N = numero de particiones

    t_ini = perf_counter()

    (t, y) = heunSis(a, b, f4, N, y0) # llamada al metodo de heun para sistemas
    
    t_fin = perf_counter()
    
    plot(y[0, :], y[1,:]) # dibuja la trayectoria aproximada
    
    # Resultados
    print('-----')
    print('Tiempo CPU:', t_fin-t_ini)
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)        
    print('-----')

xlabel('x')
ylabel('y')
legend(['N = ' + str(N) for N in malla])
grid(False)
show()

print ('Ejercicio 4 - Punto Medio')

def puntomedioSis(a, b, fun, N, y0):
    """Implementacion del metodo de punto medio en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros((len(y0), N+1)) # inicializacion del vector de resultados
    t[0] = a         # nodo inicial
    y[:, 0] = y0        # valor inicial

    # Metodo de Punto Medio
    for k in range(N):
        t[k+1] = t[k]+h
        y[:, k+1] = y[:, k]+h*fun(t[k] + h/2, y[:, k] + h/2*fun(t[k],y[:, k]))
    return (t, y)

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 20.  # extremo superior del intervalo
N = 20  # numero de particiones
y0 = array([80,30])  # condiciones iniciales

tini = perf_counter()

(t, y) = puntomedioSis(a, b, f4, N, y0) # llamada al metodo de puntoMedioSis

tfin=perf_counter()

# Dibujamos las soluciones
figure('Ejercicio 4 - Prueba método de puntomedioSis')

subplot(121)
plot(t, y[0, :], t, y[1, :]) # dibuja la solucion aproximada
xlabel('t')
ylabel('x,y')
legend(['Presa', 'Depredador'])

subplot(122)
plot(y[0, :], y[1, :])
xlabel('x')
ylabel('y')
legend(['Trayectoria'])


# Resultados
print('-----')
print('Tiempo CPU: ' + str(tfin-tini)) #print('Tiempo CPU: ', tfin-tini)
print('Paso de malla: ' + str((b-a)/N))
print('-----')

show() # muestra la grafica

print('\nApartado b)\n')

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 20.  # extremo superior del intervalo
y0 = array([80,30])  # condiciones iniciales
malla = [20,40,80,160,320,640]

figure ('Ejercicio 4b - Punto Medio')

for N in malla :    #N = numero de particiones

    t_ini = perf_counter()

    (t, y) = puntomedioSis(a, b, f4, N, y0) # llamada al metodo de punto medio para sistemas
    
    t_fin = perf_counter()
    
    plot(y[0, :], y[1,:]) # dibuja la trayectoria aproximada
    
    # Resultados
    print('-----')
    print('Tiempo CPU:', t_fin-t_ini)
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)        
    print('-----')

xlabel('x')
ylabel('y')
legend(['N = ' + str(N) for N in malla])
grid(False)
show()

# Ejercicio 5

print('Ejercicio 5 - Euler')

def exacta(t):
    """Solucion exacta del problema de valor inicial"""
    return exp(-10*t)*cos(t)

def f5(t,y): # x = y[0] e y = y[1]
    '''Función que define la ecuacion diferencial en dos ecuaciones'''
    dx = y[1]
    dy = -20*y[1]-101*y[0]
    return array([dx, dy])

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 7.  # extremo superior del intervalo
malla = [20,40,80,160,320,640]
y0 = array([1,-10])  # condiciones iniciales

figure ('Ejercicio 5 - Euler')

for N in malla :    #N = numero de particiones

    t_ini = perf_counter()

    (t, y) = eulerSis(a, b, f5, N, y0) # llamada al metodo de RK4 para sistemas
    
    t_fin = perf_counter()
    
    plot(t, y[0, :]) # dibuja la solucion aproximada
    
    ye = exacta(t) # Cálculo solución exacta
    
    error = max(abs(y[0, :]-ye)) # Cálculo error cometido
    
    # Resultados
    print('-----')
    print('Tiempo CPU:', t_fin-t_ini)
    print('Numero de particiones ', N)
    print('Error: ', str(error))
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)        
    print('-----')

plot (t, ye, 'k')    
xlabel('x')
ylabel('y')
leyenda = ['N = ' + str(N) for N in malla]
leyenda.append('exacta')
legend(leyenda)
show()

print('Ejercicio 5 - Heun')

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 7.  # extremo superior del intervalo
malla = [20,40,80,160,320,640]
y0 = array([1,-10])  # condiciones iniciales

figure ('Ejercicio 5 - Heun')

for N in malla :    #N = numero de particiones

    t_ini = perf_counter()

    (t, y) = heunSis(a, b, f5, N, y0) # llamada al metodo de Heun para sistemas
    
    t_fin = perf_counter()
    
    plot(t, y[0, :]) # dibuja la solucion aproximada
    
    ye = exacta(t) # Cálculo solución exacta
    
    error = max(abs(y[0, :]-ye)) # Cálculo error cometido
    
    # Resultados
    print('-----')
    print('Tiempo CPU:', t_fin-t_ini)
    print('Numero de particiones ', N)
    print('Error: ', str(error))
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)        
    print('-----')

plot (t, ye, 'k')    
xlabel('x')
ylabel('y')
leyenda = ['N = ' + str(N) for N in malla]
leyenda.append('exacta')
legend(leyenda)
show()

print('Ejercicio 5 - RK4')

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 7.  # extremo superior del intervalo
malla = [20,40,80,160,320,640]
y0 = array([1,-10])  # condiciones iniciales

figure ('Ejercicio 5 - RK4')

for N in malla :    #N = numero de particiones

    t_ini = perf_counter()

    (t, y) = RK4Sis(a, b, f5, N, y0) # llamada al metodo de RK4 para sistemas
    
    t_fin = perf_counter()
    
    plot(t, y[0, :]) # dibuja la solucion aproximada
    
    ye = exacta(t) # Cálculo solución exacta
    
    error = max(abs(y[0, :]-ye)) # Cálculo error cometido
    
    # Resultados
    print('-----')
    print('Tiempo CPU:', t_fin-t_ini)
    print('Numero de particiones ', N)
    print('Error: ', str(error))
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)        
    print('-----')

plot (t, ye, 'k')    
xlabel('x')
ylabel('y')
leyenda = ['N = ' + str(N) for N in malla]
leyenda.append('exacta')
legend(leyenda)
show()

print('Ejercicio 5 - Punto Medio')

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 7.  # extremo superior del intervalo
malla = [20,40,80,160,320,640]
y0 = array([1,-10])  # condiciones iniciales

figure ('Ejercicio 5 - Punto Medio')

for N in malla :    #N = numero de particiones

    t_ini = perf_counter()

    (t, y) = puntomedioSis(a, b, f5, N, y0) # llamada al metodo de RK4 para sistemas
    
    t_fin = perf_counter()
    
    plot(t, y[0, :]) # dibuja la solucion aproximada
    
    ye = exacta(t) # Cálculo solución exacta
    
    error = max(abs(y[0, :]-ye)) # Cálculo error cometido
    
    # Resultados
    print('-----')
    print('Tiempo CPU:', t_fin-t_ini)
    print('Numero de particiones ', N)
    print('Error: ', str(error))
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)        
    print('-----')

plot (t, ye, 'k')    
xlabel('x')
ylabel('y')
leyenda = ['N = ' + str(N) for N in malla]
leyenda.append('exacta')
legend(leyenda)
show()

# Ejercicio 6

print('Ejercicio 6 - Apartado a)')

def f6(t,y): # x = y[0] , y = y[1] y z = y[2]
    '''Función que define el sistema diferencial'''
    dx = -2e-3*y[0]*y[1]-1e-5*y[0]
    dy = 2e-3*y[0]*y[1]-5e-3*y[1]
    dz = 1e-5*y[0] + 5e-3*y[1]
    return array([dx, dy, dz])

# Datos del problema
a = 0
b = 60
h = 0.05
N = int((b-a)/h)
y0 = array([99, 1, 0])  # [S(0), I(0), R(0)]

tini = perf_counter()

(t, y) = RK4Sis(a, b, f6, N, y0) # llamada al metodo de RK4SISMod

tfin=perf_counter()

#Resultados 
print('-----')
print('Numero de particiones ', N)
print('Tiempo CPU: ' + str(tfin-tini))
print('Paso de malla: ' + str((b-a)/N))
print('-----')

# Dibujamos las soluciones
figure('Ejercicio 6 - Prueba método de RK4Sis')

plot(t, y[0, :], t, y[1, :], t, y[2, :]) # dibuja la solucion aproximada
xlabel('t')
ylabel('x,y,z')
legend(['Susceptibles', 'Infectados', 'Resto'])

show() # muestra la grafica

"""
Observamos que en un primer momento, 99/100 eran susceptibles y solo 1/100
era contagiado. A medida que avanza t, se van contagiando más, así que baja el número de 
susceptibles consecuentemente. Asimismo, observamos
el máximo de contagiados en torno a 85; no llega a ser 100 porque parte de los
ellos se van recuperando o mueren, por eso vemos un poco de crecimiento en la línea 
azul. Al final de la observación, no hay susceptibles (todos se han contagiado), y sigue
habiendo bastantes que aún están enfermos. Aquí alcanza su máximo el número de 
recuperados/muertos, y seguiría creciendo si seguimos observando en el tiempo, 
ya que en algún momento, cualquier individuo contagiado dejará de estar enfermo.

"""

print('Apartado b)')

def f6b(t,y): # x = y[0] , y = y[1] y z = y[2]
    '''Función que define el sistema diferencial'''
    dx = -2e-3*y[0]*y[1]-1e-5*y[0]
    dy = 2e-3*y[0]*y[1]-5e-2*y[1]
    dz = 1e-5*y[0] + 5e-2*y[1]
    return array([dx, dy, dz])

# Datos del problema
a = 0
b = 60
h = 0.05
N = int((b-a)/h)
y0 = array([99, 1, 0])  # [S(0), I(0), R(0)]

tini = perf_counter()

(t, y) = RK4Sis(a, b, f6b, N, y0) # llamada al metodo de RK4SISMod

tfin=perf_counter()

#Resultados 
print('-----')
print('Numero de particiones ', N)
print('Tiempo CPU: ' + str(tfin-tini))
print('Paso de malla: ' + str((b-a)/N))
print('-----')

# Dibujamos las soluciones
figure('Ejercicio 6b - Prueba método de RK4Sis')

plot(t, y[0, :], t, y[1, :], t, y[2, :]) # dibuja la solucion aproximada
xlabel('t')
ylabel('x,y,z')
legend(['Susceptibles', 'Infectados', 'Resto'])

show() # muestra la grafica

"""
Ahora, como k2 es la tasa de superación de la enfermedad y la hemos incrementado en gran medida,
ocurre que el máximo de enfermos a la vez es mucho menor, ya que se van recuperando antes.
Esto hace, evidentemente, que en el mismo periodo de tiempo, haya muchos más recuperados, así
que la línea verde crece a un ritmo mucho mayor.
Asimismo, como la masa de contagiados es menor, esto produce que el número de personas sanas
susceptibles sufra un descenso algo más suave, ya que el contagio no es tan agresivo.

"""

print('Apartado c)')

def f6c(t,y): # x = y[0] , y = y[1] y z = y[2]
    '''Función que define el sistema diferencial'''
    dx = -2e-3*y[0]*y[1]-1e-5*y[0] + y[1]*0.5*5e-2
    dy = 2e-3*y[0]*y[1]-5e-2*y[1]
    dz = 1e-5*y[0] + 5e-2*y[1] - y[1]*0.5*5e-2
    return array([dx, dy, dz])

# Datos del problema
a = 0
b = 60
h = 0.05
N = int((b-a)/h)
y0 = array([99, 1, 0])  # [S(0), I(0), R(0)]

tini = perf_counter()

(t, y) = RK4Sis(a, b, f6c, N, y0) # llamada al metodo de RK4SIS

tfin=perf_counter()

#Resultados 
print('-----')
print('Numero de particiones ', N)
print('Tiempo CPU: ' + str(tfin-tini))
print('Paso de malla: ' + str((b-a)/N))
print('-----')

# Dibujamos las soluciones
figure('Ejercicio 6c - Prueba método de RK4Sis')

plot(t, y[0, :], t, y[1, :], t, y[2, :]) # dibuja la solucion aproximada
xlabel('t')
ylabel('x,y,z')
legend(['Susceptibles', 'Infectados', 'Resto'])

show()

print('Ejercicio 7')

print('Apartado a)')

def RK4SisBis(a, b, fun, N, y0):
    """Implementacion del metodo de RK4 en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros((len(y0), N+1)) # inicializacion del vector de resultados
    t[0] = a         # nodo inicial
    y[:, 0] = y0        # valor inicial

    # Metodo de RK4
    for k in range(N):
        
        t[k+1] = t[k]+h 
        K1 = fun(t[k],y[:, k])
        K2 = fun(t[k]+h/2, y[:, k]+h/2*K1)
        K3 = fun(t[k]+h/2, y[:, k]+h/2*K2)
        K4 = fun(t[k+1], y[:, k]+h*K3)
        
        y[:, k+1] = y[:, k] + h/6*(K1+2*K2+2*K3+K4)
        
        if y[0, k+1] < 0:
            return t[:k+1], y[:, :k+1]
        
    return (t, y)

print('\nApartado b)')

# Datos del problema
h = 0.05
N = int((b-a)/h)
y0 = array([0, 50, 7.5]) 

print('Apartado i)')

def f7i(t, y): # z = y[0], v = y[1], mf = y[2]
    '''Función que define el sistema diferencial'''
    dz = y[1]
    dv = -9.81 + (0/(7.5+y[2])) - (0/(7.5+y[2]))*y[1]*abs(y[1])+0.02*(0/(7.5+y[2]))*y[1]
    dmf = -0.02*0
    return array([dz, dv, dmf])

tini = perf_counter()

(t, y) = RK4SisBis(a, b, f7i, N, y0)

tfin=perf_counter()

#Resultados 
print('-----')
print('Numero de particiones ', N)
print('Tiempo CPU: ' + str(tfin-tini))
print('Paso de malla: ' + str((b-a)/N))
print('-----')

# Dibujamos las soluciones
figure('Ejercicio 7bi - Prueba método de RK4SisBis')

plot(t, y[0, :], t, y[1, :], t, y[2, :]) # dibuja la solucion aproximada
xlabel('t')
ylabel('z,v,mf')
legend(['Altura', 'Velocidad', 'Masa Combustible'])

show() # muestra la grafica

print('Apartado ii)')

def f7ii(t, y): # z = y[0], v = y[1], mf = y[2]
    '''Función que define el sistema diferencial'''
    dz = y[1]
    dv = -9.81 + (0/(7.5+y[2])) - (0.02/(7.5+y[2]))*y[1]*abs(y[1])+0.02*(0/(7.5+y[2]))*y[1]
    dmf = -0.02*0
    return array([dz, dv, dmf])

tini = perf_counter()

(t, y) = RK4SisBis(a, b, f7ii, N, y0)

tfin=perf_counter()

#Resultados 
print('-----')
print('Numero de particiones ', N)
print('Tiempo CPU: ' + str(tfin-tini))
print('Paso de malla: ' + str((b-a)/N))
print('-----')

# Dibujamos las soluciones
figure('Ejercicio 7bii - Prueba método de RK4SisBis')

plot(t, y[0, :], t, y[1, :], t, y[2, :]) # dibuja la solucion aproximada
xlabel('t')
ylabel('z,v,mf')
legend(['Altura', 'Velocidad', 'Masa Combustible'])

show() # muestra la grafica

print('Apartado iii)')

def Tiii(t, y):
    if y[2] > 0:
        return 50
    else:
        return 0

def f7iii(t, y): # z = y[0], v = y[1], mf = y[2]
    '''Función que define el sistema diferencial'''
    dz = y[1]
    dv = -9.81 + (Tiii(t,y)/(7.5+y[2])) - (0.02/(7.5+y[2]))*y[1]*abs(y[1])+0.02*(Tiii(t,y)/(7.5+y[2]))*y[1]
    dmf = -0.02*Tiii(t,y)
    return array([dz, dv, dmf])

tini = perf_counter()

(t, y) = RK4SisBis(a, b, f7iii, N, y0)

tfin=perf_counter()

#Resultados 
print('-----')
print('Numero de particiones ', N)
print('Tiempo CPU: ' + str(tfin-tini))
print('Paso de malla: ' + str((b-a)/N))
print('-----')

# Dibujamos las soluciones
figure('Ejercicio 7biii - Prueba método de RK4SisBis')

plot(t, y[0, :], t, y[1, :], t, y[2, :]) # dibuja la solucion aproximada
xlabel('t')
ylabel('z,v,mf')
legend(['Altura', 'Velocidad', 'Masa Combustible'])

show() # muestra la grafica


# FORMA VISTA EN CLASE DEL EJERCICIO 7

g = 9.81
alpha = 0.02
M = 7.5

def f7Mod(t,y): # y[0] = z, y[1] = v, y[2] = mf
     '''Función que define el sistema diferencial'''
     m = M + y[2]
     T = T0 * (y[2]>0)
     dz = y[1]
     dv = -g + (T/m) - (C/m)*y[1]*abs(y[1]) + alpha*(T/m)*y[1]
     dmf = -alpha*T
     return array([dz, dv, dmf])
 
# Datos del problema
a = 0
b = 20
h = 0.05
N = int((b-a)/h)
y0 = array([0, 50, 7.5]) 

# Usemos el método de RK4Sis

# Sin motor ni rozamiento
T0 = 0.
C = 0.

tini = perf_counter()

(ti,yi) = RK4Sis(a,b,f7Mod, N, y0)

tfin=perf_counter()

# Con motor y sin rozamiento
T0 = 0.
C = 0.02

tini = perf_counter()

(tii,yii) = RK4Sis(a,b,f7Mod, N, y0)

tfin=perf_counter()

# Con motor y rozamiento
T0 = 50.
C = 0.02

tini = perf_counter()

(tiii,yiii) = RK4Sis(a,b,f7Mod, N, y0)

tfin=perf_counter()

figure ('Ejercicio 7 - Previo')

plot(ti, yi[0], tii, yii[0], tiii, yiii[0]) # dibuja la solucion aproximada
xlabel('t')
ylabel('z')
legend(['T=0;C=0', 'T=0;C=0.02', 'T=50;C=0.02'])
show()

''' Ahora mismo estamos suponiendo que la altura es negativa, pero esto no
debería suceder, luego en el partado a) se nos pide realmente definir una función 
python que permita resolverlo en RK4 mientras que z >= 0. '''

print('\nApartado a)')

# Definamos un nuevo método RK4

g = 9.81
alpha = 0.02
M = 7.5

def f7Mod(t,y): # y[0] = z, y[1] = v, y[2] = mf
     '''Función que define el sistema diferencial'''
     m = M + y[2]
     T = T0 * (y[2]>0)
     
     dz = y[1]
     dv = -g + (T/m) - (C/m)*y[1]*abs(y[1]) + alpha*(T/m)*y[1]
     dmf = -alpha*T
     return array([dz, dv, dmf])
 
# Datos del problema
a = 0
h = 0.05
y0 = array([0, 50, 7.5]) 

# IMPLEMENTACIÓN METODO RK4 con bucle WHILE

def RK4SisMod(a, fun, h, y0):
    """Implementacion del metodo de RK4 modificado en el usando
    h como paso de malla y condicion inicial y0"""
    
    # No podemos saber a priori el tamaño final, luego no podemos inicializar
    # el tamaño correcto de N en los vectores iniciales.
    # Entonces debemos en cada iteración aumentaremos el tamaño del vector de nodos y resultados.
    
    t = zeros((1)) # inicialización del vector de nodos
    y = zeros((len(y0), 1) )# inicialización del vector de resultados
    t[0] = a         # nodo inicial
    y[:, 0] = y0        # valor inicial
    
    k = 0

    # Metodo de RK4 modificado
    while  y[0, k]>= 0:
        
        
        K1 = fun(t[k],y[:, k])
        K2 = fun(t[k]+h/2, y[:, k]+h/2*K1)
        K3 = fun(t[k]+h/2, y[:, k]+h/2*K2)
        K4 = fun(t[k] + h, y[:, k]+h*K3)
        
        ykmas1 = y[:, k] + h/6*(K1+2*K2+2*K3+K4)
        
        t = append(t,t[k]+h)
        y = column_stack((y, ykmas1))
        
        k = k+1
        
    return (t, y)

print('\nApartado b)')

# Sin motor ni rozamiento
T0 = 0.
C = 0.

tini = perf_counter()

(ti,yi) = RK4SisMod(a,f7Mod, h, y0)

tfin=perf_counter()

# Con motor y sin rozamiento
T0 = 0.
C = 0.02

tini = perf_counter()

(tii,yii) = RK4SisMod(a,f7Mod, h, y0)

tfin=perf_counter()

# Con motor y rozamiento
T0 = 50.
C = 0.02

tini = perf_counter()

(tiii,yiii) = RK4SisMod(a,f7Mod, h, y0)

tfin=perf_counter()

# Cálculo de la altura máxima

print('\nEjercicio c)\n')

# Calculamos la altura máxima y tiempo de caída en cada caso
# El tiempo de caída es el tiempo de vuelo según los profes :)

# ti[-1] es el ultimo valor de ti

print('C = 0; T = 0')
print('Máxima altura: ' + str(max(yi[0, :])))
print('Tiempo de caída: ' + str(ti[-1]))
print('\n')

print('C = 0.02; T = 0')
print('Máxima altura: ' + str(max(yii[0, :])))
print('Tiempo de caída: ' + str(tii[-1]))
print('\n')

print('C = 0.02; T = 50')
print('Máxima altura: ' + str(max(yiii[0, :])))
print('Tiempo de caída: ' + str(tiii[-1]))
print('Momento en el que combustible acaba: 7.5')
print('\n')

figure ('Ejercicio 7 - Alturas')

plot(ti, yi[0], tii, yii[0], tiii, yiii[0]) # dibuja la solucion aproximada
xlabel('t')
ylabel('z')
legend(['T=0;C=0', 'T=0;C=0.02', 'T=50;C=0.02'])
show()

figure ('Ejercicio 7 - Combustible')

plot(tiii, yiii[2]) # dibuja la solucion aproximada
xlabel('t')
ylabel('mf')
legend(['T=50;C=0.02'])
show()

