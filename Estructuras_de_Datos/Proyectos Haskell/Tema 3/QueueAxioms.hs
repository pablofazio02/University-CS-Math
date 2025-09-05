------------------------------------------------------------
-- Estructuras de Datos
-- Tema 3. Estructuras de Datos Lineales
-- Pablo López
--
-- Módulo de la especificación del TAD Cola
------------------------------------------------------------

module QueueAxioms where

--import           Queue
import           DataStructures.Queue.LinearQueue

import           Test.QuickCheck

-- | Especificación del TAD Cola
------------------------------------------------------------

{-
   Las operaciones del TAD se clasifican en constructores, selectores
   y transformadores.

   Para especificar un TAD hay que especificar qué devuelve cada
   selector y transformador cuando se aplica a un constructor.

   Para el TAD Cola tenemos 2 constructores: `enqueue` y `empty`. El
   resto de operaciones son selectores (`isEmpty`, `first`) o
   transformadores (`dequeue`).

   Definimos una propiedad QuickCheck para comprobar cada operación
   sobre el TAD Cola. A estas propiedades las llamamos axiomas de la
   cola. Toda implementación de la cola debe satisfacer los axiomas.

   ¿Qué devuelve `isEmpty` cuando se aplica a un constructor?
-}

ax_isEmpty_empty :: Bool
ax_isEmpty_empty = isEmpty empty == True

ax_isEmpty_enqueue :: a -> Queue a -> Bool
ax_isEmpty_enqueue x q = isEmpty (enqueue x q) == False

{-
   ¿Qué devuelve `first` cuando se aplica a un constructor?
-}

ax_first_enqueue_1 :: Eq a => a -> p -> Bool
ax_first_enqueue_1 x q =  first (enqueue x empty) == x

ax_first_enqueue_2 :: Eq a => a -> Queue a -> Property
ax_first_enqueue_2 x q =  not (isEmpty q) ==> first (enqueue x q) == first q

-- first sobre empty no está definido: depende de la implementación

{-
   ¿Qué devuelve `dequeue` cuando se aplica a un constructor?
-}

ax_dequeue_enqueue_1 :: Eq a => a -> p -> Bool
ax_dequeue_enqueue_1 x q =  dequeue (enqueue x empty) == empty

ax_dequeue_enqueue_2 :: Eq a => a -> Queue a -> Property
ax_dequeue_enqueue_2 x q =  not (isEmpty q) ==> dequeue (enqueue x q) == enqueue x (dequeue q)

-- dequeue sobre empty no está definido: depende de la implementación

{-
   Introducimos un sinónimo de tipo `T` para probar las propiedades
   QuickCheck son tipos concretos.
-}

type T = Integer -- o Char, etc.

check_isEmpty_empty     = quickCheck (ax_isEmpty_empty :: Bool)
check_isEmpty_enqueue   = quickCheck (ax_isEmpty_enqueue :: T -> Queue T -> Bool)
check_first_enqueue_1   = quickCheck (ax_first_enqueue_1 :: T -> Queue T -> Bool)
check_first_enqueue_2   = quickCheck (ax_first_enqueue_2 :: T -> Queue T -> Property)
check_dequeue_enqueue_1 = quickCheck (ax_dequeue_enqueue_1 :: T -> Queue T -> Bool)
check_dequeue_enqueue_2 = quickCheck (ax_dequeue_enqueue_2 :: T -> Queue T -> Property)

{-
   Para comprobar todas las propiedades QuickCheck usamos `check_Queue`.
-}

check_Queue = do
                 check_isEmpty_empty
                 check_isEmpty_enqueue
                 check_first_enqueue_1
                 check_first_enqueue_2
                 check_dequeue_enqueue_1
                 check_dequeue_enqueue_2
