# -*- coding: utf-8 -*-
"""
Created on Sun May 17 11:38:44 2020

@author: Pablo Fazio Arrabal

Práctica 3 - Estabilidad absoluta

"""

from pylab import *
    
def locfron(rho, sigma):
# Dibuja la frontera de la region de estabilidad absoluta 
# de un metodo multipaso.
# rho y sigma son los coeficientes de los polinomios caracteristicos
# ordenados de mayor a menor grado '''
    theta = arange(0, 2.*pi, 0.01)
    numer = polyval(rho, exp(theta*1j)) # rho(e^{theta*i})
    denom = polyval(sigma, exp(theta*1j)) # sigma(e^{theta*i})
    mu = numer/denom
    x = real(mu)
    y = imag(mu)
    plot(x, y)
    xlabel('Re(z)')
    ylabel('Im(z)')
    grid(True)
    axis('equal')

figure('AB Ejemplo')
# Ejemplo: AB3 y_{k+1} - y_k  = h/12*(23*f_k - 16*f_{k-1} + 5*f_{k-2})
rho = array([1., -1., 0.,0.]) # primero
sigma = array([0., 23., -16., 5.])/12. # segundo
locfron(rho,sigma)
show()

print('Ejercicio 1\n')

#### Región estabilidad absoluta AB

figure ('Métodos AB')

# AB 1 paso
rho = array([1.,-1.])
sigma = array([0,1.])
locfron(rho, sigma)

# AB 2 pasos
rho = array([1.,-1., 0.])
sigma = array([0,3/2., -1/2.])
locfron(rho, sigma)

# AB 3 pasos
rho = array([1.,-1., 0., 0.])
sigma = array([0, 23./12., -4/3., 5/12.])
locfron(rho, sigma)

# AB 4 pasos
rho = array([1.,-1., 0., 0., 0.]) # primero
sigma = array([0., 55., -59., 37., -9.])/24. # segundo
locfron(rho, sigma)

legend(['AB1', 'AB2', 'AB3', 'AB4'])
title('Región estabilidad absoluta AB')
show()

#### Región estabilidad absoluta AM

figure ('Métodos AM')

# AM 1 paso
rho = array([1.,-1.])
sigma = array([0.5, 0.5])
locfron(rho, sigma)

# AM 2 pasos
rho = array([1.,-1., 0.])
sigma = array([5/12., 2/3., -1/12.])
locfron(rho, sigma)

# AM 3 pasos
rho = array([1.,-1., 0., 0.])
sigma = array([3/8., 19./24, -5/24., 1/24.])
locfron(rho, sigma)

# AM 4 pasos
rho = array([1.,-1., 0., 0., 0.]) # primero
sigma = array([251., 646., -264., 106., -19])/720. # segundo
locfron(rho, sigma)

axis([-8,1,-4,4])

legend(['AM1', 'AM2', 'AM3', 'AM4'])
title('Región estabilidad absoluta AM')
show()

#################  region estabilidad RK

def locfronRK(dR, N):
# Localizacion de la frontera de un metodo RK
#  Derivada de la funcion R
    Npoints = 5000
    T = 2*N*pi
    h = 2*N*pi/Npoints
    z = zeros(Npoints +1 , dtype = complex)
    z[0] = 0.
    t = 0
    for k in range(len(z)-1):
        k1 = 1j*exp(1j*t)/dR(z[k])
        k2 = 1j*exp(1j*(t+0.5*h))/dR(z[k] + 0.5*h*k1)
        k3 = 1j*exp(1j*(t+0.5*h))/dR(z[k] + 0.5*h*k2)
        k4 = 1j*exp(1j*(t+h))/dR(z[k] + h*k3)
        z[k+1] = z[k]+ h*(k1+ 2*k2+ 2*k3 + k4)/6
        t = t + h
    x = real(z)
    y = imag(z)
    plot(x,y)
    xlabel('Re(z)')
    ylabel('Im(z)')
    grid(True)
    axis('equal')

figure('RK explicitos')

# Euler: función de estabilidad R = 1 + z

def dREuler(z):
    return 1.
locfronRK(dREuler, 1.)

# RK2 explicitos: función de estabilidad R = 1 + z

def dRK2exp(z):
    return 1. + z
locfronRK(dRK2exp, 2.)

# RK3 explicitos: función de estabilidad R = 1 + z + z**2/2

def dRK3exp(z):
    return 1. + z + z**2/2.
locfronRK(dRK3exp,3.)

# RK4 explicitos: función de estabilidad R = 1 + z + z**2/2 + z**3/6

def dRK4exp(z):
    return 1. + z + z**2/2. + z**3/6
locfronRK(dRK4exp,4.)

legend(['RK1', 'RK2', 'RK3', 'RK4'])
title('Región estabilidad absoluta RK')
show()


print('Ejercicio 2\n')

def exacta(t):
    return (5/3)-(1495/3597)*exp(-1200*t)-(1500/1199)*exp(-t)

def f(t,y):
    return -1200*y + 2000 - 1500*exp(-t)

def df(t,y):
    return -1200

print('Apartado a)\n')

# -1200 = h*df/dy <=> 0 < h < 1/600 <=> N = 4/h = 2400
# Ya que deberá pertenecer a (-2,0) = D_A
 
# Datos del problema
a = 0.
b = 4.
y0 = 0.

# Método de Euler

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


figure ('Ejercicio 2a)')

# Tomemos diferentes valores de N para h mayores y menores que el estimado

malla = [0.001, 1/600, 0.0017]

for h in malla:
    N = int((b-a)/h) + 1
    (t,y) = euler(a,b,f,N,y0)
    plot(t,y)
    
tex = linspace(a,b,200)
yex = exacta(tex)
plot(tex, yex)
legend(['h=0.001', 'h=1/160', 'h=0.0017', 'exacta'])
axis([0,4,-10,10])
show()

print('Apartado b)\n')

# Sabemos que la región de estabilidad de euler impl es el hiperplano real
# Pero 

def eulerImplicito(a, b, fun, N, y0):
    """Implementacion del metodo de Euler implicito en el intervalo [a, b]
    usando N particiones y condicion inicial y0"""
    
    h = (b-a)/N      # paso de malla
    t = zeros(N+1)   # inicializacion del vector de nodos
    y = zeros(N+1)   # inicializacion del vector de resultados
                                # tantas filas como condiciones iniciales 
                                # tantas columnas como "puntos"
    t[0] = a      # nodo inicial
    y[0] = y0     # valor inicial

    # Metodo de Euler
    for k in range(N):
        
        t[k+1] = t[k]+h
        y[k+1] = (y[k]+h*(2000 - 1500*exp(-t[k+1]))) / (1+1200*h)
        
    return (t, y)
    
figure ('Ejercicio 2b)')

# Tomemos diferentes valores de N para h mayores y menores que el estimado

malla = [0.001, 0.01, 0.1, 1]

for h in malla:
    N = int((b-a)/h) + 1
    (t,y) = eulerImplicito(a,b,f,N,y0)
    plot(t,y)
    
tex = linspace(a,b,200)
yex = exacta(tex)
plot(tex, yex)
legend(['h=0.001', 'h=0.01', 'h=0.1', 'h=1', 'exacta'])
show()
    
print('Apartado c)\n')

# Para hallar donde está el h hay que ver el punto de corte de la gráfica RK4 
# con el eje x
 
# - 1200h > -2,785  <=> h < -2,785 / -1200 <=> 

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

figure ('Ejercicio 2c)')

# Tomemos diferentes valores de N para h mayores y menores que el estimado

malla = [0.002, 2.78/1200, 0.0025]

for h in malla:
    N = int((b-a)/h) + 1
    (t,y) = RK4(a,b,f,N,y0)
    plot(t,y)
    
tex = linspace(a,b,250)
yex = exacta(tex)
plot(tex, yex)
legend(['h=0.002', 'h=2.78/1200', 'h=0.0025', 'exacta'])
axis([0,4,-10,10])
show()

print('Ejercicio 3\n')

#x'' + 20x' +101x = 0 => si y=x',
#y' = -20y -101x

def f3(t,y):
    dx = y[1]
    dy = -20*y[1] - 101*y[0]
    return array([dx, dy])

def exacta(t):
    return exp(-10*t)*cos(t)

# Datos del problema
a = 0
b = 7
y0 = array([1, -10])

#Los autovalores de una matriz se calculan A-lamda*Id = 0 
#A en máquina se calculan con eig(A)
#Aquí A =   0     1
#         -101   -20      => aut(A) = -10 +- i 

figure ('Ejercicio 3 - Región est. abs. para sistema')

def dREuler(z):
    return 1.
locfronRK(dREuler, 1.)

#Antes teníamos que ver dónde h*df/dy cortaba, ahora es h*autovalor (por sistema)
#Los autovalores son 10 +-i 
#Hay que calcular los cortes de la región de estabilidad 
# absoluta con las rectas que unen los autovalores  con el origen,
# es decir x=10y  y x=-10y.

re = -10.
im = 1.
plot([re, re], [im, -im], '*')

# dibujamos ahora las rectas que unen los puntos con el origen
plot([0,re], [0,im], '--', [0,re], [0,-im], '--')

#Ahora ampliando, podemos ver el punto de corte de la locfron de Euler 
#con esas rectas (los hgorro). Y de ahí tendríamos que sacar el h.
# Creo que hgorro = 80/101  => h = 20/101

hcritico = 20/101

# Finalmente, podemos usar ese h critico para resolver el sistema

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

N = int((b-a)/hcritico)
ns = array([N-5, N , N+5])

figure('Resolución sistema Ejercicio 3')

for N in ns:
    (t,y) = eulerSis(a,b,f3,N,y0)
    plot(t,y[0]) #solo nos interesa la x
    
plot(t,exacta(t))
axis([0,7,-10,10])
legend(['N-5','N(h_crítico)', 'N+5','exacta'])
show()

print('Ejercicio 4\n')

def BDF3Sistemas(a,b,fun, N,y0):
    
    y = zeros((len(y0),N+1))
    t = zeros(N+1)
    f = zeros((len(y0),N+1))
    
    t[0] = a
    h = (b-a)/float(N)
    
    y[:,0] = y0
    f[:,0] = fun(a,y[:,0])
    
    #Arranque con RK4
    
    for k in range(0,2):
        K1 = fun(t[k], y[:,k])
        K2 = fun(t[k] + (h/2), y[:,k] + (h/2)*K1)
        K3 = fun(t[k] + (h/2), y[:,k] + (h/2)*K2)
        K4 = fun(t[k] + h, y[:,k] + h*K3)
        
        y[:,k+1] = y[:,k] + (h/6)*(K1 + 2*K2 + 2*K3 + K4)
        t[k+1] = t[k] + h
        f[:,k+1] = fun(t[k+1], y[:,k+1])
    
    for k in range(2,N):
    
        t[k+1] = t[k] + h
        Ck = (18/11)*y[:,k] - (9/11)*y[:,k-1] + (2/11)*y[:,k-2]
        [c1, c2] = Ck
        
        b = (11*c2 - 606*h*c1)/(((3636*(h**2))/11) + ((120*h)/11) + 11)
        a = ((6*h)/11)*b + c1
        
        y[:,k+1] = array([a,b])
        f[:,k+1] = fun(t[k+1], y[:,k+1])
        
    return (t,y)

def F(t,Y):
    x = Y[0]
    y = Y[1]
    return array([y, -101*x -20*y])

def exacta(t):
    return exp(-10*t)*cos(t)

a = 0
b = 7
Y0 = array([1, -10])
Ns = [20, 40, 80, 160]
figure()
title("Aproximaciones de la ec (2) con el método BDF3")
leyenda = []
for N in Ns:
    (t, solAproximada) = BDF3Sistemas(a, b, F, N, Y0)
    leyenda.append("N = " + str(N))
    solAproximadaX = solAproximada[0,:]
    plot(t, solAproximadaX)
leyenda.append("solución exacta")
plot(t, exacta(t))
legend(leyenda)
show()
    
figure()
title("Región de estabilidad absoluta del método BDF3")
rho = [1,-18/11,9/11,-2/11]
sigma = [6/11, 0, 0, 0]
locfron(rho, sigma)

r = -10
i = -1

plot([r,r],[i,-i],'*')

plot([r,0],[i,0])
plot([r,0],[-i,0])
show()

print("Cualquier número de subintervalos proporciona convergencia a 0 cuando k tiende a infinito.")