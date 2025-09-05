------------------------------------------------------------
-- Estructuras de Datos
-- Tema 4. Árboles
-- Pablo López
--
-- Plegados de árboles de búsqueda en Haskell
------------------------------------------------------------

module BSTFolds where

import           DataStructures.Graphics.DrawTrees
import           DataStructures.SearchTree.BST

{-
   Disponemos de tres plegados para árboles binarios de búsqueda,
   según el orden en que se visiten los nodos:

     foldPreOrder :: (a -> b -> b) -> b -> BST a -> b
     foldInOrder :: (a -> b -> b) -> b -> BST a -> b
     foldPostOrder :: (a -> b -> b) -> b -> BST a -> b

   Observa que el tipo de las tres funciones es idéntico. Su
   funcionamiento es similar al de otros plegados.

   Para el caso base (BST vacío), la solución viene dada por el
   segundo parámetro:

                        BST a plegar    tipo de la solución
                                \         /
          (a -> b -> b) -> b -> BST a -> b
                            \
                   solución para el caso base

   Para el caso recursivo, la función de plegado va añadiendo uno a
   uno nodos a la solución de los nodos ya visitados:

                        BST a plegar    tipo de la solución
                                \         /
          (a -> b -> b) -> b -> BST a -> b
          /      \
    nodo que se   \
   está visitando  \
    actualmente     solución para los nodos ya visitados
                    (los que suceden al que se se está visitando actualmente)
-}

t0 :: BST Integer
t0 = mkBST [0, -3, 5]

t1 :: BST Integer
t1 = mkBST [6, 5, 7, 3, 4, 10, 8]

-- |
-- >>> sumBST t0
-- 2
-- >>> sumBST t1
-- 43
sumBST :: Num b => BST b -> b
sumBST r = foldInOrder (+) 0 r

-- |
-- >>> weightBST t1
-- 7
weightBST :: BST a -> Integer
weightBST r = foldInOrder f 0 r
 where
     f sol solResto = 1 + solResto

-- |
-- >>> maxBST t0
-- Just 5
-- maxBST empty
-- Nothing
maxBST :: Ord a => BST a -> Maybe a
maxBST t = undefined

-- |
-- >>> evenBST t1
-- [6,4,10,8]
evenBST :: Integral a => BST a -> [a]
evenBST = undefined

-- |
-- >>> filterBST odd t1
-- [5,3,7]
filterBST :: (a->Bool) -> BST a -> [a]
filterBST = undefined
