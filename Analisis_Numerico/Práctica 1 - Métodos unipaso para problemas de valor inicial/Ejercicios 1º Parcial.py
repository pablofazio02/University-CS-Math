# -*- coding: utf-8 -*-
"""
Created on Sat Mar 18 12:41:25 2023

@author: sonico22
"""

from pylab import *
from time import perf_counter #para medir cuanto tarda el metodo en converger

"EJERCICIO PARCIAL DEL AÑO PASADO"

#Como no hay ninguna COLUMNA llena de ceros, deducimos que el metodo no es explicito. Ademas, como la matriz es triangular inferior con al menos un elemento de diagonal principal distinto de 0,
#por la caracterizacion por matrices podemos decir que el metodo es semi-implicito

#Como A es matriz 2x2, el metodo tiene 2 etapas. Vamos a calcular a mano yk(1), yk(2) y posteriormente yk+1, todo ello aplicado a la ecuacion diferencial y'=-9y
#Como la funcion que define a la ecuacion diferencial, f(t,y)= -9y no depende explicitamente de t, los calculos se simplifican

#operando y sabiendo que f(tk(1,yk(1))) = -9yk(1) y que f(tk(2), yk(2)) = -9yk(2) llegamos a que 
#yk(1) = yk/(1 +3h)
#yk(2) = yk/[(1+3h)^2]
# yk+1 = yk + 0.5h[-9yk(1) -9yk(2)]

#Introducimos lo anterior en alguno de los metodos para resolver una ecuacion
#y como no se la condicion inicial tomo por ejemplo y(0) = 1
#Como no se el intervalo, tomo [0,10], N=10


def f(t, y): 
    """Funcion que define la ecuacion diferencial"""
    return -9*y

def exacta(t): 
    """Solucion exacta del problema de valor inicial"""
    return exp(-9*t)

def parcial(a, b, fun, N, y0): #a y b extremos izq der del intervalo, es decir, to y tN, fun define la ecuacion diferencial que queremos resolver, la llamamos fun e vez de f para que sea programa general, yo le doy el nombre de la funcion que define la ecuacion diferencial, para aplicar a mi funcion cambio el tercer elemento que define Euler, N numero subintervalos de la particion, y0 condicion inicial
    """Implementacion del metodo de Euler en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N # paso de malla
    t = zeros(N+1) # inicializacion del vector de nodos #arrary de tiempos
    y = zeros(N+1) # inicializacion del vector de resultados #array de valores que voy obteniendo
    t[0] = a # nodo inicial #aqui ponemos condicion inicial, el tiempo inicial es a
    y[0] = y0 # valor inicial

    # Metodo de Euler #bucle del metodo, el k toma valores entre 0 y N-1
    for k in range(N):
        yk1 = y[k] / (1 +3*h)
        yk2 = y[k] / [(1 +3*h)**2]
        y[k+1] = y[k]+ (1/2)*h*(-9*yk1 -9*yk2)
        t[k+1] = t[k]+h
    
    return (t, y) #el programa que recibe 5 datos devuelve dos arrays de tamaño N-1


# Datos del problema #intervalo (0,10) con N particiones
a = 0. # extremo inferior del intervalo
b = 10. # extremo superior del intervalo
N = 20 # numero de particiones
y0 = 1. # condicion inicial



(t, y) = parcial(a, b, f, N, y0) # llamada al metodo de Euler



ye = exacta(t) # calculo de la solucion exacta en los tiempos donde he obtenido aproximaciones

figure('Ejercicio tablero')
# Dibujamos las soluciones
plot(t, y, '-*') # dibuja la solucion aproximada #un plot tiene 3 entradas, valores linea horizontal valores linea bertical, como quiero dibujar la grafica. -*  pone estrellas y une por linea
plot(t, ye, 'k') # dibuja la solucion exacta #k dibuja en negro, b blue, r red
xlabel('t')
ylabel('y')
legend(['Parcial', 'exacta'])


# Calculo del error cometido
error = max(abs(y-ye)) #se puede hacer diferencia pues los array tienen el mismo tamaño

# Resultados


print('Error: ' + str(error))
print('Paso de malla: ' + str((b-a)/N)) #no puedo poner h porque la he creado dentro de una funcion, se destruye al salir del programa


show() # muestra la grafica




"EJERCICIO 1 PARCIAL 2012/2013 GRUPO A"

#Empezamos dando la funcion que define a la ecuacion diferencial
def f(t,y):
    return -y +2*sin(t)

#Damos la solucion exacta, que conocemos en este caso

def exacta (t):
    return (pi +1)*exp(-t) +sin(t) -cos(t)

#Damos los datos necesarios para podemos dar soluciones aproximadas
a=0
b= 3*pi
N= 50
y0=pi
h0= 1.e-3
tol=1.e-8

#Ahora implimentamos los metodos RK4 y RK45 que vamos a utilizar

def RK4(a, b, fun, N, y0): #a y b extremos izq der del intervalo, es decir, to y tN, fun define la ecuacion diferencial que queremos resolver, la llamamos fun e vez de f para que sea programa general, yo le doy el nombre de la funcion que define la ecuacion diferencial, para aplicar a mi funcion cambio el tercer elemento que define Euler, N numero subintervalos de la particion, y0 condicion inicial
    """Implementacion del metodo de Euler en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N # paso de malla
    t = zeros(N+1) # inicializacion del vector de nodos #arrary de tiempos
    y = zeros(N+1) # inicializacion del vector de resultados #array de valores que voy obteniendo
    t[0] = a # nodo inicial #aqui ponemos condicion inicial, el tiempo inicial es a
    y[0] = y0 # valor inicial

    # Metodo de Euler #bucle del metodo, el k toma valores entre 0 y N-1
    for k in range(N):
        k1=f(t[k],y[k])
        k2=f(t[k]+h/2,y[k]+h/2*k1)
        k3=f(t[k]+h/2,y[k]+h/2 *k2)
        k4=f(t[k]+h,y[k]+h*k3)
        y[k+1] = y[k]+h/6*(k1+2*k2+2*k3+k4)
        t[k+1] = t[k]+h
    
    return (t, y) #el programa que recibe 5 datos devuelve dos arrays de tamaño N-1


def rk45(a, b, fun, y0, h0, tol): #a, b extremos de intervalos, y0 solucion que da ecuacion, h0 paso inicial 
    """Implementacion del metodo encajado RK2(3)
    en el intervalo [a, b] con condicion inicial y0,
    paso inicial h0 y tolerancia tol"""
    

    hmin = (b-a)*1.e-5 # paso de malla minimo  #paso minimo para poder llegar siempre al extremo del intervalo
    hmax = (b-a)/10. # paso de malla maximo

    
    # coeficientes RK
    q = 6 # numero de etapas
    p = 4 # orden del método menos preciso
    A = zeros([q, q]) # es la matriz de coeficientes aij del tablero de Butcher, que empieza en 0 por ser metodo explicito
    A[1, 0] = 1./4.
    A[2, 0] = 3/32.
    A[3, 0] = 1932/2197.
    A[4, 0] = 439/216.
    A[5, 0] = -8/27.
    A[2, 1] = 9/32.
    A[3, 1] = -7200/2197. 
    A[4, 1] = -8.
    A[5, 1] = 2.
    A[3, 2] = 7296/2197.
    A[4, 2] = 3680/513.
    A[5, 2] = -3544/2565.
    A[4, 3] = -845/4104.
    A[5, 3] = 1859/4104.
    A[5, 4] = -11/40.
    
    B = zeros(q) 
    B[0] = 25/216.
    B[2] = 1408/2565
    B[3] =2197/4104
    B[4] =-1/5
    
    BB = zeros(q)
    BB[0] = 16/135.
    BB[2] = 6656/12825.
    BB[3] = 28561/56430.
    BB[4] = -9/50.
    BB[5] = 2/55
    
    
    C = zeros(q)
    for i in range(q):
        C[i] = sum(A[i,:]) #los ci se calcula sumando las filas
    
    # inicializacion de variables
    t = array([a]) # nodos
    y = array([y0]) # soluciones
    h = array([h0]) # pasos de malla #guardamos la h en array, que no necesario, para poder dibujar
    K = zeros(q) #q numero de etapas
    k = 0 # contador de iteraciones #es el array que contiene los K1,K2,K3 que usa RK para avanzar
    
    while (t[k] < b): #bucle while que usa el algoritmo explicado en clase
        h[k] = min(h[k], b-t[k]) # ajuste del ultimo paso de malla
        for i in range(q):
            K[i] = fun(t[k]+C[i]*h[k], y[k]+h[k]*sum(A[i,:]*K)) #vamos rellenando las Ki
        incrlow = sum(B*K) # metodo de orden 2 #phi por funcion incremento del primer tablero
        incrhigh = sum(BB*K) # metodo de orden 3 #phi *funcion imcremento del segundo tablero
        error = h[k]*(incrhigh-incrlow) # estimacion del error
        y = append(y, y[k]+h[k]*incrlow) # y_(k+1)
        t = append(t, t[k]+h[k]); # t_(k+1) #al array le añadimos nuevo tiempo
        hnew = 0.9*h[k]*abs(tol/error)**(1./(p+1)) # h_(k+1) #p orden del metodo de menor orden
        hnew = min(max(hnew,hmin),hmax) # hmin <= h_(k+1) <= hmax #comprobacion
        h = append(h, hnew) #para añadir nuevo h a array de h
        k += 1
    #array fijo pero con la funcion append le metes algo al array
  
    return (t, y, h)



figure('Ejercicio 1 Grupo A')
(t1,y1)= RK4(a,b,f,N,y0)
(t2,y2,h)= rk45(a,b,f,y0,h0,tol)


q= linspace(a,b,N)
ye= exacta(q)

plot(q,ye,"b",t1,y1,"r",t2,y2,"k")
xlabel('t')
ylabel('y')
legend(['Solucion exacta ','Aproximacion por RK4','Aproximacion por RK45'])
show()


#Ahora damos los errores para cada metodo
ye1=exacta(t1)
print("El error cometido por metodo RK4 es,",max(abs(ye1-y1)))

ye2=exacta(t2)
print("El error cometido por metodo RK45 es,",max(abs(ye2-y2)))






"EJERCICIO 1 2012/2013 GRUPO B"

#Empezamos dando la funcion que define a la ecuacion diferencial
def f(t,y):
    return -y +cos(t)

#Damos la expresion de la solucion exacta, que en este caso conocemos
def exacta(t):
    return (sin(t) +cos(t) +exp(-t))/2

#Ahora damos los datos del problema de Cauchy
a=0
b= 4*pi
y0=1
N=100
h0=1.e-3
tol=1.e-8

#Ahora implementamos los metodos de RK4 y RK45

def RK4(a, b, fun, N, y0): #a y b extremos izq der del intervalo, es decir, to y tN, fun define la ecuacion diferencial que queremos resolver, la llamamos fun e vez de f para que sea programa general, yo le doy el nombre de la funcion que define la ecuacion diferencial, para aplicar a mi funcion cambio el tercer elemento que define Euler, N numero subintervalos de la particion, y0 condicion inicial
    """Implementacion del metodo de Euler en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N # paso de malla
    t = zeros(N+1) # inicializacion del vector de nodos #arrary de tiempos
    y = zeros(N+1) # inicializacion del vector de resultados #array de valores que voy obteniendo
    t[0] = a # nodo inicial #aqui ponemos condicion inicial, el tiempo inicial es a
    y[0] = y0 # valor inicial

    # Metodo de Euler #bucle del metodo, el k toma valores entre 0 y N-1
    for k in range(N):
        k1=f(t[k],y[k])
        k2=f(t[k]+h/2,y[k]+h/2*k1)
        k3=f(t[k]+h/2,y[k]+h/2 *k2)
        k4=f(t[k]+h,y[k]+h*k3)
        y[k+1] = y[k]+h/6*(k1+2*k2+2*k3+k4)
        t[k+1] = t[k]+h
    
    return (t, y) #el programa que recibe 5 datos devuelve dos arrays de tamaño N-1


def rk45(a, b, fun, y0, h0, tol): #a, b extremos de intervalos, y0 solucion que da ecuacion, h0 paso inicial 
    """Implementacion del metodo encajado RK2(3)
    en el intervalo [a, b] con condicion inicial y0,
    paso inicial h0 y tolerancia tol"""
    

    hmin = (b-a)*1.e-5 # paso de malla minimo  #paso minimo para poder llegar siempre al extremo del intervalo
    hmax = (b-a)/10. # paso de malla maximo

    
    # coeficientes RK
    q = 6 # numero de etapas
    p = 4 # orden del método menos preciso
    A = zeros([q, q]) # es la matriz de coeficientes aij del tablero de Butcher, que empieza en 0 por ser metodo explicito
    A[1, 0] = 1./4.
    A[2, 0] = 3/32.
    A[3, 0] = 1932/2197.
    A[4, 0] = 439/216.
    A[5, 0] = -8/27.
    A[2, 1] = 9/32.
    A[3, 1] = -7200/2197. 
    A[4, 1] = -8.
    A[5, 1] = 2.
    A[3, 2] = 7296/2197.
    A[4, 2] = 3680/513.
    A[5, 2] = -3544/2565.
    A[4, 3] = -845/4104.
    A[5, 3] = 1859/4104.
    A[5, 4] = -11/40.
    
    B = zeros(q) 
    B[0] = 25/216.
    B[2] = 1408/2565
    B[3] =2197/4104
    B[4] =-1/5
    
    BB = zeros(q)
    BB[0] = 16/135.
    BB[2] = 6656/12825.
    BB[3] = 28561/56430.
    BB[4] = -9/50.
    BB[5] = 2/55
    
    
    C = zeros(q)
    for i in range(q):
        C[i] = sum(A[i,:]) #los ci se calcula sumando las filas
    
    # inicializacion de variables
    t = array([a]) # nodos
    y = array([y0]) # soluciones
    h = array([h0]) # pasos de malla #guardamos la h en array, que no necesario, para poder dibujar
    K = zeros(q) #q numero de etapas
    k = 0 # contador de iteraciones #es el array que contiene los K1,K2,K3 que usa RK para avanzar
    
    while (t[k] < b): #bucle while que usa el algoritmo explicado en clase
        h[k] = min(h[k], b-t[k]) # ajuste del ultimo paso de malla
        for i in range(q):
            K[i] = fun(t[k]+C[i]*h[k], y[k]+h[k]*sum(A[i,:]*K)) #vamos rellenando las Ki
        incrlow = sum(B*K) # metodo de orden 2 #phi por funcion incremento del primer tablero
        incrhigh = sum(BB*K) # metodo de orden 3 #phi *funcion imcremento del segundo tablero
        error = h[k]*(incrhigh-incrlow) # estimacion del error
        y = append(y, y[k]+h[k]*incrlow) # y_(k+1)
        t = append(t, t[k]+h[k]); # t_(k+1) #al array le añadimos nuevo tiempo
        hnew = 0.9*h[k]*abs(tol/error)**(1./(p+1)) # h_(k+1) #p orden del metodo de menor orden
        hnew = min(max(hnew,hmin),hmax) # hmin <= h_(k+1) <= hmax #comprobacion
        h = append(h, hnew) #para añadir nuevo h a array de h
        k += 1
    #array fijo pero con la funcion append le metes algo al array
  
    return (t, y, h)


figure('Ejercicio 1 Grupo B')

(t1,y1)= RK4(a,b,f,N,y0)
(t2,y2,h)= rk45(a,b,f,y0,h0,tol)


q= linspace(a,b,N)
ye= exacta(q)

plot(q,ye,"b",t1,y1,"r",t2,y2,"k")
xlabel('t')
ylabel('y')
legend(['Solucion exacta ','Aproximacion por RK4','Aproximacion por RK45'])
show()


#Ahora damos los errores para cada metodo
ye1=exacta(t1)
print("El error cometido por metodo RK4 es,",max(abs(ye1-y1)))

ye2=exacta(t2)
print("El error cometido por metodo RK45 es,",max(abs(ye2-y2)))

