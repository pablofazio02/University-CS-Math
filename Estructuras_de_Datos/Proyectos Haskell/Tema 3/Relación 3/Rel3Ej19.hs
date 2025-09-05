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

module Entero
    (cero,
    suc,
    pre,
    (+)
    )where
import Test.QuickCheck

data Entero = Cero | Suc Entero | Pre Entero deriving (Eq, Show)

cero :: Entero
cero = Cero

suc :: Entero -> Entero 
suc (Pre n) = n
suc n = Suc n

pre :: Entero -> Entero
pre (Suc n) = n
pre n = Pre n

(+) :: Entero -> Entero -> Entero
(+) suc x y = Suc (Entero.+ x)
(+) pre x y = Pre (Entero.+ x)

