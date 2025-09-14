# -- coding: utf-8 --
"""
Created on Fri Apr 26 12:25:18 2024

@author: Pablo Fazio Arrabal

Práctica 2 - Métodos multipaso lineales

"""

from pylab import *
from time import perf_counter

'''
def ejecutarMetodo(y0, a, b, N, nombre_grafico, metodo, fun, exacta, dfy, es_newton):
    
    figure(nombre_grafico)
    tini = perf_counter()
    if es_newton:
        (t,y, maxiter) = metodo(a,b,fun, N,y0, dfy)
    else:
        (t,y, maxiter) = metodo(a,b,fun, N,y0)
    tfin = perf_counter()
    ye = exacta(t)
    plot(t,y)
    h = (b - a)/float(N)
    errorAntiguo = max(abs(y-ye))
    tcpu = tfin-tini
    print('---------------')
    print('h = '+ str(h))
    print('Error = '+str(errorAntiguo))
    print('Tiempo CPU = '+str(tcpu))
    print('Número máximo de iteraciones = '+ str(maxiter))
    print('---------------')


    """
    Nueva formula para el orden, orden = ( log(e(h)) - log(e(h/k)) )/( log(k) ) 
    """

    Ns = [20, 40, 80, 160]

    for N in Ns:
        
        tini = perf_counter()
        if es_newton:
            (t,y, maxiter) = metodo(a,b,fun, N,y0, dfy)
        else:
            (t,y, maxiter) = metodo(a,b,fun, N,y0)
        tfin = perf_counter()
        ye = exacta(t)
        plot(t,y)
        h = (b - a)/float(N)
        errorNuevo = max(abs(y-ye))
        tcpu = tfin-tini
        print('---------------')
        print('h = '+ str(h))
        print('Error = '+str(errorNuevo))
        print('Tiempo CPU = '+str(tcpu))
        print('Número máximo de iteraciones = '+ str(maxiter))
        print('---------------')
        orden = (log(errorAntiguo) - log(errorNuevo))/log(2)
        print("Orden aproximado =>", orden)
        print('\n')
        errorAntiguo = errorNuevo
        
    plot(t,ye)
    show()
'''

print('Ejercicio 1\n')

def fun(t,y):
    return -y+exp(-t)*cos(t);

def exacta(t):
    return exp(-t)*sin(t);

# Método de Adams-Bashforth de 2 pasos

def AB2(a,b,fun, N,y0):
    
    y = zeros(N+1)
    t = zeros(N+1)
    f = zeros(N+1)
    
    t[0] = a
    h = (b-a)/float(N)
    
    y[0] = y0
    f[0] = fun(a,y[0])    
    
    y[1] = y[0] + h*f[0]
    t[1] = a+h
    f[1] = fun(t[1], y[1])
    
    for k in range(1,N):
    
        y[k+1] = y[k]+0.5*h*(3.0*f[k] - f[k-1])
        t[k+1] = t[k] + h
        f[k+1] = fun(t[k+1], y[k+1])
        
    return (t,y)

# Datos del problema
y0 = 0.0
a = 0.0
b = 5.0
N = 30

tini = perf_counter()

(t,y) = AB2(a,b, fun, N,y0)

tfin = perf_counter()

figure ('Método AB2 - Prueba')

ye = exacta(t)
plot(t, y)
plot(t, ye, 'orange')
xlabel('t')
ylabel('y')
legend(['Aproximación', 'Exacta'])

h = (b - a)/float(N)
err = max(abs(y-ye))

print('Prueba para N = 30 de AB2')
print('---------------')
print('h = '+ str(h))
print('Error = ' + str(err))
print('Tiempo CPU = '+ str(tfin-tini))
print('---------------\n')
show()

"""

Nueva fórmula para el orden, 

orden = (log(e(h)) - log(e(h/k)))/(log(k)) 

"""

print('Apartado a)\n')

# Datos del problema
y0 = 0.0
a = 0.0
b = 5.0
ns = [20, 40, 80, 160]
i = 0

figure ('Metodo AB2 - Apartado a)')

for N in ns:
    
    tini = perf_counter()
    
    (t,y) = AB2(a,b,fun,N,y0)
    
    tfin = perf_counter()
    
    ye = exacta(t)
    plot(t,y)
    h = (b - a)/float(N)
    errorNuevo = max(abs(y-ye))
    
    tcpu = tfin-tini
    print('---------------')
    print('h = '+ str(h))
    print('Error = '+str(errorNuevo))
    print('Tiempo CPU = '+str(tcpu))
    if(i>0):
        orden = (log(errorAntiguo) - log(errorNuevo))/log(2)
        print("Orden aproximado =>", orden)
    print('---------------\n')
    
    errorAntiguo = errorNuevo
    i = i + 1
    
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
leyenda=['N = ' + str(N) for N in ns]
leyenda.append('exacta')
legend(leyenda)
show()

''' Luego el orden aproximado del método AB2 converge hacia 2 '''

print('Apartado b)\n')

# Método de Adams-Bashforth de 3 pasos

def AB3(a,b,fun, N,y0):
    
    y = zeros(N+1)
    t = zeros(N+1)
    f = zeros(N+1)
    
    t[0] = a
    h = (b-a)/float(N)
    
    y[0] = y0
    f[0] = fun(a,y[0])
    
    # Se usa el método de Heun (podría ser otro cualquiera de orden 2) para arrancar
    
    y[1] = y[0] + (h/2)*(fun(t[0],y[0]) + fun(t[0] + h, y[0] + h*fun(t[0], y[0])))
    t[1] = a+h
    f[1] = fun(t[1], y[1])
    
    y[2] = y[1] + (h/2)*(fun(t[1],y[1]) + fun(t[1] + h, y[1] + h*fun(t[1], y[1])))
    t[2] = a +2*h
    f[2] = fun(t[2], y[2])
    
    for k in range(2,N):
    
        y[k+1] = y[k] + (h/12)*(23*f[k] - 16*f[k-1] + 5*f[k-2])
        t[k+1] = t[k] + h
        f[k+1] = fun(t[k+1], y[k+1])
        
    return (t,y)

# Datos del problema
y0 = 0.0
a = 0.0
b = 5.0
N = 30

figure('Metodo AB3 - Prueba')

tini = perf_counter()
(t,y) = AB3(a,b,fun, N,y0)
tfin = perf_counter()

ye = exacta(t)
plot(t, y)
plot(t, ye, 'orange')
xlabel('t')
ylabel('y')
legend(['Aproximación', 'Exacta'])

h = (b - a)/float(N)
err = max(abs(y-ye))
tcpu = tfin-tini

print('Prueba para N = 30 de AB3')
print('---------------')
print('h = '+ str(h))
print('Error = '+str(err))
print('Tiempo CPU = '+str(tcpu))
print('---------------\n')

show()

# Datos del problema
y0 = 0.0
a = 0.0
b = 5.0
ns = [20, 40, 80, 160]
i = 0

figure('Metodo AB3 - Apartado b)')

for N in ns:
    
    tini = perf_counter()
    (t,y) = AB3(a,b,fun, N,y0)
    tfin = perf_counter()
    
    ye = exacta(t)
    plot(t,y)
    h = (b - a)/float(N)
    errorNuevo = max(abs(y-ye))
    tcpu = tfin-tini
    
    print('---------------')
    print('h = '+ str(h))
    print('Error = '+str(errorNuevo))
    print('Tiempo CPU = '+str(tcpu))
    if(i>0):
        orden = (log(errorAntiguo) - log(errorNuevo))/log(2)
        print("Orden aproximado =>", orden)
    print('---------------\n')
    
    errorAntiguo = errorNuevo
    i = i + 1
    
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
leyenda=['N = ' + str(N) for N in ns]
leyenda.append('exacta')
legend(leyenda)
show()

''' Luego el orden aproximado del método AB3 converge hacia 3 '''

print("Apartado c)\n")

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
y0 = 0.0
a = 0.0
b = 5.0
N = 3000

t_ini = perf_counter()
(t,y) = heun(a,b,fun, N, y0)
t_fin = perf_counter()

t_heun = t_fin-t_ini

t_ini = perf_counter()
(t,y) = AB3(a,b,fun, N, y0)
t_fin = perf_counter()

t_AB3 = t_fin-t_ini

print("Tiempo de ejecución Heun, N =", N, "=>", t_heun)
print("Tiempo de ejecución AB3, N =", N, "=>", t_AB3)

'''
Comparando el coste del método unipaso (Heun) y multipaso (AB3)
podemos ver que: el método multipaso es el doble de rápido aproximadamente.
'''

print("\nEjercicio 2\n")

# Método de Adams-Moulton de 3 pasos para una funcion especifica

def AM3(a,b,fun, N,y0):
    
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
    
        t[k+1] = t[k] + h
        Ck = y[k] + (h/24)*(19*f[k] - 5*f[k-1] + f[k-2])
        y[k+1] = ((9*h/24)*exp(-t[k+1])*cos(t[k+1])+ Ck)/(1 + (9*h)/24)
        f[k+1] = fun(t[k+1], y[k+1])
        
    return (t,y)

print ('Apartado a)\n')

# Datos del problema
y0 = 0.0
a = 0.0
b = 5.0
N = 30

figure('AM3 - Prueba')

tini = perf_counter()
(t,y) = AM3(a,b,fun, N,y0)
tfin = perf_counter()
ye = exacta(t)
plot(t,y)
plot(t,ye)
xlabel('t')
ylabel('y')
legend(['Aproximación', 'Exacta'])


h = (b - a)/float(N)
errorAntiguo = max(abs(y-ye))
tcpu = tfin-tini
print('Prueba para N = 30 de AM3 especifico')
print('---------------')
print('h = '+ str(h))
print('Error = '+str(errorAntiguo))
print('Tiempo CPU = '+str(tcpu))
print('---------------\n')
show()

# Datos del problema
y0 = 0.0
a = 0.0
b = 5.0
ns = [20, 40, 80, 160]
i = 0

figure('AM3 - Apartado a)')

for N in ns:
    
    tini = perf_counter()
    (t,y) = AM3(a,b,fun, N,y0)
    tfin = perf_counter()
    ye = exacta(t)
    plot(t,y)
    h = (b - a)/float(N)
    errorNuevo = max(abs(y-ye))
    tcpu = tfin-tini
    print('---------------')
    print('h = '+ str(h))
    print('Error = '+str(errorNuevo))
    print('Tiempo CPU = '+str(tcpu))
    if(i>0):
        orden = (log(errorAntiguo) - log(errorNuevo))/log(2)
        print("Orden aproximado =>", orden)
    print('---------------\n')
    
    errorAntiguo = errorNuevo
    i = i + 1
    
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
leyenda=['N = ' + str(N) for N in ns]
leyenda.append('exacta')
legend(leyenda)
show()

print('Apartado b)\n')

# Método de Adams-Moulton de 3 pasos general

def AM3General(a,b,fun, N,y0):
    
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
        zAntiguo = y[k]
        zNuevo = y[k]
        error = 1
        cont = 0
        
        while error >= 1e-12 and cont < 200:
            
            zNuevo = h*(9/24)*fun(t[k+1], zAntiguo) + Ck
            error = abs(zNuevo-zAntiguo)
            zAntiguo = zNuevo
            cont = cont + 1
        
        if(cont >= 200):
            print("El método de punto fijo no ha convergido")
        
        maxiter = max(cont, maxiter)
        
        y[k+1] = zNuevo
        
        f[k+1] = fun(t[k+1], y[k+1])
        
    return (t,y, maxiter)

# Datos del problema
y0 = 0.0
a = 0.0
b = 5.0
N = 30

figure('AM3 - Prueba')

tini = perf_counter()
(t,y, maxiter) = AM3General(a,b,fun, N,y0)
tfin = perf_counter()

ye = exacta(t)
plot(t,y)
plot(t,ye)
xlabel('t')
ylabel('y')
legend(['Aproximación', 'Exacta'])

h = (b - a)/float(N)
errorAntiguo = max(abs(y-ye))
tcpu = tfin-tini

print('Prueba para N = 30 de AM3 general')
print('---------------')
print('h = '+ str(h))
print('Error = '+str(errorAntiguo))
print('Tiempo CPU = '+str(tcpu))
print('Número máximo de iteraciones = '+ str(maxiter))
print('---------------\n')
show()

# Datos del problema
y0 = 0.0
a = 0.0
b = 5.0
ns = [20, 40, 80, 160]
i = 0

figure('AM3 General - Apartado b)')

for N in ns:
    
    tini = perf_counter()
    (t,y, maxiter) = AM3General(a,b,fun, N,y0)
    tfin = perf_counter()
    
    ye = exacta(t)
    plot(t,y)
    
    h = (b - a)/float(N)
    errorNuevo = max(abs(y-ye))
    tcpu = tfin-tini
    print('---------------')
    print('h = '+ str(h))
    print('Error = '+str(errorNuevo))
    print('Tiempo CPU = '+str(tcpu))
    print('Número máximo de iteraciones = '+ str(maxiter))
    if(i>0):
        orden = (log(errorAntiguo) - log(errorNuevo))/log(2)
        print("Orden aproximado =>", orden)
    print('---------------\n')
    
    errorAntiguo = errorNuevo
    i = i + 1
    
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
leyenda=['N = ' + str(N) for N in ns]
leyenda.append('exacta')
legend(leyenda)
show()

''' Tiene orden convergente a 4 el método de AM3 General '''

print("Apartado c)\n")

# Método de Adams-Moulton de 3 pasos general usando método de Newton

def AM3GeneralNewton(a,b,fun, N,y0, dfy):
    
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
        zAntiguo = y[k]
        zNuevo = y[k]
        error = 1
        cont = 0
        
        while error >= 1e-12 and cont != 200:
            
            #z - (9h/24)f(tk+1,z)-Ck
            
            Fk = zAntiguo - (9/24)*h*fun(t[k+1], zAntiguo) - Ck
            dFk = 1 - (9/24)*h*dfy(t[k+1], zAntiguo)
            zNuevo = zAntiguo - (Fk/dFk)
            error = abs(zNuevo-zAntiguo)
            zAntiguo = zNuevo
            cont = cont + 1
        
        if(cont == 200):
            print("El método de punto fijo no ha convergido")
        
        maxiter = max(cont, maxiter)
        
        y[k+1] = zNuevo
        f[k+1] = fun(t[k+1], y[k+1])
        
    return (t,y, maxiter)

def dfy(t,y):
    return -1

# Datos del problema
y0 = 0.0
a = 0.0
b = 5.0
N = 30

figure('AM3 General Newton - Prueba')

tini = perf_counter()
(t,y, maxiter) = AM3GeneralNewton(a,b,fun,N,y0,dfy)
tfin = perf_counter()

ye = exacta(t)
plot(t,y)
plot(t,ye)
xlabel('t')
ylabel('y')
legend(['Aproximación', 'Exacta'])

h = (b - a)/float(N)
errorAntiguo = max(abs(y-ye))
tcpu = tfin-tini

print('Prueba para N = 30 de AM3 general usando Newton')
print('---------------')
print('h = '+ str(h))
print('Error = '+str(errorAntiguo))
print('Tiempo CPU = '+str(tcpu))
print('Número máximo de iteraciones = '+ str(maxiter))
print('---------------\n')
show()


"""
Nueva formula para el orden, orden = ( log(e(h)) - log(e(h/k)) )/( log(k) ) 
"""

# Datos del problema
y0 = 0.0
a = 0.0
b = 5.0
ns = [20, 40, 80, 160]
i = 0

figure('AM3 General Newton - Apartado c)')

for N in ns:
    
    tini = perf_counter()
    (t,y, maxiter) = AM3GeneralNewton(a,b,fun, N,y0, dfy)
    tfin = perf_counter()
    
    ye = exacta(t)
    plot(t,y)
    
    h = (b - a)/float(N)
    errorNuevo = max(abs(y-ye))
    tcpu = tfin-tini
    print('---------------')
    print('h = '+ str(h))
    print('Error = '+str(errorNuevo))
    print('Tiempo CPU = '+str(tcpu))
    print('Número máximo de iteraciones = '+ str(maxiter))
    if(i>0):
        orden = (log(errorAntiguo) - log(errorNuevo))/log(2)
        print("Orden aproximado =>", orden)
    print('---------------\n')
    
    errorAntiguo = errorNuevo
    i = i + 1
    
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
leyenda=['N = ' + str(N) for N in ns]
leyenda.append('exacta')
legend(leyenda)
show()

print("El método de Newton está resolviendo una ecuación lineal, la resuelve en una iteracion, la segunda iteración es para verificar que la iteración nueva es igual que la antigua.")


print("\nApartado d)\n")

def fun(t,y):
    return 1 + y**2

def dfy(t,y):
    return 2*y

def exacta(t):
    return tan(t)

print("Solución mediante AM3 General\n")

# Datos del problema
y0 = 0.0
a = 0.0
b = 1.0
N = 320

figure('AM3 General')

tini = perf_counter()
(t,y, maxiter) = AM3General(a,b,fun,N,y0)
tfin = perf_counter()

ye = exacta(t)
plot(t,y)
plot(t,ye)
xlabel('t')
ylabel('y')
legend(['Aproximación', 'Exacta'])

h = (b - a)/float(N)
errorAntiguo = max(abs(y-ye))
tcpu = tfin-tini

print('---------------')
print('h = '+ str(h))
print('Error = '+str(errorAntiguo))
print('Tiempo CPU = '+str(tcpu))
print('Número máximo de iteraciones = '+ str(maxiter))
print('---------------\n')
show()

print("Solución mediante AM3 General Newton\n")

# Datos del problema
y0 = 0.0
a = 0.0
b = 1.0
N = 320

figure('AM3 General Newton')

tini = perf_counter()
(t,y, maxiter) = AM3GeneralNewton(a,b,fun,N,y0,dfy)
tfin = perf_counter()

ye = exacta(t)
plot(t,y)
plot(t,ye)
xlabel('t')
ylabel('y')
legend(['Aproximación', 'Exacta'])

h = (b - a)/float(N)
errorAntiguo = max(abs(y-ye))
tcpu = tfin-tini

print('---------------')
print('h = '+ str(h))
print('Error = '+str(errorAntiguo))
print('Tiempo CPU = '+str(tcpu))
print('Número máximo de iteraciones = '+ str(maxiter))
print('---------------\n')
show()

print("Apartado e)\n")

print("Método de AM3 General con semilla modificada\n")

# Método de Adams-Moulton de 3 pasos general con semilla la aproximación que daría en el tiempo tk+1 el método
# Adams-Bahsforth de tres pasos

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

# Datos del problema
y0 = 0.0
a = 0.0
b = 1.0
N = 320

figure('AM3 General Modificada')

tini = perf_counter()
(t,y, maxiter) = AM3General_AB3(a,b,fun,N,y0)
tfin = perf_counter()

ye = exacta(t)
plot(t,y)
plot(t,ye)
xlabel('t')
ylabel('y')
legend(['Aproximación', 'Exacta'])

h = (b - a)/float(N)
errorAntiguo = max(abs(y-ye))
tcpu = tfin-tini

print('---------------')
print('h = '+ str(h))
print('Error = '+str(errorAntiguo))
print('Tiempo CPU = '+str(tcpu))
print('Número máximo de iteraciones = '+ str(maxiter))
print('---------------\n')
show()

print("Método de AM3 General Newton con semilla modificada\n")

# Método de Adams-Moulton de 3 pasos general usando método de Newton modificando la semilla
# con la aproximación que daría en el tiempo tk+1 el método AB3

def AM3GeneralNewton_AB3(a,b,fun, N,y0, dfy):
    
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
            
            #z - (9h/24)f(tk+1,z)-Ck
            
            Fk = zAntiguo - (9/24)*h*fun(t[k+1], zAntiguo) - Ck
            dFk = 1 - (9/24)*h*dfy(t[k+1], zAntiguo)
            zNuevo = zAntiguo - (Fk/dFk)
            error = abs(zNuevo-zAntiguo)
            zAntiguo = zNuevo
            cont = cont + 1
        
        if(cont == 200):
            print("El método de punto fijo no ha convergido")
        
        maxiter = max(cont, maxiter)
        
        y[k+1] = zNuevo
        f[k+1] = fun(t[k+1], y[k+1])
        
    return (t,y, maxiter)

# Datos del problema
y0 = 0.0
a = 0.0
b = 1.0
N = 320

figure('AM3 General Newton Modificado')

tini = perf_counter()
(t,y, maxiter) = AM3GeneralNewton_AB3(a,b,fun,N,y0,dfy)
tfin = perf_counter()

ye = exacta(t)
plot(t,y)
plot(t,ye)
xlabel('t')
ylabel('y')
legend(['Aproximación', 'Exacta'])

h = (b - a)/float(N)
errorAntiguo = max(abs(y-ye))
tcpu = tfin-tini

print('---------------')
print('h = '+ str(h))
print('Error = '+str(errorAntiguo))
print('Tiempo CPU = '+str(tcpu))
print('Número máximo de iteraciones = '+ str(maxiter))
print('---------------\n')
show()

''' Con estas modificaciones se mejora el máximo de iteraciones y el tiempo CPU
casi a la mitad '''


print('Ejercicio 3\n')

def fun(t,y):
    return -y+exp(-t)*cos(t);

def exacta(t):
    return exp(-t)*sin(t);

# Método PECE AB3

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

    
print('Apartado a)\n')

# Datos del problema
y0 = 0.0
a = 0.0
b = 5.0
ns = [20, 40, 80, 160]
i = 0

figure ('Metodo PECE ABM - Ejercicio 3')

for N in ns:
    
    tini = perf_counter()
    
    (t,y) = ABM3(a,b,fun,N,y0)
    
    tfin = perf_counter()
    
    ye = exacta(t)
    plot(t,y)
    h = (b - a)/float(N)
    errorNuevo = max(abs(y-ye))
    
    tcpu = tfin-tini
    print('---------------')
    print('h = '+ str(h))
    print('Error = '+str(errorNuevo))
    print('Tiempo CPU = '+str(tcpu))
    if(i>0):
        orden = (log(errorAntiguo) - log(errorNuevo))/log(2)
        print("Orden aproximado =>", orden)
    print('---------------\n')
    
    errorAntiguo = errorNuevo
    i = i + 1
    
plot(t, ye, 'k') # dibuja la solucion exacta
xlabel('t')
ylabel('y')
leyenda=['N = ' + str(N) for N in ns]
leyenda.append('exacta')
legend(leyenda)
show()

''' Luego el orden aproximado del método ABM3 converge hacia 4 '''

print('Ejercicio 4\n')

def f4(t,y): # x = y[0] e y = y[1]
    '''Función que define el sistema diferencial'''
    dx = 0.25*y[0]-0.01*y[0]*y[1]
    dy = -y[1]+0.01*y[0]*y[1]
    return array([dx, dy])

# Datos del problema
a = 0.   # extremo inferior del intervalo
b = 20.  # extremo superior del intervalo
ns = [20, 40, 80, 160, 320, 640]
y0 = array([80,30])  # condiciones iniciales

# Método de Adams-Bashforth de 3 pasos para sistemas lineales

def AB3Sis(a,b,fun, N,y0):
    
    y = zeros([len(y0), N+1])
    t = zeros(N+1)
    f = zeros([len(y0), N+1])
    
    t[0] = a
    h = (b-a)/float(N)
    
    y[:, 0] = y0
    f[:, 0] = fun(a,y[:, 0])
    
    # Se usa el método de Heun (podría ser otro cualquiera de orden 2) para arrancar
    
    y[:, 1] = y[:, 0] + (h/2)*(fun(t[0],y[:, 0]) + fun(t[0] + h, y[:, 0] + h*fun(t[0], y[:, 0])))
    t[1] = a+h
    f[:, 1] = fun(t[1], y[:, 1])
    
    y[:, 2] = y[:, 1] + (h/2)*(fun(t[1],y[:, 1]) + fun(t[1] + h, y[:, 1] + h*fun(t[1], y[:, 1])))
    t[2] = a +2*h
    f[:, 2] = fun(t[2], y[:, 2])
    
    for k in range(2,N):
    
        y[:, k+1] = y[:, k] + (h/12)*(23*f[:, k] - 16*f[:, k-1] + 5*f[:, k-2])
        t[k+1] = t[k] + h
        f[:, k+1] = fun(t[k+1], y[:, k+1])
        
    return (t,y)

figure('AB3Sis')

for N in ns :    #N = numero de particiones

    t_ini = perf_counter()

    (t, y) = AB3Sis(a, b, f4, N, y0) # llamada al metodo de AM3 para sistemas
    
    t_fin = perf_counter()
    
    plot(y[0, :], y[1,:]) # dibuja la trayectoria aproximada
    
    # Resultados
    print('-----')
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)        
    print('Tiempo CPU:', t_fin-t_ini)
    print('-----\n')

xlabel('x')
ylabel('y')
legend(['N = ' + str(N) for N in ns])
title('Implementación AB3 Sistemas')
grid(False)
show()

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

figure('AM3pfSis')

for N in ns :    #N = numero de particiones

    t_ini = perf_counter()

    (t, y, maxiter) = AM3pfSis(a, b, f4, N, y0) # llamada al metodo de AM3 para sistemas
    
    t_fin = perf_counter()
    
    plot(y[0, :], y[1,:]) # dibuja la trayectoria aproximada
    
    # Resultados
    print('-----')
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)        
    print('Máximo número de iteraciones: ', maxiter)
    print('Tiempo CPU:', t_fin-t_ini)
    print('-----\n')

xlabel('x')
ylabel('y')
legend(['N = ' + str(N) for N in ns])
title('Implementación AM3 Sistemas')
grid(False)
show()

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

figure('ABM3Sis')

for N in ns :    #N = numero de particiones

    t_ini = perf_counter()

    (t, y) = ABM3Sis(a, b, f4, N, y0) # llamada al metodo de ABM3 para sistemas
    
    t_fin = perf_counter()
    
    plot(y[0, :], y[1,:]) # dibuja la trayectoria aproximada
    
    # Resultados
    print('-----')
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)        
    print('Tiempo CPU:', t_fin-t_ini)
    print('-----\n')

xlabel('x')
ylabel('y')
legend(['N = ' + str(N) for N in ns])
title('Implementación ABM3 Sistemas')
grid(False)
show()

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

figure('RK4Sis')

for N in ns :    #N = numero de particiones

    t_ini = perf_counter()

    (t, y) = RK4Sis(a, b, f4, N, y0) # llamada al metodo de RK4 para sistemas
    
    t_fin = perf_counter()
    
    plot(y[0, :], y[1,:]) # dibuja la trayectoria aproximada
    
    # Resultados
    print('-----')
    print('Numero de particiones ', N)
    print('Paso de malla: ' + str((b-a)/N))   #distancia entre puntos (longitud de las partciones)        
    print('Tiempo CPU:', t_fin-t_ini)
    print('-----\n')

xlabel('x')
ylabel('y')
legend(['N = ' + str(N) for N in ns])
title('Implementación RK4 Sistemas')
grid(False)
show()

'''

Para el Ejercicio 4 de la Práctica 1,

RK4 en N = 640
Tiempo CPU: 0.012236300000949996

ABM3 en N = 640
Tiempo CPU: 0.012049700002535246

AM3 en N = 640
Tiempo CPU: 0.024679199999809498

AB3 en N = 640
Tiempo CPU: 0.0069667999996454455

'''