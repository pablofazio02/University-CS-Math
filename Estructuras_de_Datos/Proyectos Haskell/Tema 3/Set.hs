------------------------------------------------------------
-- Estructuras de Datos
-- Tema 3. Estructuras de Datos Lineales
-- Pablo López
--
-- Módulo del TAD Conjunto (para tipos ordenados)
------------------------------------------------------------

------------------------------------------------------------
-- Implementación del TAD Conjunto (para tipos ordenados)
------------------------------------------------------------

module Set(Set,
           empty,
           isEmpty,
           insert,
           isElem,
           delete,
           union,
           fold
          ) where

import           Test.QuickCheck

data Set a = Empty
           | Node a (Set a)
           deriving (Show, Eq)

{-
   * Eligiendo la representación interna del TAD Conjunto:

   Queremos utilizar el tipo algebraico `Set` arriba definido para
   representar conjuntos como el siguiente:

        insert 7 (insert 1 (insert 2 (insert 1 (insert 5 empty))))

   Observa que al construir el conjunto los elementos no se han
   facilitado en orden y, además, uno de los elementos aparece
   repetido.

   El implementador del TAD Conjunto debe decidir cómo representar el
   conjunto anterior. Por ejemplo, puede decidir representar los
   conjuntos apilando los elementos conforme se insertan:

        Node 7 (Node 1 (Node 2 (Node 1 (Node 5 Empty))))

   esto significa que la representación puede contener elementos
   repetidos.

   Otra posibilidad es que el implementador decida almacenar los
   elementos ordenados y sin repeticiones:

        Node 1 (Node 2 (Node 5 (Node 7 Empty)))

   Ambas representaciones son correctas, aunque obviamente no son
   equivalentes.

   Ejercicio: ¿Qué ventajas e inconvenientes tiene cada una de estas
   representaciones internas? ¿Cómo afecta al usuario la elección?

   * Invariante de representación:

   Un invariante de representación de un TAD es una propiedad
   (booleana) sobre la representación interna del TAD.

   Este invariante debe ser cierto para todo valor del TAD:

     - antes de aplicar una operación pública del TAD
     - después de aplicar una operación pública del TAD

   sin embargo, el invariante puede ser falso durante la aplicación de
   una operación pública o al aplicar operaciones privadas.

   En la práctica, esto significa que todo valor del TAD que manipula
   el código del cliente satisface el invariante, pues ha sido
   construido por las operaciones públicas del TAD.

   La primera representación que hemos propuesto antes, basada en
   apilar elementos conforme se insertan:

        Node 7 (Node 1 (Node 2 (Node 1 (Node 5 Empty))))

   no satisface ningún invariante interesante.

   Sin embargo, la segunda representación:

        Node 1 (Node 2 (Node 5 (Node 7 Empty)))

   satisface un invariante muy importante: los elementos aparecen
   ordenados y sin repetidos.

   Es obligación del implementador del TAD asegurar que todos los
   valores del TAD satisfacen este invariante. Mantener este
   invariante supone un esfuerzo adicional, pero se ve recompensado
   porque simplifica la implementación de ciertas operaciones y mejora
   la eficiencia.
-}

-- invariante: ordenado y sin repetidos
sample1 :: Set Char
sample1 = Node 'a' (Node 'c' (Node 'f' (Node 'z' Empty)))

-- complejidad: O(1)
-- |
-- >>> empty
-- Empty
empty :: Set a
empty = Empty

-- complejidad: O(1)
-- |
-- >>> isEmpty empty
-- True
-- >>> isEmpty sample
-- False
isEmpty :: Set a -> Bool
isEmpty Empty = True
isEmpty _ = False

-- complejidad: O(n)
-- |
-- >>> isElem 'x' sample
-- False
-- >>> isElem 'f' sample
-- True
isElem :: Ord a => a -> Set a -> Bool
isElem x Empty = False
isElem x (Node y s) | x == y = True
                    | x > y = isElem x s
                    | otherwise = False

-- complejidad: O(n)
-- |
-- >>> insert 'x' sample
-- Node 'a' (Node 'c' (Node 'f' (Node 'x' (Node 'z' Empty))))
-- >>> insert 'a' sample
-- Node 'a' (Node 'c' (Node 'f' (Node 'z' Empty)))
insert :: Ord a => a -> Set a -> Set a
insert x Empty = Node x Empty
insert x (Node y s) | x==y = Node y s
                    | x < y = Node x (Node y s)
                    | otherwise = Node y (insert x s)


-- complejidad: O(n)
-- |
-- >>> delete 'x' sample
-- Node 'a' (Node 'c' (Node 'f' (Node 'z' Empty)))
-- >>> delete 'f' sample
-- Node 'a' (Node 'c' (Node 'z' Empty))
delete :: Ord a => a -> Set a -> Set a
delete _ Empty = Empty
delete x (Node y s) | x==y = s
                    | x<y = (Node y s)
                    | x>y =  insert y (delete x s)

-- complejidad: O(n)
-- |
-- > union sample sample
-- Node 'a' (Node 'c' (Node 'f' (Node 'z' Empty)))
-- > union sample (insert 'w' (insert 'f' empty))
-- Node 'a' (Node 'c' (Node 'f' (Node 'w' (Node 'z' Empty))))
union :: Ord a => Set a -> Set a -> Set a
union Empty s2 = s2
union s1 Empty = s1
union (Node x s1) (Node y s2) | x < y = Node x (union s1 (Node y s2))
                              | x > y = Node y (union (Node x s1) s2)
                              | x == y = Node x (union s1 s2)
                         

-- complejidad: O(n)
fold :: (a -> b -> b) -> b -> Set a -> b
fold f z s = recSet s
  where
    recSet Empty      = z
    recSet (Node x s) = f x (recSet s)

{-
   La siguiente instancia de `Arbitrary` es para enseñar a QuickCheck
   a generar `Sets` aleatorios: no hay que saber cómo hacerlo; siempre
   se facilita
-}

instance (Ord a, Arbitrary a) => Arbitrary (Set a) where
  arbitrary = do
                xs <- listOf arbitrary
                return (foldr insert empty xs)
