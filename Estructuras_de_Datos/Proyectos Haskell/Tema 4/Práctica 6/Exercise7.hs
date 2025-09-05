-------------------------------------------------------------------------------
-- Estructuras de Datos. 2º ETSI Informática. UMA
-- Práctica 6 - Árboles generales en Haskell
--
-- Alumno: Fazio Arrabal, Pablo
-------------------------------------------------------------------------------

module Exercise7 where

import qualified DataStructures.Queue.LinearQueue as Q

data Tree a = Empty
            | Node a [Tree a]
            deriving Show

gtree1 :: Tree Int
gtree1 =
  Node 1 [ Node 2 [ Node 4 [ ]
                  , Node 5 [ ]
                  , Node 6 [ ]
                  ]
         , Node 3 [ Node 7 [ ] ]
         ]

-- |
-- >>> levels gtree1
-- [1,2,3,4,5,6,7]
levels :: Tree a -> [a]
levels Empty = []
levels t = lista (Q.enqueue t Q.empty)
 where 
   lista q | Q.isEmpty q = []
           | otherwise = root : lista (encolarHijos hs (Q.dequeue q))
     where
       (Node root hs) = Q.first q

encolarHijos :: [Tree a] -> Q.Queue (Tree a) -> Q.Queue (Tree a)
encolarHijos [] q = q
encolarHijos (t:ts) q = encolarHijos ts (Q.enqueue t q)
