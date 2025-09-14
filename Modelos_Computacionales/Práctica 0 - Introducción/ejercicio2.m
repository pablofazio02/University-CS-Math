% Ejercicio 2

% Calcular la suma de los cuadrados de los primeros 10 números naturales

function resultado = cuadrado(n)
    resultado = n^2;
end

suma = 0;

for i = 1:10
    suma = suma + cuadrado(i);
end

fprintf("La suma de los cuadrados de los primeros 10 naturales es: %d", suma)