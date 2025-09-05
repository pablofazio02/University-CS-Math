-------------------------------------------------------------------------------
-- Topological Sorting of a Graph
--
-- Data Structures. Grado en Informática. UMA.
-- Pepe Gallardo, 2012
-------------------------------------------------------------------------------

module DataStructures.Graph.TopologicalSortingDic
  ( topSorting
  , topSortings
  ) where

import DataStructures.Graph.DiGraph
import DataStructures.Dictionary.AVLDictionary as D
import Data.List((\\))

-- Decrement 1 the value associated to key v
decrementValue :: (Num b, Ord a) => a -> Dictionary a b -> Dictionary a b
decrementValue v dic = D.insert v (u-1) dic
    where
    Just u = D.valueOf v dic

-- Remove all keys from the dic
removeKeys :: (Ord a) => [a] -> Dictionary a b -> Dictionary a b
removeKeys keys dic = foldr D.delete dic keys

list2Dic :: Ord a => [(a,b)] -> Dictionary a b
list2Dic xs = foldr (\ (k,v) d -> D.insert k v d) D.empty xs
  

topSorting :: (Ord a) => DiGraph a -> [a]
topSorting g  = aux initPenPred
 where
  initPenPred = list2Dic [(v, inDegree g v) | v <- vertices g]
  aux pendingPred
    | D.isEmpty pendingPred = []
    | null srcs    = error "DiGraph is cyclic"
    | otherwise  = srcs ++ aux pendingPred'
    where
      srcs = [v | (v,0) <- D.keysValues pendingPred]
      dicWithoutSrcs = removeKeys srcs pendingPred
      sucScrs = concat [ successors g s| s <- srcs]
      pendingPred' = foldr decrementValue dicWithoutSrcs sucScrs -- restar sucesores de las fuentes

-- Include information of parallel tasks
topSortings :: (Ord a) => DiGraph a -> [[a]]
topSortings g  =  aux initPenPred
 where
  initPenPred = list2Dic [(v, inDegree g v) | v <- vertices g]
  aux pendingPred
    | D.isEmpty pendingPred = []
    | null srcs    = error "DiGraph is cyclic"
    | otherwise  = srcs : aux pendingPred'
    where
      srcs = [v | (v,0) <- D.keysValues pendingPred]
      dicWithoutSrcs = removeKeys srcs pendingPred
      sucScrs = concat [ successors g s| s <- srcs]
      pendingPred' = foldr decrementValue dicWithoutSrcs sucScrs -- restar sucesores de las fuentes
       
