-------------------------------------------------------------------
-- Estructuras de Datos
-- Grado en Ingeniería Informática, del Software y de Computadores
-- Tema 1. Introducción a la Programación Funcional
-- Pablo López
-------------------------------------------------------------------

module Punto where

import           Test.QuickCheck

{-
   Representaremos un punto en el plano por sus coordenadas cartesianas
   almacenadas en una tupla de dimensión 2. Por ejemplo:
-}

unPunto :: (Int, Int)
unPunto = (5, 2)

-- Completa las siguientes funciones sobre puntos:

-- |
-- >>> esOrigen (0,0)
-- True
-- >>> esOrigen (1,0)
-- False

{-
   Paso de parámetros y patrones:

   En lenguajes como Java/C/C++ el parámetro real (el que aparece en la llamada)
   es una expresión, mientras que el parámetro formal (el que aparece en la
   definición de la función) es una variable:


               Definición                                Invocación

             parámetro formal                            parámetro real
            (es una variable)                          (es una expresión)
                    |                                          |
                    |                                          |
          int f(int x) {                                   f(3 * 5)
              .....
          }


   En estos lenguajes el paso de parámetros consiste en inicializar el parámetro
   formal con el valor del parámetro real (x = 15). Es una operación incondicional
   que no puede fallar.

   En Haskell el parámetro real es una expresión y el parámetro formal es un
   patrón (no necesariamente una variable):

               Definición                                Invocación

             parámetro formal                            parámetro real
             (es un patrón)                            (es una expresión)
                  |                                            |
                  |                                            |
                f x = ...                                 f (3 * 5)


   En Haskell el paso de parámeros se realiza por correspondencia de patrones:
   el patrón (parámetro formal) puede imponer una restricción sobre el valor
   que puede tomar el parámetro real. Esto significa que el paso de parámetros
   está condicionado y puede fallar:

      1. Si el parámetro real no encaja con el patrón, el paso de parámetros
         falla y no se puede realizar

      2. Si el parámetro real encaja con el patrón, el paso de parámetros
         tiene éxito y las variables del patrón se inicializan al valor
         correspondiente del parámetro formal

   Los patrones disponibles para restringir los valores del parámetro real dependen
   del tipo del parámetro formal.
-}

esOrigen :: (Int, Int) -> Bool

{-
   En la función 'esOrigen' el parámetro formal es de tipo tupla. Veremos varios
   patrones para restringir el valor de la tupla de entrada.
-}

-- | Opción 1: patrón variable

{-
   El patrón es simplemente una variable y, como en Java/C/C++, no impone ninguna
   restricción sobre el valor de la entrada: acepta cualquier valor del tipo (Int, Int).
-}

--esOrigen x = fst x == 0 && snd x == 0

{-
   El inconveniente de esta solución es que dado que 'x' es una tupla, tenemos que
   utilizar las funciones 'fst' y 'snd' para acceder a sus componentes. La mayoría
   de las funciones que hemos definido hasta ahora usan solo patrones variable.
-}

-- | Opción 2: patrón tupla

{-
   El patrón es una tupla y, a su vez, cada componente de la tupla se describe mediante
   un patrón: (patrón_1, patrón_2)
-}

--esOrigen (x,y) = x == 0 && y == 0

{-
   En esta ocasión tenemos un patrón tupla '(x,y)' y cada componente
   es un patrón variable, 'x' e 'y'. Esto significa que la función
   acepta como entrada cualquier valor del tipo (Int,Int).  La ventaja
   respecto a la opción 1 es que podemos acceder a las componentes de la tupla
   sin necesidad de usar las funciones 'fst' y 'snd'.
-}

-- | Opción 3: patrón constante

{-
   El patrón es un valor concreto descrito mediante una constante. Es el patrón
   más restrictivo de todos: el parámetro real debe tomar exactamente el valor
   de esa constante; de lo contrario no encaja y el paso de parámetros fracasa.

   Cuando utilizamos patrones constantes es frecuente que las funciones se
   definan por casos: cada caso se describe en una ecuación independiente.
   Haskell trata de aplicar estas ecuaciones en el orden de aparición: si una
   ecuación no se puede aplicar (porque el patrón no encaja), se prueba con la
   siguiente. Solo se aplica la primera ecuación cuyo patrón encaja. Si ninguna
   ecuación es aplicable, el programa eleva una excepción.
-}

--esOrigen (0, 0) = True   -- primero se prueba la primera ecuación
--esOrigen x      = False  -- solo si la primera ecuación falla, se prueba la segunda

{-
   En esta ocasión tenemos en la primera ecuación un patrón tupla
   '(0,0)', cada componente es un patrón constante '0'. Por lo tanto,
   esa ecuación solo se puede aplicar si la entrada tiene el valor
   '(0,0)'. Esto no significa que la tupla de entrada deba ser
   literalmente '(0,0)'; también se puede aplicar a cualquier tupla
   cuyo valor sea '(0,0)', por ejemplo '(1-1, x * 0)'.
   Si la primera ecuación no es aplicable se intenta aplicar la segunda.
   En esta ocasión la segunda ecuación siempre es aplicable, porque
   utiliza un patrón variable que acepta cualquier valor del tipo '(Int,Int)'
-}

-- | Opción 4: patrón subrayado

{-
   El patrón subrayado se escribe '_' y es como el patrón variable (acepta
   cualquier valor de entrada), excepto que no le da ningún nombre, por lo que
   no se puede utlizar en la definición de la función (a la derecha del '=').
-}

esOrigen (0, 0) = True
esOrigen _      = False

{-
   Observa que la segunda ecuación no hace uso del parámetro: no necesitamos ni
   darle un nombre ni acceder a sus componentes: solo necesitamos saber que
   está ahí.
-}

{-
   Resumen de patrones:

   Los patrones no solo se aplican a las tuplas: se aplican a todos los tipos
   Haskell. A continuación resumimos los patrones que hemos estudiado.

        Patrón                            Significado

         x                        patrón variable, acepta cualquier valor y le da un nombre

       (patrón_1,...,patrón_n)    patrón tupla de dimensión n, permite imponer restricciones
                                  sobre los componentes y acceder a los mismos

         n                        patrón constante, solo acepta el valor literal de la constante

         _                        patrón subrayado, acepta cualquier valor pero no le da nombre
-}

-- |
-- >>> estaEnX (5,0)
-- True
-- >>> estaEnX (7,2)
-- False

estaEnX :: (Int, Int) -> Bool
estaEnX (_,0) = True; -- PATRÓN SUBRAYADO
estaEnX _ = False;

{-

estaEnX (x,y) = y==0; -- PATRÓN TUPLA

estaEnX x = snd x ==0;  PATRÓN VARIABLE
 
estaEnX (x,0) = True; PATRÓN CONSTANTE
estaEnX x = False;

-}

-- |
-- >>> modulo (2,5)
-- 29

modulo :: (Int, Int) -> Int
modulo (x,y) = x*x + y*y;  --Patrón Variable

-- |
-- >>> trasladar (4, 3) 6
-- (10, 9)

trasladar :: (Int, Int) -> Int -> (Int, Int)
trasladar (x,y) d = (x+d,y+d);

{-
   Definimos una relación de igualdad sobre los puntos. Supondremos
   que los puntos son iguales si lo son ambas componentes (igualdad
   lexicográfica).
-}

-- |
-- >>> iguales (4,2) (4, 2)
-- True
-- >>> iguales (6,8) (8,6)
-- False

iguales :: (Int, Int) -> (Int, Int) -> Bool
iguales (x,y) (z,t) = x == y && y == t;

{-
   Definimos ua relación de orden sobre los puntos. Supondremos que
   los puntos están ordenados por su primera componente y, en caso de
   igualdad, por su segunda componente (orden lexicográfico).
-}

-- |
-- >>> orden (5,3) (5,3)
-- EQ
-- >>> orden (1,2) (1,3)
-- LT
-- >>> orden (2,1) (3,7)
-- LT

orden :: (Int, Int) -> (Int,Int) -> Ordering
orden (x,y) (z,t) |x/=z = compare x z
                  |otherwise = compare y t

{-

|c1 /= EQ = c1
|otherwise = compare y t

  where
    c1 = compare x z
    
-}

