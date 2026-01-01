"""
Created on Sat Nov  19 19:18:05 2022

@author: pablo

Práctica 3 - Interpolación polinómica de Lagrange 
-  Métodos Numéricos I

"""

from numpy import *
from matplotlib.pyplot import *
from scipy.interpolate import interp1d

print('Ejercicio 1\n')

def tabla_diferencias_divididas(x,y):
    
    """ Calcula la tabla completa de las diferencias divididas a partir de los datos x e y.
    Devuelve una matriz (df) triangular inferior que en la columna k-esima contiene las
    diferencias divididas de orden k"""
    
    n= len(y)
    df=zeros([n,n])
    df[:,0]=y
    yn=y
    for i in range(0, n-1):      #len(x)=len(y)=n 
        dx=x[i+1: n]-x[0:n-(i+1)]
        yn=diff(yn)/dx
        df[i+1:n,i+1]=yn
    return df

print('Apartado a)\n')

x = linspace (0,1,5)
y = exp(x)
print(tabla_diferencias_divididas(x,y))

print('Ejercicio 2\n')
    
def eval_forma_newton(x,y,z_0):
    
    #z0 puede ser un número (y en tal caso devuelve el polinomio de newton evaluado en ese punto), 
    #o un array de números (y devuelve un array con las evaluaciones de cada uno de esos puntos)
    
    """ Calcula en primer lugar el polinomio de interpolacion de Lagrange que interpola los datos x e
    y mediante la formula de Newton y lo evalua en z0."""  
    
    n= len(y)
    df=tabla_diferencias_divididas(x,y)
    peval=df[0,0]
    prod=1.0
    for i in range(1,n):
        prod=prod*(z_0-x[i-1])
        peval=peval+df[i,i]*prod
    return peval    

print('Apartado a)\n')

eval_forma_newton(x, y, 1/3)

#Ahora evalua el pol.newton en cada punto del array x
#En efecto, ve que la evaluación coincide con la imagen de esos puntos
#es decir, al evaluar el polinomio en el array x, da el array y

print('\n Vemos que pasa por los datos dados (valores de los nodos): ', eval_forma_newton(x,y,x)==y)

print('Apartado b)\n')

def eval_forma_horner(c,z_0):
    n=len(c)
    peval=c[n-1]
    for i in range(n-2,-1,-1):
        peval=peval*z_0+c[i]
    return peval

#Probémoslo con un ejemplo:

prueba_horner=array([1,2,3])
eval_prueba=eval_forma_horner(prueba_horner,2)
print('\n Probando Horner...', eval_prueba)

print('Apartado c)\n')

def eval_forma_horner_mod (x,y,z_0):
    n= len(x)
    df=tabla_diferencias_divididas(x,y)
    peval=df[n-1,n-1]
    
    for i in range(n-2,-1,-1):
        peval=peval*(z_0-x[i])+df[i,i]
    return peval

pUnTercioHorner=eval_forma_horner_mod(x,y,1/3)
print('\n Probando formula de Newton-Horner...', pUnTercioHorner)
print('\n Vemos que pasa por los datos dados (valroes de los nodos): ', eval_forma_horner_mod(x,y,x)==y)


print('Apartado d)\n')

def evalpol_equidistante(f,a,b,N,z_0):  #z_0 es un vector!
    x=linspace(a,b,N+1)
    y=f(x)
    pz0=eval_forma_horner_mod(x, y, z_0)
    error=max(abs(f(z_0)-pz0))
    return pz0,error

print('Apartado e)\n')

def f1(x):
    return exp(x)

a=-3
b=3
h= 0.01
n=int((b-a)/h)
z0= linspace(a,b,n+1)

"""

[pz0,error] = evalpol_equidistante(f1, a, b, 5, z0)
figure()
clf()
plot(z0,f1(z0),'b',z0,pz0,'r')
show()

"""

for i in array([5,10,15,20]):
    
    x=linspace(a,b,i+1)
    
    polin,err=evalpol_equidistante(f1,a,b,i,z0)
    
    plot(z0,f1(z0),z0,polin,x,f1(x),'o')
    show()
    
    print('Error para',i,'intervalos:',err)
    
print('Apartado f)\n')

def f2(x):
    return 1/(1+x**2)

a=-5
b=5
h=0.01
n=int((b-a)/h)
z0=linspace(a,b,n+1)

for i in array([5,10,15,20]):
    
    x=linspace(a,b,i+1)
    
    polin,err=evalpol_equidistante(f2,a,b,i,z0)
    
    plot(z0,f2(z0),z0,polin,x,f2(x),'o')
    show()
    
    print('Error para',i,'intervalos:',err)

print('Apartado g)\n')

def evalpol_Chebysev(f,a,b,N,z_0):
    
    #El método de Chebyshev se usan cuando hay muchos nodos N>>>
    
    indices = linspace(0,N,N+1) #array de 0 a N con N+1 puntos
    
    x=cos((2*indices+1)*pi/(2*(N+1)))  #array de los nodos de chebyshev
    
    x=a+(b-a)/2*(x+1) #Nodos en [a,b]
 
    y=f(x) #array con los valores de la función en el array x
    
    polinomio=eval_forma_horner_mod(x,y,z0)
    
    error=max(abs(f(z0)-polinomio))
    
    return polinomio, error


for i in array([5,10,15,20]):
        
    x=linspace(a,b,i+1)
        
    polin,err=evalpol_Chebysev(f2,a,b,i,z0)
        
    plot(z0,f2(z0),z0,polin,x,f2(x),'o')
    show()
        
    print('Error para',i,'intervalos:',err)

print('Ejercicio 3\n')

def f2(x):
    return 1/(1+x**2)

print('Apartado a)\n')

def splinelinear(f,a,b,N):
   x=linspace(a,b,N+1)
   y=f(x)
   pol=interp1d(x,y,kind='linear')
   return pol

def splinecubic(f,a,b,N):
    x=linspace(a,b,N+1)
    y=f(x)
    pol=interp1d(x,y,kind='cubic')
    return pol

print('Apartado b)\n')

a=-5
b=5
h=0.01
n=int((b-a)/h)
z0=linspace(a,b,n+1)

N=50
spline_lineal = splinelinear(f2,-5,5,N)
spline_cubico = splinecubic(f2,-5,5,N)

error_lineal = max (abs (f2(z0) - spline_lineal(z0)))
error_cubico = max (abs (f2(z0) - spline_cubico(z0)))

print('El error del interpolante lineal a trozos para N =', N, 'trozos es: ', error_lineal)
print('El error del interpolante cúbico a trozos para N =', N, 'trozos es: ', error_cubico)

figure()
clf()
subplot(2,1,1)
plot(z0,f2(z0),'b:',z0,spline_lineal(z0), 'r')
subplot(2,1,2)
plot(z0,f2(z0),'b:',z0,spline_cubico(z0), 'r')


