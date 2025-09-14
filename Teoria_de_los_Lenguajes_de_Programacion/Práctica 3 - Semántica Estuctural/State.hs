-- State.hs - Implementation of State

module State where

type  Var    =  String
type  Z      =  Integer
type  State  =  Var -> Z

sInit :: State
sInit "x" =  3
sInit "y"   =  7
sInit _ = 0

update :: State -> Var -> Z -> State
update s x z = \y -> if x == y then z else s y  
-- Recordamos que State es una función Var(y) -> Z 