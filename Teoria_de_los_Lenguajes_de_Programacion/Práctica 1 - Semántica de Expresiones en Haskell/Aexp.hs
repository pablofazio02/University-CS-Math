{-

Programming Languages
Fall 2024

Semantics of Arithmetic Expressions

Pablo Fazio Arrabal

-}

module Aexp where

import Data.Set(Set)
import qualified Data.Set as S

-- |----------------------------------------------------------------------
-- | Exercise 1 - Abstract Syntax and Semantics of Aexp
-- |----------------------------------------------------------------------
-- | Define the algebraic data type 'Aexp' for representing arithmetic
-- | expressions.

-- data  Aexp  =  n | x | a1 + a2 | a1 - a2 | a1 * a2

-- Estas definiciones de tipos, las hago para poder posteriormente
-- modificar el tipo de las variables en una única línea

type VarId = String

-- Quiero que me dé la secuencia de digitos y luego ya yo decido la semántica que quiero
-- si aquí uso Integer, automáticamente se le da la de Integer
type LitNum = String 

data Aexp = NumLit LitNum
          | Var VarId
          | Add Aexp Aexp
          | Sub Aexp Aexp
          | Mul Aexp Aexp
          -- | Menos Aexp
          deriving Show

-- exp0 :: Aexp
-- exp0 = "hola"(Falla!!)

-- exp0 :: Aexp
-- exp0 = Var "hola"

-- IMPORTANTE: En los tipos algebraicos siempre hay que poner un constructor de datos, 
-- que indica si estoy en un caso que valor aplico. (Empieza en mayúscula)

-- (x * 3) + (y - 5)
exp0 :: Aexp
exp0 = Add (Mul (Var "x") (NumLit "3")) (Sub (Var "y") (NumLit "5"))

-- Los paréntesis no son parte de la sintaxis construida en Aexp. Se lo
-- da Haskell para el árbol parser concreto que queramos.

-- | Define the function 'aval' that computes the value of an arithmetic
-- | expression in a given state.

type Z = Integer
type State = VarId -> Z

-- El estado es una función total, luego tenemos que darle caso para cualquier variable
-- s0 = {x -> 5, y -> 7, z -> -2}
s0 :: State 
s0 "x" = 5
s0 "y" = 7
s0 "z" = -2
s0 _ = 0

nVal :: LitNum -> Z
-- read :: Read a => String -> a (El contexto me dice quién es a, a menos que lo declare)
-- Haskell Interactive Shell (Aexp.hs) λ read "237" :: Double
-- 237.0
nVal n = read n

aVal :: Aexp -> State -> Z
aVal (NumLit n) _ =  nVal n
aVal (Var x) s = s x
aVal (Add a1 a2) s = aVal a1 s + aVal a2 s
aVal (Mul a1 a2) s = aVal a1 s * aVal a2 s
aVal (Sub a1 a2) s = aVal a1 s - aVal a2 s
-- aVal (Menos a) s = 0 - aVal a s

-- Haskell Interactive Shell (Aexp.hs) λ aVal exp0 s0        
-- 17

-- |----------------------------------------------------------------------
-- | Exercise 2 - Free variables of expressions
-- |----------------------------------------------------------------------
-- | Define the function 'fvAexp' that computes the set of free variables
-- | occurring in an arithmetic expression. Ensure that each free variable
-- | occurs only once in the resulting list.

fvAexp :: Aexp -> Set VarId
fvAexp (NumLit n) = S.empty
fvAexp (Var x) = S.singleton x
fvAexp (Add a1 a2) = S.union (fvAexp a1) (fvAexp a2)
fvAexp (Mul a1 a2) = S.union (fvAexp a1) (fvAexp a2)
fvAexp (Sub a1 a2) = S.union (fvAexp a1) (fvAexp a2)
-- fvAexp (Menos a) = fvAexp a

--  Forma 2 :nub quita los elementos repetidos de una lista

-- |----------------------------------------------------------------------
-- | Exercise 3 - Substitution of variables in expressions
-- |----------------------------------------------------------------------
-- | Define the algebraic data type 'Subst' for representing substitutions.

-- data Subst 
data Subst = VarId :->: Aexp  -- operador infijo, debe empezar por ':'

-- | Define a function 'substAexp' that takes an arithmetic expression
-- | 'a' and a substitution 'y -> a0' and returns the substitution 'a [y -> a0]';
-- | i.e., replaces every occurrence of 'y' in 'a' by 'a0'.

substAexp :: Aexp -> Subst -> Aexp
substAexp (NumLit n) _ = NumLit n
substAexp (Var x) (y :->: a0) = if x == y then a0 else (Var x)
substAexp (Add a1 a2) (y :->: a0) = Add (substAexp a1 (y :->: a0)) (substAexp a2 (y :->: a0))
substAexp (Mul a1 a2) (y :->: a0) = Mul (substAexp a1 (y :->: a0)) (substAexp a2 (y :->: a0))
substAexp (Sub a1 a2) (y :->: a0) = Sub (substAexp a1 (y :->: a0)) (substAexp a2 (y :->: a0))
-- substAexp (Menos a) (y :->: a0) = Menos (substAexp a (y :->: a0))

-- |----------------------------------------------------------------------
-- | Exercise 4 - Update of state
-- |----------------------------------------------------------------------
-- | Define the algebraic data type 'Update' for representing state updates.

data Update = VarId :=>: Z

-- | Define a function 'update' that takes a state 's' and an update 'x -> v'
-- | and returns the updated state 's [x -> v]'

update :: State -> Update -> State
update s (y :=>: z) = \ x -> if x == y then z else s x
-- update s (y :=>: z) w = if w == x then z else s w (pq State desplegado el tipo es VarId -> Z)

-- Haskell Interactive Shell (Aexp.hs) λ update s0 ("x" :=>:(-7)) "x"
-- -7

-- | Define a function 'updates' that takes a state 's' and a list of updates
-- | 'us' and returns the updated states resulting from applying the updates
-- | in 'us' from head to tail. For example:
-- |
-- |    updates s {x -> 1, y > 2, x -> 3}
-- |
-- | returns a state that binds 'x' to 3 (the most recent update for 'x').

updates :: State -> [Update] -> State
updates s [] = s
updates s (u:us) = updates (update s u) us

-- Haskell Interactive Shell (Aexp.hs) λ updates s0 ["x" :=>:(-7), "y" :=>: 9, "x" :=>: 27] "x"  
-- 27

-- |----------------------------------------------------------------------
-- | Exercise 5 - Folding expressions
-- |----------------------------------------------------------------------
-- | Define a function 'foldAexp' to fold an arithmetic expression.

-- Me voy a guiar por los tipos algebraicos de Aexp
-- NumLit :: LitNum -> Aexp  ---------> nl :: LitNum -> a
-- Var :: VarId -> Aexp        --------->    v :: varId -> a
-- Add :: Aexp -> Aexp -> Aexp    --------->   add :: a -> a -> a

foldAexp :: (LitNum -> b) -> (VarId -> b) -> (b -> b -> b) -> (b -> b -> b) -> (b -> b -> b) -> Aexp -> b
foldAexp nl v add mul sub a = recAexp a
    where
        recAexp (NumLit n) = nl n
        recAexp (Var x) = v x
        recAexp (Add a1 a2) = add (recAexp a1) (recAexp a2)
        recAexp (Mul a1 a2) = mul (recAexp a1) (recAexp a2)
        recAexp (Sub a1 a2) = sub (recAexp a1) (recAexp a2)

-- | Use 'foldAexp' to define the functions 'aVal', 'fvAexp', and 'substAexp'.

aVal' :: Aexp -> State -> Z
aVal' a s = foldAexp nVal s (+) (*) (-) a

fvAexp' :: Aexp -> Set VarId
fvAexp' a = foldAexp (\_ -> S.empty) S.singleton S.union S.union S.union a

substAexp' :: Aexp -> Subst -> Aexp
substAexp' a (y :->: a0) = foldAexp NumLit (\x -> if x == y then a0 else Var x) Add Mul Sub a

-- Resuelto por Pablo L.
substAexp'' :: Aexp -> Subst -> Aexp
substAexp'' a (x :->: a0) = foldAexp NumLit subsVar Add Mul Sub a
    where
        -- subsVar :: VarId -> Aexp
        subsVar y = if y == x then a0 else Var y
