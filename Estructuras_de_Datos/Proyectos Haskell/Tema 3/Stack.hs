------------------------------------------------------------
-- Estructuras de Datos
-- Tema 3. Estructuras de Datos Lineales
-- Pablo López
--
-- Módulo del TAD Stack
------------------------------------------------------------

------------------------------------------------------------
-- Implementación del TAD Stack
------------------------------------------------------------

module Stack(Stack, empty, push, top, pop, isEmpty) where

import           Test.QuickCheck

data Stack a = Empty
             | Node a (Stack a)
             deriving (Show, Eq)

customers :: Stack String
--                 top
customers = Node "peter" (Node "mary" (Node "john" Empty))

-- Complejidad: O(1)
-- |
-- >>> empty
-- Empty
empty :: Stack a
empty = Empty

-- Complejidad: O(1)
-- |
-- | push "frank" customers
-- Node "frank" (Node "peter" (Node "mary" (Node "john" Empty)))
push :: a -> Stack a -> Stack a
push a xs = Node a xs

-- Complejidad: O(1)
-- |
-- >>> pop customers
-- Node "mary" (Node "john" Empty)
pop :: Stack a -> Stack a
pop Empty = error "No hay elementos"
pop (Node _ p) = p

-- Complejidad: O(1)
-- |
-- >>> top customers
-- "peter"
top :: Stack a -> a
top Empty = error "No hay elementos"
top (Node x p) = x

-- Complejidad: O(1)
-- |
-- >>> isEmpty empty
-- True
--
-- isEmpty customers
-- False
isEmpty :: Stack a -> Bool
isEmpty Empty = True
isEmpty (_) = False

-- esto es para enseñar a QuickCheck a generar Stack aleatorias:
-- no hay que saber cómo hacerlo; siempre se facilita

instance Arbitrary a => Arbitrary (Stack a) where
  arbitrary =  do
                xs <- listOf arbitrary
                return (foldr push empty xs)
