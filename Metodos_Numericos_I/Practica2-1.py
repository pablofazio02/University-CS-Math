# -*- coding: utf-8 -*-

"""
Created on Thu Oct 13 14:57:22 2022

@author: Pablo Fazio Arrabal

Métodos Numéricos I: Resolución numérica de ecuaciones escalares no lineales I

"""
from numpy import *
from matplotlib.pyplot import *

print('Ejercicio 1\n')

def bisec(f,a,b,N):
    an=a
    bn=b
    fan=f(an)
    fbn=f(bn)
    if fan==0:
        print(str(a)+'es raíz de la función')
        return a
    elif fbn==0:
        print(str(b)+'es raíz de la función')
        return b
    elif fan*fbn>0:
        print('No hay cambio de signo: no se puede aplicar el método')
        #return
   
    for k in range(N):
        cn=(an+bn)/2.
        fcn=f(cn)
        print('En iteración', k,'c= ', cn, 'y f(cn)= ', fcn) # Apartado a)
        if fcn==0:
            print(str(cn)+'es raíz de la función')
            return cn
        elif fan*fcn<0:
            bn=cn
            fbn=fcn
        else:
            an=cn
            fan=fcn
    print('La aproximación de la raíz tras '+str(N)+' iteraciones es '+str(cn))
    return cn

print('Apartado b)\n')

def f1(x):
    return x**5-5*x**3+1

def f3(x):
    return x**3-x-1

x = linspace(-3,3)
plot(x,f1(x))
plot(x,x*0)
show()

bisec(f1, 0, 1, 20)

bisec(f1, -3,-2, 20)

bisec(f1, 2,3, 20)

print('Apartado c)\n')

def f2(x):
    return cos(x) - x

x = linspace (-pi,pi)
plot(x,f2(x))
plot(x,x*0)
show()

bisec(f2, 0.5, 1.5, 20)

print('Apartado d)\n')

def bisec_bis(f,a,b,e):
    an=a
    bn=b
    fan=f(an)
    fbn=f(bn)
    N = int((log(b-a)-log(e))/log(2)) + 1 
    if fan==0:
        print(str(a)+'es raíz de la función')
        return a
    elif fbn==0:
        print(str(b)+'es raíz de la función')
        return b
    elif fan*fbn>0:
        print('No hay cambio de signo: no se puede aplicar el método')
        #return
   
    for k in range(N):
        cn=(an+bn)/2.
        fcn=f(cn)
        print('En iteración', k,'c= ', cn, 'y f(cn)= ', fcn) # Apartado a)
        if fcn==0:
            print(str(cn)+'es raíz de la función')
            return cn
        elif fan*fcn<0:
            bn=cn
            fbn=fcn
        else:
            an=cn
            fan=fcn
    print('La aproximación de la raíz tras '+str(N)+' iteraciones es '+str(cn))
    return cn

print('Apartado e)\n')
 
bisec_bis(f1, 0, 1, 1e-7)
bisec_bis(f1, -3,-2, 1e-7)
bisec_bis(f1, 2,3, 1e-7)
bisec_bis(f2,0.5,1.5,1e-7)

print('Ejercicio 2\n')

print('Apartado a)\n')

def regula_falsi(f,a,b,e,nmax):
    an=a
    bn=b
    fan=f(an)
    fbn=f(bn)
    if fan==0:
        print(str(a)+'es raíz de la función')
        return a
    elif fbn==0:
        print(str(b)+'es raíz de la función')
        return b
    elif fan*fbn>0:
        print('No hay cambio de signo: no se puede aplicar el método')
        #return
   
    k = 0
    cn = bn - ((bn-an)/(fbn-fan))*fbn
    fcn=f(cn)
    print('En iteración', k+1,'c= ', cn, 'y f(cn)= ', fcn) # Apartado a)
    k+=1
    err = e + 1
    cn_old = cn
    if fcn==0:
        print(str(cn)+'es raíz de la función')
        return cn
    elif fan*fcn<0:
        bn=cn
        fbn=fcn
    else:
        an=cn
        fan=fcn
    while(k < nmax and err > e):
       
        cn= bn - ((bn-an)/(fbn-fan))*fbn
        fcn=f(cn)
        print('En iteración', k+1,'c= ', cn, 'y f(cn)= ', fcn) # Apartado a)
        k+=1
        err = abs(cn - cn_old)
        cn_old = cn
        if fcn==0:
            print(str(cn)+'es raíz de la función')
            return cn
        elif fan*fcn<0:
            bn=cn
            fbn=fcn
        else:
            an=cn
            fan=fcn
        
    if(k < nmax):
     print('La aproximación de la raíz tras '+str(k)+' iteraciones es '+str(cn)+ ' porque la aproximación es satisfactoria.')
    else:
     print('La aproximación de la raíz tras '+str(k)+' iteraciones es '+str(cn)+ ' porque hemos alcanzado número máximo de iteraciones')
    return cn 

    
print('Apartado b)\n')

regula_falsi(f1, 0, 1, 1e-7, 50)
regula_falsi(f1, -3,-2, 1e-7, 50)
regula_falsi(f1, 2,3, 1e-7, 50)
regula_falsi(f2,0.5,1.5,1e-7, 50)
   
print('Apartado c)\n')

def regula_falsi_bis(f,a,b,e,nmax):
    an=a
    bn=b
    fan=f(an)
    fbn=f(bn)
    if fan==0:
        print(str(a)+'es raíz de la función')
        return a
    elif fbn==0:
        print(str(b)+'es raíz de la función')
        return b
    elif fan*fbn>0:
        print('No hay cambio de signo: no se puede aplicar el método')
        #return
   
    k = 0
    err = e + 1
    while(k<nmax and err > e):
        cn= bn - ((bn-an)/(fbn-fan))*fbn
        fcn=f(cn)
        err = abs(fcn)
        print('En iteración', k+1, 'c= ', cn, 'y f(cn)= ', fcn) # Apartado a)
        k+=1
        if fcn==0:
            print(str(cn)+'es raíz de la función')
            return cn
        elif fan*fcn<0:
            bn=cn
            fbn=fcn
        else:
            an=cn
            fan=fcn
        
    if(k < nmax):
     print('La aproximación de la raíz tras '+str(k)+' iteraciones es '+str(cn)+ ' porque la aproximación es satisfactoria.')
    else:
     print('La aproximación de la raíz tras '+str(k)+' iteraciones es '+str(cn)+ ' porque hemos alcanzado número máximo de iteraciones')
    return cn

print('Apartado d)\n')

regula_falsi_bis(f1, 0, 1, 1e-7, 50)
regula_falsi_bis(f1, -3,-2, 1e-7, 50)
regula_falsi_bis(f1, 2,3, 1e-7, 50)
regula_falsi_bis(f2,0.5,1.5,1e-7, 50)


print('Ejercicio 3\n')

print('Apartado a)\n')

def secante(f,x0,x1,e,nmax):
  
    fx0=f(x0)
    fx1=f(x1)
    if fx0==0:
        print(str(x0)+'es raíz de la función')
        return x0
    elif fx1==0:
        print(str(x1)+'es raíz de la función')
        return x1
    elif fx0 == fx1:
        print('No se puede aplicar el método')
        #return
   
    k = 0
    err = e + 1
    
    while(k < nmax and err > e):
        x2 = x1 - ((x1-x0)/(fx1-fx0))*fx1
        if isreal(f(x2))==False:
            print("El punto no pertenece al dominio de la función.")
            return
        else:
            fx2=f(x2)
            print('En iteración', k+1,'c= ', x2, 'y f(cn)= ', fx2) # Apartado a)
            k+=1
            err = abs(x2-x1)
            x0 = x1
            x1 = x2
            fx0 = fx1
            fx1 = fx2
            if fx2==0:
                print(str(x2)+'es raíz de la función')
                return x2
        
    if(k < nmax):
        print('La aproximación de la raíz tras '+str(k)+' iteraciones es '+str(x2)+ ' porque la aproximación es satisfactoria.')
    else:
        print('La aproximación de la raíz tras '+str(k)+' iteraciones es '+str(x2)+ ' porque hemos alcanzado número máximo de iteraciones')
    return x2
 

print('Apartado b)\n')

secante(f1, 0, 1, 1e-7, 50)
secante(f1, -3,-2, 1e-7, 50)
secante(f1, 2,3, 1e-7, 50)
secante(f2,0.5,1.5,1e-7, 50)

print('Apartado c)\n')

def secante_bis (f,x0,x1,e,nmax):
    fx0=f(x0)
    fx1=f(x1)
    if fx0==0:
        print(str(x0)+'es raíz de la función')
        return x0
    elif fx1==0:
        print(str(x1)+'es raíz de la función')
        return x1
    elif fx0 == fx1:
        print('No se puede aplicar el método')
        #return
   
    k = 0
    err = e + 1
    
    while(k < nmax and err > e):
        x2 = x1 - (x1-x0)/(fx1-fx0)*fx1
        fx2=f(x2)
        print('En iteración', k+1,'c= ', x2, 'y f(cn)= ', fx2) # Apartado a)
        k+=1
        err = abs(fx2)
        x0 = x1
        x1 = x2
        fx0 = fx1
        fx1 = fx2
        if fx2==0:
            print(str(x2)+'es raíz de la función')
            return x2
        
    if(k < nmax):
     print('La aproximación de la raíz tras '+str(k)+' iteraciones es '+str(x2)+ ' porque la aproximación es satisfactoria.')
    else:
     print('La aproximación de la raíz tras '+str(k)+' iteraciones es '+str(x2)+ ' porque hemos alcanzado número máximo de iteraciones')
    return x2

print('Apartado d)\n')

secante_bis(f1, 0, 1, 1e-7, 50)
secante_bis(f1, -3,-2, 1e-7, 50)
secante_bis(f1, 2,3, 1e-7, 50)
secante_bis(f2,0.5,1.5,1e-7, 50)
   