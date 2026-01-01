# -*- coding: utf-8 -*-
from numpy import *
from numpy.linalg import *
from numpy import abs, sum, max, min
import matplotlib.pyplot as plt

# Devuelve la matriz adjunta de una matriz o vector (traspuesta para reales y conjudada + traspuesta para complejos)
def conjugada(A): 
    nd = ndim(A)
    if nd == 1:
        AA = array([A]) #Meto una matriz fila en una matriz
    elif nd == 2:
        AA = array(A) #Concluyo igual (Copia Literal)
    else:
        AA = 0
        print("Error con conjugada")
    return conjugate(transpose(AA))

# Devuelve la norma vectorial del vector (o matriz columna) dado p>=1 o p = inf
def norma_vec(X, p):
    XX = array (X , dtype=complex)
    normainf = max(abs(XX))
    if p == inf:
        return normainf # La salida de la funcion abs() te trunca a número real.
    elif p>=1:
        if normainf < 1e-200:
            return (sum(abs(XX)**p)**(1/p))
        else:
            return normainf*(sum((abs(XX)/normainf)**p))**(1/p)
    else:
        print("Error norma_vec: valor p < 1 no es una norma")
        return 

# Calcula la norma infinita y las normas p=1,2,3... hasta que el error relativo sea menor en valor absoluto que un error fijado (1e-10) o un nº iter.
def conv_norma_vec(X):
    print("Vector: X = ", X)
    normainf = norma_vec(X, inf)
    print("||X||_inf = ", normainf)
    error = 1.
    p = 0
    while error >= 1e-10 and p < 200:
        p = p+1
        normap = norma_vec(X, p)
        if normainf < 1e-200:
            error = abs(normap-normainf)
            print("p = ", p, " ||X||_p = ", normap, " Error relativo = ", error)
        else :
            error= abs((normap-normainf)/normainf)
            print("p = ", p, " ||X||_p = ", normap, " Error relativo = ", error)
    if error < 1e-10:
        print("Convergencia numérica alcanzada.")
    else:
        print("Número máximo de iteraciones alcanzado.")

# Devuelve la norma matricial de una matriz cuadrada con p = inf, 1, 2 o fro (euclídea)
def norma_mat(A, p):
    AA = array(A, dtype = complex)
    if p == inf:
        return max(sum(abs(AA),axis=1))
    elif p == 1:
        return max(sum(abs(AA),axis=0))
    elif p == 2:
        return max(svd(AA)[1])
    elif p == 'fro':
        return sqrt(sum(abs(AA)**2))
    else:
        print("Error norma_mat: valor de p.")
        return

# Dados dos matrices A (triang.inf, regular con aii != 0) y B devuelve la solución del sistema AX = B mediante el proceso de descenso (Además,  modificado para resolver numerosos sistemas de forma simultánea)

def descenso(A, B):
    m, n = shape(A)
    p, q = shape(B)
    if m != n or n != p or q < 1:
        return False, "Error descenso: error en las dimensiones."
    if min(abs(diag(A))) < 1e-200:
        return False, "Error descenso: matriz singular."
    if A.dtype == complex or B.dtype == complex:
        X = zeros((n, q), dtype=complex)
    else:
        X = zeros((n, q), dtype=float)
    for i in range(n): 
        X[i, :] = B[i, :]
        if i != 0:
            X[i, :] -= A[i, :i]@X[:i, :]
        X[i, :] = X[i, :]/A[i, i]
    return True, X

# Dados dos matrices A (triang.sup, regular con aii != 0) y B devuelve la solución del sistema AX = B mediante el proceso de remonte (Además,  modificado para resolver numerosos sistemas de forma simultánea)

def remonte(A, B):
    m, n = shape(A)
    p, q = shape(B)
    if m != n or n != p or q < 1:
        return False, "Error remonte: error en las dimensiones."
    if min(abs(diag(A))) < 1e-200:
        return False, "Error remonte: matriz singular."
    if A.dtype == complex or B.dtype == complex:
        X = zeros((n, q), dtype=complex)
    else:
        X = zeros((n, q), dtype=float)
    for i in range(n-1,-1,-1): # De n-1 a 0 (-1 excluido) con saltos -1
        X[i, :] = B[i, :]
        if i != n-1:
            X[i, :] -= A[i, i+1:]@X[i+1:, :]
        X[i, :] = X[i, :]/A[i, i]
    return True, X

# Solo se usa cuando la matriz A tiene 1's en la diagonal principal
def descenso1(A, B):
    m, n = shape(A)
    p, q = shape(B)
    if m != n or n != p or q < 1:
        return False, "Error descenso1: error en las dimensiones."
    if A.dtype == complex or B.dtype == complex:
        X = zeros((n, q), dtype=complex)
    else:
        X = zeros((n, q), dtype=float)
    for i in range(n):
        X[i, :] = B[i, :]
        if i != 0:
            X[i, :] -= A[i, :i]@X[:i, :]
    return True, X

# Solo se usa cuando la matriz A tiene 1's en la diagonal principal
def remonte1(A, B):
    m, n = shape(A)
    p, q = shape(B)
    if m != n or n != p or q < 1:
        return False, "Error remonte1: error en las dimensiones."
    if A.dtype == complex or B.dtype == complex:
        X = zeros((n, q), dtype=complex)
    else:
        X = zeros((n, q), dtype=float)
    for i in range(n-1,-1,-1): # De n-1 a 0 (-1 excluido) con saltos -1
        X[i, :] = B[i, :]
        if i != n-1:
            X[i, :] -= A[i, i+1:]@X[i+1:, :]
    return True, X

# Solo se usa cuando la matriz A es tridiagonal y solo tiene elementos no nulos en la diagonal principal y en k = -1

def descenso_1diag(A, B):
    m, n = shape(A)
    p, q = shape(B)
    if m != n or n != p or q < 1:
        return False, "Error descenso_1diag: error en las dimensiones."
    if min(abs(diag(A))) < 1e-200:
        return False, "Error descenso_1diag: matriz singular."
    if A.dtype == complex or B.dtype == complex:
        X = zeros((n, q), dtype=complex)
    else:
        X = zeros((n, q), dtype=float)
    for i in range(n):
        X[i, :] = B[i, :]
        if i != 0:
            X[i, :] -= A[i, i-1]*X[i-1, :] # Producto normal, no matricial!!
        X[i, :] = X[i, :]/A[i,i]
    return True, X

# Solo se usa cuando la matriz A es tridiagonal y solo tiene elementos no nulos en la diagonal principal y en k = 1

def remonte_1diag(A, B):
    m, n = shape(A)
    p, q = shape(B)
    if m != n or n != p or q < 1:
        return False, "Error remonte_1diag: error en las dimensiones."
    if min(abs(diag(A))) < 1e-200:
        return False, "Error remonte_1diag: matriz singular."
    if A.dtype == complex or B.dtype == complex:
        X = zeros((n, q), dtype=complex)
    else:
        X = zeros((n, q), dtype=float)
    for i in range(n-1,-1,-1):
        X[i, :] = B[i, :]
        if i != n-1:
            X[i, :] -= A[i, i+1]*X[i+1, :]   
        X[i, :] = X[i, :]/A[i, i]
    return True, X

# Devuelve, dadas una matriz A inversible y el vector/matriz B, la solución del sistema AX = B mediante el método de Gauss usando la estrategia de pívot parcial

def gauss_pp(A, B):
    m, n = shape(A)
    p, q = shape(B)
    if m != n or n != p or q < 1:
        return False, "Error gauss_pp: error en las dimensiones."
    if A.dtype == complex or B.dtype == complex:
        gaussA = array(A, dtype=complex)
        gaussB = array(B, dtype=complex)
    else:
        gaussA = array(A, dtype=float)
        gaussB = array(B, dtype=float)
    for k in range(n-1):
        pos = argmax(abs(gaussA[k:, k])) # Elección del pívot (argmax da la posicion!! del maximo valor de los elementos)
        ik = pos+k # Posicion absoluta (no relativa al tamaño k-ésimo!!)
        if ik != k: # Si pivot no está en posición natural, permutamos las filas
            gaussA[[ik, k], :] = gaussA[[k, ik], :]
            gaussB[[ik, k], :] = gaussB[[k, ik], :]
        if abs(gaussA[k, k]) >= 1e-200:
            for i in range(k+1, n):
                gaussA[i, k] = gaussA[i, k]/gaussA[k, k] 
                gaussA[i, k+1:] -= gaussA[i, k]*gaussA[k, k+1:]
                gaussB[i, :] -= gaussA[i, k]*gaussB[k, :]
    exito, X = remonte(gaussA, gaussB)
    return exito, X

# Devuelve, dadas una matriz A inversible y el vector/matriz B, la solución del sistema AX = B mediante el método de Gauss-Jordan usando la estrategia de pívot parcial

def gaussjordan_pp(A, B): 
    m, n = shape(A)
    p, q = shape(B)
    if m != n or n != p or q < 1:
        return False, "Error gaussjordan_pp: error en las dimensiones."
    if A.dtype == complex or B.dtype == complex:
        gJA = array(A, dtype=complex) # a_1, a_2, a_3 ...
        gJB = array(B, dtype=complex) # b_1, b_2, b_3 ...
    else:
        gJA = array(A, dtype=float)
        gJB = array(B, dtype=float)
        
    for k in range(n):
        pos = argmax(abs(gJA[k:, k])) #argmax da la posicion del maximo valor seleccionado
        ik = pos+k
        if ik != k:
            gJA[[ik, k], :] = gJA[[k, ik], :]
            gJB[[ik, k], :] = gJB[[k, ik], :]
        if abs(gJA[k, k]) >= 1e-200:
            
            for i in range(k): #por encima de la diagonal
                gJA[i, k] = gJA[i, k]/gJA[k, k]
                gJA[i, k+1:] -= gJA[i, k]*gJA[k, k+1:]
                gJB[i, :] -= gJA[i, k]*gJB[k, :]
                
            for i in range(k+1, n): #por debajo de la diagonal
                gJA[i, k] = gJA[i, k]/gJA[k, k]
                gJA[i, k+1:] -= gJA[i, k]*gJA[k, k+1:]
                gJB[i, :] -= gJA[i, k]*gJB[k, :]
                
    if min(abs(diag(gJA))) < 1e-200:
        return False, "Error gaussjordan_pp: matriz singular"
    if A.dtype == complex or B.dtype == complex:
        X = zeros((n, q), dtype == complex)
    else:
        X = zeros((n, q), dtype = float)
    for i in range (n):
        X[i, :] = gJB[i, :]/gJA[i, i]

    return True, X

# Devuelve, dadas una matriz A inversible y el vector/matriz B, la solución del sistema AX = B mediante el método de Gauss usando la estrategia del primer pívot no nulo

def gauss_1p(A, B):
    m, n = shape(A)
    p, q = shape(B)
    if m != n or n != p or q < 1:
        return False, "Error gauss_1p: error en las dimensiones."
    if A.dtype == complex or B.dtype == complex:
        gaussA = array(A, dtype=complex) # a_1, a_2, a_3 ...
        gaussB = array(B, dtype=complex) # b_1, b_2, b_3 ...
    else:
        gaussA = array(A, dtype=float)
        gaussB = array(B, dtype=float)
    for k in range(n-1):
        for ik in range(k, n):
            if abs(gaussA[ik, k] >= 1e-200):
                break
        if ik != k:
            gaussA[[ik, k], :] = gaussA[[k, ik], :]
            gaussB[[ik, k], :] = gaussB[[k, ik], :]
        if abs(gaussA[k, k]) >= 1e-200:
            for i in range(k+1, n):
                gaussA[i, k] = gaussA[i, k]/gaussA[k, k]
                gaussA[i, k+1:] -= gaussA[i, k]*gaussA[k, k+1:]
                gaussB[i, :] -= gaussA[i, k]*gaussB[k, :]
    exito, X = remonte(gaussA, gaussB) #llama a remonte y resuelve el sistema
    return exito, X

# Devuelve, dadas una matriz A inversible y el vector/matriz B, la solución del sistema AX = B mediante el método de Gauss-Jordan usando la estrategia del primer pívot no nulo

def gaussjordan_1p(A, B):
    m, n = shape(A)
    p, q = shape(B)
    if m != n or n != p or q < 1:
        return False, "Error gaussjordan_1p: error en las dimensiones."
    if A.dtype == complex or B.dtype == complex:
        gJA = array(A, dtype=complex) # a_1, a_2, a_3 ...
        gJB = array(B, dtype=complex) # b_1, b_2, b_3 ...
    else:
        gJA = array(A, dtype=float)
        gJB = array(B, dtype=float)
    for k in range(n):
        for ik in range(k, n):
            if abs(gJA[ik, k] >= 1e-200):
                break
        pos = argmax(abs(gJA[k:, k])) #argmax da la posicion del maximo valor seleccionado
        ik = pos+k
        if ik != k:
            gJA[[ik, k], :] = gJA[[k, ik], :]
            gJB[[ik, k], :] = gJB[[k, ik], :]
        if abs(gJA[k, k]) >= 1e-200:
            for i in range(k): #por encima de la diagonal
                gJA[i, k] = gJA[i, k]/gJA[k, k]
                gJA[i, k+1:] -= gJA[i, k]*gJA[k, k+1:]
                gJB[i, :] -= gJA[i, k]*gJB[k, :]
            for i in range(k+1, n): #por debajo de la diagonal
                gJA[i, k] = gJA[i, k]/gJA[k, k]
                gJA[i, k+1:] -= gJA[i, k]*gJA[k, k+1:]
                gJB[i, :] -= gJA[i, k]*gJB[k, :]
    if min(abs(diag(gJA))) < 1e-200:
        return False, "Error gaussjordan_1p: matriz singular"
    if A.dtype == complex or B.dtype == complex:
        X = zeros((n, q), dtype == complex)
    else:
        X = zeros((n, q), dtype = float)
    for i in range (n):
        X[i, :] = gJB[i, :]/gJA[i, i]

    return True, X

def gauss_pp_verbose(A, B):
    m, n = shape(A)
    p, q = shape(B)
    if m != n or n != p or q < 1:
        return False, "Error gauss_pp_verbose: error en las dimensiones."
    if A.dtype == complex or B.dtype == complex:
        gaussA = array(A, dtype=complex)
        gaussB = array(B, dtype=complex)
    else:
        gaussA = array(A, dtype=float)
        gaussB = array(B, dtype=float)
    for k in range(n-1):
        print("\nIteración: k = ", k+1)
        pos = argmax(abs(gaussA[k:, k])) # Elección del pívot (argmax da la posicion!! del maximo valor de los elementos)
        ik = pos+k # Posicion absoluta (no relativa al tamaño k-ésimo!!)
        print("Posición pívot: ik = ", ik+1)
        if ik != k: # Si pivot no está en posición natural, permutamos las filas
            gaussA[[ik, k], :] = gaussA[[k, ik], :]
            gaussB[[ik, k], :] = gaussB[[k, ik], :]
        if abs(gaussA[k, k]) >= 1e-200:
            for i in range(k+1, n):
                gaussA[i, k] = gaussA[i, k]/gaussA[k, k] 
                gaussA[i, k+1:] -= gaussA[i, k]*gaussA[k, k+1:]
                gaussB[i, :] -= gaussA[i, k]*gaussB[k, :]
        print("Matriz A_k+1: \n", gaussA)       
    print("\nMatriz triangular (MA): \n", triu(gaussA))
    print("Segundo miembro: \n", gaussB)
    exito, X = remonte(gaussA, gaussB)
    return exito, X

def gaussjordan_pp_verbose(A, B): #método de Gauss-Jordan pivote parcial
    m, n = shape(A)
    p, q = shape(B)
    if m != n or n != p or q < 1:
        return False, "Error gaussjordan_pp_verbose: error en las dimensiones."
    if A.dtype == complex or B.dtype == complex:
        gJA = array(A, dtype=complex) # a_1, a_2, a_3 ...
        gJB = array(B, dtype=complex) # b_1, b_2, b_3 ...
    else:
        gJA = array(A, dtype=float)
        gJB = array(B, dtype=float)
        
    for k in range(n):
        print("\nIteración: k = ", k)
        pos = argmax(abs(gJA[k:, k])) #argmax da la posicion del maximo valor seleccionado
        ik = pos+k
        print("Posición pívot: ik = ", ik)
        if ik != k:
            gJA[[ik, k], :] = gJA[[k, ik], :]
            gJB[[ik, k], :] = gJB[[k, ik], :]
        if abs(gJA[k, k]) >= 1e-200:
            
            for i in range(k): #por encima de la diagonal
                gJA[i, k] = gJA[i, k]/gJA[k, k]
                gJA[i, k+1:] -= gJA[i, k]*gJA[k, k+1:]
                gJB[i, :] -= gJA[i, k]*gJB[k, :]
                
            for i in range(k+1, n): #por debajo de la diagonal
                gJA[i, k] = gJA[i, k]/gJA[k, k]
                gJA[i, k+1:] -= gJA[i, k]*gJA[k, k+1:]
                gJB[i, :] -= gJA[i, k]*gJB[k, :]
        print("Matriz A_k+1: \n", gJA)   
    print("\nMatriz triangular (MA): \n", triu(gJA))
    print("Segundo miembro: \n", gJB)
    if min(abs(diag(gJA))) < 1e-200:
        return False, "Error gaussjordan_pp_verbose: matriz singular"
    if A.dtype == complex or B.dtype == complex:
        X = zeros((n, q), dtype == complex)
    else:
        X = zeros((n, q), dtype = float)
    for i in range (n):
        X[i, :] = gJB[i, :]/gJA[i, i]

    return True, X

# Devuelve, dada la matriz A inversible, una matriz cuya parte inferior es la matriz L (cuya diagonal está formada por 1's (no se guardan)) y cuya parte superior es la matriz U.

def facto_lu(A):
    m, n = shape(A)
    if m != n :
        return False, "Error facto_lu: error en las dimensiones."
    if A.dtype == complex:
        lu = array(A, dtype=complex)
    else:
        lu = array(A, dtype=float)
    for k in range(n-1):
        if abs(lu[k, k]) >= 1e-200: # Matrzi inversible?
            for i in range(k+1, n):
                lu[i, k] = lu[i, k]/lu[k, k]
                lu[i, k+1:] -= lu[i, k]*lu[k, k+1:]             
        else:
            return False,"Error facto_lu: no existe la factorización LU"
    return True, lu

# Dada dos matrices A (inversible) y B, resuelve el sistema AX = B mediante el método LU (factorizando LU la matriz A y realizando un descenso y remonte)

def metodo_lu(A, B):
    m, n = shape(A)
    p, q = shape(B)
    if m!= n or n != p or q < 1:
        return False, "Error metodo_lu: Tamaños erróneos"
    exito,lu = facto_lu(A)
    if exito:
        ex,Y = descenso1(lu,B)
        exito1,X = remonte(lu,Y)
        if exito1:
            return True,X
        else:
            return False, "Error metodo_lu: factorización LU no inversible"
    else:
        return False, "Error metodo_lu: error en la resolucion"

# Dada una matriz A simétrica e inversible, devuelve una matriz cuya parte inferior es la matriz C y cuya parte superior es C^t (misma diagonal). Esta factorización es posible sii A es definida +

def facto_cholesky(A):
    m, n = shape(A)
    if m != n:
        return False, "Error facto_cholesky: error en las dimensiones."
    if A.dtype == complex:
        chol = array(A, dtype=complex)
    else:
        chol = array(A, dtype=float)
    for i in range(n):
        chol[i, i] -= sum(power(abs(chol[i, 0:i]), 2)) 
        if chol[i, i] >= 1e-100:
            chol[i, i] = sqrt(chol[i, i])
        else:
            return False, "Error facto_cholesky: no se factoriza la matriz"
        chol[i, i+1:] -= chol[i, 0:i]@conjugada(chol[i+1:, 0:i]) 
        chol[i, i+1:] = chol[i, i+1:]/chol[i, i]
        chol[i+1:, [i]] = conjugada(chol[i, i+1:])
    return True, chol

# Dada dos matrices A (inversible y simétrica) y B, resuelve el sistema AX = B mediante el método Cholesky (factorizando CC^t la matriz A y realizando un descenso y remonte)

def metodo_cholesky(A, B):
    exito,chol=facto_cholesky(A)
    if exito:
        exito2,Y=descenso(chol,B)
        exito3,X=remonte(chol,Y)
        if exito2 and exito3:
            return True,X
        else:
            return False, "Error metodo_cholesky: error remonte o descenso"
    else:
        return False, "Error metodo_cholesky: error en la resolución"

# Dado un vector X no nulo (real o complejo), calcula su matriz de Householder.

def householder(X):
    m , n = shape(X) 
    return eye(m) - (2/(conjugada(X)@X) * (X@conjugada(X)))

# Dada una matriz A inversible y un número p, devuelve el cond(A)_p = ||A||_p*||A^-1||_p

def condicionamiento(A,n):
    return norma_mat(A,n)*norma_mat(inv(A),n)

# Dada una matriz A inversible, el segundo miembro B, un vector inicial X0, el nº máximo de iteraciones y un error de tolerancia del test de parada,  devuelve la solucion Xk del sistema AX = B usando el método iterativo de Jacobi 

def jacobi(A, B, XOLD, itermax, tol):
    m, n = shape(A)
    p, q = shape(B)
    r, s = shape(XOLD)
    if m != n or n != p or q != 1 or n != r or s != 1 or min(abs(diag(A))) < 1e-200:
        return False, 'ERROR jacobi: no se resuelve el sistema.'
    k = 0
    error = 1.
    while k < itermax and error >= tol:
        k = k+1
        XNEW = array(B)
        for i in range(n):
            if i != 0:
                XNEW[i, 0] -= A[i, :i]@XOLD[:i, 0]
            if i != n-1:
                XNEW[i, 0] -= A[i, i+1:]@XOLD[i+1:, 0]
            XNEW[i, 0] = XNEW[i, 0]/A[i, i]
        error = norma_vec(XNEW - XOLD, inf)
        # error = norma_mat (B - A@XNEW, inf)
        XOLD = array(XNEW)
    print('\nIteración: k = ', k)
    print('Error absoluto: error = ', error)
    if k == itermax and error >= tol:
        return False, 'ERROR jacobi: no se alcanza convergencia.'
    else:
        print('Convergencia numérica alcanzada: jacobi.')
        return True, XNEW

# Dada una matriz A inversible, el segundo miembro B, un vector inicial X0, el nº máximo de iteraciones y un error de tolerancia del test de parada,  devuelve la solucion Xk del sistema AX = B usando el método iterativo de Gauss Seidel  

def gauss_seidel(A, B, XOLD, itermax, tol): # Cambia desde Jacobi X_k a X_k+1
    m, n = shape(A)
    p, q = shape(B)
    r, s = shape(XOLD)
    if m != n or n != p or q != 1 or n != r or s != 1 or min(abs(diag(A))) < 1e-200:
        return False, 'ERROR gauss_seidel: no se resuelve el sistema.'
    k = 0
    error = 1.
    while k < itermax and error >= tol:
        k = k+1
        XNEW = array(B)
        for i in range(n):
            if i != 0: #estos if's los podemos eliminar, pues entra de todos modos
                XNEW[i, 0] -= A[i, :i]@XNEW[:i, 0]
            if i != n-1: #estos if's los podemos eliminar, pues entra de todos modos
                XNEW[i, 0] -= A[i, i+1:]@XOLD[i+1:, 0]
            XNEW[i, 0] = XNEW[i, 0]/A[i, i]
        error = norma_vec(XNEW - XOLD, inf)
        XOLD = array(XNEW)
    print('\nIteración: k = ', k)
    print('Error absoluto: error = ', error)
    if k == itermax and error >= tol:
        return False, 'ERROR gauss_seidel: no se alcanza convergencia.'
    else:
        print('Convergencia numérica alcanzada: gauss-seidel.')
        return True, XNEW

# Dada una matriz A inversible, el segundo miembro B, un vector inicial X0, el parámetro de relajación, el nº máximo de iteraciones y un error de tolerancia del test de parada, devuelve la solucion Xk del sistema AX = B usando el método iterativo de relajación 

def relajacion(A, B, XOLD, omega, itermax, tol):
    (m, n) = shape(A)
    (p, q) = shape(B)
    (r, s) = shape(XOLD)
    if m != n or n != p or q != 1 or n != r or s != 1 or min(abs(diag(A))) < 1e-10:
        return False, 'ERROR relajacion: no se resuelve el sistema.'
    k = 0
    error = 1.
    while k < itermax and error >= tol:
        k = k+1
        XNEW = array(B)
        for i in range(n):
            if i != 0: #estos if's los podemos eliminar, pues entra de todos modos
                XNEW[i, 0] = XNEW[i, 0] - A[i, :i]@XNEW[:i, 0]
            if i != n-1: #estos if's los podemos eliminar, pues entra de todos modos
                XNEW[i, 0] = XNEW[i, 0] - A[i, i+1:]@XOLD[i+1:, 0]
            XNEW[i, 0] += ((1 - omega)/omega)*A[i, i]*XOLD[i, 0]
            XNEW[i, 0] = omega*XNEW[i, 0]/A[i, i]
        error = norma_vec(XNEW - XOLD, inf)
        XOLD = array(XNEW)
    print('\nIteración: k = ', k)
    print('Error: error = ', error)
    if k == itermax and error >= tol:
        return False, 'ERROR relajacion: no se resuelve el sistema.'
    else:
        print('Convergencia numérica alcanzada: relajación.')
        return True, XNEW

# Dada A una matriz, un vector inicial X0, la norma con la que realizar el proceso de iteración, el nº máximo de iteraciones y la tolerancia del test de parada, devuelve los valores de la sucesión Yk de las normas, de los cocientes y los autovectores. 
def potencia(A, X, norma, itermax, tol):
    m, n = shape(A)
    r, s = shape(X)
    if m != n or n != r or s != 1:
        return False, 'ERROR potencia: no se ejecuta el programa.', 0, 0
    k = 0
    error = 1.
    normaold = 0. # ||Y_k||
    if A.dtype == complex or X.dtype == complex:
        lambdas = zeros(n, dtype=complex)
    else:
        lambdas = zeros(n, dtype=float)
    while k < itermax and error >= tol:
        k = k+1
        Y = A@X
        normanew = norm(Y, ord=norma) # = norma_vec(inf)
        error = abs(normanew - normaold)
        for i in range(n):
            if abs(X[i, 0]) >= 1.e-100:
                lambdas[i] = Y[i, 0]/X[i, 0]
            else:
                lambdas[i] = 0.
        X = Y/normanew
        print('\nIteración: k = ', k)
        print('Norma: ||A*X_k|| = ', normanew) # deben converger hacia el autovalor dominante en módulo
#        print('Lambdas: lambdas_k = \n', lambdas)
#        print('Vectores: X_k = \n', X)
        normaold = normanew
    if k == itermax and error >= tol:
        return False, 'ERROR potencia: no se alcanza convergencia.', 0, 0
    else:
        print('Método de la potencia: convergencia numérica alcanzada.')
        return True, normanew, lambdas, X
    
# Análogo al anterior para la matriz A^-1

def potenciainv(A, X, norma, itermax, tol):
    m, n = shape(A)
    r, s = shape(X)
    if m != n or n != r or s != 1:
        return False, 'ERROR potenciainv: no se ejecuta el programa.', 0, 0
    exito, LU = facto_lu(A)
    if not exito:
        return False, 'ERROR potenciainv: sin factorización LU.', 0, 0
    k = 0
    error = 1.
    normaold = 0.
    if A.dtype == complex or X.dtype == complex:
        lambdas = zeros(n, dtype=complex)
    else:
        lambdas = zeros(n, dtype=float)
    while k < itermax and error >= tol:
        k = k+1
        exito, Y = descenso1(LU, X)
        exito, Y = remonte(LU, Y)
        if not exito:
            return False, 'ERROR potenciainv: sin factorización LU.', 0, 0
        normanew = norm(Y, ord=norma)
        error = abs(normanew - normaold)
        for i in range(n):
            if abs(X[i, 0]) >= 1e-100:
                lambdas[i] = Y[i, 0]/X[i, 0]
            else:
                lambdas[i] = 0.
        X = Y/normanew
        print('\nIteración: k = ', k)
        print('Norma: ||A-1*X_k|| = ', normanew)
#        print('Lambdas: lambdas_k = ', lambdas)
#        print('Vectores: X_k = ', X)
        normaold = normanew
    if k == itermax and error >= tol:
        return False, 'ERROR potenciainv: no se alcanza convergencia.', 0, 0
    else:
        print('Método de la potencia inversa: convergencia numérica alcanzada.')
        return True, normanew, lambdas, X

# Consiste en aplicar el método de la potencia a A-yI (siendo des el parametro de entrada para el desplazamiento)
def potenciades(A, X, des, norma, itermax, tol):
    m, n = shape(A)
    r, s = shape(X)
    if m != n or n!= r or s != 1:
        return False, 'ERROR potenciades: no se ejecuta el programa.', 0, 0
    B = A - des*eye(n)
    exito, normanew, lambdas, X = potencia(B, X, norma, itermax, tol)
    return exito, normanew, lambdas, X 

# Análogo al método anterior para la matriz A^-1

def potenciadesinv(A, X, des, norma, itermax, tol):
    m, n = shape(A)
    r, s = shape(X)
    if m != n or n!= r or s != 1:
        return False, 'ERROR potenciadesinv: no se ejecuta el programa.', 0, 0
    B = A - des*eye(n)
    exito, normanew, lambdas, X = potenciainv(B, X, norma, itermax, tol)
    return exito, normanew, lambdas, X