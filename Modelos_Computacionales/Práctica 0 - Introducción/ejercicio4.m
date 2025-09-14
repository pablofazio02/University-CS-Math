% Ejercicio 4

% Dado un numero entero positivo, verifica si es un numero perfecto. Un
% numero es considerado perfecto si la suma de sus divisores positivos
% (excluyendo el propio numero) es igual a ese numero.

numero = 28;

function res = sumaDivisoresPos(n)
   suma = 0;
   for i = 1:(n-1)
       if(rem(n, i) == 0)
           suma = suma + i;
       end
   end
   res = suma;
end


function resultado = esPerfecto(n)
    resultado = n == sumaDivisoresPos(n);
end

if(esPerfecto(numero))
    fprintf("El número %d es perfecto.", numero)
else
    fprintf("El número %d no es perfecto.", numero)
end
