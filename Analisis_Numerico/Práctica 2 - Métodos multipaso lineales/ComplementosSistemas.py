# -*- coding: utf-8 -*-
"""
Created on Mon Apr 13 13:31:11 2020

@author: Usuario
"""

from numpy import *
from numpy import linalg as LA ## llamamos LA al paquete de software para Álgebra lineal

### Matrices: ejemplos
A=eye(4) # matriz identidad 4x4
print(shape(A)) # dice las filas y columnas de A
A[0,1:5] = 1 # modificamos algunos elementos de A
A[1:5,0] = -2
print('A = '+ str(A))

### Producto matriz-vector
x = array([[1],[2], [3], [4]])# vector (4,1)
y = dot(A,x)#producto matriz-vector
print('x = '+ str(x))
print('y = ' + str(y))

#################### producto matriz por matriz

B = array([[1,0, -1, 1 ], [3,3,0,-1]])
print('B= '+ str(B))
C = dot(B,A) #producto de una matriz (2,4) por una matriz (4,4)
print('C= '+ str(C))
# D = dot(A,B) da error: no es posible multiplicar una matriz (4,4) por una (2,4)

D = dot(A,transpose(B)) ### pero si se puede multiplicar A por la traspueta de B
print('Traspuesta de B = ' + str(transpose(B)))
print('D = ' + str(D))

################### normas
v = array([1,-2,e,4])
# cómo calcular algunas normas de v:
print('v = '+str(v))
print('norma infinito de v=' + str(max(abs(v))))
print('norma 1 de v= '+str(sum(abs(v))))
print('norma 2 de v= '+str(sqrt(sum(v*v))))
## Tambien se puede hacer con la funcion norm del paquete linalg
print('norma infinito de v= '+str(LA.norm(v,inf)))
print('norma 1 de v= '+str(LA.norm(v,1)))
print('norma 2 de v= '+str(LA.norm(v,2)))
### En algunas versions de python basta con poner norm(v, inf)

###################  un array de un indice y otro de dos indices al que se van 
### añadiendo elementos y columnas

t = array([0.]) # nodos
z = zeros([2,1]) # solucion numerica (vector columna)
print('valores iniciales de t y z:')
print(t)
print(z)
for i in range(5):
    t = append(t, i+1)
    z = column_stack((z, [i+1, i+2]))
    print('valores de t y z en la iteracion ' + str(i))
    print(t)
    print(z)
    
    
#####  copia de arrays (cuidado!!!)

#### copia de variables

a = 7
b = a
### se crea una variable b con el mismo contenido que a
print(a,b)

### si modifico b, a no se entera
b += 1
print(a,b)

u = zeros(3)
v = u
### se crea un nuevo nombre para el array u
print(u,v)

### si modifico v, u tambien cambia
v[0] = 7
print(u,v)

### para crear un array con el mismo contenido que u pero independiente de u hya que usar copy
w = u.copy()
print(u,w)

# si modifico w, u no se entera
w[1] = 7
print(u,w)

