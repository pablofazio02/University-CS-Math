
{-
Exercise 1.15 (Essential)
Define substitution for boolean expressions: b[y→a0] is to be the boolean expression that is 
like b except that all occurrences of the variable y are replacedby the arithmetic expression a0
-}


-- Bexp.hs

data SubstBexp = Var :-->: Aexp

substBexp :: Bexp -> SubstBexp -> Bexp
substBexp TRUE _ = TRUE
substBexp FALSE _ = FALSE
substBexp (Equ a1 a2) (y :-->: a0) = Equ (substAexp a1 (y :->: a0)) (substAexp a2 (y :->: a0))
substBexp (Leq a1 a2) (y :-->: a0) = Leq (substAexp a1 (y :->: a0)) (substAexp a2 (y :->: a0))
substBexp (Neg b) (y :-->: a0) = Neg (substBexp b (y:-->: a0))
substBexp (And b1 b2) (y :-->: a0) = And (substBexp b1 (y:-->: a0)) (substBexp b2 (y:-->: a0))

-- Aexp.hs

data Subst = Var :->: Aexp  -- operador infijo, debe empezar por ':'

-- | Define a function 'substAexp' that takes an arithmetic expression
-- | 'a' and a substitution 'y -> a0' and returns the substitution 'a [y -> a0]';
-- | i.e., replaces every occurrence of 'y' in 'a' by 'a0'.

substAexp :: Aexp -> Subst -> Aexp
substAexp (N n) _ = N n
substAexp (V x) (y :->: a0) = if x == y then a0 else (V x)
substAexp (Add a1 a2) (y :->: a0) = Add (substAexp a1 (y :->: a0)) (substAexp a2 (y :->: a0))
substAexp (Mult a1 a2) (y :->: a0) = Mult (substAexp a1 (y :->: a0)) (substAexp a2 (y :->: a0))
substAexp (Sub a1 a2) (y :->: a0) = Sub (substAexp a1 (y :->: a0)) (substAexp a2 (y :->: a0))


{-
  Exercise. Define the set of free variables FV(b) in a Boolean expression b.
-}

-- Bexp.hs

fvBexp :: Bexp -> Set Var
fvBexp (TRUE) = S.empty
fvBexp (FALSE) = S.empty
fvBexp (Equ a1 a2) = S.union (fvAexp a1) (fvAexp a2)
fvBexp (Leq a1 a2) = S.union (fvAexp a1) (fvAexp a2)
fvBexp (Neg b) = fvBexp b
fvBexp (And b1 b2) = S.union (fvBexp b1) (fvBexp b2)


-- Aexp.hs

fvAexp :: Aexp -> Set Var
fvAexp (N n) = S.empty
fvAexp (V x) = S.singleton x
fvAexp (Add a1 a2) = S.union (fvAexp a1) (fvAexp a2)
fvAexp (Mult a1 a2) = S.union (fvAexp a1) (fvAexp a2)
fvAexp (Sub a1 a2) = S.union (fvAexp a1) (fvAexp a2)


{-
Exercise 3.2
Extend While with the statement 'assert b before S'
The idea is that if b evaluates to true, then we execute S, and otherwise the
execution of the complete program aborts. Extend the structural operational
semantics of Table 2.2 to express this (without assuming that While contains
the abort-statement). 
-}

{-
< assert b before S, s> -> <S, s> si B[b]s = tt

< assert b before S, s> -> <abort, s> si B[b]s = ff
-}

sosStm (Inter (Assert b ss) s) | bVal b s = Inter ss s
sosStm (Inter (Assert b ss) s) | not (bVal b s) = Stuck (Assert b ss) s

{-
Exercise 2.34 Extend the WHILE language with the statement random (x)
that changes the value of x to be any positive natural number.
Extend the natural and structural operational semantics to support
this statement. Discuss whether random would be redundant if WHILE
were extended with the or statement as well.


-------------------------------------
   < random x, s > -> s [x -> n]

donde n es cualquier numero entero positivo


random no sería totalmente redudante a or, es cierto que si se podría replica rle funcionamiento usando or:

x := 1;
while true do
    x := x + 1 or skip;
end

pero random lo da de una manera mucho mas directa.
-}

{-
Exercise 2.35 Consider an extension of WHILE that in addition to
par also includes the construct:

protect S end

so that S must be executed as an atomic entity. For example:
x := 1 par protect ( x := 2; x := x +2) end
has only two possible outcomes, namely s x = 1 or s x = 4.
Extend the Structural Operational Semantics to support protect
and get all the possible derivations for the sentence above.
Can you specify a Natural Semantics for protect?

              <ss1,s> -> <ss1',s'>
----------------------------------------------------------
<par ss1 (protect ss2), s> -> <par ss1' (protect ss2), s>

                  <ss1,s> -> s'
---------------------------------------------------------
        <par ss1 (protect ss2), s> -> <ss2, s>

              <ss2,s> -> s'
-----------------------------------------
<par ss1 (protect ss2), s> -> <ss1, s>

         <ss2,s> -> <ss2' ,s'>
---------------------------------------------
<par ss1 (protect ss2), s> -> <ss2';ss1, s>

-}

