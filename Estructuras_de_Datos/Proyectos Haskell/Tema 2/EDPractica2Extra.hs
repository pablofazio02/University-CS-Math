-------------------------------------------------------------------------------
-- Estructuras de Datos. 2º ETSI Informática. UMA
-- Práctica 2 - Ejercicios extra
--
-- Alumno: FAZIO ARRABAL, PABLO
-------------------------------------------------------------------------------

module Practica2Extra where

import           Data.Char
import           Test.QuickCheck
import           Text.Show.Functions

----------------------------------------------------------------------
-- Ejercicio - empareja
----------------------------------------------------------------------

empareja :: [a] -> [b] -> [(a, b)]
empareja _ [] = []
empareja [] _ = []
empareja (x:xs) (y:ys) = [(x,y)] ++ empareja xs ys 

-- Tutoría
prop_empareja_OK :: (Eq b, Eq a) => [a] -> [b] -> Bool
prop_empareja_OK xs ys = zip xs ys == empareja xs ys

----------------------------------------------------------------------
-- Ejercicio - emparejaCon
----------------------------------------------------------------------

emparejaCon ::  (a -> b -> c) -> [a] -> [b] -> [c]
emparejaCon f [] _ = []
emparejaCon f _ [] = []
emparejaCon f (x:xs) (y:ys) = f x y : emparejaCon f xs ys

-- Tutoría
prop_emparejaCon_OK :: Eq c => (a -> b -> c) -> [a] -> [b] -> Bool
prop_emparejaCon_OK f xs ys = emparejaCon f xs ys == zipWith f xs ys

----------------------------------------------------------------------
-- Ejercicio - separa
----------------------------------------------------------------------

separaRec :: (a -> Bool) -> [a] -> ([a], [a])
separaRec f [] = ([],[])
separaRec f (x:xs) | f x = (x:pares, impares)
                   | otherwise = (pares, x:impares) 
    where
      (pares,impares) = separaRec f xs

separaC :: (a -> Bool) -> [a] -> ([a], [a])
separaC f xs = ([x | x <- xs, f x], [y | y <- xs, not(f y)])

separaP :: (a -> Bool) -> [a] -> ([a], [a])
separaP f xs = foldr g ([],[]) xs
    where
      g cab solCola 
          | f cab = (cab:a,b)
          | otherwise = (a,cab:b)
              where
                (a, b) = solCola

prop_separa_OK :: Eq a => (a -> Bool) -> [a] -> Bool
prop_separa_OK f xs = separaRec f xs == separaC f xs && separaP f xs == separaC f xs

----------------------------------------------------------------------
-- Ejercicio - lista de pares
----------------------------------------------------------------------

cotizacion :: [(String, Double)]
cotizacion = [("apple", 116), ("intel", 35), ("google", 824), ("nvidia", 67)]

buscarRec :: Eq a => a -> [(a,b)] -> [b]
buscarRec _ [] = []
buscarRec x (y:xs) | x == fst y = [snd y]
                   | otherwise = buscarRec x xs

-- Tutoría
buscarC :: Eq a => a -> [(a, b)] -> [b]
buscarC x [] = []
buscarC x xs = [head [snd y | y <- xs, fst y == x]]

buscarP :: Eq a => a -> [(a, b)] -> [b]
buscarP x xs = foldr f [] xs
   where 
       f cab solCola
         | x == fst cab = [snd cab]
         | otherwise = solCola

prop_buscar_OK :: (Eq a, Eq b) => a -> [(a, b)] -> Bool
prop_buscar_OK x xs = buscarC x xs == buscarP x xs

{-

Responde las siguientes preguntas si falla la propiedad anterior.

¿Por qué falla la propiedad prop_buscar_OK?
*** Failed! Falsified (after 4 tests):
()
[((),()),((),())]

No contempla el caso de tuplas vacias. Donde existe más de un elemento igual.

Realiza las modificaciones necesarias para que se verifique la propiedad.

-}

-- Tutoría
head' :: [Double] -> Double
head' [] = 0
head' xs = head xs

valorCartera :: [(String, Double)] -> [(String, Double)] -> Double
valorCartera xs ys = sum  (map (mapeado)  [fst y | y <- xs])
   where
     mapeado = \x -> head' (buscarRec x ys) * head [snd z | z <- xs, fst z == x]
  
  

----------------------------------------------------------------------
-- Ejercicio - mezcla
----------------------------------------------------------------------

mezcla :: Ord a => [a] -> [a] -> [a]
mezcla xs [] = xs
mezcla [] xs = xs
mezcla (x:xs) (y:ys) | x<=y = [x] ++ mezcla xs (y:ys)
                     | otherwise = [y] ++ mezcla (x:xs) ys

----------------------------------------------------------------------
-- Ejercicio - takeUntil
----------------------------------------------------------------------

takeUntil :: (a -> Bool) -> [a] -> [a]
takeUntil f [] = []
takeUntil f (x:xs) | f x = []
                   | otherwise = [x] ++ takeUntil f xs

prop_takeUntilOK :: Eq a => (a -> Bool) -> [a] -> Bool
prop_takeUntilOK f xs = takeWhile f (takeUntil f xs) == []

----------------------------------------------------------------------
-- Ejercicio - número feliz
----------------------------------------------------------------------

--Turoría
digitosDe :: Integer -> [Integer]
digitosDe x | x == 0 = []
            | otherwise =  digitosDe (div x 10) ++ [mod x 10] 

sumaCuadradosDigitos :: Integer -> Integer
sumaCuadradosDigitos x = sum (map (^2) (digitosDe x)) 

-- Tutoría
esFeliz :: Integer -> Bool
esFeliz x = esFelizAc [] x
 where
  esFelizAc xs x | x `elem` xs = False
                 | s == 1      = True
                 | otherwise   = esFelizAc (x : xs) s
    where 
        s = sumaCuadradosDigitos x

felicesHasta :: Integer -> [Integer]
felicesHasta x = [y | y <- [1..x], esFeliz y]

{-

Responde a la siguiente pregunta.

¿Cuántos números felices hay menores o iguales que 1000?

Haskell Interactive Shell (EDPractica2Extra.hs) λ felicesHasta 1000
[1,7,10,13,19,23,28,31,32,44,49,68,70,79,82,86,91,94,97,100,103,109,129,
130,133,139,167,176,188,190,192,193,203,208,219,226,230,236,239,262,263,
280,291,293,301,302,310,313,319,320,326,329,331,338,356,362,365,367,368,
376,379,383,386,391,392,397,404,409,440,446,464,469,478,487,490,496,536,
556,563,565,566,608,617,622,623,632,635,637,638,644,649,653,655,656,665,
671,673,680,683,694,700,709,716,736,739,748,761,763,784,790,793,802,806,
818,820,833,836,847,860,863,874,881,888,899,901,904,907,910,912,913,921,
923,931,932,937,940,946,964,970,973,989,998,1000]

Haskell Interactive Shell (EDPractica2Extra.hs) λ length (felicesHasta 1000)
143
-}

----------------------------------------------------------------------
-- Ejercicio - borrar
----------------------------------------------------------------------

borrarRec :: Eq a => a -> [a] -> [a]
borrarRec _ [] = []
borrarRec x (y:xs) | x == y = borrarRec x xs
                   | otherwise = [y] ++ borrarRec x xs

borrarC :: Eq a => a -> [a] -> [a]
borrarC x xs = [ y | y <- xs, y/=x]

borrarP :: Eq a => a -> [a] -> [a]
borrarP x xs = foldr f [] xs
 where
   f cab solCola
     | cab == x = solCola
     | otherwise = [cab] ++ solCola

prop_borrar_OK :: Eq a => a -> [a] -> Bool
prop_borrar_OK x xs = borrarRec x xs == borrarC x xs && borrarC x xs == borrarP x xs

----------------------------------------------------------------------
-- Ejercicio - agrupar
----------------------------------------------------------------------

agrupar :: Eq a => [a] -> [[a]]
agrupar xs = foldr f [] xs
    where f x []     = [[x]]
          f x (y:ys) | x == (head y) = ((x:y):ys)
                     | otherwise = ([x]:y:ys)
  

----------------------------------------------------------------------
-- Ejercicio - aplica
----------------------------------------------------------------------

aplicaRec :: a -> [ a -> b] -> [b]
aplicaRec _ [] = []
aplicaRec  x (y:xs) = [y x] ++ aplicaRec x xs 

aplicaC :: a -> [ a -> b] -> [b]
aplicaC x xs = [ f x | f <- xs ] 

aplicaP :: a -> [ a -> b] -> [b]
aplicaP x xs = foldr f [] xs
  where
      f cab solCola = cab x:solCola

aplicaM :: a -> [ a -> b] -> [b]
aplicaM x [] = []
aplicaM x (y:xs) = map y [x] ++ aplicaM x xs 

prop_aplica_OK :: Eq b => a -> [a -> b] -> Bool
prop_aplica_OK x xs = aplicaRec x xs == aplicaC x xs && aplicaP x xs == aplicaM x xs && aplicaRec x xs == aplicaP x xs
