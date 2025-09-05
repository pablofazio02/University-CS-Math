-------------------------------------------------------------------------------
-- Estructuras de Datos. 2º ETSI Informática. UMA
-- Práctica 2
--
-- Alumno: FAZIO ARRABAL, PABLO
-------------------------------------------------------------------------------

module Practica2 where

import           Data.List
import           Test.QuickCheck

-------------------------------------------------------------------------------
-- Ejercicio 2 - máximoYResto
-------------------------------------------------------------------------------

máximoYRestoOrden :: Ord a => [a] -> (a,[a])
máximoYRestoOrden [] = error "lista vacía"
máximoYRestoOrden xs = (maximum xs, borra xs)

borra:: Ord a => [a] -> [a]
borra [] = []
borra [x] = []
borra (x:xs) | (maximum xs) == x = xs
             | otherwise = [x] ++ borra xs


máximoYResto :: Ord a => [a] -> (a,[a])
máximoYResto [] = error "lista vacía"
máximoYResto [x] = (x,[])
máximoYResto (x:xs) | x > m = (x, m:rs)
                    | otherwise = (m, x:rs)
   where
     (m, rs) = máximoYResto xs

{-
máximoYResto [] = error "lista vacía"
máximoYResto [x] = (x,[])
máximoYResto (x:xs) = if maximum xs <= x then (x,xs) else máximoYResto (xs ++ [x])
-}

-------------------------------------------------------------------------------
-- Ejercicio 3 - reparte
-------------------------------------------------------------------------------

reparte :: [a] -> ([a], [a])
reparte [] = ([],[])
reparte [x] = ([x], [])
reparte (x:y:xs) = (x:lista1, y:lista2)
    where
     (lista1,lista2) = reparte xs

-------------------------------------------------------------------------------
-- Ejercicio 4 - distintos
-------------------------------------------------------------------------------

distintos :: Eq a => [a] -> Bool
distintos [] = True
distintos (x:xs) = notElem x xs && distintos xs

-------------------------------------------------------------------------------
-- Ejercicio 13 - hoogle
-------------------------------------------------------------------------------

-- Hoogle (https://www.haskell.org/hoogle/) es un buscador para el API de Haskell.
-- Usa Hoogle para encontrar información sobre las funciones 'and', y 'zip'

desconocida :: Ord a => [a] -> Bool
desconocida xs = and [ x <= y | (x, y) <- zip xs (tail xs) ]

{-
Comentario: La función and es una conjunción lógica como &&
pero entre listas, si en alguna lista el Bool es False, lo será
la función. 
Dentro de cada lista se debe cumplir que al tomar duplas
del conjunto (lista, cola de la lista), el elemento cogido de la cola de la
lista debe ser mayor o igual que el elemento de la lista
por tanto es claro que lo que debe pasar:
Para que la función sea True, el primer elemento de la lista sea el
mínimo de la lista y haga creciente a la lista.
-}

-------------------------------------------------------------------------------
-- Ejercicio 14 - inserta y ordena
-------------------------------------------------------------------------------

-- 14.a - usando takeWhile y dropWhile
inserta :: Ord a => a -> [a] -> [a]
inserta x xs = takeWhile (<x) xs ++ [x] ++ dropWhile (<x) xs

-- 14.b - mediante recursividad
insertaRec :: Ord a => a -> [a] -> [a]
insertaRec x [] = [x]
insertaRec x (y:xs) | x <= y = [x] ++ (y:xs)
                    | otherwise = [y] ++ insertaRec x xs

-- 14.c

-- La línea de abajo no compila hasta que completes los apartados
-- anteriores.

p1_inserta x xs = desconocida xs ==> desconocida (inserta x xs)

-- 14.e - usando foldr
ordena :: Ord a => [a] -> [a]
ordena xs = foldr inserta [] xs
  
-- 14.f
prop_ordena_OK xs = ordena xs == sort xs
-- prop_ordena_OK xs = desconocida (ordena xs)

-------------------------------------------------------------------------------
-- Ejercicio 21 - nub
-------------------------------------------------------------------------------

-- 21.a
nub' :: Eq a => [a] -> [a]
nub' xs = foldr f [] xs
   where
       f cab solCola
         | not(elem cab solCola) = [cab] ++ solCola  
         | otherwise = solCola

-- 21.b
p_nub' xs = nub xs == nub' xs

-- 21.c (distintos se define en el ejercicio 4)

p_sinRepes xs = distintos (nub' xs)

{-

Escribe aquí tu razonamiento de por qué p_sinRepes no
es suficiente para comprobar que nub' es correcta:

La función distintos verifica que dada una lista todos los
elementos son diferentes entre sí, necesario para nuestro nub'
pero no verifica totalmente la corrección ya que esta función
no comprueba elementos de la lista inicial que no se hayan añadido
y sean únicos en la primera lista, por ejemplo.

-}

-- 21.d
todosEn :: Eq a => [a] -> [a] -> Bool
ys `todosEn` xs = all (`elem` xs) ys

p_sinReps' xs = todosEn xs (nub' xs) && distintos (nub' xs)
