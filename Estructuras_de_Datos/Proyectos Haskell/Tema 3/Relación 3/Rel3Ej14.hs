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
import qualified DataStructures.Queue.LinearQueue as Q
import Test.QuickCheck

foldrStack :: (a -> b -> b) -> b -> S.Stack a -> b
foldrStack f z s
 | S.isEmpty s = z
 | otherwise = S.top s `f` foldrStack f z (S.pop s)

foldrQueue :: (a -> b -> b) -> b -> Q.Queue a -> b
foldrQueue f z q 
 | Q.isEmpty q = z
 | otherwise = f (Q.first q) (foldrQueue f z (Q.dequeue q))

listToQueue :: [a] -> Q.Queue a
listToQueue xs = foldr f Q.empty xs
    where
        f cab solCola = Q.enqueue cab solCola

stackToQueue :: S.Stack a -> Q.Queue a
stackToQueue xs = foldrStack f Q.empty xs
    where 
        f cab solCola = Q.enqueue cab solCola

queueToStack :: Q.Queue a -> S.Stack a 
queueToStack xs = foldrQueue f S.empty xs
    where
        f cab solCola = S.push cab solCola

queueToList :: Q.Queue a -> [a]
queueToList xs = foldrQueue f [] xs
    where
        f cab solCola = cab:solCola 

mapQueue :: (a -> b) -> Q.Queue a -> Q.Queue b
mapQueue f q = foldrQueue g Q.empty q
   where
       g cab solCola = Q.enqueue (f cab) solCola