-------------------------------------------------------------------
-- Estructuras de Datos
-- Grados en Ingeniería Informática, del Software y de Computadores
-- Tema 2. Características de la Programación Funcional
-- Pablo López
-------------------------------------------------------------------

module Tema2Plegados where

import           Data.Char
import           Data.List
import           Test.QuickCheck

{-
   Contenido:

    14. Plegado a la derecha
    15. Plegado a la izquierda

    Ejercicios sobre listas.
-}

-- | 14. Plegado a la derecha
------------------------------------------------------------

{-
   Recuerda que la mayoría de las funciones recursivas sobre listas
   siguen el siguiente esquema en Haskell:

          fun []     = solCasoBase
          fun (x:xs) = añadir x (fun xs)

   La parte creativa consiste en determinar:

      - 'solCasoBase', la solución del caso base (suele ser inmediato)

      - 'añadir', la función que "añade" la cabeza 'x' a la solución
        de la cola '(fun xs)'

   Recuerda también que los operadores binarios se pueden escribir
   como funciones prefijas; por ejemplo:

                  x +  suma xs

   se puede escribir como:

                  (+) x (suma xs)

   Este truco permite escribir todas las siguientes funciones
   recursivas aplicando el mismo esquema.
-}

-- |
-- >>> suma [1,2,3,4,5]
-- 15
suma :: [Int] -> Int -- predefinida como sum
suma []     = 0
suma (x:xs) = (+) x (suma xs)

-- |
-- >>> producto [1,2,3,4,5]
-- 120
producto :: [Int] -> Int -- predefinida como product
producto []     = 1
producto (x:xs) = (*) x (producto xs)

-- |
-- >>> conjunción [True, 1 < 2, 'a' == 'a']
-- True
-- >>> conjunción [True, 1 < 2, 'a' == 'b']
-- False
conjunción :: [Bool] -> Bool -- predefinida como and
conjunción []     = True
conjunción (x:xs) = (&&) x (conjunción xs)

-- |
-- >>> aplana [ [1,2], [3], [], [4,5,6]]
-- [1,2,3,4,5,6]
aplana :: [[a]] -> [a] -- predefinida como concat
aplana []       = []
aplana (xs:xss) = (++) xs (aplana xss)

{-
   Es obvio que las funciones anteriores se aparecen mucho. Podemos
   hacer como con 'map' y 'filter' y abstraer las diferencias:

     - todas las funciones tienen el tipo [a] -> b

     - todas las funciones necesitan un valor para solCasoBase

     - todas las funciones necesitan una función que añada la cabeza a
     la solución de la cola
-}

plegar :: (a -> b -> b) -> b -> [a] -> b
plegar f solCasoBase xs = recLista xs
  where 
    recLista [] = solCasoBase
    recLista (x:xs) = f x (recLista xs)

-- Todas las funciones anteriores pueden definirse mediante 'foldr'

-- |
-- >>> sumaR [1,2,3,4,5]
-- 15
sumaR :: [Int] -> Int -- predefinida como sum
sumaR xs = foldr (+) 0 xs

-- |
-- >>> productoR [1,2,3,4,5]
-- 120
productoR :: [Int] -> Int -- predefinida como product
productoR xs = foldr (*) 1 xs

-- |
-- >>> conjunciónR [True, 1 < 2, 'a' == 'a']
-- True
-- >>> conjunciónR [True, 1 < 2, 'a' == 'b']
-- False
conjunciónR :: [Bool] -> Bool -- predefinida como and
conjunciónR xs = foldr (&&) True xs

-- |
-- >>> aplana [ [1,2], [3], [], [4,5,6]]
-- [1,2,3,4,5,6]
aplanaR :: [[a]] -> [a]  -- predefinida como concat
aplanaR xs = foldr (++) [] xs

{-
   A veces la función que "añade" la cabeza a la solución de la cola
   es un poco más complicada. Por ejemplo, puede incluir un
   condicional. En tal caso, podemos definirla localmente en un where:

           fun []     = solCasoBase
           fun (x:xs) = f x (fun xs)
             where
                 f cabeza cola = ...
-}

-- |
-- >>> borraTodas 1 [1,2,1,3,3,1,2,1]
-- [2,3,3,2]
-- >>> borraTodas 't' "Haskell"
-- "Haskell"

borraTodas :: Eq a => a -> [a] -> [a]
borraTodas _ [] = []
borraTodas x (y:ys) = f y (borraTodas x ys)
  where
    f cabeza solCola
      | cabeza == x = solCola
      | otherwise   = cabeza:solCola

borraTodas' :: Eq a => a -> [a] -> [a]
borraTodas' x xs = foldr f [] xs
  where
    f cabeza solCola
      | cabeza == x = solCola
      | otherwise   = cabeza:solCola

-- | 15. Plegado a la izquierda
------------------------------------------------------------

{-
   Recuerda que la mayoría de las funciones recursivas con acumulador
   sobre listas siguen el siguiente esquema en Haskell:

          fun xs = funAc xs solCasoBase
             where
               fun []     ac = ac
               fun (x:xs) ac = funAc  x (actualiza ac x)

   La parte creativa consiste en determinar:

      - 'solCasoBase', la solución del caso base (suele ser inmediato)

      - 'actualiza', la función que "actualiza" el acumulador 'ac'
        para que tenga en cuenta la cabeza 'x' (el acumulador debe ser
        la solución de la prefijo visitado)

   Las siguientes funciones aplican recursión con acumulador (de nuevo aplicamos
   el truco de escribir los operadores como funciones prefijas).
-}

-- |
-- >>> suma' [1,2,3,4,5]
-- 15
suma' :: [Int] -> Int -- predefinida como sum
suma' xs = sumaAc xs 0
  where
    sumaAc [] ac     = ac
    sumaAc (x:xs) ac = sumaAc xs ((+) ac x)

-- |
-- >>> producto' [1,2,3,4,5]
-- 120
producto' :: [Int] -> Int -- predefinida como product
producto' xs = productoAc xs 1
  where
    productoAc [] ac     = ac
    productoAc (x:xs) ac = productoAc xs ((*) ac x)

-- |
-- >>> conjunción' [True, 1 < 2, 'a' == 'a']
-- True
-- >>> conjunción' [True, 1 < 2, 'a' == 'b']
-- False
conjunción' :: [Bool] -> Bool -- predefinida como and
conjunción' xs = conjunciónAc xs True
  where
    conjunciónAc [] ac     = ac
    conjunciónAc (x:xs) ac = conjunciónAc xs ((&&) ac x)

{-
   Es obvio que las funciones anteriores se aparecen mucho. Podemos
   abstraer las diferencias:

     - todas las funciones tienen el tipo [a] -> b

     - todas las funciones necesitan un valor para solCasoBase

     - todas las funciones necesitan una función que actualice el
       acumulador con el valor de la cabeza
-}


{-
   * Ejercicios de listas

   Resuelve los siguientes ejercicios aplicando diferentes técnicas
   (recursividad, foldr, foldl, map o filter).

-}

-- Una cadena es una palabra si está formada solo por letras.

-- |
-- >>> esPalabra "haskell"
-- True
-- >>> esPalabra "haskell2015"
-- False


esPalabra ::  String -> Bool  
esPalabra (x:xs) = foldr ((&&) . esLetra) True xs
   where
      esLetra x = ((x >= 'a') && (x <='z')) || (x>='A') && (x<='Z')

{-
 esPalabra xs = foldr esLetra True xs
  where
    esLetra cabeza solCola = ((cabeza >= 'a') && (cabeza <='z')) || (cabeza>='A') && (cabeza<='Z') && solCola
-}

{-

  
-}

-- |
-- >>> todasMayúsculas "Haskell"
-- False
todasMayúsculas :: String -> Bool
todasMayúsculas (x:xs) = foldr ((&&) . esMay) True xs
   where 
      esMay x = (x>='A') && (x<='Z')


-- |
-- >>> pares [1,2,3,4,5,6,7,8,9,10]
-- [2,4,6,8,10]
pares :: [Integer] -> [Integer]
pares xs = foldr f [] xs
 where 
   f cab solCola = if(even cab) then cab:solCola else solCola

-- |
-- >>> longitud "haskell"
-- 7

longitud :: [a] -> Integer -- predefinida como length  
longitud xs = foldr (\cab solCola -> 1+solCola) 0 xs

-- |
-- >> apariciones 'a' "Abracadabra"
-- 4
apariciones :: Eq a => a -> [a] -> Integer 
apariciones x (y:xs) = foldr ((+) . f) 0 xs
   where
     f y = if x == y then 1 else 0

{-
apariciones x xs = foldr (\ elem cab solCola -> f+solCola) 0 xs
-}

-- Purgar una lista es quitar las repeticiones.

-- |
-- >>> purga "Abracadabra"
-- "Abracd"
purga :: Eq a => [a] -> [a] -- predefinida como nub  --Este
purga xs = foldr (\z ys -> z : filter (/= z) ys) [] xs
  

-- |
-- >>> pertenece 4 [1,2,3,4,5]
-- True
-- >>> pertenece 't' "Haskell"
-- False
pertenece :: Eq a => a -> [a] -> Bool -- predefinida como elem
pertenece x xs = foldr f False xs
  where
    f cab solCola = cab == x || solCola

-- |
-- >>> paresImpares [1,2,3,4,5,6,7,8,9]
-- ([2,4,6,8],[1,3,5,7,9])
paresImpares :: [Int] -> ([Int], [Int])
paresImpares xs = foldr f ([],[]) xs
     where
       f cab solCola | even cab = (cab:pares,impares)
                     | otherwise = (pares, cab:impares)
        where
          (pares,impares) = solCola
