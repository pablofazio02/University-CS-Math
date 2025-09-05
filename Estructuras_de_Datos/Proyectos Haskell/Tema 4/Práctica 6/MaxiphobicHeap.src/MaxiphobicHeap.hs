-------------------------------------------------------------------------------
-- Estructuras de Datos. 2º Curso. ETSI Informática. UMA
--
-- PRACTICA 6. Montículos maxifóbicos en Haskel
--
-- Alumno: Fazio Arrabal, Pablo
-------------------------------------------------------------------------------

-- Solo tienes que completar el código de la función 'merge' de acuerdo con
-- las explicaciones del enunciado.

module MaxiphobicHeap
  ( Heap
  , empty
  , isEmpty
  , minElem
  , delMin
  , insert
  , merge
-- los siguientes son auxiliares
  , mkHeap
  , verifyOP
  , drawOnWith
  ) where

import           DataStructures.Graphics.DrawTrees
import           Test.QuickCheck

data Heap a = Empty | Node a Int (Heap a) (Heap a) deriving Show

-- number of elements
size :: Heap a -> Int
size Empty           = 0
size (Node _ sz _ _) = sz

empty :: Heap a
empty  = Empty

isEmpty :: Heap a -> Bool
isEmpty Empty = True
isEmpty _     = False

singleton :: a -> Heap a
singleton x  = Node x 1 Empty Empty

insert :: (Ord a) => a -> Heap a -> Heap a
insert x h  = merge h (singleton x)

minElem :: Heap a -> a
minElem Empty          = error "minElem on empty heap"
minElem (Node x _ _ _) = x

delMin :: (Ord a) => Heap a -> Heap a
delMin Empty            = error "delMin on empty heap"
delMin (Node _ _ lh rh) = merge lh rh

----------------------------------------------------------
-- VVVVVVVVVVVV-SOLO TOCAR ABAJO-VVVVVVVVVVVV-------------
----------------------------------------------------------

-- recursively merges smallest subheaps. Achieves O(log n) complexity
merge :: (Ord a) => Heap a -> Heap a -> Heap a
merge Empty x  = x
merge  y Empty = y
merge h1@(Node x1 y1 l1 r1) h2@(Node x2 y2 l2 r2) | x1 <= x2 = Node x1 (y1+y2) masPesado (merge ligero1 ligero2) 
                                                  | otherwise = Node x2 (y1+y2) masPesado' (merge ligero1' ligero2') -- merge h2 h1

 where 
   (masPesado, ligero1, ligero2) = ordena3 l1 r1 h2
   (masPesado', ligero1', ligero2') = ordena3 l2 r2 h1


ordena3 :: Heap a -> Heap a -> Heap a -> (Heap a, Heap a, Heap a)
ordena3 l r h | size l >= size r && size l >= size h = (l, r, h)
              | size r >= size h = (r,l,h)
              | otherwise = (h,l,r)

----------------------------------------------------------
-- ^^^^^^^^^^^^^^-- SOLO TOCAR ARRIBA ^^^^^^^^^^^ --------
----------------------------------------------------------

-- Efficient O(n) bottom-up construction for heaps
mkHeap :: (Ord a) => [a] -> Heap a
mkHeap []  = empty
mkHeap xs  = mergeLoop (map singleton xs)
  where
    mergeLoop [h] = h
    mergeLoop hs  = mergeLoop (mergePairs hs)

    mergePairs []        = []
    mergePairs [h]       = [h]
    mergePairs (h:h':hs) = merge h h' : mergePairs hs

-------------------------------------------------------------------------------
-- Generating arbitrary Heaps
-------------------------------------------------------------------------------

instance (Ord a, Arbitrary a) => Arbitrary (Heap a) where
  arbitrary  = do
    xs <- arbitrary
    return (mkHeap xs)

-------------------------------------------------------------------------------
-- Invariants
-------------------------------------------------------------------------------

verifyOP :: (Ord a) => Heap a -> Bool
verifyOP Empty             = True
verifyOP (Node x _ lh rh)  = x `lessEq` lh && x `lessEq` rh
                           && verifyOP lh && verifyOP rh
 where
  x `lessEq` Empty           = True
  x `lessEq` (Node x' _ _ _) = x<=x'

-------------------------------------------------------------------------------
-- Drawing a Heap
-------------------------------------------------------------------------------

instance Subtrees (Heap a) where
  subtrees Empty            = []
  subtrees (Node _ _ lh rh) = [lh,rh]

  isEmptyTree Empty = True
  isEmptyTree _     = False

instance (Show a) => ShowNode (Heap a) where
  showNode (Node x _ _ _) = show x

drawOnWith :: FilePath -> (a -> String) -> Heap a -> IO ()
drawOnWith file toString = _drawOnWith file showHeap
 where
  showHeap (Node x _ _ _) = toString x
