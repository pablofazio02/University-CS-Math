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

module WellBalanced where 
import DataStructures.Stack.LinearStack
import Test.QuickCheck

wellBalanced :: String -> Bool
wellBalanced xs = wellBalanced' xs empty

wellBalanced' :: String -> Stack Char -> Bool
wellBalanced' [] s = isEmpty s
wellBalanced' (x:xs) s | (x =='{' || x =='[' || x =='(' )  = wellBalanced' xs (push x s)
                       | ((x =='}') && (top s == '{')) || ((x ==')') && (top s == '(')) || ((x ==']') && (top s == '['))  = wellBalanced' xs (pop s)
                       | otherwise = wellBalanced' xs s 


