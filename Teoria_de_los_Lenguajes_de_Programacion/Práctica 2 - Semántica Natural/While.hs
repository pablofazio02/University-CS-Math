-- While.hs - abstract syntax of WHILE

module While where

import           Aexp
import           Bexp
import           State

-- -------------------------------------------------------------------
-- Abstract syntax of statements
-- -------------------------------------------------------------------

data Stm = Ass Var Aexp
         | Skip
         | Comp Stm Stm
         | If Bexp Stm Stm
         | While Bexp Stm
         | Repeat Stm Bexp           
         | For Var Aexp Aexp Stm  
         deriving Show
