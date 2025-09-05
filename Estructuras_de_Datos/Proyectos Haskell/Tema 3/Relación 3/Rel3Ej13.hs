-------------------------------------------------------------------------------
-- Estructuras de Datos. 2º Curso. ETSI Informática. UMA
--
-- 
-- Titulación: Doble Grado en Ingeniería Informática y  Matemáticas
-- Alumno: Fazio Arrabal, Pablo
-- Fecha de entrega: 30 | 11 | 2021
--
-- Relación de Ejercicios 3. Ejercicios resueltos.
--
-------------------------------------------------------------------------------

module FoldStackQueue where
import qualified DataStructures.Stack.LinearStack as S
import Test.QuickCheck

foldrStack :: (a -> b -> b) -> b -> S.Stack a -> b
foldrStack f z s
 | S.isEmpty s = z
 | otherwise = S.top s `f` foldrStack f z (S.pop s)

-- APARTADO A)

listToStack :: [a]-> S.Stack a
listToStack xs = foldr f S.empty xs
   where
       f cab solCola = S.push cab solCola

stackToList :: S.Stack a -> [a]
stackToList xs = foldrStack  f [] xs
   where 
       f top solResto = top:solResto

-- APARTADO B)

prop_complementario1 xs = (stackToList (listToStack xs) == xs)
prop_complementario2 xs = (listToStack (stackToList xs) == xs)

-- APARTADO C)

mapStack :: (a -> b) -> S.Stack a -> S.Stack b
mapStack f s = foldrStack func S.empty s
   where
       func top solResto = S.push (f top) solResto

-- APARTADO D)

sizeStack :: S.Stack a -> Int
sizeStack xs = foldrStack f 0 xs
   where
       f top solResto = 1 + solResto

-- APARTADO E)

prop_complementarios f s = (sizeStack (mapStack f s) == sizeStack s)