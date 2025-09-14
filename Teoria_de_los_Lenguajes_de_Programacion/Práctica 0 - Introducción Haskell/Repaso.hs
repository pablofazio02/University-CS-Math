----------------------------------------------------------------
-- Lenguajes de Programación
-- 4º del Grado en Ingeniería Informática, mención en Computación
-- Pablo Fazio Arrabal
----------------------------------------------------------------

module Repaso where

import           Data.Char
import           Data.List
import           Data.Maybe

-- Haskell = Puro (la misma entrada produce la misma salida siempre en funciones, no se 
-- puede modificar las variables a gusto) + Tipado estático fuerte + Perezoso

-- | 1. Tipos básicos:
----------------------------------------------------------------

-- Los nombres de los tipos empiezan por mayúsculas:
-- Int, Integer, Float, Double, Char, Bool

-- | 2. Definición de funciones: currificación 
----------------------------------------------------------------

-- square

{-

   int square(int x) {
      return x * x;
   }

-}

-- Notación currificada tanto en la declaración como en la definición!! (no hacen falta parentesis p.ej)

square :: Integer -> Integer -- declaración
square x = x * x             -- definición

-- IMPORTANTE

-- Haskell Interactive Shell (Repaso.hs) λ square 5+1
-- 26
-- Haskell Interactive Shell (Repaso.hs) λ square (5+1)
-- 36

-- pythagoras

{-

   int pythagoras(int x, int y) {
      return square(x) + square(y);
   }

-}


-- RECORDAR
-- (Integer x Integer) -> Integer =====> Integer -> Integer -> Integer

pythagoras :: Integer -> Integer -> Integer
pythagoras x y = square x + square y

-- Haskell Interactive Shell (Repaso.hs) λ pythagoras 4 6
-- 52

-- | 3. Condicionales en Haskell
----------------------------------------------------------------

-- El condicional if then else en Haskell:
--
--     1) es una expresión, no una sentencia;
--     2) el else es obligatorio
--     3) los tipos de then y else debe coincidir

maxOf :: Integer -> Integer -> Integer -- predefinida como max
maxOf x y = if x >= y then x else y

-- signo (predefinida como signum)

{-

   int signo(int x) {
      if (x == 0) return  0;
      if (x <  0) return -1;
      if (x >  0) return  1;
   }

-}

-- |
-- >>> signo 6
-- 1
-- >>> signo 0
-- 0
-- >>> signo (-3)
-- -1

signo :: Integer -> Integer  -- predefinida como signum
signo x = if x == 0 then 0 
          else if x>0 then 1 
          else -1

-- Es mejor emplear guardas que anidar if then else
-- guarda ::= '|' exp_Bool = exp

maxOf' :: Integer -> Integer -> Integer
maxOf' x y
    | x >= y = x
    | otherwise = y


-- A partir de tres casos SIEMPRE usar guardas, el caso de dos es mejor if then else

signo' :: Integer -> Integer
signo' x 
      | x == 0 = 0 
      | x>0 = 1 
      | otherwise = -1

-- Curiosidad: las guardas de una ecuación no tienen que ser exhaustivas;
-- las guardas de una función (que puede tener varias ecuaciones) sí deben
-- ser exhaustivas.
-- Utilizaremos este truco para implementar las semánticas.

-- En esta asignatura, no vamos a querer que seamos exhaustivos!! Vamos a hacer ecuaciones independientes
-- para una misma función

múltiploDe2o5 x
   | x `mod` 2 == 0 = "múltiplo de 2"

múltiploDe2o5 x
   | x `mod` 5 == 0 = "múltiplo de 5"

múltiploDe2o5 x = "no es múltiplo ni de 2 ni de 5"

-- | 4. Tuplas
----------------------------------------------------------------

--       valor                    tipo
-- ('a', 1 <= 2, ord 'A') :: (Char, Bool, Int)

-- el número de componentes es fijo
-- cada componente puede ser de un tipo distinto
-- es un producto cartesiano!!
-- existe la tupla vacía: ()
-- no existe la tupla unitaria: (x) ¡ambiguedad con parentesis!
-- utilidad de las tuplas: una función puede devolver varios datos 
-- NO USAR TUPLAS PARA METER PARÁMETROS, SI NO PARA DEVOLVER RESULTADOS

predSuc :: Integer -> (Integer, Integer)
predSuc x = (x-1, x+1)

-- | 5. Parámetros formales y patrones
----------------------------------------------------------------

-- un parámetro formal es un patrón donde debe encajar el parámetro real

-- patrón variable: x (Encaja con cualquier valor)
módulo :: (Integer, Integer) -> Integer
módulo x = square (fst x) + square (snd x)

-- patrón tupla: (x,y)
módulo' :: (Integer, Integer) -> Integer
módulo' (x, y) = square x + square y

esOrigen :: (Integer, Integer) -> Bool
esOrigen x = fst x == 0 && snd x == 0

-- patrón constante: 0
esOrigen' :: (Integer, Integer) -> Bool
esOrigen' (0, 0) = True
esOrigen' (x, y) = False

-- patrón subrayado: _
esOrigen'' :: (Integer, Integer) -> Bool
esOrigen'' (0, 0) = True
esOrigen'' _      = False

-- esOrigen'' undefined falla ya que pretende primero evaluarlo con (0,0) NO DA FALSE

-- funcion undefined: función que devuelve error, es mejor ponerla para ver que nunca lleguemos allí
-- Los patrones se evalúan de izquierda a derecha y este orden influye!!

-- | 6. Polimorfismo
----------------------------------------------------------------

-- versiones monomórficas (tipos concretos)

primeroI :: (Integer, Integer) -> Integer
primeroI (x, _) = x

primeroC :: (Char, Bool) -> Char
primeroC (x, _) = x

primeroB :: (Bool, Integer) -> Bool
primeroB (x, _) = x

-- versiones polimórficas (variables de tipo, genericidad en Java)

primero :: (a, b) -> a -- predefinida como fst
primero (x, _) = x

segundo :: (a, b) -> b -- predefinida como snd
segundo (_, y) = y

-- | 7. Polimorfismo restringido o sobrecarga
----------------------------------------------------------------

-- 1) en Java el genérico <T> puede ser reemplazado por cualquier tipo (clase)
-- en Haskell una variable de tipo a puede ser reemplazada por cualquier tipo
-- 2) en Java puedo restringir un genérico: T extends Comparable<T>
-- en Haskell puedo restringir una variable de tipo: Ord a => a
-- 3) una clase Haskell es semejante (pero no equivalente) a una interfaz Java

-- la clase Eq

sonSimétricos :: Eq a => (a, a) -> (a, a) -> Bool
sonSimétricos (x, y) (u, v) =
       x == v && y == u -- Eq: usamos igualdad: ==, /=

sonSimétricos' :: (Eq a, Eq b) => (a, b) -> (b, a) -> Bool
sonSimétricos' (x, y) (u, v) =
        x == v && y == u -- Eq: usamos igualdad: ==, /=

-- la clase Ord

estáOrdenada :: Ord a => (a, a) -> Bool
estáOrdenada (x, y) = x <= y -- Ord: usamos comparación: <, <=, >, >=, compare, ==, /=

-- | 8. Definiciones locales
----------------------------------------------------------------

-- definición local, función error y pereza

raíces :: Double -> Double -> Double -> (Double, Double)
raíces a b c
   | abs a <= epsilon = error "la ecuación no es de segundo grado"
   | disc < 0 = error "raíces complejas"
   | otherwise = ((-b + raízDisc) / dosA, (-b - raízDisc) / dosA )
   where
      epsilon = 1e-8
      disc = b**2 - 4*a*c
      raízDisc = sqrt disc
      dosA = 2*a

-- | 9. Listas y patrones
----------------------------------------------------------------

--        valor                           tipo
-- [1, -2,  3 + 5,  123 `div` 6]    :: [Integer]
--
-- 1 : -2 : 3 + 5 : 123 `div` 6: [] :: [Integer]

-- número de componentes variable
-- todos los componentes deben ser del mismo tipo
-- existe la lista vacía: []
-- existe la lista unitaria: [x]
-- constructores de listas:
--      [] :: [a]
--      (:) :: a -> [a] -> [a]

-- funciones predefinidas:

{-
    head              tail
     |   ------------------------------
    [x1, x2, x3, ............, xn-1, xn]
     ------------------------------  |
                 init               last

    -------------- + -----------------
         take              drop

   null
   elem / notElem
   length
   (++)

-}

-- patrones habituales:

{-
     []               lista vacía
     [x]              lista unitaria
     (x:xs)           lista no vacía
-}

-- regla general:  [...]   ==> longitud fija,
--               (...:...) ==> longitud mínima

{-

Por ejemplo,

     [x,y,z]          lista con tres elementos
     (x:y:zs)         lista con al menos dos elementos
-}

longitud :: [a] -> Integer -- predefinida como length
longitud []     =  0
longitud (_:xs) =  1 + longitud xs

ordenada :: Ord a => [a] -> Bool
ordenada []       = True
ordenada [_]      = True
ordenada (x:y:ys) =  x <= y && ordenada (y:ys)

-- | 10. Orden superior
----------------------------------------------------------------

--- Una función en Haskell se dice que es de orden superior si:
-- 1. Devuelve función
-- 2. Recibe como parámetro una función


-- |
-- >>> twice (+1) 5
-- 7
--
-- >>> twice (*2) 3
-- 12

twice :: (a -> a) -> a -> a
twice f x = f (f x)

-- |
-- >>> mapTuple (+1) (*2) (3, 4)
-- (4,8)
--
-- >>> mapTuple ord (==5) ('A', 3 + 1)
-- (65,False)

mapTuple :: (a->c) -> (b->d) -> (a,b) -> (c,d)
mapTuple f g (x,y) = (f x, g y)

-- map y secciones

-- Map no modifica el tamaño!

-- map f t -> aplica f a cada elemento de t
-- map f [x1, ... xn] = [fx1 ... fxn]

-- |
-- >>> aprobadoGeneral [1..10]
-- [5.0,5.0,5.0,5.0,5.0,6.0,7.0,8.0,9.0,10.0]
--
-- >>> aprobadoGeneral [4.7, 2.5, 7, 10, 8.7]
-- [5.0,5.0,7.0,10.0,8.7]

aprobadoGeneral :: [Double] -> [Double]
aprobadoGeneral xs = map (max 5) xs

-- aprobadoGeneral' :: [Double] -> [Double]
-- aprobadoGeneral' [] = []
-- aprobadoGeneral' (x:xs) | x < 5.0 = 5.0:aprobadoGeneral' xs
--                         | otherwise = x:aprobadoGeneral' xs                       

-- lambda expresiones

-- ¿Qué es? Forma abreviada / anónima de escribir una función. Se pueden construir lambdas con patrones pero
-- como es anónima hay que tener cuidado para que sean irrefutables.

-- MAD = Multiply, Add, Divide (se usa en hashing)

-- |
-- >> f = mad 2 3 7
-- >> f 5
-- 6
-- >> f 10
-- 2

-- construimos una función MAD y la devolvemos como resultado
mad :: Int -> Int -> Int -> (Int -> Int)
mad m a d = \ x -> ((m*x) + a) `mod` d

-- | 11. Plegado de listas!
----------------------------------------------------------------

-- revisión de la recursión sobre listas

-- |
-- >>> suma [1..10]
-- 55
--
-- >>> suma [7]
-- 7
--
-- >>> suma []
-- 0

suma :: Num a => [a] -> a
suma []     = 0
suma (x:xs) = x + suma xs -- (+) x (suma xs)
                    --  función cabeza solCola

-- |
-- >>> conjunción [1 == 1, 'a' < 'b', null []]
-- True
--
-- >>> conjunción [1 == 1, 'a' < 'b', null [[]]]
-- False
--
-- >>> conjunción []
-- True

conjunción :: [Bool] -> Bool
conjunción []     = True
conjunción (x:xs) = x && conjunción xs -- (&&) x (conjuncion xs)

-- |
-- >>> esPalabra "haskell"
-- True
--
-- >>> esPalabra "haskell 2021"
-- False
--
-- >>> esPalabra "h"
-- True
--
-- >>> esPalabra ""
-- True

esPalabra :: String -> Bool
esPalabra []     = True
esPalabra (x:xs) = isLetter x && esPalabra xs

-- esPalabra :: String -> Bool
-- esPalabra []     = True
-- esPalabra (x:xs) = f x (esPalabra xs)
-- where f :: Char -> Bool -> Bool
-- f cab solCola = isLetter x && solCola

-- En las definiciones locales no debemos poner definicion de tipos concretos (aunque se lo trague)
esPalabra' :: String -> Bool
esPalabra' []     = True
esPalabra' (x:xs) = f x (esPalabra' xs)
      where
         f :: Char -> Bool -> Bool
         f c solCola = isLetter c && solCola

-- |
-- >>> todasMayúsculas "WHILE"
-- True
--
-- >>> todasMayúsculas "While"
-- False
--
-- >>> todasMayúsculas ""
-- True

todasMayúsculas :: String -> Bool
todasMayúsculas []     = True
todasMayúsculas (x:xs) = isUpper x && todasMayúsculas xs

-- reclista (\ cab solCola -> isUpper cab && solCola) True "HASKELL"
-- True

-- |
-- >>> máximo "hola mundo"
-- 'u'
--
-- >>> máximo [7, -8, 56, 17, 34, 12]
-- 56
--
-- >>> máximo [-8]
-- -8

máximo :: Ord a => [a] -> a
máximo [x]    = x
máximo (x:xs) = max x (máximo xs)

-- No encaja con los patrones anteriores. El caso recursivo sí, pero el caso base no lo hace.

-- |
-- >>> mínimoYmáximo "hola mundo"
-- (' ','u')
--
-- >>> mínimoYmáximo [7, -8, 56, 17, 34, 12]
-- (-8,56)
--
-- >>> mínimoYmáximo [1]
-- (1,1)

mínimoYmáximo :: Ord a => [a] -> (a,a)
mínimoYmáximo [x] = (x,x)
mínimoYmáximo (x:xs) = (min x u, max x v)
  where (u,v) = mínimoYmáximo xs

-- |
-- >>> aplana [[1,2], [3,4,5], [], [6]]
-- [1,2,3,4,5,6]
--
-- >>> aplana [[1,2]]
-- [1,2]
--
-- >>> aplana []
-- []

aplana :: [[a]] -> [a]
aplana []       = []
aplana (xs:xss) = xs ++ aplana xss -- (++) xs aplana xss (Sigue el patrón)

-- deducir el patrón de foldr!!!

reclista :: (a -> b -> b) -> b -> [a] -> b
reclista f z xs = recListaAux xs
     where recListaAux [] = z
           recListaAux (x:xs) = f x (recListaAux xs)

-- resolver las anteriores funciones con foldr

-- |
-- >>> sumaR [1..10]
-- 55
--
-- >>> sumaR [7]
-- 7
--
-- >>> sumaR []
-- 0

sumaR :: Num a => [a] -> a
sumaR xs = foldr (+) 0 xs

-- |
-- >>> longitudR "hola mundo"
-- 10
--
-- >>> longitudR [True]
-- 1
--
-- >>> longitudR []
-- 0

longitudR :: [a] -> Integer
longitudR xs = foldr (\ cab solCola -> 1 + solCola) 0 xs

-- |
-- >>> conjunciónR [1 == 1, 'a' < 'b', null []]
-- True
--
-- >>> conjunciónR [1 == 1, 'a' < 'b', null [[]]]
-- False
--
-- >>> conjunciónR []
-- True

conjunciónR :: [Bool] -> Bool
conjunciónR xs = foldr (&&) True xs

-- |
-- >>> esPalabraR "haskell"
-- True
--
-- >>> esPalabraR "haskell 2021"
-- False
--
-- >>> esPalabraR "h"
-- True
--
-- >>> esPalabraR ""
-- True

esPalabraR :: String -> Bool
esPalabraR s = foldr (\cab solCola -> isLetter cab && solCola) True s

-- |
-- >>> todasMayúsculasR "WHILE"
-- True
--
-- >>> todasMayúsculasR "While"
-- False
--
-- >>> todasMayúsculasR ""
-- True

todasMayúsculasR :: String -> Bool
todasMayúsculasR s = foldr (\cab solCola -> isUpper cab && solCola) True s

-- |
-- >>> máximoR "hola mundo"
-- 'u'
--
-- >>> máximoR [7, -8, 56, 17, 34, 12]
-- 56
--
-- >>> máximoR [-8]
-- -8

máximoR :: Ord a => [a] -> a
máximoR (x:xs) = foldr (\cab solCola -> max cab solCola) x xs

-- |
-- >>> mínimoYmáximoR "hola mundo"
-- (' ','u')
--
-- >>> mínimoYmáximoR [7, -8, 56, 17, 34, 12]
-- (-8,56)
--
-- >>> mínimoYmáximoR [1]
-- (1,1)

mínimoYmáximoR :: Ord a => [a] -> (a,a)
mínimoYmáximoR (x:xs) = foldr (\ cab (sCola, sCola') -> ((min cab sCola), (max cab sCola'))) (x, x) xs

-- |
-- >>> aplanaR [[1,2], [3,4,5], [], [6]]
-- [1,2,3,4,5,6]
--
-- >>> aplanaR [[1,2]]
-- [1,2]
--
-- >>> aplanaR []
-- []

aplanaR :: [[a]] -> [a]
aplanaR xs = foldr (++) [] xs

-- otros ejercicios de foldr

-- |
-- >>> mapR (2^) [0..10]
-- [1,2,4,8,16,32,64,128,256,512,1024]
--
-- >>> mapR undefined []
-- []
--
-- >>> mapR ord  "A"
-- [65]

mapR :: (a -> b) -> [a] -> [b]
mapR f xs = foldr (\cab solCola -> f cab:solCola) [] xs

-- |
-- >>> filterR even [1..20]
-- [2,4,6,8,10,12,14,16,18,20]
--
-- >>> filterR undefined []
-- []
--
-- >>> filterR even [5]
-- []

filterR :: (a -> Bool) -> [a] -> [a]
filterR g xs = foldr f [] xs
   where
      f cab solCola | g cab = cab:solCola
                    | otherwise = solCola

-- |
-- >>> apariciones 'a' "casa"
-- 2
-- >>> apariciones 'u' "casa"
-- 0

apariciones :: Eq a => a -> [a] -> Integer
apariciones x xs = foldr f 0 xs
   where
      f cab solCola | cab == x = solCola + 1
                    | otherwise = solCola

-- |
-- >>> purgar "abracadabra"
-- "cdbra"
--
-- >>> purgar [1,2,3]
-- [1,2,3]
--
-- >>> purgar "aaaaaaaaaa"
-- "a"

purgar :: Eq a => [a] -> [a]
purgar xs = foldr f [] xs
   where
      f cab solCola | cab `elem` solCola = solCola
                    | otherwise = cab:solCola

-- |
-- >>> agrupa "mississippi"
-- ["m","i","ss","i","ss","i","pp","i"]
--
-- >>> agrupa [1,2,2,3,3,3,4,4,4,4]
-- [[1],[2,2],[3,3,3],[4,4,4,4]]
--
-- >>> agrupa []
-- []

agrupa :: Eq a => [a] -> [[a]]
agrupa xs = foldr f [] xs
   where
      f cab [] = [[cab]]
      f cab (ys:yss) | cab == head ys = (cab:ys):yss
                     | otherwise = [cab]:ys:yss

-- | 12. Tipos algebraicos: recursión y plegados
----------------------------------------------------------------

data Tree a = Empty
            | Leaf a
            | Node a (Tree a) (Tree a)
            deriving Show

-- Se puede sacar mecanicamente el foldTree (plegado) de cualquier tipo algebraico

-- Tree a -> b

-- Con la idea de que el plegado es una función de orden superior, se puede sacar mecanicamente el plegado de cualquier tipo algebraico

-- Empty :: Tree a                                          e :: b
-- Leaf :: a -> Tree a                                      l :: a -> b
-- Node :: a -> Tree a -> Tree a -> Tree a                  n :: a -> b -> b -> b


treeI :: Tree Integer
treeI = Node 1
             (Node 2 (Leaf 4) (Leaf 5))
             (Node 3 Empty (Leaf 6))

treeC :: Tree Char
treeC = Node 'z'
          (Node 't' (Node 's' Empty (Leaf 'a')) (Leaf 'g'))
          (Node 'w' (Leaf 'h') (Node 'p' (Leaf 'f') (Leaf 'n')))

-- |
-- >>> treeSize treeI
-- 6
--
-- >>> treeSize treeC
-- 10

treeSize :: Tree a -> Integer
treeSize Empty = 0
treeSize (Leaf h) = 1
treeSize (Node r i d) = 1 + (treeSize i) + (treeSize d) -- (+) (\ _ -> 1) r treeSize i treeSize d

-- |
-- >>> treeHeight treeI
-- 3
-- >>> treeHeight treeC
-- 4

treeHeight :: Tree a -> Integer
treeHeight Empty = 0
treeHeight (Leaf h) = 1 -- (\ _ -> 1) h
treeHeight (Node r i d) = max (treeHeight i) (treeHeight d) + 1

-- |
-- >>> treeSum treeI
-- 21

treeSum :: Num a => Tree a -> a
treeSum Empty = 0
treeSum (Leaf h) = h
treeSum (Node r i d) = r + treeSum i + treeSum d 

-- |
-- >>> treeProduct treeI
-- 720

treeProduct :: Num a => Tree a -> a
treeProduct Empty = 1
treeProduct (Leaf h) = h
treeProduct (Node r i d) = r * (treeProduct i) * (treeProduct d)

-- |
-- >>> treeElem 5 treeI
-- True
--
-- >>> treeElem 48 treeI
-- False
--
-- >> treeElem 'w' treeC
-- True
--
-- >>> treeElem '*' treeC
-- False

treeElem :: Eq a => a -> Tree a -> Bool
treeElem x Empty = False
treeElem x (Leaf h) = h == x
treeElem x (Node r i d) = (x == r) || (treeElem x i) || (treeElem x d)
-- where
  -- f r si sd = (x==r) || si || sd ( x se puede poner porque la f ha sido definida localmente)

-- |
-- >>> treeToList treeI
-- [4,2,5,1,3,6]
--
-- >>> treeToList treeC
-- "satgzhwfpn"

treeToList :: Tree a -> [a]
treeToList Empty = []
treeToList (Leaf h) = [h]
treeToList (Node r i d) = (treeToList i) ++ [r] ++ (treeToList d)

-- |
-- >>> treeBorder treeI
-- [4,5,6]
--
-- >>> treeBorder treeC
-- "aghfn"

treeBorder :: Tree a -> [a]
treeBorder Empty = []
treeBorder (Leaf h) = [h]
treeBorder (Node r i d) = (treeBorder i) ++ (treeBorder d)

-- Plegado de tipo Tree a

foldTree :: (a -> b -> b -> b) -> (a -> b) -> b -> Tree a -> b
foldTree n l e t = recTreeAux t
 where 
   recTreeAux Empty = e
   recTreeAux (Leaf h) = l h
   recTreeAux (Node r i d) = n r (recTreeAux i) (recTreeAux d)

-- Haskell Interactive Shell (Repaso.hs) λ recTree (\ r si sd -> 1 + si + sd) (\ _ -> 1) 0 treeC
-- 10

-- Haskell Interactive Shell (Repaso.hs) λ recTree (\ r si sd -> 1 + max si sd) (const 1) 0 treeC  
-- 4

-- Haskell Interactive Shell (Repaso.hs) λ recTree (\ r si sd -> r + si + sd) id  0 treeI       
-- 21

-- NOTA = Se puede poner en vez de (\ _ -> 1), (const 1)

-- resolver los ejercicios anteriores con foldTree

-- |
-- >>> treeSize' treeI
-- 6
--
-- >>> treeSize' treeC
-- 10

treeSize' :: Tree a -> Integer
treeSize' t = foldTree (\ r si sd -> 1 + si  + sd) (const 1) 0 t 

-- |
-- >>> treeHeight' treeI
-- 3
-- >>> treeHeight' treeC
-- 4

treeHeight' :: Tree a -> Integer
treeHeight' t = foldTree (\ r si sd -> 1 + max si sd) (const 1) 0 t

-- |
-- >>> treeSum' treeI
-- 21

treeSum' :: Num a => Tree a -> a
treeSum' t = foldTree (\ r si sd -> r + si + sd) id 0 t  

-- |
-- >>> treeProduct' treeI
-- 720

treeProduct' :: Num a => Tree a -> a
treeProduct' t = foldTree (\ r si sd -> r * si * sd) id 1 t 

-- |
-- >>> treeElem' 5 treeI
-- True
--
-- >>> treeElem' 48 treeI
-- False
--
-- >> treeElem' 'w' treeC
-- True
--
-- >>> treeElem' '*' treeC
-- False

treeElem' :: Eq a => a -> Tree a -> Bool
treeElem' x t = foldTree (\r si sd -> r == x || si || sd ) (x==) False t

-- |
-- >>> treeToList' treeI
-- [4,2,5,1,3,6]
--
-- >>> treeToList' treeC
-- "satgzhwfpn"

treeToList' :: Tree a -> [a]
treeToList' t = foldTree (\ r si sd -> si ++ [r] ++ sd) (:[]) [] t

-- |
-- >>> treeBorder' treeI
-- [4,5,6]
--
-- >>> treeBorder' treeC
-- "aghfn"

treeBorder' :: Tree a -> [a]
treeBorder' t = foldTree (\ r si sd -> si ++ sd) (:[]) [] t
