----------------------------------------------------------------
-- Lenguajes de Programación
-- 4 del Grado en Ingeniería Informática, mención en Computación
-- Pablo Fazio Arrabal
----------------------------------------------------------------

{-# LANGUAGE DeriveFoldable #-}
{-# LANGUAGE DeriveFunctor  #-}

module TwoThreeTree where


data TwoThreeTree a = Empty
                    | Leaf a
                    | Two a (TwoThreeTree a) (TwoThreeTree a)
                    | Three a a (TwoThreeTree a)  (TwoThreeTree a) (TwoThreeTree a)
                   deriving (Show, Functor, Foldable)


tree :: TwoThreeTree Int
tree = Three 1 10
             (Two 2
                  (Leaf 3)
                  (Two 4
                       Empty
                       (Leaf 4)))
             (Three 5 50
                 (Leaf 6)
                 (Leaf 7)
                 (Leaf 8))
             (Two 9
                 (Leaf 10)
                 Empty
             )

-- |
-- >>> aplica (*2) tree
-- >>> Three 2 20 (Two 4 (Leaf 6) (Two 8 Empty (Leaf 8))) (Three 10 100 (Leaf 12) (Leaf 14) (Leaf 16)) (Two 18 (Leaf 20) Empty)

aplica :: (a -> b) -> TwoThreeTree a -> TwoThreeTree b
aplica _ Empty = Empty
aplica f (Leaf x) = Leaf (f x)
aplica f (Two x y z) = Two (f x) (aplica f y) (aplica f z)
aplica f (Three x y z r t) = Three (f x) (f y) (aplica f z) (aplica f r) (aplica f t) 

-- |
-- >>> plegar 0 id (\ x si sd -> x + si + sd) (\ x y si sc sr -> x + y + si + sc + sr ) tree
-- >>> 119

-- MEJOR PLEGADO!!!

plegar :: b -> (a ->b) -> (a -> b -> b -> b) -> (a -> a -> b -> b -> b -> b) -> TwoThreeTree a -> b
plegar s l two three t = recTree23 t
    where
        recTree23 Empty = s
        recTree23 (Leaf x) = l x
        recTree23 (Two x y z) = two x (recTree23 y) (recTree23 z)
        recTree23 (Three x y z r t) = three x y (recTree23 z) (recTree23 r) (recTree23 t)

-- |
-- >>> plegar (+) 0 tree
-- >>> 119

-- plegar :: (a -> b -> b) -> b -> TwoThreeTree a -> b
-- plegar _ s Empty = s
-- plegar f s (Leaf x) = f x s
-- plegar f s (Two x y z) = f x (plegar f (plegar f s y) z)
-- plegar f s (Three x y z r t) = f x (f y (plegar f (plegar f (plegar f s z) r) t))