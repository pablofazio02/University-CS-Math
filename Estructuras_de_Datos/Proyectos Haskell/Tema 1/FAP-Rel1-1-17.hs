-------------------------------------------------------------------------------
-- Estructuras de Datos. 2º Curso. ETSI Informática. UMA
--
-- 
-- Titulación: Doble Grado en Ingeniería Informática y Matemáticas.
-- Alumno: FAZIO ARRABAL, PABLO
-- Fecha de entrega: 18 | 10 | 2021
--
-- Relación de Ejercicios 1. Ejercicios resueltos: 1-2-3-4-5-6-7-8-9-10-11-12-13-14-15-16-17
--
-------------------------------------------------------------------------------
import Test.QuickCheck

--- EJERCICIO 1 

square :: Integer -> Integer
square x = x*x

esTerna :: Integer -> Integer -> Integer -> Bool
esTerna x y z = square x + square y == square z 

terna :: Integer -> Integer -> (Integer, Integer, Integer)
terna x y = (square x - square y, 2*x*y, square x + square y)

p_ternas x y = x>0 && y>0 && x>y ==> esTerna l1 l2 h where (l1,l2,h) = terna x y



--- EJERCICIO 2

intercambia :: (a,b) -> (b, a)
intercambia (x, y) = (y, x)



--- EJERCICIO 3

ordena2 :: Ord a => (a,a) -> (a,a)
ordena2 (x,y) = if x>y then (y,x) else (x,y)

p1_ordena2 x y = enOrden (ordena2 (x,y)) where enOrden (x,y) = x<=y
p2_ordena2 x y = mismosElementos (x,y) (ordena2 (x,y)) where
 mismosElementos (x,y) (z,v) = (x==z && y==v) || (x==v && y==z)


ordena3 :: Ord a => (a,a,a) -> (a,a,a)
ordena3 (x,y,z) |x>y = ordena3(y,x,z)
                |y>z = ordena3(x,z,y)
                |x>z = ordena3(z,x,y)
                |otherwise = (x,y,z)

p1_ordena3 x y z = enOrden(ordena3(x,y,z)) where enOrden(x,y,z) = x<=y && y<=z


--- EJERCICIO 4

max2 :: Ord a => a -> a -> a
max2 x y = if x > y then x else y

p1_max2 x y = max x y == x || max x y == y

p2_max2 x y = max x y >= x && max x y >= y

p3_max2 x y = x>=y && max x y == x

p4_max2 x y = y>=x && max x y == y


--- EJERCICIO 5

entre :: Ord a => a -> (a,a) -> Bool
entre x (y,z) = x>=y && x<=z


--- EJERCICIO 6

iguales3 :: Eq a => (a,a,a) -> Bool
iguales3 (x,y,z) = (x==y) && (y==z) 


--- EJERCICIO 7

type TotalSegundos = Integer
type Horas = Integer
type Minutos = Integer
type Segundos = Integer

descomponer :: TotalSegundos -> (Horas,Minutos,Segundos)
descomponer x = (horas, minutos, segundos) where  horas = div x 3600; minutos = div (mod x 3600) 60; segundos = mod (mod x 3600) 60

p_descomponer x = x>=0 ==> h*3600 + m*60 + s == x && entre m (0,59) && entre s (0,59) where (h,m,s) = descomponer x


--- EJERCICIO 8

unEuro :: Double
unEuro = 166.386

pesetasAEuros :: Double -> Double
pesetasAEuros x = x/unEuro

eurosAPesetas :: Double -> Double
eurosAPesetas x = x*unEuro

-- Ej.8) p_inversas x = eurosAPesetas (pesetasAEuros x) == x
p_inversas x = eurosAPesetas (pesetasAEuros x) ~= x

-- El QuickCheck falla porque nos desentendemos de lo que pueda ocurrir en los decimales más pequeños ya que es un número flotante 


-- EJERCICIO 9

infix 4 ~=
(~=) :: Double -> Double -> Bool
x ~= y = abs (x-y) < epsilon where epsilon = 1/1000

--p_inversas x = eurosAPesetas (pesetasAEuros x) ~= x


-- EJERCICIO 10

raíces :: (Ord a, Floating a) => a -> a -> a -> (a, a)
raíces a b c | dis < 0     = error "Raíces no reales"
             | otherwise   = ((-b + raizDisc) / denominador, (-b - raizDisc) / denominador)
 where  dis = b^2 - 4*a*c
        raizDisc = sqrt dis
        denominador = 2*a


p1_raíces a b c = esRaíz r1 && esRaíz r2
 where
 (r1,r2) = raíces a b c
 esRaíz r = a*r^2 + b*r + c ~= 0

 -- Falla ya que suponemos discriminante positivo y denominador distinto de 0

p2_raíces a b c = a/= 0 && b^2 - 4*a*c >= 0  ==> esRaíz r1 && esRaíz r2 where (r1,r2) = raíces a b c; esRaíz r = a*r^2 + b*r + c ~= 0


-- EJERCICIO 11

esMúltiplo :: Integer -> Integer-> Bool
esMúltiplo x y = mod x y == 0


-- EJERCICIO 12

infixl 1 ==>>
(==>>) :: Bool -> Bool -> Bool

False ==>> y    =       True
True ==>>  y     =       y


-- EJERCICIO 13

esBisiesto :: Int -> Bool
esBisiesto x | (mod x 4 == 0) &&  not(mod x 100==0)  = True
             | (mod x 4 == 0) &&  (mod x 100==0)  = mod x 400 ==0
             | otherwise = False



-- EJERCICIO 14

potencia :: Integer -> Integer -> Integer
potencia x y = x^y

potencia' :: Integer -> Integer -> Integer
potencia' x y |mod y 2 == 0 = (potencia x (div y 2))^2
              |otherwise = x* (potencia x (div (y-1) 2))^2  

p_pot b n = n>=0 ==> potencia b n == sol
 && potencia' b n == sol
 where sol = b^n

 -- n-1 productos en el primer caso (potencia) 


 -- EJERCICIO 15

factorial :: Integer -> Integer
factorial x | x==0 = 1
            |otherwise = factorial(x-1)*x 



 -- EJERCICIO 16

divideA :: Int -> Int -> Bool
divideA x y = (mod y x == 0)

p1_divideA x y = y/=0 && y `divideA` x ==> div x y * y == x

p2_divideA x y z = y/=0 && y `divideA`z && y `divideA` x ==> y `divideA` (x+z) 


 -- EJERCICIO 17

mediana :: Ord a => (a,a,a,a,a) -> a
mediana (x,y,z,t,u) | x > z = mediana (z,y,x,t,u)
                    | y > z = mediana (x,z,y,t,u)
                    | t < z = mediana (x, y, t, z, u)
                    | u < z = mediana (x, y, u, t ,z)
                    | otherwise = z
