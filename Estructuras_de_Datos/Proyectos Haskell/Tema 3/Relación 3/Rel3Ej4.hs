-------------------------------------------------------------------------------
-- Estructuras de Datos. 2º Curso. ETSI Informática. UMA
--
-- 
-- Titulación: Doble Grado en Ingeniería Informática y  Matemáticas
-- Alumno: Fazio Arrabal, Pablo
-- Fecha de entrega: 30 | 11 | 2021
--
-- Relación de Ejercicios 3. Ejercicios resueltos.
--
-------------------------------------------------------------------------------

module Expression (
 Item (..)
 , Expression
 , value
 , showExpr
 , sample1, sample2
 ) where

data Item = Add | Dif | Mul | Value Integer | LeftP | RightP deriving Show

type Expression = [Item]

-- sample1 corresponde con 5 + (6 - 2) * 3
sample1 = [ Value 5, Add, LeftP, Value 6, Dif, Value 2, RightP, Mul, Value 3 ]


