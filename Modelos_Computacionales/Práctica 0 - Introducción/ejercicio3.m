% Ejercicio 3
% Dado un arreglo de numeros, encuentra la suma de los numeros primos en el arreglo.

vector = [1,2,3,4,5,6,7,8,9];
suma = 0;

function resultado = esPrimo(n)
    resultado = all(mod(n,2:n-1) ~= 0);
end

for i = vector
    if(esPrimo(i))
        suma = suma + i;
    end
end

fprintf("La suma de los números primos del vector es: %d", suma)