-------------------------------------------------------------------
-- Estructuras de Datos
-- Grados en Ingeniería Informática, del Software y de Computadores
-- Tema 2. Características de la Programación Funcional
-- Pablo López
-------------------------------------------------------------------

module Tema2Comprension where

import           Data.Char
import           Data.List
import           Test.QuickCheck

{-
   Contenido:

     16. Secuencias aritméticas
     17. Listas por compresión
-}

-- | 16. Secuencias aritméticas
------------------------------------------------------------

{-
   En Matemáticas es frecuente trabajar con sucesiones aritméticas,
   una sucesión donde la diferencia entre elementos consecutivos se
   mantiene constante; por ejemplo:

       3, 7, 11, 15, 19, 23, ...

   En Haskell podemos definir listas que representan una sucesión
   aritmética posiblemente acotada. En el caso más simple, definimos
   una secuencia aritmética acotada indicando su primer y último
   elementos, asumiendo que la diferencia es 1:
-}

-- |
-- >>> meses
-- [1,2,3,4,5,6,7,8,9,10,11,12]
meses :: [Int]
meses = [1..12]

{-
   El tipo de la secuencia aritmética no tiene que ser necesariamente
   numérico:
-}

-- |
-- >>> minusculas
-- "abcdefghijklmnopqrstuvwxyz"
minusculas :: String
minusculas = ['a'..'z']

{-
   Una secuencia aritmética estará vacía si el límite inferior es
   menor que el superior:
-}

-- |
-- >>> vacia
-- []
vacia :: [Int]
vacia = [10..0]

{-
   Para definir secuencias aritméticas en las que la diferencia no sea
   1, basta facilitar los dos primeros elementos de la misma. Haskell
   calcula la diferencia entre estos dos elementos y la emplea para
   generar la secuencia aritmética:
-}

-- |
-- >>> imparesHasta50
-- [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49]
imparesHasta50 :: [Int]
imparesHasta50 = [1,3..50]  -- diferencia = 3 - 1 = 2

{-
   Esto permite escribir secuencias aritméticas decrecientes, donde la
   diferencia es negativa:
-}

-- |
-- >>> cuentaAtras
-- [10,9,8,7,6,5,4,3,2,1,0]
cuentaAtras :: [Int]
cuentaAtras = [10,9..0]  -- diferencia = 9 - 10 = -1

{-
   También es posible definir secuencias aritméticas infinitas (no
   acotadas). Basta omitir el extremo superior (o inferior, si es
   decreciente):
-}

naturales :: [Integer]
naturales = [0..]

{-
   La lista `naturales` es infinita. Gracias a la pereza, Haskell puede
   trabajar con listas infinitas (en realidad, con cualquier
   estructura de datos infinitas). Obviamente, el resultado que
   queramos calcular debe ser finito y no debe requerir recorrer la
   lista completa. Es habitual usar `take` para tomar los primeros
   valores de una lista infinita:
-}

-- |
-- >>> take 10 naturales
-- [0,1,2,3,4,5,6,7,8,9]

{-
   Obviamente, en las secuencias aritméticas infinitas la diferencia
   no tiene que ser 1:
-}

-- |
-- >>> take 10 (multiplosDe 5)
-- [0,5,10,15,20,25,30,35,40,45]
multiplosDe :: Integer -> [Integer]
multiplosDe n = [0,n..]

{-
   Ejercicio: encuentra los 10 primeros múltiplos de 7 que acaban en 1024
-}

-- |
-- >>> take 10 multiplosDe7QueAcabanEn1024
-- [31024,101024,171024,241024,311024,381024,451024,521024,591024,661024]
multiplosDe7QueAcabanEn1024 :: [Integer]
multiplosDe7QueAcabanEn1024 = filter (\x -> x `mod` 10000 == 1024) [0,7..]

-- | 17. Listas por comprensión
------------------------------------------------------------

{-
   En Matemáticas es posible definir un conjunto por enumeración,
   indicando uno a uno sus elementos:

         {0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100}

   Una técnica más potente es la definición de conjuntos por
   comprensión, que permite construir nuevos conjuntos a partir de
   otros conjuntos:

         { x^2 / x pertenece a {1..10} }

    La definición por comprensión permite definir conjuntos infinitos:

         { x^2 / x pertenece a N }

    ¿Qué representa el siguiente conjunto?

         { (x,y) | (x,y) pertenece a (R,R) y x^2 + y^2 <= r^2 }

     Similarmente, en Haskell podemos definir listas por comprensión,
     es decir, listas definidas a partir de otras listas.

     La sintaxis básica es:

         [ expresión | patrón <- lista ]

     donde la expresión `patrón <- lista` es un generador que visita uno
     a uno los elementos de la lista.
-}

-- |
-- >>> cuadradosHasta10
-- [0,1,4,9,16,25,36,49,64,81,100]
cuadradosHasta10 :: [Integer]
cuadradosHasta10 = [ x^2 | x <- [0..10] ]

{-
   A la derecha de `<-` en el generador puede aparecer un patrón que
   sea adecuado para el tipo base de la lista:
-}

-- |
-- >>> primeros [("java", 1995), ("python", 1991), ("haskell", 1990)]
-- ["java","python","haskell"]
primeros :: [(a, b)] -> [a]
primeros xs = [fst x | x <- xs]

{-
   Los generadores pueden anidarse dando lugar a un producto
   cartesiano. El orden en que aparecen los generaodres es
   significativo pues se generan listas, no conjuntos.
-}

-- |
-- >>> anidados1
-- [(1,'a'),(1,'b'),(1,'c'),(2,'a'),(2,'b'),(2,'c'),(3,'a'),(3,'b'),(3,'c')]
anidados1 :: [(Integer, Char)]
anidados1 = [ (x,y) | x <- [1,2,3], y <- "abc" ]

-- |
-- >>> anidados2
-- [(1,'a'),(2,'a'),(3,'a'),(1,'b'),(2,'b'),(3,'b'),(1,'c'),(2,'c'),(3,'c')]
anidados2 :: [(Integer, Char)]
anidados2 = [ (x,y) | y <- "abc", x <- [1,2,3] ]

{-
   En una definición por comprensión también pueden aparecer guardas.
   Las guardas son expresiones booleanas permiten descartar o filtrar
   valores devueltos por un generador:

           [ expresión | patrón <- lista, guarda ]
-}

-- |
-- >>> divisores 32
-- [1,2,4,8,16,32]
divisores :: Integer -> [Integer]
divisores x = [ y | y <- [1..x],  mod x y == 0]

-- |
-- >>> esPrimo 12345678
-- False
-- >>> esPrimo 31
-- True
esPrimo :: Integer -> Bool
esPrimo x = divisores x == [1,x]

-- |
-- >>>  take 25 primos
-- [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]
primos :: [Integer]
primos = [x | x <- [2..], esPrimo x]

{-
   A veces en una compresión aparece repetida una expresión que se
   evalúa más de una vez. Por ejemplo, en la siguiente compresión `ord
   x` se evalúa dos veces:
-}

ejemploSinLet :: [(Char, Int)]
ejemploSinLet = [ (x, ord x) | x <- "Hola Mundo" , ord x > 75 ]

{-
   La forma habitual de evitar este reevaluación en Haskell es usar una
   definición local con `where`. Sin embargo, esto no funciona porque
   la variable `x` es local a la compresión.

   Para evitar repetir el cálculo realizamos una definición local con
   `let` dentro de la comprensión:
-}

ejemploConLet :: [(Char, Int)]
ejemploConLet = [ (x, y) | x <- "Hola Mundo" , let y = ord x, y > 75 ]

{-
   Ejercicio: define mediante una comprensión una función que devuelva
   todas las fichas de un dominó.
-}

-- |
-- >>> dominó
-- [(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6),(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(2,2),(2,3),(2,4),(2,5),(2,6),(3,3),(3,4),(3,5),(3,6),(4,4),(4,5),(4,6),(5,5),(5,6),(6,6)]
dominó :: [(Int, Int)]
dominó = [ (x,y) | x <- [0..6] , y <- [x..6]]
