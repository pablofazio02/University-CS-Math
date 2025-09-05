-------------------------------------------------------------------
-- Estructuras de Datos
-- Grados en Ingeniería Informática, del Software y de Computadores
-- Tema 2. Características de la Programación Funcional
-- Pablo López
-------------------------------------------------------------------

module Tema2 where

import           Data.Char
import           Data.List
import           Test.QuickCheck

{-
   Contenido:

     8. Orden superior sobre listas: map y filter
     9. Funciones como valores
    10. Lambda expresiones o funciones anónimas
    11. Secciones
    12. Parcialización
    13. Composición de funciones
-}

-- | 8. Orden superior sobre listas: map y filter
------------------------------------------------------------

{-
   Las siguientes funciones recursivas aplican una función 'f' a cada
   elemento de una lista.
-}

-- |
-- >>> cuadrados [1,2,3,4]
-- [1,4,9,16]

cuadrados :: [Int] -> [Int]
cuadrados []     = []
cuadrados (x:xs) = cuadrado x : cuadrados xs

-- |
-- >>> cuadrado 5
-- 25

cuadrado :: Int -> Int
cuadrado x = x * x

-- |
-- >>> aMayúsculas "Haskell"
--- "HASKELL"

aMayúsculas :: String -> String
aMayúsculas []     = []
aMayúsculas (x:xs) = toUpper x : aMayúsculas xs

-- |
-- >>> ordinales "Haskell"
-- [72,97,115,107,101,108,108]

ordinales :: String -> [Int]
ordinales []     = []
ordinales (x:xs) = ord x : ordinales xs

{-
   Las funciones anteriores se parecen mucho y conceptualmente siguen
   el mismo esquema:

        lista de entrada:   [  x1,   x2,   x3 ...    xn ]
                               |     |     |         |
        lista de salida:   [ f x1, f x2, f x3, ... f xn ]

   Lo que varia de una función a otra es:

      - el tipo de las listas de entrada y salida
      - la función 'f'

   Podemos abstraer y parametrizar:

      - el tipo mediante polimorfismo
      - la función 'f' mediante orden superior (pasar la función como parámetro)
-}

aplica :: (a-> b) -> [a] -> [b]-- predefinida como map
aplica f [] = []
aplica f (x:xs) =  f x : aplica f xs

 --Ejemplo main> aplica ord "haskell"

{-
   Las siguientes funciones seleccionan aquellos elementos de una
   lista que verifican una propiedad concreta 'p'.
-}

-- |
-- >>> pares [1,2,3,4,5,6]
-- [2,4,6]

pares :: [Integer] -> [Integer]
pares [] = []
pares (x:xs)
   | even x = x : pares xs
   | otherwise = pares xs

-- |
-- >>> esVocal 'a'
-- True
-- >>> esVocal 'b'
-- False

esVocal :: Char -> Bool
esVocal x = toUpper x `elem` "AEIOU"

-- |
-- >>> vocales "haskell"
-- "ae"

vocales :: String -> String
vocales [] = []
vocales (x:xs)
   | esVocal x = x : vocales xs
   | otherwise = vocales xs

{-
   De nuevo, las funciones anteriores se parecen mucho y
   conceptualmente siguen el mismo esquema:

        lista de entrada:   [  x1,   x2,   x3,  x4, ... xn ]
                                     |     |            |
        lista de salida:   [         x2,   x3       ... xn ]

   las diferencias son:

      - el tipo de ambas  listas
      - la condición 'p' que deben verificar los elementos

   Podemos abstraer y parametrizar:

      - el tipo de ambas mediante polimorfismo
      - la condición 'p' mediante orden superior
-}

filtra :: (a->Bool) -> [a] -> [a]
filtra f [] = []
filtra f (x:xs) 
     | f x = x : filtra f xs
     | otherwise = filtra f xs

-- | 9. Funciones como valores
------------------------------------------------------------

{-
   Supongamos un tipo básico como Int.

   ¿Qué podemos hacer con un valor de tipo Int?
-}

-- almacenarlo en una variable:

unEntero :: Int
unEntero = 5

-- almacenarlo en una estructura de datos:

listaDeEnteros :: [Int]
listaDeEnteros = [unEntero, 6, 1, 27]

-- pasarlo como parámetro o devolverlo como resultado de una función:

inc :: Int -> Int
inc x = x + 1

-- aplicarle ciertas operaciones (+,*,<,...)

-- escribirlo literalmente; por ejemplo 5

{-
    Idea clave de la programación funcional:

       - las funciones son valores
       - podemos hacer con ellas las mismas cosas que con un valor de Int
-}

-- almacenar función en una variable:

unaFunc :: Int -> Int
unaFunc = inc

-- almacenar función en una estructura de datos:

listaDeFunciones :: [Int->Int]
listaDeFunciones = [unaFunc, abs, cuadrado]

-- pasar una función como parámetro a una función:

twice :: (Int->Int) -> Int -> Int
twice f x = f (f x)

-- devolverla como resultado de una función:

elige :: Bool -> (Int->Int)
elige x = if x then inc
          else cuadrado

-- aplicarle cierta operación; la aplicación de la función a un valor: f x !!!

-- escribirla literalmente mediante lambda expresiones

-- | 10. Lambda expresiones o funciones anónimas
------------------------------------------------------------

{-
   Para escribir literalmente el valor de una función utilizamos
   lambda-expresiones, también llamadas funciones anónimas.
-}

{-
\ x -> x*x*x    [Expresión landa f anónima de cubo, se usa en la consola]
-}

-- |
-- >>> cubo 2
-- 8

cubo :: Integer -> Integer
cubo x = x * x * x

-- |
-- >>> cubos [1,2,3]
-- [1,8,27]

cubos :: [Integer] -> [Integer]
cubos xs = map cubo xs

{-
   Las lambda-expresiones son especialmente útiles para pasar una
   función como parámetro. Por ejemplo, podemos reescribir cubos
   usando una lambda expresión.
-}

cubos' :: [Integer] -> [Integer]
cubos' xs = map (\ x -> x * x * x ) xs

-- Escribe estas funciones usando lambdas:

-- |
-- >>> duplica [1,2,3,4]
-- [2,4,6,8]

duplica :: [Int] -> [Int]
duplica xs = map (2*) xs

-- |
-- >>> sigChar "Haskell"
--- "Ibtlfmm"

sigChar :: String -> String
sigChar xs = map (\ x -> chr (ord x + 1)) xs

-- |
-- >>> múltiplosDeTres [1,2,3,4,5,6,7,8,9,10,12]
-- [3,6,9,12]

múltiplosDeTres :: [Int] -> [Int]
múltiplosDeTres xs = filter (\x -> mod x 3 == 0) xs

-- | 11. Secciones
------------------------------------------------------------

{-
   Una sección es un operador binario que recibe un solo
   argumento, que puede ser el izquierdo o el derecho; por ejemplo:

              (+3)

              (2*)

   La sección espera recibir el otro argumento para aplicar el operador,
   por lo que una sección es una función unaria:

              (+3)  5

              (2*)  7

   Si el operador no es conmutativo, el orden de la sección importa:

              (^2)  5

              (2^)  5

   Una sección es realmente azúcar sintáctico para una lambda expresión:

            (@n) ---> \ x -> x @ n
            (n@) ---> \ x -> n @ x
-}

-- | 12. Parcialización
------------------------------------------------------------

{-
   Una sección es un operador binario que recibe un solo argumento y
   devuelve una función unaria que espera el otro operando.

   Esa idea se puede generalizar a cualquier función, no solo a
   operadores binarios: una función de n argumentos puede ser invocada
   con k argumentos (k <= n).

   Cuando k < n:

       1) se pasan los primeros k argumentos
       2) se devuelve una función que espera los n-k restantes argumentos
-}

f :: Int -> Int -> Int -> Int
f x y z = x + 2*y + 3*z   --- \ x y z -> x + 2*y + 3*z  ó \x->(\y->(\z-> x + 2*y + 3*z ))

g :: Int -> Int
g = f 1 2 -- versión especializada de f: g z = 1 + 2*2 + 3*z

-- ejemplo de parcialización: sustituye todos los supensos por aprobados

-- |
-- >>> apruébame [4, 8.5, 2.5, 7.25, 9.1, 6, 10]
-- [5.0,8.5,5.0,7.25,9.1,6.0,10.0]

apruébame :: [Double] -> [Double]
apruébame xs = map (max 5) xs


-- | 13. Composición de funciones
------------------------------------------------------------

{-
   En cálculo se define la composición de funciones de la siguiente
   manera:

      f o g (x) = f (g(x))

   En Haskell también está definida la composición de funciones:

      (f . g) x = f (g x)

   Primero se aplica 'g' a 'x', y al resultado se le aplica 'f'.
-}

logTotal :: Double -> Double
logTotal x = log (abs x)

logTotal' :: Double -> Double
logTotal' x = (log . abs) x


nextChar :: Char -> Char
nextChar x = (chr . (1+) . ord) x

{-
   Ejemplo de composición:

   El cifrado César consiste en reemplazar cada carácter de un mensaje
   en claro por el carácter que está 'n' posiciones más adelante en el
   alfabeto; por ejemplo, para n = 3 tenemos:

   alfabeto     : "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
   alfabeto + 3 : "DEFGHIJKLMNOPQRSTUVWXYZ[\]"

       cifrar("ATACAZ", 3)  --> "DWDFD]"
       descrifrar("DWDFD]", 3) --> "ATACAZ"
-}

cifrar :: String -> String
cifrar x = map (chr . (3+) . ord) x

descifrar :: String -> String
descifrar x = map (chr . (+(-3)) . ord) x

cifrar' :: (String, Int) -> String
cifrar' (x, n) = map (chr . (n+) . ord) x

descifrar' :: (String, Int) -> String
descifrar' (x, n) = map (chr . (+(-n)) . ord) x

prop_cifradoOK xs = (descifrar . cifrar) xs == xs
