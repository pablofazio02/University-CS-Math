{-|

Programming Languages
Fall 2024

Implementation of the Structural Operational Semantics of the WHILE Language

Author: Pablo Fazio Arrabal

-}

module StructuralSemantics where

import           Aexp
import           Bexp
import           State
import           While

-- representation of configurations for WHILE

data Config = Inter Stm State  -- <S, s>
            | Final State      -- s
            | Stuck Stm State  -- <S, s>

isFinal :: Config -> Bool
isFinal (Final _) = True
isFinal _         = False

isInter :: Config -> Bool
isInter (Inter _ _) = True
isInter _           = False

isStuck :: Config -> Bool
isStuck (Stuck _ _) = True
isStuck _           = False

-- representation of the transition relation <S, s> => gamma

sosStm :: Config -> Config

-- x := a

-- Primero definimos update en State.hs 
-- Vemos cómo están definidas Config (aquí) y Stm (en While.hs)

sosStm (Inter (Ass x a) s) = Final (update s x (aVal a s))

-- skip

sosStm (Inter Skip s) = Final s

-- s1; s2

-- comp1 
  
--   <S1, s> => gamma (<S1', s'>)
--   -----------------------------
--   <S1;S2, s> => <S1';S2, s'>

sosStm (Inter (Comp ss1 ss2) s)
    | isInter gamma = Inter (Comp ss1' ss2) s'
        where
            gamma = sosStm (Inter ss1 s)
            Inter ss1' s' = gamma

-- comp2
sosStm (Inter (Comp ss1 ss2) s)
    | isFinal gamma = Inter ss2 s' 
        where 
            gamma = sosStm (Inter ss1 s)
            Final s' = gamma

-- comp3 (para Stuck)
sosStm (Inter (Comp ss1 ss2) s)
    | isStuck gamma = Stuck (Comp ss1' ss2) s' 
        where 
            gamma = sosStm (Inter ss1 s)
            Stuck ss1' s' = gamma 

-- la "culpa" del fallo es de ss1
-- Especificamos que se ha quedado atascado en la configuración <S1';S2, s'>
-- Es decir, lo último que se ha ejecutado es la primera sentencia <S1, s> y se ha quedado atascado

-- Aunque llamemos a sosStm no hay recursividad como tal porque 
-- eso no es lo que devolvemos, es solo para observar el siguiente paso.

-- if b then s1 else s2

sosStm (Inter (If b ss1 ss2) s) 
    | bVal b s = Inter ss1 s

sosStm (Inter (If b ss1 ss2) s)
    | not (bVal b s)  = Inter ss2 s     -- bVal b s == False = ...

-- NOTA: NO ponemos en la devolución   sosStm (Inter ssi s)   porque así estaríamos llamando 
-- recursivamente a sosStm y daríamos más pasos, como hacíamos en semántica natural.
-- Lo que ahora devolvemos es la siguiente configuración 

-- while b do s

sosStm (Inter (While b ss) s) = Inter (If b (Comp ss (While b ss)) Skip) s

-- repeat s until b

sosStm (Inter (Repeat ss b) s) = Inter (Comp ss (If b Skip (Repeat ss b))) s

-- for x a1 to a2 s

sosStm (Inter (For x a1 a2 ss) s) = Inter (If (Leq a1 a2) (Comp (Ass x a1) (Comp ss (For x n1 n2 ss))) Skip) s
    where
        n1 = Add (N (show (aVal a1 s))) (N "1")
        n2 = N (show (aVal a2 s))

-- abort

-- Si nos encontramos algo que no puede progresar (abort), devolvemos Stuck
-- se puede dar con índice fuera de rango, división por 0, etc.

-- En la teoría no lo especificamos, dijimos que no se podía transitar así que no escribimos
-- ninguna regla asociada a Abort, pero en la práctica sí que tenemos que definirlo, pues 
-- de lo contrario, al llegar un abort, el intérprete petaría al no saber qué hacer con él.
-- La solución es devolver Stuck, una configuración especial que no transitará.

-- sosStm (Inter Abort s) = Stuck Abort s 
-- es una opción, pero es mejor hacerlo más genérico, poniendo una regla universal para que 
-- devuelva stuck (regla estructural)
-- Así, como no se ha definido guarda para Abort, entrará por aquí, así como todo otro caso
-- que no se haya definido.

sosStm (Inter ss s) = Stuck ss s