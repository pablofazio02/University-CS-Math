-------------------------------------------------------------------------------
-- Estructuras de Datos. 2º Curso. ETSI Informática. UMA
--
-- 
-- Titulación: Doble Grado en Ingeniería Informática y Matemáticas.
-- Alumno: FAZIO ARRABAL, PABLO
-- Fecha de entrega: DIA | MES | AÑO
--
-- Relación de Ejercicios 2. Ejercicios resueltos: 
--
-------------------------------------------------------------------------------
import Test.QuickCheck

-- EJERCICIO 1



-- EJERCICIO 2

máximo :: Ord a => a -> [a] -> Bool
máximo x [] = True
máximo x [y] = x>=y
máximo x xs = x >= head xs && máximo x (tail xs)

máximoYResto :: Ord a => [a] -> (a,[a])
máximoYResto [] = error "lista vacía"
máximoYResto [x] = (x,[])
máximoYResto (x:xs) = if máximo x xs then (x,xs) else máximoYResto (xs ++ [x])


-- EJERCICIO 4
delete' :: (Eq a) => a -> [a] -> [a]
delete' y xs = delete'' y xs []
                 where delete'' _ [] _ = []
                       delete'' d (a:as) acc
                         | a == d    = reverse acc ++ as
                         | otherwise = delete'' d as (a:acc)

distintos :: Eq a => [a] -> Bool
distintos xs = foldr f True xs
  where 
    f cab solCola 
     | elem cab (delete' cab xs) = False
     | otherwise = solCola

-- EJERCICIO 5
replicate' :: Int -> a -> [a]
replicate' x y = [y | _ <- [1..x]]

p_replicate' n x = n>=0 && n<=1000 ==> length (filter (==x) xs) == n && length (filter (/=x) xs )==0 
 where
     xs = replicate' n x

--EJERCICIO 6
divisores :: Int -> [Int]
divisores x = [y | y <- [1..x], mod x y == 0]

divisores' :: Int -> [Int]
divisores' x | x > 0 = [y | y <- [-x..x], y/=0, mod x y == 0]
             | x < 0 = [y | y <- [x..(-x)], y/=0, mod x y == 0]

--EJERCICIO 7
mcd :: Int -> Int -> Int
mcd x y = maximum [z | z <- divisores' x, mod y z == 0]
   
p_mcd x y z = x/=0 && y/=0 && z/=0 ==> mcd (x*z) (y*z) == (abs z) * (mcd x y)

mcm :: Int -> Int -> Int
mcm x y = div (x*y) (mcd x y)

--EJERCICIO 8
esPrimo :: Int -> Bool
esPrimo x = divisores x == [1,x]


primosHasta :: Int -> [Int]
primosHasta x = [ y | y<-[2..x] , esPrimo y]

primosHasta' :: Int -> [Int]
primosHasta' x = filter (\ y -> esPrimo y) [0..x]

p1_primos x = primosHasta x == primosHasta' x

--EJERCICIO 9
pares :: Int -> [(Int,Int)]
pares x = [(y,z) | y <- primosHasta x, z <- primosHasta x, y + z == x, y <= z]

goldbach :: Int -> Bool
goldbach x | null (pares x) = False
           | otherwise = True

goldBachHasta :: Int -> Bool
goldBachHasta x = and ([goldbach y | y <- [4,x], mod y 2 == 0])



--EJERCICIO 10
esPerfecto :: Int -> Bool
esPerfecto x = x == sum [y | y <- [1..x-1], mod x y == 0]

perfectosMenoresQue :: Int -> [Int]
perfectosMenoresQue x = [y | y <- [1..x], esPerfecto y]

--EJERCICIO 11
take' :: Int -> [a] -> [a]
take' n xs = [x | (p,x) <- zip [0..n-1] xs]

drop' :: Int -> [a] -> [a]
drop' n xs = [x | (p,x) <- zip [0..n-1] xs, n/=0]

prop_original n xs = n>=0 ==> xs == take' n xs ++ drop' n xs

--EJERCICIO 12

concat' :: [[a]] -> [a]
concat' xs = foldr f [] xs
   where
     f cab solCola = cab ++ solCola
        
concat'' :: [[a]] -> [a]
concat'' xs = [ x | x <- ys]
   where 
     ys = undefined

-- EJERCICIO 15

iterate' :: (a -> a) -> a -> [a]
iterate' f x = x: iterate' f (f x)

geometrica :: Int -> Int -> [Int]
geometrica x y = iterate' (+y) x

-- EJERCICIO 22

binarios :: Int -> [[Char]]
binarios 0 = [[]]
binarios x = ['0':y | y <- binarios (x-1)] ++ ['1':z | z <- binarios (x-1)]

-- EJERCICIO 23

varRep:: Integer -> [a] -> [[a]]
varRep 0 xs = [[]]
varRep m xs = [y++[z] | y <- varRep (m-1) xs, z <- xs]