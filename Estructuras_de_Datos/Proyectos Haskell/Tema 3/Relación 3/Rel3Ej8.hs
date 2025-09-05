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

module QueueP(QueueP,
             isEmpty,
             empty,
             enqueue,
             first,
             dequeue
             ) where

import           Test.QuickCheck

data QueueP a = Empty
             | Node a (QueueP a)
             deriving (Eq, Show)


empty :: QueueP a
empty = Empty

isEmpty :: QueueP a -> Bool
isEmpty Empty = True
isEmpty _ = False

first :: QueueP a -> a
first Empty = error "No existe primer elemento"
first (Node x xs) = x

dequeue :: QueueP a -> QueueP a
dequeue Empty = Empty
dequeue (Node x xs) = xs

enqueue :: (Ord a) => a -> QueueP a -> QueueP a
enqueue a Empty = Node a Empty
enqueue a (Node x xs) | a >= x = Node x (enqueue a xs)
                      | otherwise = Node a (Node x xs)

