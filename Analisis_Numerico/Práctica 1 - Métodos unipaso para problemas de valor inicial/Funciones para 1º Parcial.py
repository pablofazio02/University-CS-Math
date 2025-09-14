# -*- coding: utf-8 -*-
"""
Created on Sun Feb 26 13:52:34 2023

@author: sonico22
"""


from pylab import *
from time import perf_counter #para medir cuanto tarda el metodo en converger


"El error para sistemas esta en Practica 1 Bis Ejercicio 2"
"Dibujar solucion segun diferente N, usando mesh, esta en Practica 1 Ejercicio 5"

"1. Funcion de dos variables para ecuacion"

def f(t, y): #funcion de dos variables, si fuese sistema es t tiempo y vector y
    """Funcion que define la ecuacion diferencial"""
    return 0.5*(t**2 - y)

"2. Solucion exacta de ecuacion"

def exacta(t): #en este caso tenemos la solucion exacta
    """Solucion exacta del problema de valor inicial"""
    return t**2 - 4*t + 8 - 7.*exp(-0.5*t)


"3. Metodo Euler para ecuacion"

def euler(a, b, fun, N, y0): #a y b extremos izq der del intervalo, es decir, to y tN, fun define la ecuacion diferencial que queremos resolver, la llamamos fun e vez de f para que sea programa general, yo le doy el nombre de la funcion que define la ecuacion diferencial, para aplicar a mi funcion cambio el tercer elemento que define Euler, N numero subintervalos de la particion, y0 condicion inicial
    """Implementacion del metodo de Euler en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N # paso de malla
    t = zeros(N+1) # inicializacion del vector de nodos #arrary de tiempos
    y = zeros(N+1) # inicializacion del vector de resultados #array de valores que voy obteniendo
    t[0] = a # nodo inicial #aqui ponemos condicion inicial, el tiempo inicial es a
    y[0] = y0 # valor inicial

    # Metodo de Euler #bucle del metodo, el k toma valores entre 0 y N-1
    for k in range(N):
        y[k+1] = y[k]+h*fun(t[k], y[k])
        t[k+1] = t[k]+h
    
    return (t, y) #el programa que recibe 5 datos devuelve dos arrays de tamaño N-1



"4. Metodo Punto Medio para ecuacion"

def MPM(a, b, fun, N, y0): #a y b extremos izq der del intervalo, es decir, to y tN, fun define la ecuacion diferencial que queremos resolver, la llamamos fun e vez de f para que sea programa general, yo le doy el nombre de la funcion que define la ecuacion diferencial, para aplicar a mi funcion cambio el tercer elemento que define Euler, N numero subintervalos de la particion, y0 condicion inicial
    """Implementacion del metodo de Euler en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N # paso de malla
    t = zeros(N+1) # inicializacion del vector de nodos #arrary de tiempos
    y = zeros(N+1) # inicializacion del vector de resultados #array de valores que voy obteniendo
    t[0] = a # nodo inicial #aqui ponemos condicion inicial, el tiempo inicial es a
    y[0] = y0 # valor inicial

    # Metodo de Euler #bucle del metodo, el k toma valores entre 0 y N-1
    for k in range(N):
        ykmedio= y[k] + h/2 *fun(t[k],y[k])
        y[k+1] = y[k]+h*fun(t[k]+h/2, ykmedio)
        t[k+1] = t[k]+h
    
    return (t, y) #el programa que recibe 5 datos devuelve dos arrays de tamaño N-1



"5. Metodo RK4 para ecuacion"

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
        k1=fun(t[k],y[k])
        k2=fun(t[k]+h/2,y[k]+h/2*k1)
        k3=fun(t[k]+h/2,y[k]+h/2 *k2)
        k4=fun(t[k]+h,y[k]+h*k3)
        y[k+1] = y[k]+h/6*(k1+2*k2+2*k3+k4)
        t[k+1] = t[k]+h
    
    return (t, y) #el programa que recibe 5 datos devuelve dos arrays de tamaño N-1


"6. Metodo Taylor de Orden 2 para ecuacion "

def taylor2(a,b,fun,dfun,N,y0): # dfun derivada de fun respecto de t
    h = (b-a)/N
    t = zeros(N+1)
    y = zeros(N+1)
    t[0] = a 
    y[0] = y0
    
    for k in range(N):
        y[k+1] = y[k] + h*fun(t[k],y[k]) + (h**2/2)*dfun(t[k],y[k])
        t[k+1] = t[k] + h
        
    return (t,y)



def df(t,y):
    return 0.5*(2*t-f(t,y)) # =0.5(2t-y')


"7. Metodo Taylor de Orden 3 para ecuacion "

def taylor3(a,b,fun,dfun,ddfun,N,y0):   # dfun derivada de fun respecto de t, ddfun derivada segunda de fun respecto de t
    h = (b-a)/N
    t = zeros(N+1)
    y = zeros(N+1)
    t[0] = a 
    y[0] = y0 

    for k in range(N):
        y[k+1] = y[k]+h*fun(t[k],y[k])+(h**2/2)*dfun(t[k],y[k])+(h**3/6)*ddfun(t[k],y[k])
        t[k+1] = t[k]+h
        
    return (t,y)


def ddf(t,y):
    return 0.5*(2-df(t,y)) # =(2-y'')/2


"8. Metodo de Heun (trapecio) para ecuacion "

def heun(a,b,fun,N,y0):
    h = (b-a)/N
    t = zeros(N+1)
    y = zeros(N+1)
    t[0] = a
    y[0] = y0 

    for k in range(N): 
        t[k+1] = t[k]+h
        y[k+1] = y[k]+(h/2)*(fun(t[k], y[k])+fun(t[k+1], y[k]+h*fun(t[k],y[k])))
        
    return (t, y)


"9. Sistema de dos ecuaciones"

def f(t, z):
    f1 = 0.25*z[0]-0.01*z[0]*z[1]
    f2 = -z[1]+0.01*z[0]*z[1]
    return array([f1,f2])


"10. Metodo de Euler aplicado a sistemas"

def euler_sys(a, b, fun, N, y0):
    """Implementacion del metodo de Euler en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
   
    h = (b-a)/N # paso de malla
    t = zeros(N+1) # inicializacion del vector de nodos
    y = zeros([len(y0),N+1]) # inicializacion del vector de resultados
    t[0] = a # nodo inicial
    y[:, 0] = y0 # ponemos las condiciones iniciales en la primera columna de la matriz y
    # Metodo de Euler
    for k in range(N):
        y[:, k+1] = y[:, k]+h*fun(t[k], y[:, k]) # meter en la columna k+1 el metodo de euler evaluado en la columna k
        t[k+1] = t[k]+h
   
    return (t, y)


"11. Metodo Punto Medio para sistemas"

def MPM_sys(a, b, fun, N, y0): #a y b extremos izq der del intervalo, es decir, to y tN, fun define la ecuacion diferencial que queremos resolver, la llamamos fun e vez de f para que sea programa general, yo le doy el nombre de la funcion que define la ecuacion diferencial, para aplicar a mi funcion cambio el tercer elemento que define Euler, N numero subintervalos de la particion, y0 condicion inicial
    """Implementacion del metodo de Euler en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N # paso de malla
    t = zeros(N+1) # inicializacion del vector de nodos #arrary de tiempos
    y = zeros([len(y0),N+1]) # inicializacion del vector de resultados #array de valores que voy obteniendo
    t[0] = a # nodo inicial #aqui ponemos condicion inicial, el tiempo inicial es a
    y[:,0] = y0 # valor inicial

    # Metodo de Euler #bucle del metodo, el k toma valores entre 0 y N-1
    for k in range(N):
        ykmedio= y[:,k] + h/2 *fun(t[k],y[:,k])
        y[:,k+1] = y[:,k]+h*fun(t[k]+h/2, ykmedio)
        t[k+1] = t[k]+h
    
    return (t, y) #el programa que recibe 5 datos devuelve dos arrays de tamaño N-1


"12. Metodo de Heun para sistemas "

def heun_sistemas(a,b,fun,N,y0):
    h = (b-a)/N
    t = zeros(N+1)
    y = zeros([len(y0),N+1])
    t[0] = a
    y[:,0] = y0 


    for k in range(N): 
        t[k+1] = t[k]+h
        y[:,k+1] = y[:,k]+(h/2)*(fun(t[k], y[:,k])+fun(t[k+1], y[:,k]+h*fun(t[k],y[:,k])))
    return (t, y)    


"13. Metodo RK4 para sistemas "

def rk4_sistemas(a,b,fun,N,y0):
    h = (b-a)/N
    t = zeros(N+1)
    y = zeros([len(y0),N+1])
    t[0] = a
    y[:,0] = y0 

    for k in range(N):
        t[k+1] = t[k]+h
        k1=fun(t[k],y[:,k])
        k2=fun(t[k]+h/2,y[:,k]+k1*h/2)
        k3=fun(t[k]+h/2,y[:,k]+k2*h/2)
        k4=fun(t[k+1],y[:,k]+h*k3)
        y[:,k+1] = y[:,k]+(h/6)*(k1+2*k2+2*k3+k4)
    return (t, y) 




"14. Metodo RK23 para ecuacion"

def rk23(a, b, fun, y0, h0, tol): #a, b extremos de intervalos, y0 solucion que da ecuacion, h0 paso inicial 
    """Implementacion del metodo encajado RK2(3)
    en el intervalo [a, b] con condicion inicial y0,
    paso inicial h0 y tolerancia tol"""
    

    hmin = (b-a)*1.e-5 # paso de malla minimo  #paso minimo para poder llegar siempre al extremo del intervalo
    hmax = (b-a)/10. # paso de malla maximo

    
    # coeficientes RK
    q = 3 # numero de etapas
    p = 2 # orden del método menos preciso
    A = zeros([q, q]) # es la matriz de coeficientes aij del tablero de Butcher, que empieza en 0 por ser metodo explicito
    A[1, 0] = 1./2.
    A[2, 0] = -1.
    A[2, 1] = 2.
    
    B = zeros(q) 
    B[1] = 1. #el unico no 0 es el dos (que se corresponde con indice 1)
    
    BB = zeros(q)
    BB[0] = 1./6.
    BB[1] = 2./3.
    BB[2] = 1./6.
    
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

"15. Metodo RK45 para ecuacion"

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


"16. Metodo RK23 para sistema"


def rk23_sistemas(a, b, fun, y0, h0, tol): #a, b extremos de intervalos, y0 solucion que da ecuacion, h0 paso inicial 
    """Implementacion del metodo encajado RK2(3)
    en el intervalo [a, b] con condicion inicial y0,
    paso inicial h0 y tolerancia tol"""
    

    hmin = (b-a)*1.e-5 # paso de malla minimo  #paso minimo para poder llegar siempre al extremo del intervalo
    hmax = (b-a)/10. # paso de malla maximo

    
    # coeficientes RK
    q = 3 # numero de etapas
    p = 2 # orden del método menos preciso
    A = zeros([q, q]) # es la matriz de coeficientes aij del tablero de Butcher, que empieza en 0 por ser metodo explicito
    A[1, 0] = 1./2.
    A[2, 0] = -1.
    A[2, 1] = 2.
    
    B = zeros(q) 
    B[1] = 1. 
    
    BB = zeros(q)
    BB[0] = 1./6.
    BB[1] = 2./3.
    BB[2] = 1./6.
    
    C = zeros(q)
    for i in range(q):
        C[i] = sum(A[i,:]) 
    
    # inicializacion de variables
    t = array([a]) # nodos
    y = zeros([len(y0),1]) #ARRAY CON TANTAS FILAS COMO COMPONENTE INICIAL
    #y = y0.reshape(len(y0),1)
    y[:,0] = y0 # ESTO CAMBIA, NO SIRVE ARRAY NORMAL, NECESITO ARRAY DE DOS INDICES, UNO PARA COMPONENTES DE ECUACION Y OTRO PARA EL TIEMPO, CADA APROXIMACION N COMPONENTES. MATRIZ NXN
    h = array([h0]) # pasos de malla 
    K = zeros([len(y0),q]) #LO QUE CAMBIAMOS
    k = 0 # contador de iteraciones #LA K CAMBIA, METODO RK NECESITA MATRIZ N FILAS Y q COMPONENTES
    
    while (t[k] < b): #bucle while que usa el algoritmo explicado en clase
        h[k] = min(h[k], b-t[k]) # ajuste del ultimo paso de malla
        for i in range(q):
            K[:,i] = fun(t[k]+C[i]*h[k], y[:,k]+h[k]*dot(A[i,:],transpose(K))) #vamos rellenando las Ki
        incrlow = dot(B,transpose(K)) # metodo de orden 2 #phi por funcion incremento del primer tablero #CAMBIAMOS
        incrhigh = dot(BB,transpose(K)) # metodo de orden 3 #phi *funcion imcremento del segundo tablero #CAMBIAMOS
        error = max(abs(h[k]*(incrhigh-incrlow))) # norma infinito de la estimacion, MAXIMO NORMA INFINITO DEL ERROR
        y = column_stack((y, y[:,k]+h[k]*incrlow)) # y_(k+1) #CAMBIA, PARA INTRODUCIR COLUMNA AL ARRAY, DOS PARENTESIS PORQUE COLUMN STACK TIENE COMO ARGUMENTO UNA TUPLA
        t = append(t, t[k]+h[k]); # t_(k+1) #al array le añadimos nuevo tiempo
        hnew = 0.9*h[k]*abs(tol/error)**(1./(p+1)) # h_(k+1) #p orden del metodo de menor orden
        hnew = min(max(hnew,hmin),hmax) # hmin <= h_(k+1) <= hmax #comprobacion
        h = append(h, hnew) #para añadir nuevo h a array de h
        k += 1
    #array fijo pero con la funcion append le metes algo al array
  
    return (t, y, h)

"17. Metodo RK45 para sistema"

def rk45_sistemas(a, b, fun, y0, h0, tol): #a, b extremos de intervalos, y0 solucion que da ecuacion, h0 paso inicial 
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
    y = zeros([len(y0),1]) #ARRAY CON TANTAS FILAS COMO COMPONENTE INICIAL
    #y = y0.reshape(len(y0),1)
    y[:,0] = y0 # ESTO CAMBIA, NO SIRVE ARRAY NORMAL, NECESITO ARRAY DE DOS INDICES, UNO PARA COMPONENTES DE ECUACION Y OTRO PARA EL TIEMPO, CADA APROXIMACION N COMPONENTES. MATRIZ NXN
    h = array([h0]) # pasos de malla 
    K = zeros([len(y0),q]) #LO QUE CAMBIAMOS
    k = 0 # contador de iteraciones #LA K CAMBIA, METODO RK NECESITA MATRIZ N FILAS Y q COMPONENTES
    
    while (t[k] < b): #bucle while que usa el algoritmo explicado en clase
        h[k] = min(h[k], b-t[k]) # ajuste del ultimo paso de malla
        for i in range(q):
            K[:,i] = fun(t[k]+C[i]*h[k], y[:,k]+h[k]*dot(A[i,:],transpose(K))) #vamos rellenando las Ki
        incrlow = dot(B,transpose(K)) # metodo de orden 2 #phi por funcion incremento del primer tablero #CAMBIAMOS
        incrhigh = dot(BB,transpose(K)) # metodo de orden 3 #phi *funcion imcremento del segundo tablero #CAMBIAMOS
        error = max(abs(h[k]*(incrhigh-incrlow))) # norma infinito de la estimacion, MAXIMO NORMA INFINITO DEL ERROR
        y = column_stack((y, y[:,k]+h[k]*incrlow)) # y_(k+1) #CAMBIA, PARA INTRODUCIR COLUMNA AL ARRAY, DOS PARENTESIS PORQUE COLUMN STACK TIENE COMO ARGUMENTO UNA TUPLA
        t = append(t, t[k]+h[k]); # t_(k+1) #al array le añadimos nuevo tiempo
        hnew = 0.9*h[k]*abs(tol/error)**(1./(p+1)) # h_(k+1) #p orden del metodo de menor orden
        hnew = min(max(hnew,hmin),hmax) # hmin <= h_(k+1) <= hmax #comprobacion
        h = append(h, hnew) #para añadir nuevo h a array de h
        k += 1
    #array fijo pero con la funcion append le metes algo al array
  
    return (t, y, h)




"18. Dar orden del metodo segun diferentes N, y el cociente errores eN/e2N"

mesh= [10,20,40,80,160]
for N  in mesh:
    
    tini = perf_counter()
    
    (t,y)= euler(a,b,deposito,N,y0)
    tfin= perf_counter()
    ye= exacta(t)
    error = max(abs(y-ye))
    plot(t, y, '-*')
    print('----')
    print('Tiempo CPU: ' + str(tfin-tini))
    print('Error: ' + str(error))
    if N != mesh[0]: #no es igual
         cerror =errorold/error
         print('cociente de errores:'+str(cerror))
         
    #resultados
    print('Paso de malla:' +str((b-a)/N))    
    print('----')
    errorold = error
   #el dibujo de la exacta se puede dibujar fuera del bucle ya que siempre es la misma 
xlabel('t')
ylabel('y')
plot(t,ye,'k')
leyenda= ['Euler,N='+str(N) for N in mesh]
leyenda.append('Exacta') #a la lista que he creado antes le añado la exacta
legend(leyenda)
grid(True)
#for N in mesh:
  #  leyenda = ['Euler','N='+str(N)]
#leyenda.append('Exacta')
grid(True)  



"19. Comparar en misma grafica las trayectorias obtenidas "
subplot(211)
plot(t, y[0], t, y[1])
legend(['Presas', 'Depredadores'])
subplot(212)
plot(y[0], y[1])
legend('Trayectoria')


"20. Comparar en misma grafica solucion exacta con aproximaciones obtenidas con un mismo metodo usando distintos pasos de tiempo"
mesh= [20,40,80,160,320,640]

for N in mesh:
    (t,y) = euler_sys(a,b,f,N,y0)
    plot(t,y[0])


ye = exacta(t) # calculo de la solucion exacta
xlabel('t')
ylabel('y')
plot(t,ye,'k')
leyenda = ['Euler, N ='+str(N) for N in mesh]
leyenda.append('Exacta') # a la lista que he creado de leyenda le añade la última exacta
ylim(-1, 1) # para establecer el rango de la y
legend(leyenda)
grid(True)


"21. Dar error en un sistema"

errorEuler = zeros(len(y))
for k in range(len(y)):
    errorEuler[k] = max(abs(y[k] -ye[k]))
    
print(errorEuler)




"22.Crear metodo para una acuacion:"
#Es solo cambiar en la expresion de y[k+1] o t[k+1] y si hay pasos intermedios ponerlos arriba sin corchetes, por ejemplo ykmedios

def modificacion(a, b, fun, N, y0): #a y b extremos izq der del intervalo, es decir, to y tN, fun define la ecuacion diferencial que queremos resolver, la llamamos fun e vez de f para que sea programa general, yo le doy el nombre de la funcion que define la ecuacion diferencial, para aplicar a mi funcion cambio el tercer elemento que define Euler, N numero subintervalos de la particion, y0 condicion inicial
    """Implementacion del metodo de Euler en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N # paso de malla
    t = zeros(N+1) # inicializacion del vector de nodos #arrary de tiempos
    y = zeros(N+1) # inicializacion del vector de resultados #array de valores que voy obteniendo
    t[0] = a # nodo inicial #aqui ponemos condicion inicial, el tiempo inicial es a
    y[0] = y0 # valor inicial

    # Metodo de Euler #bucle del metodo, el k toma valores entre 0 y N-1
    for k in range(N):
        y[k+1] = "AQUI"
        t[k+1] = "AQUI"
        
        
        
"23Crear metodo para sistema"
#en Y0 zeros... ahora es un corchete, y poner primero len(y0)
#a todos los y[k+1] los cambiamos a y[:,k+1]
def euler_sys(a, b, fun, N, y0):
    """Implementacion del metodo de Euler en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
   
    h = (b-a)/N # paso de malla
    t = zeros(N+1) # inicializacion del vector de nodos
    y = zeros([len(y0)"AQUI",N+1]) # inicializacion del vector de resultados
    t[0] = a # nodo inicial
    y[:, 0] = y0 # ponemos las condiciones iniciales en la primera columna de la matriz y
    # Metodo de Euler
    for k in range(N):
        "AQUI"y[:, k+1] = y[:, k]+h*fun(t[k], y[:, k]) # meter en la columna k+1 el metodo de euler evaluado en la columna k
        t[k+1] = t[k]+h
   
    return (t, y)


"24. Crear metodo RK encajado"
#tener en cuenta que el numero de etapas es el de metodo de mayor orden
#La tabla es                 orden:   1  2  3  4  5  6  7  8
#nmenor numero de etapas necesario:   1  2  3  4  6  7  9  11
#Poner la matriz A
#En B va el vector del metodo de menor orden
#En BB va el vector del metodo de mayor orden

def rk23_sistemas(a, b, fun, y0, h0, tol): #a, b extremos de intervalos, y0 solucion que da ecuacion, h0 paso inicial 
    """Implementacion del metodo encajado RK2(3)
    en el intervalo [a, b] con condicion inicial y0,
    paso inicial h0 y tolerancia tol"""
    

    hmin = (b-a)*1.e-5 # paso de malla minimo  #paso minimo para poder llegar siempre al extremo del intervalo
    hmax = (b-a)/10. # paso de malla maximo

    
    # coeficientes RK
    q = "AQUI" # numero de etapas
    p = "AQUI" # orden del método menos preciso
    A = zeros([q, q]) # es la matriz de coeficientes aij del tablero de Butcher, que empieza en 0 por ser metodo explicito
    A[1, 0] = 1./2.
    A[2, 0] = -1.
    A[2, 1] = 2.
    "AQUI MATRIZ A"
    
    B = zeros(q) 
    B[1] = 1. 
    "AQUI VECTOR B DE METODO DE MENOR ORDEN"
    
    BB = zeros(q)
    BB[0] = 1./6.
    BB[1] = 2./3.
    BB[2] = 1./6.
    "AQUI VECTOR B DE METODO DE MAYOR ORDEN"
    
    C = zeros(q)
    for i in range(q):
        C[i] = sum(A[i,:]) 
    
    # inicializacion de variables
    t = array([a]) # nodos
    y = zeros([len(y0),1]) #ARRAY CON TANTAS FILAS COMO COMPONENTE INICIAL
    #y = y0.reshape(len(y0),1)
    y[:,0] = y0 # ESTO CAMBIA, NO SIRVE ARRAY NORMAL, NECESITO ARRAY DE DOS INDICES, UNO PARA COMPONENTES DE ECUACION Y OTRO PARA EL TIEMPO, CADA APROXIMACION N COMPONENTES. MATRIZ NXN
    h = array([h0]) # pasos de malla 
    K = zeros([len(y0),q]) #LO QUE CAMBIAMOS
    k = 0 # contador de iteraciones #LA K CAMBIA, METODO RK NECESITA MATRIZ N FILAS Y q COMPONENTES
    
    while (t[k] < b): #bucle while que usa el algoritmo explicado en clase
        h[k] = min(h[k], b-t[k]) # ajuste del ultimo paso de malla
        for i in range(q):
            K[:,i] = fun(t[k]+C[i]*h[k], y[:,k]+h[k]*dot(A[i,:],transpose(K))) #vamos rellenando las Ki
        incrlow = dot(B,transpose(K)) # metodo de orden 2 #phi por funcion incremento del primer tablero #CAMBIAMOS
        incrhigh = dot(BB,transpose(K)) # metodo de orden 3 #phi *funcion imcremento del segundo tablero #CAMBIAMOS
        error = max(abs(h[k]*(incrhigh-incrlow))) # norma infinito de la estimacion, MAXIMO NORMA INFINITO DEL ERROR
        y = column_stack((y, y[:,k]+h[k]*incrlow)) # y_(k+1) #CAMBIA, PARA INTRODUCIR COLUMNA AL ARRAY, DOS PARENTESIS PORQUE COLUMN STACK TIENE COMO ARGUMENTO UNA TUPLA
        t = append(t, t[k]+h[k]); # t_(k+1) #al array le añadimos nuevo tiempo
        hnew = 0.9*h[k]*abs(tol/error)**(1./(p+1)) # h_(k+1) #p orden del metodo de menor orden
        hnew = min(max(hnew,hmin),hmax) # hmin <= h_(k+1) <= hmax #comprobacion
        h = append(h, hnew) #para añadir nuevo h a array de h
        k += 1
    #array fijo pero con la funcion append le metes algo al array
  
    return (t, y, h)



"25. Uso de subplots"
#poniendo 211, 21 es el tamaño de la matriz, que es 2x1, y el tercer digito llena el hueco, 211 se queda el primer hueco y 212 se queda el segundo hueco
#con 311, 312, 313 se llenan los tres huecos respectivamente

"26. Separar graficas"
#Poner figure() entre los plots

"27. Plano de fases, orbita, trayectoria"
#Plot(y[0],y[1]) normalmente es circular, y en caso de cohete linea recta vertical

"28. Orden de un metodo"
#En el cociente de errores, que esta hecho en Practica 1 Ejercicio 1, sale un numero 2^p. p es el orden del metodo. En caso de que no obtengamos algo asi, el metodo es muy inestable

"29. Comentarios sobre la grafica de los pasos"
#Comentar si se usan pasos mas pequeños por ejemplo. Cuando solucion numerica oscila mas se usan pasos mas pequeños y cuando la solucion oscila menos se usan pasos mas grandes. Si la solucion es periodica, la h es periodica

"30. Pregunta parcial: Comparar el metodo RK45 con lo que daria el metodo de orden par(el mas bajo) con paso constante"
#En RK45 quitar las lineas donde calculas el h y quitar BB. (El h se calcula con (b-a)/N). Es solo quitar lineas del programa

"31. Metodo RK12 para sistemas"

def rk12_sistemas(a, b, fun, y0, h0, tol): #a, b extremos de intervalos, y0 solucion que da ecuacion, h0 paso inicial 
    """Implementacion del metodo encajado RK2(3)
    en el intervalo [a, b] con condicion inicial y0,
    paso inicial h0 y tolerancia tol"""
    

    hmin = 1.e-5 # paso de malla minimo  #paso minimo para poder llegar siempre al extremo del intervalo
    hmax = 0.1 # paso de malla maximo

    
    # coeficientes RK
    q = 2 # numero de etapas
    p = 1 # orden del método menos preciso
    A = zeros([q, q]) # es la matriz de coeficientes aij del tablero de Butcher, que empieza en 0 por ser metodo explicito
    A[1, 0] = 1./2.
   
    
    B = zeros(q) 
    B[0] = 1. 
    
    BB = zeros(q)
    BB[1] = 1.
  
    
    C = zeros(q)
    for i in range(q):
        C[i] = sum(A[i,:]) 
    
    # inicializacion de variables
    t = array([a]) # nodos
    y = zeros([len(y0),1]) #ARRAY CON TANTAS FILAS COMO COMPONENTE INICIAL
    #y = y0.reshape(len(y0),1)
    y[:,0] = y0 # ESTO CAMBIA, NO SIRVE ARRAY NORMAL, NECESITO ARRAY DE DOS INDICES, UNO PARA COMPONENTES DE ECUACION Y OTRO PARA EL TIEMPO, CADA APROXIMACION N COMPONENTES. MATRIZ NXN
    h = array([h0]) # pasos de malla 
    K = zeros([len(y0),q]) #LO QUE CAMBIAMOS
    k = 0 # contador de iteraciones #LA K CAMBIA, METODO RK NECESITA MATRIZ N FILAS Y q COMPONENTES
    
    while (t[k] < b): #bucle while que usa el algoritmo explicado en clase
        h[k] = min(h[k], b-t[k]) # ajuste del ultimo paso de malla
        for i in range(q):
            K[:,i] = fun(t[k]+C[i]*h[k], y[:,k]+h[k]*dot(A[i,:],transpose(K))) #vamos rellenando las Ki
        incrlow = dot(B,transpose(K)) # metodo de orden 2 #phi por funcion incremento del primer tablero #CAMBIAMOS
        incrhigh = dot(BB,transpose(K)) # metodo de orden 3 #phi *funcion imcremento del segundo tablero #CAMBIAMOS
        error = max(abs(h[k]*(incrhigh-incrlow))) # norma infinito de la estimacion, MAXIMO NORMA INFINITO DEL ERROR
        y = column_stack((y, y[:,k]+h[k]*incrlow)) # y_(k+1) #CAMBIA, PARA INTRODUCIR COLUMNA AL ARRAY, DOS PARENTESIS PORQUE COLUMN STACK TIENE COMO ARGUMENTO UNA TUPLA
        t = append(t, t[k]+h[k]); # t_(k+1) #al array le añadimos nuevo tiempo
        hnew = 0.9*h[k]*abs(tol/error)**(1./(p+1)) # h_(k+1) #p orden del metodo de menor orden
        hnew = min(max(hnew,hmin),hmax) # hmin <= h_(k+1) <= hmax #comprobacion
        h = append(h, hnew) #para añadir nuevo h a array de h
        k += 1
    #array fijo pero con la funcion append le metes algo al array
  
    return (t, y, h)




"32."
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




"33. Metodo RK4 con tablero de Butcher (es decir, sin pendientes como el que hay programado"
def butcherRK4():
    q = 4 # numero de etapas
    A = zeros([q, q])
    A[1, 0] = 1./2.
    A[2, 1] = 1./2.
    A[3, 2] = 1.
    B = zeros(q) # fila de abajo del tablero de Butcher para el metodo de orden 2
    B[0] = 1./6.
    B[1] = 1./3.
    B[2] = 1./3.
    B[3] = 1./6.
    C = zeros(q) # columna de la derecha de la tabla
    for i in range(q):
        C[i] = sum(A[i,:])
    
    return (A,B,C)


def rk4(a, b, fun, N, y0): 
    
    q = 4
    
    (A,B,C) = butcherRK4()
    
    h = (b-a)/N # pasos de malla
    t = zeros(N+1)
    t[0] = a
    y = zeros(N+1)
    y[0] = y0
    
    K = zeros(q)
    for k in range(N):
        for i in range(q):
            K[i] = fun(t[k]+C[i]*h, y[k]+h*sum(A[i,:]*K)) # fórmula del método de RK
        y[k+1] = y[k]+h*sum(B*K) # se añade al vector de aproximaciones el y_(k+1)
        t[k+1] = t[k]+h # se añade al vector de tiempos el t_(k+1)
    return (t, y)

def rk4_sistemas(a,b,fun,N,y0):
    
    q = 4
    
    (A,B,C) = butcherRK4()
    
    h = (b-a)/N
    t = zeros(N+1)
    y = zeros([len(y0),N+1])
    t[0] = a # nodo inicial
    y[:,0] = y0 # valor inicial
    
    K = zeros([len(y0),q])
    for k in range(N):
        for i in range(q):
            K[:,i] = fun(t[k]+C[i]*h, y[:,k]+h*dot(A[i,:],transpose(K)))
        t[k+1] = t[k]+h
        y[:,k+1] = y[:,k]+h*dot(B,transpose(K))
    return