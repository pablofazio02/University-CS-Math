------------------------------------------------------------
-- Estructuras de Datos
-- Tema 3. Estructuras de Datos Lineales
-- Pablo López
--
-- Módulo cliente del TAD Cola
------------------------------------------------------------

module QueueClient where

{-
   Dado que tanto el módulo `Stack` como el módulo `Queue` exportan la
   operación `empty`, es necesario utilizar una importación
   cualificada:

           import qualified NombreDeModulo as Prefijo

   Para hacer referencia a los elementos públicos del módulo necesitamos
   prefijarlos con `Prefijo`. Esto permite distinguir si nos estamos
   refiriendo al `empty` de `Stack` o al de `Queue`.
-}

import qualified DataStructures.Queue.LinearQueue as Q
import qualified DataStructures.Stack.LinearStack as S

-- Debemos importar los modulos de forma cualificada si hay colisión

stack1 :: S.Stack Integer
stack1 = S.push 1 (S.push 2 (S.push 3 (S.push 4 S.empty)))

stackSize :: S.Stack a -> Integer
stackSize s
  | S.isEmpty s = 0
  | otherwise = 1 + stackSize (S.pop s)

queue1 :: Q.Queue String
queue1 = Q.enqueue "c++" (Q.enqueue "java" (Q.enqueue "haskell" Q.empty))

queueSize :: Q.Queue a -> Integer
queueSize q
  | Q.isEmpty q = 0
  | otherwise = 1 + queueSize (Q.dequeue q)

