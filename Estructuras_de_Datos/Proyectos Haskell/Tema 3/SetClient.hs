------------------------------------------------------------
-- Estructuras de Datos
-- Tema 3. Estructuras de Datos Lineales
-- Pablo López
--
-- Módulo cliente del TAD Conjunto
------------------------------------------------------------

module SetClient where

import           Data.Char                          (toUpper)
import           DataStructures.Set.SortedLinearSet

-- |
-- >>> mkSet [1..10]
-- SortedLinearSet(1,2,3,4,5,6,7,8,9,10)
-- mkSet "abracadabra"
-- SortedLinearSet('a','b','c','d','r')
mkSet :: Ord a => [a] -> Set a
mkSet xs = foldr insert empty xs

primos :: Set Integer
primos = mkSet [13, 7, 3, 2, 5, 11, 19]

-- |
-- >>> cardinal primos
-- 7
-- >>> cardinal (mkSet "abracadabra")
-- 5
cardinal :: Set a -> Integer  
cardinal s = fold (\_ sol -> 1 + sol) 0 s

-- |
-- >>> suma primos
-- 60
suma :: Num a => Set a -> a
suma s = fold (+) 0 s

-- Bieeen la ha puesto como yo quiero

-- |
-- >>> setToList primos
-- [2,3,5,7,11,13,19]
setToList :: Set a -> [a]
setToList s = fold (:) [] s

-- Realmente no importa el orden, más eficiente al comienzo

-- |
-- >>> filtra even primos
-- SortedLinearSet(2)
-- >>> filtra (\ x -> x `mod` 5 == 0) (mkSet [1..100])
-- SortedLinearSet(5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100)
filtra :: Ord a => (a -> Bool) -> Set a -> Set a
filtra func s = fold f empty s
   where 
       f x solResto = if func x then insert x solResto else solResto


-- HACERLOS A PARTIR DE AQUÍ!!!
-- |
-- >>> union' primos primos
-- SortedLinearSet(2,3,5,7,11,13,19)
-- >>> union primos (mkSet [1..10])
-- SortedLinearSet(1,2,3,4,5,6,7,8,9,10,11,13,19)
union' :: Ord a => Set a -> Set a -> Set a
union' = undefined

-- |
-- >>> aplica (*2) primos
-- SortedLinearSet(4,6,10,14,22,26,38)
-- >>> aplica toUpper (mkSet "abracadabra")
-- SortedLinearSet('A','B','C','D','R')
aplica :: (Ord a, Ord b) => (a->b) -> Set a -> Set b
aplica = undefined

-- |
-- >>>  maximo primos
-- Just 19
-- >>> maximo (mkSet "abracadabra")
-- Just 'r'
-- maximo empty
-- Nothing
maximo :: Ord a => Set a -> Maybe a
maximo = undefined
