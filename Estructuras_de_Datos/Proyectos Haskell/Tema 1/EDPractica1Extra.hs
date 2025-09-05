-------------------------------------------------------------------------------
-- Estructuras de Datos. 2º ETSI Informática. UMA
-- Práctica 1 - Ejercicios extra
--
-- Alumno: FAZIO ARRABAL, PABLO
-------------------------------------------------------------------------------

module Practica1Extra where

import           Test.QuickCheck

----------------------------------------------------------------------
-- Ejercicio - esPrimo
----------------------------------------------------------------------


esPrimo :: (Integral a) => a -> Bool
esPrimo n |n<=0 = error "esPrimo: argumento negativo o cero"
          |n==1 = True
          |otherwise = divisores n == [1,n]

divisores :: (Integral a) => a -> [a]
divisores n =  [x | x<-[1..n], mod n x ==0 ]


----------------------------------------------------------------------
-- Ejercicio - cocienteYResto
----------------------------------------------------------------------


func :: (Integral a) => a -> a -> a
func x y |x<y = 0
         |otherwise = 1 + (func(x-y) y)

cocienteYResto :: (Integral a) => a-> a -> (a, a)
cocienteYResto x y |y==0 = error "división por 0"
                   |(y<0)||(x<0) = error "argumentos negativos"
                   |otherwise = (funcion, x-funcion*y)
                      where
                          funcion = func x y
                      
                        

prop_cocienteYResto_OK x y = (x>=0&&y>0) ==> cocienteYResto x y == divMod x y

----------------------------------------------------------------------
-- Ejercicio - libre de cuadrados
----------------------------------------------------------------------


libreDeCuadrados :: Integer -> Bool
libreDeCuadrados n |n<=0 = error "libreDeCuadrados: argumento cero o negativo"
                   |n==1 = True
                   |otherwise = length(cuadrados n) == 0

cuadrados :: (Integral a) => a -> [a]
cuadrados n = [x | x <-[2..n], mod n (x*x) ==0 ]




----------------------------------------------------------------------
-- Ejercicio - raiz entera
----------------------------------------------------------------------

raizEntera :: Integer -> Integer
raizEntera x | x < 0 = error "raizEntera: argumento negativo"
             | otherwise = raiz x 0

raiz :: Integer -> Integer -> Integer
raiz x r | r*r > x = r-1
         | otherwise = raiz x (r+1)

prop_raizEntera_OK n = n >= 0 ==> truncate (sqrt (fromIntegral n)) == raizEntera n

raizEnteraRapida :: Integer -> Integer
raizEnteraRapida n | n < 0 = error "raizEnteraRapida: argumento negativo"
                   | otherwise = rapidas 0 n
                     where
                         rapidas a b  |n==0 = 0
                                      |n == 1 = 1
                                      |a+1 == b = a
                                      |(medio) ^2 <= n = rapidas (medio) b
                                      |otherwise = rapidas a (medio)
                                           where 
                                              medio = div (a+b) 2
               

prop_raiz_OK n = n>=0 ==> raizEntera n == raizEnteraRapida n



----------------------------------------------------------------------
-- Ejercicio - números de Harshad
----------------------------------------------------------------------

sumaDigitos :: Integer -> Integer
sumaDigitos n | n<0 = error "sumaDigitos: argumento negativo"
              | n < 10 = n
              | otherwise = sumaDigitos (div n 10) + mod n 10

harshad :: Integer -> Bool
harshad x | x<=0 = error "harshad: argumento no positivo"
          | otherwise = divisible == 0
              where
                divisible =  x `mod` sumaDigitos x

harshadMultiple :: Integer -> Bool
harshadMultiple n | n<=0 = error "harshad: argumento no positivo"
                  | otherwise = (harshad n) && (num)
                     where
                       num = harshad (n `div` sumaDigitos n)
                     
                

vecesHarshad :: Integer -> Integer
vecesHarshad n | n<=0 = error "harshad: argumento no positivo"
               | not (harshad n) = 0
               | n==1 = 1
               | otherwise = 1 + vecesHarshad (n `div` sumaDigitos n)

prop_Bloem_Harshad_OK :: Integer -> Property
prop_Bloem_Harshad_OK n = n>0 ==>  n + 2 == vecesHarshad (1008 * 10^n)

----------------------------------------------------------------------
-- Ejercicio - ceros del factorial
----------------------------------------------------------------------

factorial :: Integer -> Integer
factorial n  | n == 0 = 1
             | otherwise = n * factorial (n-1)


cerosDe :: Integer -> Integer
cerosDe n    | n == 0 = 1
             | n >= 10 && (mod n 10) == 0 = 1 + (cerosDe (div n 10))
             | n <= -10 && (mod n 10) == 0 = 1 + (cerosDe (div n 10))
             | otherwise = 0

prop_cerosDe_OK :: Integer -> Integer -> Property
prop_cerosDe_OK n m = (cerosDe n == 0) && m>=0 && m<=1000 ==> cerosDe(n*10^m) == m

{-

Responde las siguientes preguntas:

¿En cuántos ceros acaba el factorial de 10?
2
¿En cuántos ceros acaba el factorial de 100?
24
¿En cuántos ceros acaba el factorial de 1000?
249
¿En cuántos ceros acaba el factorial de 10000?
2499

-}

----------------------------------------------------------------------
-- Ejercicio - números de Fibonacci y fórmula de Binet
----------------------------------------------------------------------

fib :: Integer -> Integer
fib n  | n<0 = error "fib: argumento negativo"
       | n == 0 = 0
       | n == 1 = 1
       | otherwise = fib(n-1) + fib(n-2)

llamadasFib :: Integer -> Integer
llamadasFib n | n==0 = 1
              | n== 1 = 1
              | otherwise = 1 + llamadasFib(n-1) + llamadasFib(n-2)

{-

Responde a las siguientes preguntas:

¿Cuántas llamadas a fib son necesarias para calcular fib 30?

2692537

¿Cuántas llamadas a fib son necesarias para calcular fib 36?

48315633

-}

fib' :: Integer -> Integer
fib' n = fibAc n 0 1
  where
    fibAc n a b    | n<0 = error "fib': argumento negativo"
                   | n==0 = a
                   | otherwise = fibAc (n-1) b (a+b)

prop_fib_OK :: Integer -> Property
prop_fib_OK n = n>=0 && n<=30 ==> fib n == fib' n

phi :: Double
phi = (1 + sqrt 5) / 2


binet :: Integer -> Integer
binet n | n<0 = error "binet: argumento negativo"
        | otherwise = round ((phi^n - (1 - phi)^n)/raiz) 
             where 
               raiz = sqrt 5


prop_fib'_binet_OK :: Integer -> Property
prop_fib'_binet_OK n = n>0 ==> binet n == fib' n

{-

Responde a la siguiente pregunta:

¿A partir de qué valor devuelve binet resultados incorrectos?
A partir del 76.

*** Failed! Falsified (after 83 tests and 1 shrink):
76

> Haskell Interactive Shell (EDPractica1Extra.hs) λ binet 76
3416454622906706
> Haskell Interactive Shell (EDPractica1Extra.hs) λ fib' 76
3416454622906707

-}
