{-|

Programming Languages
Fall 2024

Implementation of the Natural Semantics of the WHILE Language

Author:

-}

module Exercises02 where

import           Aexp
import           Bexp
import           NaturalSemantics
import           State
import           While
import           WhileExamples
import           WhileParser

import qualified Data.Set as S

-- |----------------------------------------------------------------------
-- | Exercise 1
-- |----------------------------------------------------------------------
-- | The function 'sNs' returns the final state of the execution of a
-- | WHILE statement 'st' from a given initial state 's'. For example:

execFactorial :: State
execFactorial = sNs factorial factorialInit

-- | returns the final state:
-- |
-- |    s x = 1
-- |    s y = 6
-- |    s _ = 0
-- |
-- | Since a state is a function it cannot be printed thus you cannot
-- | add 'deriving Show' to the algebraic data type 'Config'.
-- | The goal of this exercise is to define a function to "show" a state
-- | thus you can inspect the final state yielded by the natural semantics
-- | of WHILE.

-- | Exercise 1.1
-- | Define a function 'showState' that given a state 's' and a list
-- | of variables 'vs' returns a list of strings showing the bindings
-- | of the variables mentioned in 'vs'. For example, for the state
-- | 's' above we get:
-- |
-- |    showState s ["x"] = ["x -> 1"]
-- |    showState s ["y"] = ["y -> 6"]
-- |    showState s ["x", "y"] = ["x -> 1", "y -> 6"]
-- |    showState s ["y", "z", "x"] = ["y -> 6", "z -> 0", "x -> 1"]

showState :: State -> [Var] -> [String]
showState s lv = map (\x -> x ++ " -> " ++ show(s x)) lv

-- | Using the function 'sNs' to execute a WHILE program is handy but a bit awkward.
-- | The WHILE statement must be provided in abstract syntax and the initial
-- | state must be explicitly given and inspected.
-- |
-- | The 'run' function allows to execute a WHILE program stored in a file
-- | in concrete syntax and reports the final value of the variables mentioned
-- | in the program header. For example:
-- |
-- |    > run "Examples/Factorial.w"
-- |    Program Factorial finalized.
-- |    Final State: ["x->0","y->120"]

-- | Run the WHILE program stored in filename and show final values of variables
run :: FilePath -> IO()
run filename =
  do
     (programName, vars, stm) <- parser filename
     let Final s = nsStm (Inter stm (const 0))
     putStrLn $ "Program " ++ programName ++ " finalized."
     putStr "Final State: "
     print $ showState s vars

-- | Exercise 1.2
-- | Use the function 'run' to execute the WHILE programs 'Factorial.w' and 'Divide.w'
-- | in the directory 'Examples' to check your implementation of the Natural Semantics.
-- | Write a few more WHILE programs. For example, write a WHILE program
-- | "Power.w" to compute x^y.

-- |----------------------------------------------------------------------
-- | Exercise 2
-- |----------------------------------------------------------------------
-- | The WHILE language can be extended with a 'repeat S until b' statement.
-- | The file Examples/FactorialRepeat.w contains a simple program to
-- | compute the factorial with a 'repeat until' loop.

-- | Exercise 2.1
-- | Define the natural semantics of this new statement. You are not allowed
-- | to rely on the 'while b do S' statement.

{- Formal definition of 'repeat S until b'

  La diferencia con 'while b do S' es que ahora se ejecuta S al menos una vez
  (es como el do-while, solo que se ejecuta la sentencia mientras la condición
  sea falsa, y se detiene cuando la condición sea verdadera)

-- B[b]s' = tt

                                     <S,s> -> s'
  [repeat_tt_ns]  -------------------------------------------------    B[b]s' = tt
                       <repeat S until b, s> -> s'

-- B[b]s' = ff
                       <S, s> -> s' ,  <repeat S until b, s'> -> s''
  [repeat_ff_ns]   ---------------------------------------------------    B[b]s' = ff
                             <repeat S until b, s> -> s''
-}

-- | Exercise 2.2
-- | Extend the definition of 'nsStm' in module NaturalSemantics.hs
-- | to include the 'repeat S until b' statement.

-- | Exercise 2.3
-- | Write a couple of WHILE programs that use the 'repeat' statement.
-- | Use 'run' to test your programs.

-- He creado un programa llamado "PowerRepeat.w" que calcula la potencia de un número
-- x elevado a y, utilizando la estructura de repetición "repeat until".

-- |----------------------------------------------------------------------
-- | Exercise 3
-- |----------------------------------------------------------------------
-- | The WHILE language can be extended with a 'for x:= a1 to a2 do S'
-- | statement.
-- | The file Examples/FactorialFor.w contains a simple program to compute
-- | the factorial with a 'for' loop.
-- | The file Examples/ForTests.w contains a more contrived example illustrating
-- | some subtle points of the semantics of the for loop.

-- | Exercise 3.1
-- | Define the natural semantics of this new statement. You are not allowed
-- | to rely on the 'while b do S' or the 'repeat S until b' statements.

{- Formal definition of 'for x:= a1 to a2 do S'

-- B[a1 <= a2]s = ff 

  [for_ff_ns] -------------------------------------------------    B[a1 <= a2]s = ff
                  <for x:= a1 to a2 do S, s> -> s                  ó  A[a1]s > A[a2]s


debemos tener en cuenta que a1 y a2 en la línea de definición de los límites del for, deben ser fijos
es decir, que aunque dentro del bucle se puedan modificar, los límites del for no pueden ser variables
La primera evaluación de a1 y a2 es la que se usa en todas las iteraciones.

Por tanto necesitamos una función que haga "constantes" literales
 N-1 :: Z -> Num    # esta es la función que en Aexp está definida como numLit
 N-1[89] = '89'
 Tras definir numLitInv en Aexp, 

                # esto se puede resumir en una composición 
                <x := a1, s> -> s' , <S,s'> -> s'',  <for x:= n1+1 to n2 do S, s''> -> s'''
  [for_tt_ns] ----------------------------------------------------------------------------------------     B[a1 <= a2]s = tt 
                               <for x:= a1 to a2 do S, s> ->  s'''                                         ó  A[a1]s <= A[a2]s

  where n2 = N-1(A[a2]s)        #A[a2]s es la evaluación inicial de a2 
        n1 = N-1(A[a1]s)        #Luego le añadiremos 1 porque es la actualización

-}

-- | Exercise 3.2
-- | Extend  the definition 'nsStm' in module NaturalSemantics.hs
-- | to include the 'for x:= a1 to a2 do S' statement.

-- | Exercise 3.3
-- | Write a couple of WHILE programs that use the 'for' statement.
-- | Use 'run' to test your programs.

-- He creado un programa llamado "PowerFor.w" que calcula la potencia de un número
-- x elevado a y, utilizando la estructura de repetición "for".

-- |----------------------------------------------------------------------
-- | Exercise 4
-- |----------------------------------------------------------------------

-- | Define the semantics of arithmetic expressions (Aexp) by means of
-- | natural semantics. To that end, define an algebraic datatype 'ConfigAexp'
-- | to represent the configurations, and a function 'nsAexp' to represent
-- | the evaluation judgement.

-- representation of configurations for Aexp

data ConfigAExp = InterAExp Aexp State  -- <a, s>
                | FinalAExp Z     -- z

-- representation of the evaluation judgement <a, s> -> z

nsAexp :: ConfigAExp -> ConfigAExp
nsAexp (FinalAExp x) = FinalAExp x
nsAexp (InterAExp (N n) s) = FinalAExp (read n)
nsAexp (InterAExp (V x) s) = FinalAExp (s x)
nsAexp (InterAExp (Add a1 a2) s) = FinalAExp (z1 + z2)
  where
    FinalAExp z1 = nsAexp (InterAExp a1 s)
    FinalAExp z2 = nsAexp (InterAExp a2 s)
nsAexp (InterAExp (Sub a1 a2) s) = FinalAExp (z1 - z2)
  where
    FinalAExp z1 = nsAexp (InterAExp a1 s)
    FinalAExp z2 = nsAexp (InterAExp a2 s)
nsAexp (InterAExp (Mult a1 a2) s) = FinalAExp (z1 * z2)
  where
    FinalAExp z1 = nsAexp (InterAExp a1 s)
    FinalAExp z2 = nsAexp (InterAExp a2 s)

-- | Test your function with a number of expressions and states.

data ConfigBExp = InterBexp Bexp State
                | FinalBexp T

nsBexp :: ConfigBExp -> ConfigBExp

nsBexp (InterBexp TRUE s) = FinalBexp True

nsBexp (InterBexp FALSE s) = FinalBexp False
              
nsBexp (InterBexp (Equ a1 a2) s) = FinalBexp ((aVal a1 s) == (aVal a2 s)) 

nsBexp (InterBexp (Leq a1 a2) s) = FinalBexp ((aVal a1 s) <= (aVal a2 s)) 

nsBexp (InterBexp (Neg b) s) = FinalBexp (not (bVal b s))

nsBexp (InterBexp (And b1 b2) s) = FinalBexp ((bVal b1 s) && (bVal b2 s))

-- |----------------------------------------------------------------------
-- | Exercise 5
-- |----------------------------------------------------------------------

-- | In the statement 'for x:= a1 to a2 S' the variable 'x' is the control
-- | variable. Some programming languages protect this variable in that
-- | it cannot be assigned to in the body of the loop, S.
-- |
-- | For example, the program below:
-- |
-- |    y := 1;
-- |    for x:= 1 to 10 do begin
-- |       y := y * x;
-- |       x := x + 1    // assignment to control variable
-- |    end
-- |
-- | would be rejected by languages enforcing such a restriction.
-- | Note that this check is performed before the program is executed,
-- | and therefore is a static semantics check.

-- | Exercise 5.1
-- | Define the static semantics by means of a judgement that is valid
-- | if and only if the program does not overwrite its control variables.
-- | Use axioms and inference rules to validate your judgements.

{-

La semántica estática es conservativa (rechaza problemas que son correctos)

VF: set de variables del for


-----------
VF |- skip 

x no está en VF
_____________
VF |- x:=a


VF |- S1 and VF |- S2
------------------------
      VF |- S1;S2


  VF |- S1 and VF |- S2
---------------------------
VF |- if b then S1 else S2

      VF |- S
-------------------
VF |- while b do S


    VF U {x} |- S
---------------------------
VF |- for x:=a1 to a2 do S

-}

-- | Exercise 5.2
-- | Define a function 'forLoopVariableCheck' that implements the static
-- | semantics check above described. Use the function 'analyze'
-- | to check your implementation.

forLoopVariableCheck :: Stm -> Bool
forLoopVariableCheck stm = checkLoop S.empty stm
  where
    checkLoop vf Skip = True
    checkLoop vf (Ass x a) = x `S.notMember` vf
    checkLoop vf (Comp ss1 ss2) = checkLoop vf ss1 && checkLoop vf ss2
    checkLoop vf (If b ss1 ss2) = checkLoop vf ss1 && checkLoop vf ss2
    checkLoop vf (While b stm) = checkLoop vf stm
    checkLoop vf (For x a1 a2 stm) = checkLoop (x `S.insert` vf) stm

-- | Analyze the WHILE program stored in filename and show results
analyze :: FilePath -> IO()
analyze filename =
  do
     (program, _, stm) <- parser filename
     putStrLn $ "Analyzing program " ++ program
     let ok = forLoopVariableCheck stm
     if ok then putStrLn "Program accepted"
     else putStrLn "Program rejected"


-- | Convert concrete syntax to abstract syntax
concreteToAbstract :: FilePath -> FilePath -> IO()
concreteToAbstract inputFile outputFile =
  do
    (_, _, stm) <- parser inputFile
    let s = show stm              -- | have 'show' replaced by a pretty printer
    if null outputFile
      then putStrLn s
      else writeFile outputFile s
